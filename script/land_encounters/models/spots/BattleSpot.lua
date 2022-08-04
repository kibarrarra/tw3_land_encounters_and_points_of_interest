require("script/land_encounters/utils/strings")
require("script/land_encounters/utils/boolean")
require("script/land_encounters/utils/random")

local elligible_items = require("script/land_encounters/constants/items/balancing_items")

local Spot = require("script/land_encounters/models/spots/abstract_classes/Spot")
local Army = require("script/land_encounters/models/battle/Army")

------------------------------------------------
--- Constant values of the class [DO NOT CHANGE]
------------------------------------------------
local FIRST_OPTION = 0

local EVENT_IMAGE_ID_LOCATION_OF_INTEREST = 1017

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
    
    --TODO clean this logic on the August update
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
function Spot:reinstate(state_info, flattened_key)
    self.automatic_deactivation_countdown = state_info[flattened_key .. "_deactivation"]
    self.marker_id = state_info[flattened_key .. "_marker"]
    self:set_event_from_string(state_info[flattened_key .. "_event"])
    self.is_triggered = state_info[flattened_key .. "_is_triggered"]
end


function BattleSpot:trigger_event(context)
    self.player_character = context:family_member():character()
    local triggering_faction = self.player_character:faction()
    local player_faction_name = triggering_faction:name()
    
    local can_remove_encounter_marker = false

    if self:is_human_and_it_is_its_turn(triggering_faction) then
        --out("LEAPOI - BattleSpot:trigger_event Triggering battle land encounter: " .. self.event.dilemma)
        -- Character is in normal stance and can trigger the event
        if self.player_character:military_force():active_stance() == "MILITARY_FORCE_ACTIVE_STANCE_TYPE_DEFAULT" then
            cm:trigger_dilemma(player_faction_name, self.event.dilemma)
            --out("LEAPOI - BattleSpot:trigger_event dilemma " .. self.event.dilemma .. "; TRIGGERED")
        else
            cm:show_message_event_located(player_faction_name,
                "event_feed_strings_text_title_event_land_enc_and_poi_encountered",
                "event_feed_strings_text_subtitle_event_land_enc_and_poi_encountered",
                "event_feed_strings_text_description_event_land_enc_and_poi_encountered",
                self.coordinates[1],
                self.coordinates[2],
                false,
                EVENT_IMAGE_ID_LOCATION_OF_INTEREST
            )
        end
    
    elseif not triggering_faction:is_human() then
        -- trigger balancing incident
        local trigger_event_feed = false
        cm:add_ancillary_to_faction(triggering_faction, elligible_items[random_number(#elligible_items)], trigger_event_feed)
        can_remove_encounter_marker = true
        --out("LEAPOI - BattleSpot:trigger_event was triggered by the AI and was given to them; TRIGGERED")
    end
    
    return can_remove_encounter_marker
end


function BattleSpot:trigger_dilemma_by_choice(invasion_battle_manager, zone, spot_index, context)
    local choice = context:choice()
    
    local can_remove_encounter_marker = false
    --out("LEAPOI - BattleSpot:trigger_dilemma_by_choice= " .. tostring(choice) .. ", type= " .. type(choice))
    if choice == FIRST_OPTION then
        --out("LEAPOI - First choice -- Battle time!")
        local x, y = self:find_location_for_character_to_spawn(context:faction():name())
        
        self.is_triggered = true
        invasion_battle_manager:generate_battle(self:get_offensive_army(), self.player_character, {x, y})
        invasion_battle_manager:setup_encounter_force_removal("encounter_invasion")
        invasion_battle_manager:reset_state_post_battle(
            zone, 
            self:get_class(), 
            spot_index, 
            "encounter_invasion"
        )
        return can_remove_encounter_marker
    else
        --out("LEAPOI - Second choice -- No thanks!")
        self:trigger_battle_avoidance_incident()
        can_remove_encounter_marker = true
        return can_remove_encounter_marker
    end
end


function BattleSpot:trigger_battle_avoidance_incident()
    self:trigger_incident(self.event.avoidance_incident, self.player_character, self.event.avoidance_targets)
end


function BattleSpot:trigger_victory_incident()
    self:trigger_incident(self.event.victory_incident, self.player_character, self.event.victory_targets)
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