--[[ Specification
V1.0 in 1.3
For the player:
The player has to visit it at least once every 3 turns to unlock it for the turn it visits it
- Should be upgradeable by giving it money (Up to three times selling greys in the first tier, green, blue etc...)
- If an enemy faction crosses through it given the level it will trigger a defensive battle.

For the AI:
- Gives a random ancillary every 5 turns if under control of the AI

V1.1 in 2.X
- Region aware. Region AI owner auto attacks the smithy if owned by the player.
- Quest given by the smithy itself. Should give legendary items or blue sets if they are completed in time.
]]--

local Spot = require("script/land_encounters/models/spots/abstract_classes/Spot")
local Army = require("script/land_encounters/models/battle/Army")

------------------------------------------------
--- Constant values of the class [DO NOT CHANGE]
------------------------------------------------
local FIRST_OPTION = 0
local SECOND_OPTION = 1

local EVENT_IMAGE_ID_LOCATION_OF_INTEREST = 1017

-- Heavily reused events
local EVENT_RECLAMATION = "land_enc_dilemma_smithy_reclamation" 
local EVENT_DEFENSE = "land_enc_dilemma_smithy_defense" 
local EVENT_VISIT_LEVEL_1 = "land_enc_dilemma_smithy_visit_level_1" 
local EVENT_VISIT_LEVEL_2 = "land_enc_dilemma_smithy_visit_level_2"
local EVENT_VISIT_LEVEL_3 = "land_enc_dilemma_smithy_visit_level_3"

-------------------------
--- Properties definition
-------------------------
local SmithySpot = {
    -- logic properties
    index = 0,
    coordinates = {0, 0},
    is_active = false,
    -- marker properties
    -- they are fixed
    marker_id = "",
    -- spot unique properties
    event = {
        -- when reclaiming the point for the HUMAN player faction if the point is occupied a battle dilemma is triggered where if one wins, the smithy passes to give their benefits to that faction. If the smithy is not occupied by anyone a default occupation event is triggered
        reclamation = {
            dilemma = EVENT_RECLAMATION
        }, 
        -- the contrary event. By default when an enemy faction passes through the control point it will automatically try to reclaim the smithy for themselves reclaiming them. To avoid this a dilemma will be triggered in where you will need to file a battle for the place.
        defense = {
            dilemma = EVENT_DEFENSE
        },
        -- if the player visits the smithy while not on cooldown this event will let them choose a gift or level up the smithy. Leveling up the smithy will improve the tribute frequency and the quality of the visit give 
        visit_dilemmas_by_level = { 
            [1] = EVENT_VISIT_LEVEL_1, -- white + improve
            [2] = EVENT_VISIT_LEVEL_2, -- green + improve
            [3] = EVENT_VISIT_LEVEL_3 -- blue only 
        },
        -- if a faction controls the point for x numbers of turns a tribute is issued
        tribute_incident = "land_enc_incident_smithy_tribute",
        -- all incidents that don't require a dilemma work directly on the faction
        targets = { character = true, force = true, faction = false, region = false }
    },
    -- smithy defense (from player or AI) variables
    is_defense_triggered = false,    
    is_reclamation_triggered = false,
    
    visiting_enemy_character = false,
    -- in case the player does not finish the battle in the same game session we save its faction to find him later                
    visiting_enemy_faction_name = false,
    
    level = 1,
    controlling_faction_name = "",
    controlling_faction_subculture = "",
    turns_under_control = 0,
    visit_cooldown = 0
}


-------------------------
--- Class Methods
-------------------------
-- Overriden Methods
function SmithySpot:get_class()
    return "SmithySpot"
end


function SmithySpot:set_event_from_string(event_as_string)
    local event_in_parts = split_by_regex(event_as_string, "/")
    self.event = {
        reclamation = {
            dilemma = event_in_parts[1]
        }, 
        defense = {
            dilemma = event_in_parts[2]
        },
        tribute_incident = "land_enc_incident_smithy_tribute",
        visit_dilemmas_by_level = { 
            [1] = EVENT_VISIT_LEVEL_1, -- white + improve
            [2] = EVENT_VISIT_LEVEL_2, -- green + improve
            [3] = EVENT_VISIT_LEVEL_3  -- blue only 
        },
        targets = { character = true, force = true, faction = false, region = false }
    }
end


-- Event cannot be nil
function SmithySpot:get_event_as_string()
    return self.event.reclamation.dilemma .. "/" .. self.event.defense.dilemma
end


function SmithySpot:activate(zone_name, ignore)
    self:set_logical_data()
    
    local marker_id = "land_enc_marker_" .. zone_name .. "_smithy_" .. self.index
    local marker_key = "encounter_marker_smithy"
    local interaction_radius = 8
    self:set_marker_on_map(marker_id, marker_key, interaction_radius)
    out("LEAPOI - SmithySpot-activate - Marker Created")
end


function SmithySpot:flatten_info(state_info, zone_name)
    local flattened_key = zone_name .. "_smithy_" .. tostring(self.index)
    
    Spot.flatten_info(self, state_info, flattened_key)
    state_info[flattened_key .. "_event"] = self:get_event_as_string()
    state_info[flattened_key .. "_is_defense_triggered"] = self.is_defense_triggered
    state_info[flattened_key .. "_is_reclamation_triggered"] = self.is_reclamation_triggered    
    state_info[flattened_key .. "_visiting_enemy_faction_name"] = self.visiting_enemy_faction_name
    state_info[flattened_key .. "_level"] = self.level
    state_info[flattened_key .. "_controlling_faction_name"] = self.controlling_faction_name
    state_info[flattened_key .. "_controlling_faction_subculture"] = self.controlling_faction_subculture
    state_info[flattened_key .. "_turns_under_control"] = self.turns_under_control
    state_info[flattened_key .. "_visit_cooldown"] = self.visit_cooldown
end


function SmithySpot:reinstate(flattened_key, previous_state)
    self.is_active = previous_state[flattened_key .. "_active"]
    self.marker_id = previous_state[flattened_key .. "_marker_id"]
    self.event = self:set_event_from_string(previous_state[flattened_key .. "_event"])
    self.is_defense_triggered = previous_state[flattened_key .. "_is_defense_triggered"]
    self.is_reclamation_triggered = previous_state[flattened_key .. "_is_reclamation_triggered"]
    self.visiting_enemy_faction_name = previous_state[flattened_key .. "_visiting_enemy_faction_name"]
    self.level = previous_state[flattened_key .. "_level"]
    self.controlling_faction_name = previous_state[flattened_key .. "_controlling_faction_name"]
    self.controlling_faction_subculture = previous_state[flattened_key .. "_controlling_faction_subculture"]
    self.turns_under_control = previous_state[flattened_key .. "_turns_under_control"]
    self.visit_cooldown = previous_state[flattened_key .. "_visit_cooldown"]
    
    if self.is_defense_triggered or self.is_reclamation_triggered then
        return true
    end
    return false
end


-- @context: interactable marker context
-- @zone: ZONE.class with it's implementation
-- @spot_index: The index of this point of interest in the ZONE. Used to trigger the intervention automatically.
function SmithySpot:trigger_event(context, invasion_battle_manager, zone, spot_index)
    local visiting_character = context:family_member():character()
    local visiting_faction = visiting_character:faction()
    
    local can_remove_encounter_marker = false
    
    -- is human
    if self:is_human_and_it_is_its_turn(visiting_faction) then
        -- and is occupied by said human
        if self:is_occupied_by_same_faction(visiting_faction:name()) then
            -- the master blacksmith can't receive you
            if self:is_on_cooldown() then
                cm:show_message_event_located(visiting_faction:name(),
                    "event_feed_strings_text_title_event_land_enc_smithy_visit_on_cooldown",
                    "event_feed_strings_text_subtitle_event_land_enc_smithy_visit_on_cooldown",
                    "event_feed_strings_text_description_event_land_enc_smithy_visit_on_cooldown",
                    self.coordinates[1],
                    self.coordinates[2],
                    false,
                    EVENT_IMAGE_ID_LOCATION_OF_INTEREST
                )
            else
            -- he can receive you
                cm:trigger_dilemma(visiting_faction:name(), self.event.visit_dilemmas_by_level[self.level])
            end
        else
        -- if it's not occupied by the player
            if not self:is_occupied() then
            -- and its not ocuppied by anyone
                cm:show_message_event_located(visiting_faction:name(),
                    "event_feed_strings_text_title_event_land_enc_smithy_default_occupation",
                    "event_feed_strings_text_subtitle_event_land_enc_smithy_default_occupation",
                    "event_feed_strings_text_description_event_land_enc_smithy_default_occupation",
                    self.coordinates[1],
                    self.coordinates[2],
                    false,
                    EVENT_IMAGE_ID_LOCATION_OF_INTEREST
                )
                self:change_owner_through_occupation(visiting_faction:name())
            elseif self:is_faction_at_war_with_owner(visiting_faction) then
            -- and its occupied by an enemy
                -- Character is in normal stance and can trigger the event
                if self:character_can_trigger_dilemma(visiting_character) then
                    -- then we can avoid it or battle for it
                    self.visiting_enemy_character = visiting_character
                    self.visiting_enemy_faction_name = visiting_faction:name()
                    cm:trigger_dilemma(visiting_faction:name(), self.event.reclamation.dilemma) 
                else
                    cm:show_message_event_located(visiting_faction:name(),
                        "event_feed_strings_text_title_event_land_enc_smithy_encountered",
                        "event_feed_strings_text_subtitle_event_land_enc_smithy_encountered",
                        "event_feed_strings_text_description_event_land_enc_smithy_encountered",
                        self.coordinates[1],
                        self.coordinates[2],
                        false,
                        EVENT_IMAGE_ID_LOCATION_OF_INTEREST
                    )
                end
            else
            -- and its occupied by an ally or a neutral faction so we tell the player they need to be at war or have this faction dissapear to take the smithy
                cm:show_message_event_located(visiting_faction:name(),
                    "event_feed_strings_text_title_event_land_enc_smithy_ally_or_neutrally_controlled",
                    "event_feed_strings_text_subtitle_event_land_enc_smithy_ally_or_neutrally_controlled",
                    "event_feed_strings_text_description_event_land_enc_smithy_ally_or_neutrally_controlled",
                    self.coordinates[1],
                    self.coordinates[2],
                    false,
                    EVENT_IMAGE_ID_LOCATION_OF_INTEREST
                )
            end
        end
    elseif not self:is_prohibited_subculture(visiting_faction) then 
    -- is not an AI faction that has too random armies
        if self:is_faction_at_war_with_owner(visiting_faction) then
        -- is an AI enemy faction so the faction attacks the point
            if self:is_occupied_by_player() then
                -- the smithy is attacked, triger related event
                self.visiting_enemy_character = visiting_character
                self.visiting_enemy_faction_name = visiting_faction:name()
                -- given that the player cannot answer dilemmas during AI turn we autotrigger the defense
                self.is_defense_triggered = true
                self:trigger_forced_interception_defense(invasion_battle_manager, zone, spot_index)
                --cm:trigger_dilemma(self.controlling_faction_name, self.event.defense.dilemma)
            else
                -- the smithy changes hands randomly automatically to the enemy faction
                if random_number(100) >= 75 then
                    local is_player = false
                    self:change_owner_through_conquest(visiting_faction:name(), is_player, visiting_character)
                end
            end
        end
    end
    
    return can_remove_encounter_marker
end


function SmithySpot:trigger_dilemma_by_choice(invasion_battle_manager, zone, spot_index, dilemma_context)
    local choice = dilemma_context:choice()
    local dilemma = dilemma_context:dilemma()
    local faction_name = dilemma_context:faction():name()
    
    local can_remove_encounter_marker = false
    
    if (dilemma == EVENT_VISIT_LEVEL_1 or dilemma == EVENT_VISIT_LEVEL_2) and choice == FIRST_OPTION then
        self.level = self.level + 1
        self.visit_cooldown = 3
        cm:show_message_event_located(self.controlling_faction_name,
            "event_feed_strings_text_title_event_land_enc_smithy_levelled_up",
            "event_feed_strings_text_subtitle_event_land_enc_smithy_levelled_up",
            "event_feed_strings_text_description_event_land_enc_smithy_levelled_up",
            self.coordinates[1],
            self.coordinates[2],
            false,
            EVENT_IMAGE_ID_LOCATION_OF_INTEREST
        )
    elseif dilemma == EVENT_VISIT_LEVEL_1 or dilemma == EVENT_VISIT_LEVEL_2 or dilemma == EVENT_VISIT_LEVEL_3 then 
        self.visit_cooldown = 10
    end
    
    -- when the smithy is controlled by an enemy faction
    if (dilemma == EVENT_RECLAMATION or dilemma == EVENT_DEFENSE) and choice == FIRST_OPTION then
        --out("LEAPOI - SmithySpot:trigger_dilemma_by_choice= " .. tostring(choice) .. ", type= " .. type(choice))
        -- If the AI controls the point. The point will be heavily defended. Only the player has to level it up correctly as the player benefits more from it
        -- up in the other logic
        if dilemma == EVENT_RECLAMATION then
            self.is_reclamation_triggered = true
        elseif dilemma == EVENT_DEFENSE then
            self.is_defense_triggered = true
        end
        self:trigger_forced_interception_defense(zone, spot_index)

    elseif dilemma == EVENT_DEFENSE and choice == SECOND_OPTION then
        self:trigger_unconditional_surrender_incident(faction_name)
        
        cm:show_message_event_located(self.controlling_faction_name,
            "event_feed_strings_text_title_event_land_enc_smithy_unconditional_surrender",
            "event_feed_strings_text_subtitle_event_land_enc_smithy_unconditional_surrender",
            "event_feed_strings_text_description_event_land_enc_smithy_unconditional_surrender",
            self.coordinates[1],
            self.coordinates[2],
            false,
            EVENT_IMAGE_ID_LOCATION_OF_INTEREST
        )
    end

    return can_remove_encounter_marker
end


--////
function SmithySpot:trigger_forced_interception_defense(invasion_battle_manager, zone, spot_index)
    local x, y = self:find_location_for_character_to_spawn(self.controlling_faction_name)
    local defender_army = self:get_defensive_army()
    
    if not self.visiting_enemy_character then
        self.visiting_enemy_character = cm:get_closest_character_to_position_from_faction(self.visiting_enemy_faction_name, self.coordinates[1], self.coordinates[2], true, false, false, false)
    end
    
    invasion_battle_manager:generate_defense_battle(defender_army, self.visiting_enemy_character, {x, y})
    invasion_battle_manager:setup_encounter_force_removal("defender_invasion")
    invasion_battle_manager:reset_state_post_battle(
        zone, 
        self:get_class(), 
        spot_index, 
        "defender_invasion"
    )    
end


function SmithySpot:trigger_victory_event_given_battle_type()
    -- the player is reclaiming the smithy and won
    if self.is_reclamation_triggered then
        self:trigger_successful_reclamation()
    -- the player defends its smithy and won
    elseif self.is_defense_triggered then
        self:trigger_successful_defense()
    end
    self:reset_defense_flags()
end


function SmithySpot:trigger_defeat_event_given_battle_type()
    if self.is_reclamation_triggered then
        self:trigger_failed_reclamation()
    elseif self.is_defense_triggered then
        self:trigger_failed_defense()
    end
    self:reset_defense_flags()
end


function SmithySpot:trigger_successful_reclamation()
    cm:show_message_event_located(self.visiting_enemy_faction_name,
        "event_feed_strings_text_title_event_land_enc_smithy_successfully_reclaimed",
        "event_feed_strings_text_subtitle_event_land_enc_smithy_successfully_reclaimed",
        "event_feed_strings_text_description_event_land_enc_smithy_successfully_reclaimed",
        self.coordinates[1],
        self.coordinates[2],
        false,
        EVENT_IMAGE_ID_LOCATION_OF_INTEREST
    )
    
    self:change_owner_through_occupation(self.visiting_enemy_faction_name)
end


function SmithySpot:trigger_successful_defense()
    cm:show_message_event_located(self.controlling_faction_name,
        "event_feed_strings_text_title_event_land_enc_smithy_successfully_defended",
        "event_feed_strings_text_subtitle_event_land_enc_smithy_successfully_defended",
        "event_feed_strings_text_description_event_land_enc_smithy_successfully_defended",
        self.coordinates[1],
        self.coordinates[2],
        false,
        EVENT_IMAGE_ID_LOCATION_OF_INTEREST
    )
end


function SmithySpot:trigger_failed_reclamation()
    cm:show_message_event_located(self.visiting_enemy_faction_name,
        "event_feed_strings_text_title_event_land_enc_smithy_reclaimed_repelled",
        "event_feed_strings_text_subtitle_event_land_enc_smithy_reclaimed_repelled",
        "event_feed_strings_text_description_event_land_enc_smithy_reclaimed_repelled",
        self.coordinates[1],
        self.coordinates[2],
        false,
        EVENT_IMAGE_ID_LOCATION_OF_INTEREST
    )
end


function SmithySpot:trigger_failed_defense()
    self:lose_by_conquest()
end


function SmithySpot:trigger_unconditional_surrender_incident()
    self:lose_by_conquest()
end


function SmithySpot:lose_by_conquest()
    cm:show_message_event_located(self.controlling_faction_name,
        "event_feed_strings_text_title_event_land_enc_smithy_lost",
        "event_feed_strings_text_subtitle_event_land_enc_smithy_lost",
        "event_feed_strings_text_description_event_land_enc_smithy_lost",
        self.coordinates[1],
        self.coordinates[2],
        false,
        EVENT_IMAGE_ID_LOCATION_OF_INTEREST
    )
    self:change_owner_through_occupation(self.visiting_enemy_faction_name)
    self:reset_defense_flags()
end


function SmithySpot:reset_defense_flags()
    self.is_reclamation_triggered = false
    self.is_defense_triggered = false
    self.visiting_enemy_character = false
    self.visiting_enemy_faction_name = false    
end


function SmithySpot:is_occupied()
    return self.controlling_faction_name ~= ""
end


function SmithySpot:is_occupied_by_player()
    local player_faction_name = cm:get_local_faction_name()
    return self.controlling_faction_name == player_faction_name
end


function SmithySpot:is_occupied_by_same_faction(faction_name)
    return self.controlling_faction_name == faction_name
end


function SmithySpot:is_prohibited_subculture(visiting_faction)
    local visiting_subculture = visiting_faction:subculture()
    return visiting_subculture == "wh2_main_rogue" or visiting_subculture == "wh_main_sc_grn_savage_orcs" or visiting_subculture == "wh_main_sc_teb_teb"
end


function SmithySpot:is_faction_at_war_with_owner(visiting_faction)
    out("SmithySpot:is_faction_at_war_with_owner controlling_faction_name=" .. self.controlling_faction_name)
    local controlling_faction = cm:get_faction(self.controlling_faction_name)
    if controlling_faction == false then
        out("SmithySpot:is_faction_at_war_with_owner controlling faction was false")
        return false
    end
    return controlling_faction:at_war_with(visiting_faction)
end


function SmithySpot:change_owner_through_occupation(faction)
    self:set_controlling_faction(faction)
end


function SmithySpot:change_owner_through_conquest(faction, is_player, representative_character)
    self:set_controlling_faction(faction)
    
    if is_player then
        self:trigger_incident(self.event.reclamation.victory_incident, representative_character, self.event.targets)
    end
end


function SmithySpot:set_controlling_faction(faction)
    if type(faction) == "string" then
        faction = cm:get_faction(faction)
    end
        
    -- The faction has been destroyed and the smithy has been abandoned or the faction cannot occupy
    if not faction or faction == "" then
        self.controlling_faction_name = ""
        self.controlling_faction_subculture = ""
    else
        self.controlling_faction_name = faction:name()
        self.controlling_faction_subculture = faction:subculture()        
    end
    
    self.turns_under_control = 0
end


-- check that controlling faction is not dead. 
function SmithySpot:update_state_through_turn_passing()
    local controlling_faction = self:check_if_owner_is_alive_and_return_faction()
    if self:is_occupied() then
        self:force_enemy_invasion_if_possible()
        
        self:reward_owner_faction(controlling_faction)
        self:update_visit_cooldown(controlling_faction:name())
        
        self.turns_under_control = self.turns_under_control + 1
    end
end


function SmithySpot:check_if_owner_is_alive_and_return_faction()
    local controlling_faction = cm:get_faction(self.controlling_faction_name)
    if not controlling_faction then
        self.controlling_faction_name = ""
        return nil
    end
    
    if not cm:faction_is_alive(controlling_faction) then
        self.controlling_faction_name = ""
        return nil
    end
    return controlling_faction
end


function SmithySpot:force_enemy_invasion_if_possible()
    -- TODO
end


function SmithySpot:reward_owner_faction(controlling_faction)
    local turns_till_reward = 9999
    if self:is_occupied_by_player() then
        -- if the smith is under player control, give an ancillary every [ancillary_reward_turn] configurable through MCT and the smithing level
        turns_till_reward = self.turns_under_control % self:reward_turn_given_level()
    else
        -- if the smith is under AI control. Every 5 levels give an ancillary to their faction (flat)
        turns_till_reward = self.turns_under_control % 5
    end
    
    if turns_till_reward == 0 then
        --TODO check wether it is the player faction
        -- if its an ai filter the event
        -- campaign_manager:disable_event_feed_events(boolean should disable, [string event categories],[string event subcategories], [string event])
        local representative_character = cm:get_highest_ranked_general_for_faction(controlling_faction)
        self:trigger_incident(self.event.tribute_incident, representative_character, self.event.targets)
    end
end


function SmithySpot:reward_turn_given_level()
    return (4 - self.level) * 5 -- [ancillary_reward_turn]
end


function SmithySpot:is_on_cooldown()
    return self.visit_cooldown > 0
end


function SmithySpot:update_visit_cooldown(visiting_faction_name)
    if self:is_occupied_by_player() and self.visit_cooldown > 0 then
        self.visit_cooldown = self.visit_cooldown - 1
        -- you can visit now
        if self.visit_cooldown == 0 then
            cm:show_message_event_located(visiting_faction_name,
                "event_feed_strings_text_title_event_land_enc_smithy_visit_available",
                "event_feed_strings_text_subtitle_event_land_enc_smithy_visit_available",
                "event_feed_strings_text_description_event_land_enc_smithy_visit_available",
                self.coordinates[1],
                self.coordinates[2],
                false,
                EVENT_IMAGE_ID_LOCATION_OF_INTEREST
            )
        end
    end
end

function SmithySpot:get_defensive_army() 
    local battle_level = 3
    if self:is_occupied_by_player() then
        battle_level = self.level
    end
    
    out("LEAPOI - SmithySpot-get_defensive_army controlling_faction_name:" .. self.controlling_faction_name .. ", controlling_faction_subculture:" .. self.controlling_faction_subculture .. ", battle_level=" .. battle_level)
    
    return Army:new_from_faction_and_subculture_and_level(self.controlling_faction_name, self.controlling_faction_subculture, battle_level)
end

-------------------------
--- Constructors
-------------------------
function SmithySpot:new_from_coordinates(old_spot, index, initial_owning_faction)   
    SmithySpot.__index = SmithySpot
    setmetatable(SmithySpot, {__index = Spot})
    local t = old_spot
    -- initalize variables related only to smithy spot
    setmetatable(t, SmithySpot)
    t:set_controlling_faction(initial_owning_faction)
    return t
end
                            
return SmithySpot