local Spot = require("script/land_encounters/models/spots/abstract_classes/Spot")


------------------------------------------------
--- Constant values of the class
------------------------------------------------
--TODO: Remove in August update. Is an experiment to fix the problems with the WH3 function that triggers events
local event_to_targets = {
    ["land_enc_incident_tomb_robbing"] = { character = true, force = false, faction = false, region = false },
    ["land_enc_incident_abandoned_camp"] = { character = true, force = true, faction = false, region = false },
    ["land_enc_incident_buried_relics"] = { character = true, force = false, faction = false, region = false },
    ["land_enc_incident_hidden_temple"] = { character = true, force = true, faction = false, region = false },
    ["land_enc_incident_caravan_remnants"] = { character = true, force = false, faction = false, region = false },
    ["land_enc_incident_legendary_bard"] = { character = false, force = false, faction = true, region = false },
    ["land_enc_incident_whispers_of_the_gods"] = { character = true, force = true, faction = false, region = false }
}

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
    
    self:trigger_incident_for_character(self.event, character, event_to_targets[self.event])

    --out("LEAPOI - Triggered targeted treasure land encounter for =" .. character:get_forename())
    
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