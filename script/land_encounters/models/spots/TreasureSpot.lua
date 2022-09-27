local Spot = require("script/land_encounters/models/spots/abstract_classes/Spot")

local elligible_items = require("script/land_encounters/constants/items/balancing_items")

------------------------------------------------
--- Constant values of the class
------------------------------------------------


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


function TreasureSpot:set_event_from_string(event_as_string)
    -- check that the string is a table
    local event_in_parts = split_by_regex(event_as_string, "/")
    
    if #event_in_parts > 1 then
        local targets_in_parts = { "false", "true", "false", "false" }
        if event_in_parts[2] ~= nil then
            targets_in_parts = split_by_regex(event_in_parts[2], "!")
        end
        
        local effect = false
        if stringtoboolean[event_in_parts[3]] == nil then -- means we have an effect
            effect = event_in_parts[3]
        end
        
        self.event = { 
            incident = event_in_parts[1], 
            targets = { 
                character = stringtoboolean[targets_in_parts[1]], 
                force = stringtoboolean[targets_in_parts[2]], 
                faction = stringtoboolean[targets_in_parts[3]], 
                region = stringtoboolean[targets_in_parts[4]] 
            },
            effect = effect
        }
    else
        self.event = self:get_clean_up_event()
    end
end


function TreasureSpot:get_event_as_string()
    if self.event == nil or type(self.event) == "string" then
        self.event = self:get_clean_up_event() -- shouldn't be nil. Return clean up event and clean
    end
    
    local effect = false
    if booleantostring[self.event.effect] == nil then -- means we have an effect
        if self.event.effect == nil then
            effect = "false"
        else
            effect = self.event.effect
        end
    else 
        effect = booleantostring[self.event.effect]
    end
    
    return self.event.incident .. "/" .. booleantostring[self.event.targets.character] .. "!" .. booleantostring[self.event.targets.force] .. "!" .. booleantostring[self.event.targets.faction] .. "!" .. booleantostring[self.event.targets.region] .. "/" .. effect
end


function TreasureSpot:trigger_event(context)
    local character = context:family_member():character()
    local triggering_faction = character:faction()
    local can_remove_encounter_flag = true
    
    if self:is_human_and_it_is_its_turn(triggering_faction) then
        self:trigger_incident_for_character(self.event.incident, character, self.event.targets)
    elseif not triggering_faction:is_human() then
        local trigger_event_feed = false
        cm:add_ancillary_to_faction(triggering_faction, elligible_items[random_number(#elligible_items)], trigger_event_feed)
        cm:treasury_mod(triggering_faction:name(), 4000)

        if self.event ~= nil and self.event.effect ~= false and self.event.targets.force and cm:char_is_general_with_army(character) then
            local militar_force_cqi = character:military_force():command_queue_index()
            cm:apply_effect_bundle_to_force(self.event.effect, militar_force_cqi, 5)
        end
    end

    return can_remove_encounter_flag
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