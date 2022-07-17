require("script/land_encounters/utils/strings")

local Zone = require("script/land_encounters/models/Zone")

-------------------------
--- Constant values of the class [DO NOT CHANGE]
-------------------------
local DEFAULT_ACTIVE_SPOT_PERCENTAGE = 0.75
local DEFAULT_BATTLE_PERCENTAGE = 0.80

--=======================
--- Properties definition
--=======================
local LandEncounterManager = {
    zones = {},
    active_spot_percentage = DEFAULT_ACTIVE_SPOT_PERCENTAGE, -- should be changed through MCT. 1.0 for debugging. 0.75 normally. Should be configurable through MCT
    battle_percentage = DEFAULT_BATTLE_PERCENTAGE, -- 0.0 For debugging treasures, 1.0 for debugging battles. Common 0.5 should be configurable through MCT
    
    -- given that the dilemma context does not have an area_key(), we need to track it here
    dilemma_zone_and_spot = false,
    
    -- TODO: Ca managers. They don't seem to pass properly to functions outside their scope and importing them does not work. Passing their instances to the land encounters manager for using them in whenever instance needs them
    -- Core is the main manager for listeners.
    core = false,
    -- For creating random armies and creating invasions
    invasion_battle_manager = false,
    
    previous_state = false
}

--=======================
--- Class Methods
--=======================
-------------------------
-- POPULATION OF DATA RELATED METHODS
-------------------------
function LandEncounterManager:has_previous_state()
    return self.previous_state ~= false
end

function LandEncounterManager:generate_land_encounters(coordinates_by_zone)
    -- we create new land encounters given the map coordinates from whatever map was selected
    self:initialize_spots_by_zone(coordinates_by_zone)
    -- we show those encounters in the map with their respective events
    self:populate_land_encounters()
end


-- Restores the data from a previous saved spot
function LandEncounterManager:restore_from_previous_state(coordinates_by_zone)
    -- we create new land encounters given the map coordinates from whatever map was selected
    self:initialize_spots_by_zone(coordinates_by_zone)
    -- we restore the data inside each encounter
    self:reinstate_land_encounters(self.previous_state)
end


-- Initialize the spots from the map coordinates given, through iterating from them. 
function LandEncounterManager:initialize_spots_by_zone(coordinates_by_zone)
    self.zones = {}
    for zone_name, zone_coordinates in pairs(coordinates_by_zone) do
        local zone = Zone:new()
        zone:initialize_from_zone_with_coordinates(zone_name, zone_coordinates, self.active_spot_percentage, self.battle_percentage)
        table.insert(self.zones, zone)
    end
end


-- Given the [spots] are initialized, initialize some of the spots to become land encounters that can give events or battles
function LandEncounterManager:populate_land_encounters()
    for i = 1, #self.zones do
        self:populate_zone(self.zones[i])
    end
end


function LandEncounterManager:reinstate_land_encounters(previous_state)
    for i = 1, #self.zones do
        local active_battle_spot_index = self.zones[i]:reinstate(previous_state)

        if active_battle_spot_index ~= nil then
            self.invasion_battle_manager:set_auxiliary_army_for_reset(self.zones[i].spots[active_battle_spot_index].event.dilemma)
            self.invasion_battle_manager:reset_state_post_battle(self.zones[i], active_battle_spot_index)
        end
    end
end


function LandEncounterManager:update_land_encounters()
    for i = 1, #self.zones do
        self.zones[i]:update_occupied_and_prohibited_spot_states()
        self:populate_zone(self.zones[i])
    end    
end


function LandEncounterManager:populate_zone(zone)
    if zone:can_add_land_encounters() then
        zone:add_land_encounters()            
    end
end

---------------------------
-- TRIGGERING RELATED METHODS
---------------------------
-- INCIDENTS
---------------------------
-- Checks wether an event should be triggered for the character entering a marker
function LandEncounterManager:check_if_is_triggerable_land_encounter(triggering_character, marker_id)
    return self:check_if_is_land_encounter_marker(marker_id) and self:check_triggering_character(triggering_character)
end


-- prevent triggering if it's not a general, or if it's a patrol army from Hertz's patrol mod
function LandEncounterManager:check_triggering_character(character)
    return cm:char_is_general_with_army(character) and character:military_force():force_type():key() ~= "PATROL_ARMY"
end


-- prevent triggering if it's not a land_encounter
function LandEncounterManager:check_if_is_land_encounter_marker(marker_id)
    return string.find(marker_id, "land_enc_marker_")
end


function LandEncounterManager:trigger_encounter(context)
    self.dilemma_zone_and_spot = self:find_zone(context)
    self.dilemma_zone_and_spot.zone:trigger_spot_event(context, self.dilemma_zone_and_spot.spot_index)
end

---------------------------
-- DILEMMAS
---------------------------
function LandEncounterManager:trigger_dilemma_by_choice(context)
    self.dilemma_zone_and_spot.zone:trigger_spot_dilemma_by_choice(self.invasion_battle_manager, context, self.dilemma_zone_and_spot.spot_index)
end


function LandEncounterManager:find_zone(context)
    local marker_id = context:area_key()
    local zone_name_and_spot_index = process_marker_id(marker_id)
    for i=1, #self.zones do
        if self.zones[i].name == zone_name_and_spot_index[1] then
            return { zone = self.zones[i], spot_index = zone_name_and_spot_index[2]}
        end
    end
    return nil
end

-- exports the entirety of the data of the land battles for saving it in a flattened table as expected by the save state manager of creative assembly
function LandEncounterManager:export_state_as_table()
    local land_encounter_state = {}
    for i=1, #self.zones do 
        for j=1, #self.zones[i].spots do
            local current_spot = self.zones[i].spots[j]
            --out("LEAPOI - LandEncounterManager:export_state_as_table - current_spot type = " .. type(current_spot))
            local flattened_key = self.zones[i].name .. "_" .. tostring(current_spot.coordinates[1]) .. "_" .. tostring(current_spot.coordinates[2])
            land_encounter_state[flattened_key .. "_type"] = current_spot:get_class()
            land_encounter_state[flattened_key .. "_event"] = current_spot:get_event_as_string()
            land_encounter_state[flattened_key .. "_marker"] = current_spot.marker_id
            land_encounter_state[flattened_key .. "_deactivation"] = current_spot.automatic_deactivation_countdown
            land_encounter_state[flattened_key .. "_active"] = current_spot.is_active
            
            if current_spot:get_class() == "BattleSpot" then
                land_encounter_state[flattened_key .. "_is_triggered"] = current_spot.is_triggered
            end
        end
    end
    return land_encounter_state
end

--=======================
--- Constructors
--=======================
function LandEncounterManager:newFrom(core, invasion_battle_manager)
    local t = { zones = {}, active_spot_percentage = DEFAULT_ACTIVE_SPOT_PERCENTAGE, battle_percentage = DEFAULT_BATTLE_PERCENTAGE, core = core, invasion_battle_manager = invasion_battle_manager }
    setmetatable(t, self)
    self.__index = self
    return t
end

return LandEncounterManager