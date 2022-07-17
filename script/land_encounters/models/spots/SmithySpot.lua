--[[ Specification
For the player:
The player has to visit it at least once every 3 turns to unlock it for the turn it visits it
- Should be upgradeable by giving it money (Up to three times selling shit in the first tier and etc etc)
- If an enemy faction crosses through it given the level it will trigger a defensive battle.
- If 
If u

For the AI:
- Gives a random ancillary every 4 turns if under control of the AI

Work advanced
 TODO

]]--

local Spot = require("script/land_encounters/models/spots/abstract_classes/Spot")

------------------------------------------------
--- Constant values of the class [DO NOT CHANGE]
------------------------------------------------
local FIRST_OPTION = 0

local EVENT_IMAGE_ID_LOCATION_OF_INTEREST = 1017

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
    event = nil, --[[ 
        { reclamation: -- when reclaiming the point for the HUMAN player faction if the point is occupied a battle dilemma is triggered where if one wins, the smithy passes to give their benefits to that faction. If the smithy is not occupied by anyone a default occupation event is triggered
          {
            dilemma: string, 
            victory_incident: string, 
            avoidance_incident: string,
            default_occupation_incident: string
          }, 
        -- the contrary event. By default when an enemy faction passes through the control point it will automatically try to reclaim the smithy for themselves reclaiming them. To avoid this a dilemma will be triggered in where you will need to file a battle for the place.
          defense: 
          {
            dilemma: string,
            victory_incident: string,
            loss_incident: string,
            surrender_incident: string
          }
        -- 
          activation_incident: string,
        -- warns the player that the spot is ready for another visit to open the store menu (mortuary cult).
          reactivation_incident: string, 
        -- the tribute that makes it all worthy. Will automatically give a gift depending on the smithy current level
          gift_incident: string,
        -- if the player visits the smithy while on cooldown this event will appear
          cooldown_incident: string
        }
    ]]--
    is_defense_triggered = false,
    is_reclamation_triggered = false,
    
    level = 1,
    controlling_faction_name = "",
    is_player_controlled = false,
    turns_under_control = 0,
    reactivation_countdown = 0
}


-------------------------
--- Class Methods
-------------------------
-- Overriden Methods
function SmithySpot:get_class()
    return "SmithySpot"
end

function SmithySpot:set_event_from_string(event_as_string)
    local event_in_parts = split_by_regex(event_as_string)
    self.event = { dilemma = event_in_parts[1], victory_incident = event_in_parts[2], avoidance_incident = event_in_parts[3] }
end

-- Event can be nil due to it loosing it's value once used.
function SmithySpot:get_event_as_string()
    if self.event ~= nil then
        return self.event.dilemma .. "/" .. self.event.victory_incident .. "/" .. self.event.avoidance_incident
    else
        return nil
    end
end

function SmithySpot:trigger_event(context)
    local visiting_character = context:family_member():character()
    local visiting_faction = visiting_character:faction()
    
    local can_remove_encounter_marker = false
    
    if self:is_human_and_it_is_its_turn() then
        if self:is_occupied_by_same_faction(visiting_faction:name()) then
            if self:is_on_cooldown() then
                self:trigger_incident(self.event.cooldown_incident, visiting_character)
            else
                -- enable mortuary cult interface for this turn letting the player buy stuff from the store
                uim:override("mortuary_cult"):unlock()
            end
        else
            if not self:is_faction_at_war_with_owner(visiting_faction) then
                -- If neutral or allies
                cm:show_message_event_located(visiting_faction:name(),
                    "event_feed_strings_text_title_event_smithy_diplomatic_visit",
                    "event_feed_strings_text_subtitle_event_smithy_diplomatic_visit",
                    "event_feed_strings_text_description_event_smithy_diplomatic_visit",
                    self.coordinates[1],
                    self.coordinates[2],
                    false,
                    EVENT_IMAGE_ID_LOCATION_OF_INTEREST
                )
            else
                out("LEAPOI - Triggering smith land encounter: " .. self.event.reclamation.dilemma)
                -- Character is in normal stance and can trigger the event
                if self:character_can_trigger_dilemma(visiting_character) then
                    -- if the smith spot is not occupied, due to its owner faction being defeated or never have been occupied
                    if self:is_occupied() then
                        cm:trigger_dilemma(player_faction_name, self.event.reclamation.dilemma) 
                        out("LEAPOI - Smithy Battle Dilemma " .. self.event.reclamation.dilemma .. "; TRIGGERED")
                    else
                        self:trigger_incident(self.event.reclamation.default_occupation_incident, visiting_character)
                        out("LEAPOI - Smithy Battle Dilemma " .. self.event.dilemma .. "; TRIGGERED")
                    end
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
            end
        end
    else -- is not an human faction and not an ally so the faction attacks the point
        if self:is_faction_at_war_with_owner(visiting_faction) then
            if self:is_occupied_by_player() then
                -- the smithy is attacked, triger related event
                local player_faction_name = cm:get_local_faction_name()
                cm:trigger_dilemma(player_faction_name, self.event.defense.dilemma)
            else
                -- the smithy changes hands randomly automatically to the enemy faction
                if random_number(100) >= 75 then
                    local is_player = false
                    self:change_owner_through_conquest(faction_name, is_player, visiting_character)
                end
            end
        end
    end
    
    return can_remove_encounter_marker
end


function SmithySpot:trigger_dilemma_by_choice(invasion_battle_manager, zone, spot_index, is_defense, context)
    local choice = context:choice()
    local faction = context:faction()
    
    local can_remove_encounter_marker = false
    out("LEAPOI - SmithySpot:trigger_dilemma_by_choice= " .. tostring(choice) .. ", type= " .. type(choice))
    if choice == FIRST_OPTION then
        out("LEAPOI - First choice -- Battle time!")
        local in_same_region = false
        local x, y = cm:find_valid_spawn_location_for_character_from_position(faction:name(), self.coordinates[1], self.coordinates[2], in_same_region)
        
        if is_defense then
            self.is_defense_triggered = true
            invasion_battle_manager:generate_defense_battle(self.event.defense.dilemma)
            invasion_battle_manager:reset_state_post_battle(zone, spot_index, invasion_battle_manager.DEFAULT_DEFENDER_INVASION)
        else
            self.is_reclamation_triggered = true
            invasion_battle_manager:generate_battle(self.event.reclamation.dilemma, self.player_character, {x, y})
            invasion_battle_manager:reset_state_post_battle(zone, spot_index, invasion_battle_manager.DEFAULT_ENEMY_INVASION)
        end

        return can_remove_encounter_marker
    else
        out("LEAPOI - Second choice -- No thanks!")
        if is_defense then
            self:trigger_unconditional_surrender_incident()
        else
            self:trigger_battle_avoidance_incident()            
        end

        return can_remove_encounter_marker
    end
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


function SmithySpot:is_faction_at_war_with_owner(visiting_faction)
    local controlling_faction = cm:get_faction(self.controlling_faction_name)
    return controlling_faction:at_war_with(visiting_faction)
end


function SmithySpot:change_owner_through_conquest(faction_name, is_player, representative_character)
    self.controlling_faction_name = faction_name
    self.is_player_controlled = is_player
    self.turns_under_control = 0
    self.reactivation_countdown = 0
    
    if is_player then
        self:trigger_incident(self.event.reclamation.victory_incident, representative_character)
    end
end


-- check that controlling faction is not dead. 
function SmithySpot:update_state_through_turn_passing()
    local controlling_faction = self:check_if_owner_is_alive_and_return_faction()
    if self:is_occupied() then
        -- if the smith is close to any enemy faction a chance of a random invasion should be triggered with a low chance
        -- TODO: Ask Vandy on how to do this
        self:force_enemy_invasion_if_possible()
        
        self:reward_owner_faction(controlling_faction)
        
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
    local representative_character = cm:get_highest_ranked_general_for_faction(controlling_faction)
    
    local turns_till_reward = 9999
    if self:is_occupied_by_player() then
        -- if the smith is under player control, give an ancillary every [ancillary_reward_turn] configurable through MCT and the smithing level
        turns_till_reward = self.turns_under_control % self:reward_turn_given_level()
    else
        -- if the smith is under AI control. Every 5 levels give an ancillary to their faction (flat)
        turns_till_reward = self.turns_under_control % 5
    end
    
    if turns_till_reward == 0 then
        self:trigger_incident(self.event.gift_incident, representative_character)
    end
end


function SmithySpot:reward_turn_given_level()
    return (4 - self.level) * 5 -- [ancillary_reward_turn]
end


-------------------------
--- Constructors
-------------------------
function SmithySpot:newFrom(old_spot)
    SmithySpot.__index = SmithSpot
    setmetatable(SmithySpot, {__index = Spot})
    local t = old_spot
    -- initalize variables related only to battle spot
    setmetatable(t, SmithySpot)
    return t
end
                            
return SmithySpot