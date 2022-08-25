require("script/land_encounters/utils/strings")

local Zone = require("script/land_encounters/models/Zone")

-------------------------
--- Constant values of the class [DO NOT CHANGE]
-------------------------
local DEFAULT_ACTIVE_SPOT_PERCENTAGE = 1.00--0.75
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
    battle_event_factory = false,
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

function LandEncounterManager:generate_land_encounters(coordinates_by_zone, perpetual_coordinates_with_types, turn_number)
    -- Create new land encounters given the map coordinates from whatever map was selected
    self:initialize_spots_by_zone(coordinates_by_zone, turn_number)
    -- Show those encounters in the map with their respective events
    self:populate_land_encounters(turn_number)
    -- Initialize the points of interest
    self:initialize_points_of_interest_by_zone(perpetual_coordinates_with_types)
    -- Activate the points of interest
    self:activate_points_of_interest_by_zone()
end


-- Restores the data from a previous saved spot
function LandEncounterManager:restore_from_previous_state(coordinates_by_zone, perpetual_coordinates_with_types, turn_number)
    -- Create new land encounters given the map coordinates from whatever map was selected
    self:initialize_spots_by_zone(coordinates_by_zone, turn_number)
    -- Restore the data inside each encounter
    self:reinstate_zone_land_encounters(self.previous_state, turn_number)
    
    self:initialize_points_of_interest_by_zone(perpetual_coordinates_with_types)
    --Reinstates the state of the points of interest
    self:reinstate_zone_points_of_interest(self.previous_state, turn_number)
end


-- Initialize the spots from the map coordinates given, through iterating from them. 
function LandEncounterManager:initialize_spots_by_zone(coordinates_by_zone, turn_number)
    self.zones = {}
    for zone_name, zone_coordinates in pairs(coordinates_by_zone) do
        local zone = Zone:new()
        zone:initialize_from_zone_with_coordinates(zone_name, zone_coordinates, self.active_spot_percentage, self.battle_percentage, turn_number)
        table.insert(self.zones, zone)
    end
end


function LandEncounterManager:initialize_points_of_interest_by_zone(perpetual_coordinates_with_types)
    for i = 1, #self.zones do
        local zone = self.zones[i]
        out("LEAPOI - LandEncounterManager:initialize_points_of_interest_by_zone Zone:" .. zone.name)
        zone:initialize_points_of_interest(perpetual_coordinates_with_types[zone.name])
    end
end


-- Given the [spots] are initialized, initialize some of the spots to become land encounters that can give events or battles
function LandEncounterManager:populate_land_encounters(turn_number)
    self.battle_event_factory.turn_number = turn_number
    for i = 1, #self.zones do
        self:populate_zone(self.zones[i])
    end
end


function LandEncounterManager:activate_points_of_interest_by_zone()
    for i = 1, #self.zones do
        self.zones[i]:activate_points_of_interest()
    end
end


function LandEncounterManager:reinstate_zone_land_encounters(previous_state, turn_number)
    self.battle_event_factory.turn_number = turn_number
    for i = 1, #self.zones do
        local active_battle_spot_index = self.zones[i]:reinstate(previous_state, self.battle_event_factory)

        if active_battle_spot_index ~= nil then
            
            self.invasion_battle_manager:set_auxiliary_army_for_reset(auxiliary_army)
            self.invasion_battle_manager:setup_encounter_force_removal("encounter_invasion")
            self.invasion_battle_manager:reset_state_post_battle(
                self.zones[i], 
                self.zones[i].spots[active_battle_spot_index]:get_class(),
                active_battle_spot_index, 
                "encounter_invasion"
            )
        end
    end
end


function LandEncounterManager:reinstate_zone_points_of_interest(previous_state)
    for i = 1, #self.zones do
        local active_poi_spot_index = self.zones[i]:reinstate_points_of_interest(previous_state)
        
        if active_poi_spot_index ~= nil then
            self.invasion_battle_manager:set_auxiliary_army_for_reset(self.zones[i].points_of_interest[active_poi_spot_index]:get_defensive_army())
            self.invasion_battle_manager:setup_encounter_force_removal("defender_invasion")
            self.invasion_battle_manager:reset_state_post_battle(
                self.zones[i], 
                self.zones[i].points_of_interest[active_poi_spot_index]:get_class(), 
                active_poi_spot_index, 
                "defender_invasion"
            )
        end
    end
end


function LandEncounterManager:update_land_encounters(turn_number)
    self.battle_event_factory.turn_number = turn_number
    for i = 1, #self.zones do
        -- related to land_encounters
        self.zones[i]:update_occupied_and_prohibited_spot_states()
        self.zones[i]:set_battles_distribution_by_turn(turn_number)
        self:populate_zone(self.zones[i], turn_number)
        
        -- related to points_of_interest
        self.zones[i]:update_points_of_interest_by_turn(turn_number)
    end    
end


function LandEncounterManager:populate_zone(zone, turn_number)
    if zone:can_add_land_encounters() then
        zone:add_land_encounters(self.battle_event_factory)
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
    self.dilemma_zone_and_spot = self:find_spot_and_zone(context)
    self.dilemma_zone_and_spot.zone:trigger_spot_event(context, self.dilemma_zone_and_spot.spot_index, self.dilemma_zone_and_spot.spot_type, self.invasion_battle_manager)
end

---------------------------
-- DILEMMAS
---------------------------
function LandEncounterManager:trigger_dilemma_by_choice(context)
    self.dilemma_zone_and_spot.zone:trigger_spot_dilemma_by_choice(self.invasion_battle_manager, context, self.dilemma_zone_and_spot.spot_index, self.dilemma_zone_and_spot.spot_type)
end


function LandEncounterManager:find_spot_and_zone(context)
    local marker_id = context:area_key()
    local zone_name_and_spot_index = process_marker_id(marker_id)
    for i=1, #self.zones do
        if self.zones[i].name == zone_name_and_spot_index[1] then
            return { zone = self.zones[i], spot_index = zone_name_and_spot_index[2], spot_type = zone_name_and_spot_index[3] }
        end
    end
    return nil
end


-- exports the entirety of the data of the land battles for saving it in a flattened table as expected by the save state manager of creative assembly
function LandEncounterManager:export_state_as_table()
    local land_encounter_state = {}
    for i=1, #self.zones do
        -- save state of land encounters
        for j=1, #self.zones[i].spots do
            local current_spot = self.zones[i].spots[j]
            local flattened_key = self.zones[i].name .. "_" .. tostring(current_spot.coordinates[1]) .. "_" .. tostring(current_spot.coordinates[2])
            current_spot:flatten_info(land_encounter_state, flattened_key)
        end
        
        --save state of points of interest
        for j=1, #self.zones[i].points_of_interest do
            local current_spot = self.zones[i].points_of_interest[j]
            current_spot:flatten_info(land_encounter_state, self.zones[i].name)
        end
    end
    return land_encounter_state
end

--=======================
--- Constructors
--=======================
function LandEncounterManager:newFrom(core, invasion_battle_manager, battle_event_factory)
    local t = { 
        zones = {},
        active_spot_percentage = DEFAULT_ACTIVE_SPOT_PERCENTAGE,
        battle_percentage = DEFAULT_BATTLE_PERCENTAGE,
        core = core,
        invasion_battle_manager = invasion_battle_manager,
        battle_event_factory = battle_event_factory 
    }
    setmetatable(t, self)
    self.__index = self
    return t
end

return LandEncounterManager