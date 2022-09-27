require("script/land_encounters/utils/strings")
require("script/land_encounters/utils/boolean")
require("script/land_encounters/utils/random")

local complex_continuity_events = require("script/land_encounters/constants/events/complex_continuity_events")

local elligible_items = require("script/land_encounters/constants/items/balancing_items")

local Spot = require("script/land_encounters/models/spots/abstract_classes/Spot")
local Army = require("script/land_encounters/models/battle/Army")


-- TODO: Effect while active. Give them an effect if they are active and not resolved due to stuff (positive or neutral effects over their region or province

------------------------------------------------
--- Constant values of the class [DO NOT CHANGE]
------------------------------------------------
local FIRST_OPTION = 0

local EVENT_IMAGE_ID_LOCATION_OF_INTEREST = 1017

local ERROR_BATTLE_CLEAN_UP_EVENT = { 
    incident = "land_enc_incident_battle_clean_up_event",
    targets = { character = true, force = false, faction = false, region = false }
}

-------------------------
--- Properties definition
-------------------------
local BattleSpot = {
    -- logic properties
    index = 0,
    coordinates = {0, 0},
    is_active = false,
    automatic_deactivation_countdown = 0, -- Should automatically dissapear after X turn
    -- marker properties
    marker_id = "",
    -- battle spot unique properties
    event = nil, -- { dilemma: string, victory_incident: string, avoidance_incident: string }
    is_triggered = false,
    player_character = nil
}

-------------------------
--- Class Methods
-------------------------
-- Overriden Methods
function BattleSpot:get_class()
    return "BattleSpot"
end


function BattleSpot:set_event_from_string(event_as_string)
    local event_in_parts = split_by_regex(event_as_string, "/")
    
    local victory_targets_in_parts = { "true", "false", "false", "false" }
    if event_in_parts[7] ~= nil then
        victory_targets_in_parts = split_by_regex(event_in_parts[7], "!")
    end
    
    local avoidance_targets_in_parts = { "true", "false", "false", "false" }
    if event_in_parts[8] ~= nil then
        avoidance_targets_in_parts = split_by_regex(event_in_parts[8], "!")
    end
    
    self.event = { 
        dilemma = event_in_parts[1], 
        victory_incident = event_in_parts[2], 
        avoidance_incident = event_in_parts[3], 
        difficulty_level = tonumber(event_in_parts[4]), 
        is_exclusive_to_zone = stringtoboolean[event_in_parts[5]],
        zone = event_in_parts[6],
        victory_targets = { 
            character = stringtoboolean[victory_targets_in_parts[1]], 
            force = stringtoboolean[victory_targets_in_parts[2]], 
            faction = stringtoboolean[victory_targets_in_parts[3]], 
            region = stringtoboolean[victory_targets_in_parts[4]] 
        },
        avoidance_targets = { 
            character = stringtoboolean[avoidance_targets_in_parts[1]], 
            force = stringtoboolean[avoidance_targets_in_parts[2]], 
            faction = stringtoboolean[avoidance_targets_in_parts[3]], 
            region = stringtoboolean[avoidance_targets_in_parts[4]] 
        }
    }
end


-- Event can be nil due to it loosing it's value once used.
function BattleSpot:get_event_as_string()
    if self.event ~= nil then
        return self.event.dilemma .. "/" .. self.event.victory_incident .. "/" .. self.event.avoidance_incident .. "/" .. self.event.difficulty_level .. "/" .. booleantostring[self.event.is_exclusive_to_zone] .. "/" .. self.event.zone .. "/" .. booleantostring[self.event.victory_targets.character] .. "!" .. booleantostring[self.event.victory_targets.force] .. "!" .. booleantostring[self.event.victory_targets.faction] .. "!" .. booleantostring[self.event.victory_targets.region] .. "/" ..
        booleantostring[self.event.avoidance_targets.character]  .. "!" ..  booleantostring[self.event.avoidance_targets.force]  .. "!" ..  booleantostring[self.event.avoidance_targets.faction]  .. "!" ..  booleantostring[self.event.avoidance_targets.region]
    else
        return nil
    end
end


function BattleSpot:flatten_info(state_info, flattened_key)
    Spot.flatten_info(self, state_info, flattened_key)
    state_info[flattened_key .. "_event"] = self:get_event_as_string()
    state_info[flattened_key .. "_is_triggered"] = self.is_triggered
end


-- REMEMBER cannot pass it to Spot.reinstate(self, state_info, flattened_key) implementation as it would give an stackoverflow due to the state_info being copied over an over again to that same table data.
function BattleSpot:reinstate(state_info, flattened_key)
    self.automatic_deactivation_countdown = state_info[flattened_key .. "_deactivation"]
    self.marker_id = state_info[flattened_key .. "_marker"]
    self:set_event_from_string(state_info[flattened_key .. "_event"])
    self.is_triggered = state_info[flattened_key .. "_is_triggered"]
end


function BattleSpot:trigger_event(context)
    local triggering_character = context:family_member():character()
    local triggering_faction = triggering_character:faction()
    local triggering_faction_name = triggering_faction:name()
    
    local can_remove_encounter_marker = false

    if self:is_human_and_it_is_its_turn(triggering_faction) then
        self.player_character = triggering_character
        -- Character is in normal stance and can trigger the event
        if self:character_is_general_and_can_trigger_dilemma(self.player_character) then
            cm:trigger_dilemma(triggering_faction_name, self.event.dilemma)
        else
            cm:show_message_event_located(triggering_faction_name,
                "event_feed_strings_text_title_event_land_enc_and_poi_encountered",
                "event_feed_strings_text_subtitle_event_land_enc_and_poi_encountered",
                "event_feed_strings_text_description_event_land_enc_and_poi_encountered",
                self.coordinates[1],
                self.coordinates[2],
                false,
                EVENT_IMAGE_ID_LOCATION_OF_INTEREST
            )
        end
    elseif not triggering_faction:is_human() and not self:get_offensive_army():check_if_faction_is_from_army(triggering_faction_name) then
        -- trigger balancing incident
        local trigger_event_feed = false
        cm:add_ancillary_to_faction(triggering_faction, elligible_items[random_number(#elligible_items)], trigger_event_feed)
        cm:treasury_mod(triggering_faction_name, 10000)
        can_remove_encounter_marker = true
    end
    
    return can_remove_encounter_marker
end


function BattleSpot:trigger_dilemma_by_choice(invasion_battle_manager, zone, spot_index, context)
    local choice = context:choice()
    local can_remove_encounter_marker = false
    if choice == FIRST_OPTION then
        -- we check that the army will be able to spawn and fight
        local offensive_army = self:get_offensive_army()
        if invasion_battle_manager:can_generate_battle(offensive_army, self.coordinates) then
            self.is_triggered = true
        
            invasion_battle_manager:generate_battle(offensive_army, self.player_character, self.coordinates)
            invasion_battle_manager:mark_battle_forces_for_removal(offensive_army)
            invasion_battle_manager:reset_state_post_battle(zone, self:get_class(), spot_index, offensive_army)
            return can_remove_encounter_marker
        -- we trigger the default removal incident
        else
            self:trigger_battle_removal_incident()
            can_remove_encounter_marker = true
        end
    else
        self:trigger_battle_avoidance_incident()
        can_remove_encounter_marker = true
        return can_remove_encounter_marker
    end
end


function BattleSpot:trigger_battle_removal_incident()
    self:trigger_incident(ERROR_BATTLE_CLEAN_UP_EVENT.incident, self.player_character, ERROR_BATTLE_CLEAN_UP_EVENT.targets)
end


function BattleSpot:trigger_battle_avoidance_incident()
    self:trigger_incident(self.event.avoidance_incident, self.player_character, self.event.avoidance_targets)
end


function BattleSpot:trigger_victory_incident()
    if self.player_character == nil or not self.player_character then
        self.player_character = self:get_player_faction_character_closest_to_spot()
    end
    
    self:trigger_incident(self.event.victory_incident, self.player_character, self.event.victory_targets)
    -- complex events trigger a balancing act
    local continuity = self:check_continuity(self.event.victory_incident, self.player_character:faction())
    if continuity ~= nil then
        self:trigger_incident(continuity.incident, self.player_character, continuity.targets)
        if continuity.balance ~= false then
            self:balance_for_ai(continuity.balance, self.player_character:faction())
        end
    end
end


function BattleSpot:check_continuity(incident_key, faction)
    local incident_logic = complex_continuity_events[incident_key]
    if incident_logic ~= nil then 
        for i=1, #incident_logic do
            if self:checks_option_conditions_are_fulfilled(faction, incident_logic[i].conditions) then
                return incident_logic[i].result
            end
        end
    end
    return nil
end


function BattleSpot:checks_option_conditions_are_fulfilled(faction, conditions)
    local conditions_are_met = true
    for condition_key, variable in pairs(conditions) do
        if condition_key == "does_not_have_ancillary" then
            conditions_are_met = not faction:ancillary_exists(variable)
        -- elseif condition_key == "" then
        end
    end
    return conditions_are_met
end


function BattleSpot:balance_for_ai(balance, player_faction)
    for condition_key, logical_variable in pairs(balance) do
        if condition_key == "give_ancillary" then
            local blessed_factions = false
            if logical_variable.faction == "random" then
                -- check enemy factions 
                local factions = player_faction:factions_at_war_with()
                if factions:num_items() == 0 then
                    factions = player_faction:factions_met()
                end
                -- get most powerful enemies
                local first_faction = false
                local second_faction = false
                local max_imperium_level = 0
                
                for i = 0, factions:num_items() - 1 do
                    local known_faction = factions:item_at(i)
                    
                    if known_faction:imperium_level() >= max_imperium_level then
                        if second_faction == false and first_faction ~= false then
                            second_faction = known_faction
                        elseif second_faction ~= false then
                            first_faction = second_faction
                            second_faction = known_faction
                        end
                        
                        if first_faction == false then
                            first_faction = known_faction
                        end
                        
                        max_imperium_level = known_faction:imperium_level()
                    end
                    
                    blessed_factions = {}
                    if first_faction ~= false then
                        table.insert(blessed_factions, first_faction)
                    end
                    
                    if second_faction ~= false then
                        table.insert(blessed_factions, second_faction)
                    end
                end
            else
                -- get faction by name
                blessed_factions = {}
                table.insert(blessed_factions, cm:get_faction(logical_variable.faction))
            end
            -- bless them
            if blessed_factions ~= false then
                local trigger_event_feed = false 
                for i=1, #blessed_factions do
                    cm:add_ancillary_to_faction(blessed_factions[i], logical_variable.ancillary, trigger_event_feed) 
                end
            end
        end
    end
end


function BattleSpot:get_offensive_army()
    return Army:new_from_event(self.event.dilemma)
end


function BattleSpot:deactivate(zone_name)
    Spot.deactivate(self, zone_name)
    -- battle spot unique properties
    self.is_triggered = false
    self.player_character = nil
end
    
-------------------------
--- Constructors
-------------------------
function BattleSpot:newFrom(old_spot)
    BattleSpot.__index = BattleSpot
    setmetatable(BattleSpot, {__index = Spot})
    local t = old_spot
    -- initalize variables related only to battle spot
    setmetatable(t, BattleSpot)
    return t
end
                            
return BattleSpot