require("script/land_encounters/utils/strings")

local Spot = require("script/land_encounters/models/Spot")

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
    local event_in_parts = split_by_regex(event_as_string)
    self.event = { dilemma = event_in_parts[1], victory_incident = event_in_parts[2], avoidance_incident = event_in_parts[3] }
end


-- Event can be nil due to it loosing it's value once used.
function BattleSpot:get_event_as_string()
    if self.event ~= nil then
        return self.event.dilemma .. "/" .. self.event.victory_incident .. "/" .. self.event.avoidance_incident
    else
        return nil
    end
end


function BattleSpot:trigger_event(context)
    self.player_character = context:family_member():character()
    local player_faction_name = self.player_character:faction():name()
    
    local can_remove_encounter = false

    if self:is_human_and_it_is_its_turn() then
        --out("LEAPOI - Triggering battle land encounter: " .. self.event.dilemma)
        -- Character is in normal stance and can trigger the event
        if self.player_character:military_force():active_stance() == "MILITARY_FORCE_ACTIVE_STANCE_TYPE_DEFAULT" then
            cm:trigger_dilemma(player_faction_name, self.event.dilemma)
            --out("LEAPOI - Battle Dilema " .. self.event.dilemma .. "; TRIGGERED")
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
    
    return can_remove_encounter
end


function BattleSpot:trigger_dilemma_by_choice(invasion_battle_manager, zone, spot_index, context)
    local choice = context:choice()
    local faction = context:faction()
    --out("LEAPOI - BattleSpot:trigger_dilemma_by_choice= " .. tostring(choice) .. ", type= " .. type(choice))
    if choice == FIRST_OPTION then
        --out("LEAPOI - First choice -- Battle time!")
        local in_same_region = false
        local x, y = cm:find_valid_spawn_location_for_character_from_position(faction:name(), self.coordinates[1], self.coordinates[2], in_same_region)
        self.is_triggered = true
        invasion_battle_manager:generate_battle(context, self.event.dilemma, self.player_character, {x, y})
        invasion_battle_manager:reset_state_post_battle(zone, spot_index)
        return false
    else
        --out("LEAPOI - Second choice -- No thanks!")
        self:trigger_battle_avoidance_incident()
        return true
    end
end


function BattleSpot:trigger_battle_avoidance_incident()
    self:trigger_incident(self.event.avoidance_incident)
end


function BattleSpot:trigger_victory_incident()
    self:trigger_incident(self.event.victory_incident)
end


function BattleSpot:trigger_incident(incident_key)
    if self:is_human_and_it_is_its_turn() then 
        -- if the campaign has been reloaded from a battle then we don't have the current player
        if self.player_character == nil then
            local faction_name = cm:get_local_faction_name()
            local only_general = true
            local is_garrison_commander = false
            local local_character, distance = cm:get_closest_character_to_position_from_faction(faction_name, self.coordinates[1], self.coordinates[2], only_general, is_garrison_commander)
            self.player_character = local_character
        end
        
        local faction_cqi = self.player_character:faction():command_queue_index()
        local incident_key = incident_key
        local target_faction_cqi = 0 -- ignore flag
        local secondary_faction_cqi = 0
        local character_cqi = self.player_character:command_queue_index()
        local military_force_cqi = self.player_character:military_force():command_queue_index()
        local region_cqi = 0
        local settlement_cqi = 0
        cm:trigger_incident_with_targets(faction_cqi, incident_key, target_faction_cqi, secondary_faction_cqi, character_cqi, military_force_cqi, region_cqi, settlement_cqi)
        --out("LEAPOI - Triggered targeted battle victory/avoidance land encounter incident")
    end
end


function BattleSpot:deactivate()
    Spot.deactivate(self)
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