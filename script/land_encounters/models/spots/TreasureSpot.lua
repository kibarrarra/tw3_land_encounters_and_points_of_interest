local Spot = require("script/land_encounters/models/spots/abstract_classes/Spot")

-------------------------
--- Properties definition
-------------------------
local TreasureSpot = {
    -- logic properties
    index = 0,
    coordinates = {0, 0},
    is_active = false,
    automatic_deactivation_countdown = 0, -- Should automatically dissapear after X turn
    -- marker properties
    marker_id = "",
    -- quest properties
    event = nil

}

-------------------------
--- Class Methods
-------------------------
-- Overriden Methods
function TreasureSpot:get_class()
    return "TreasureSpot"
end

function TreasureSpot:get_event_as_string()
    return self.event
end

function TreasureSpot:set_event_from_string(event)
    self.event = event
end

function TreasureSpot:trigger_event(context)
    local character = context:family_member():character()

    local faction_cqi = character:faction():command_queue_index()
    local incident_key = self.event
    local target_faction_cqi = 0 -- ignore flag
    local secondary_faction_cqi = 0
    local character_cqi = character:command_queue_index()
    local military_force_cqi = 0 --character:military_force():command_queue_index()
    local region_cqi = 0
    local settlement_cqi = 0
    cm:trigger_incident_with_targets(faction_cqi, incident_key, target_faction_cqi, secondary_faction_cqi, character_cqi, military_force_cqi, region_cqi, settlement_cqi)
    out("LEAPOI - Triggered targeted treasure land encounter " .. character:get_forename())
    
    return true -- can_remove_encounter_flag. Always true in the case of treasure spots
end


-------------------------
--- Constructors
-------------------------
-- https://stackoverflow.com/questions/65961478/how-to-mimic-simple-inheritance-with-base-and-child-class-constructors-in-lua-t
function TreasureSpot:newFrom(old_spot)
    TreasureSpot.__index = TreasureSpot
    setmetatable(TreasureSpot, {__index = Spot})
    local t = old_spot
    setmetatable(t, TreasureSpot)
    return t
end

return TreasureSpot