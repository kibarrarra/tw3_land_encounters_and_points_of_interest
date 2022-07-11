require("script/land_encounters/utils/random")

local treasure_events = require("script/land_encounters/constants/events/treasure_type_events")
local battle_events = require("script/land_encounters/constants/events/battle_type_events")

local Spot = require("script/land_encounters/models/Spot")
local TreasureSpot = require("script/land_encounters/models/spot_type/TreasureSpot")
local BattleSpot = require("script/land_encounters/models/spot_type/BattleSpot")

-------------------------
--- Constant values of the class [DO NOT CHANGE]
-------------------------
local SPOT_TURN_ACTIVATION_COOLDOWN = 5
local ACTIVE_STATE = 0
local ERASED_FLAG = nil

-------------------------
--- Properties definition
-------------------------
local Zone = {
    name = "Unknown",
    spots = {},
    -- Indicators
    treasure_spots = {}, -- indexes of the current active treasure spots [index of a spot] = STATE[0 = Registered but not created in the map, 1 = created in the map, nil = inactive ]
    treasure_spots_count = 0,
    max_treasures_count = 0,
    
    battle_spots = {}, -- indexes of the current active battle spots [index of a spot] = STATE[0 = Registered but not created in the map, 1 = created in the map, nil = inactive ]
    battle_spots_count = 0,
    max_battles_count = 0,
    
    prohibited_spots = {},
    
    total_spots = 0
}

-------------------------
--- Class Methods
-------------------------
function Zone:initialize_from_zone_with_coordinates(zone_name, zone_coordinates, active_spot_percentage, battle_percentage)
    self.name = zone_name
    self.spots = {}
    --out("LEAPOI - Zone:initialize_from_zone_with_coordinates - " .. zone_name .. ", #zone_coordinates : " ..  #zone_coordinates)
    for i = 1, #zone_coordinates do
        local spot = Spot:new()
        spot:initialize_from_coordinates(i, zone_coordinates[i])
        table.insert(self.spots, spot)
    end
    
    self:update_zone_indicators(active_spot_percentage, battle_percentage)
end


function Zone:update_zone_indicators(active_spot_percentage, battle_percentage)
    self.total_spots = table.getn(self.spots)
    local active_spots_count = math.floor(self.total_spots * active_spot_percentage)
    self.max_battles_count = math.floor(active_spots_count * battle_percentage)
    self.max_treasures_count = active_spots_count - self.max_battles_count
end


function Zone:can_add_land_encounters()
    self.treasure_spots_count = table.getn(self.treasure_spots)
    self.battle_spots_count = table.getn(self.battle_spots)
    if (self.treasure_spots_count + self.battle_spots_count) >= (self.max_treasures_count + self.max_battles_count) then
        return false
    else
        return true
    end
end


function Zone:update_occupied_and_prohibited_spot_states()
    self:release_prohibited_spots()
    self:update_turn_activation_cooldown(self.treasure_spots)
    self:update_turn_activation_cooldown(self.battle_spots)
end


function Zone:release_prohibited_spots()
    for spot_index, cooldown in pairs(self.prohibited_spots) do
        self.prohibited_spots[spot_index] = cooldown - 1
        if self.prohibited_spots[spot_index] == 0 then
            self.prohibited_spots[spot_index] = ERASED_FLAG
        end 
    end
end


function Zone:update_turn_activation_cooldown(flagged_spots)
    for spot_index, state in pairs(flagged_spots) do
        local deactivated_due_to_expiration = self.spots[spot_index]:check_if_active_and_countdown_reached()
        if deactivated_due_to_expiration then
            --out("LEAPOI - Zone:update_turn_activation_cooldown - Expired spot=" .. tostring(spot_index))
            self:deactivate_spot(spot_index)
        end
    end
end


function Zone:add_land_encounters()
    local disordered_indexes = randomic_length_shuffle(self.total_spots)
    --out("LEAPOI - Zone:add_land_encounters - zone_name=" .. self.name .. "number_of_spots=".. tostring(#self.spots) .. ", total_spots_value=" .. self.total_spots)
    for i= 1, #disordered_indexes do
        --out("LEAPOI - add_land_encounters {current_index=" .. tostring(i) .. ", disordered_indexes[current_index]=" .. tostring(disordered_indexes[i]).."}")
        -- after every land encounter added we should check that the total count does not surpass the total amount of encounters permitted
        if not self:can_add_land_encounters() then
            break
        end
        
        -- check if the current index is not registered as a treasure or battle spot
        local current_index = disordered_indexes[i]
        if (self.treasure_spots[current_index] == nil) and (self.battle_spots[current_index] == nil) and (self.prohibited_spots[current_index] == nil) then
            local random_event = nil
            -- Add the battles first
            if self.battle_spots_count < self.max_battles_count then
                --out("LEAPOI - Battle spot created")
                self.battle_spots[current_index] = 0 -- Registered but not created in the map
                random_event = battle_events[cm:random_number(#battle_events)]
                self.spots[current_index] = BattleSpot:newFrom(self.spots[current_index]) 
                --out("LEAPOI - Zone:add_land_encounters - Battle spot:{zone_name=" .. self.name .. ", index=" .. tostring(current_index) .. ", random_event=" .. random_event.dilemma .. "}")

            -- add the treasures later as they are less cool
            elseif self.treasure_spots_count < self.max_treasures_count then
                self.treasure_spots[current_index] = 0 -- Registered but not created in the map
                random_event = treasure_events[cm:random_number(#treasure_events)]
                self.spots[current_index] = TreasureSpot:newFrom(self.spots[current_index])  
                --out("LEAPOI - Zone:add_land_encounters - Treasure spot:{index=" .. tostring(current_index) .. ",random_event=" .. random_event .. "}")
            end
            
            if random_event ~= nil then
                self.spots[current_index]:activate(self.name, random_event)
            end
        end
    end
end


function Zone:reinstate(previous_state)
    local activate_battle_spot_index = nil
    for i=1, #self.spots do
        local flattened_key = self.name .. "_" .. tostring(self.spots[i].coordinates[1]) .. "_" .. tostring(self.spots[i].coordinates[2])
        local spot_type = previous_state[flattened_key .. "_type"]
        if spot_type ~= nil then
            --out("LEAPOI - Zone:reinstate - key=" .. flattened_key ..", zone_name=" .. self.name ..", spot_type=" .. spot_type)
            self.spots[i].is_active = previous_state[flattened_key .. "_active"]
            
            if spot_type == "TreasureSpot" and self.spots[i].is_active then
                self.spots[i] = TreasureSpot:newFrom(self.spots[i])
                
                self:reinstate_spot_basic_data(i, previous_state[flattened_key .. "_event"], previous_state[flattened_key .. "_deactivation"],  previous_state[flattened_key .. "_marker"], self.treasure_spots)
                
            elseif spot_type == "BattleSpot" and self.spots[i].is_active then
                self.spots[i] = BattleSpot:newFrom(self.spots[i])
                
                self:reinstate_spot_basic_data(i, previous_state[flattened_key .. "_event"], previous_state[flattened_key .. "_deactivation"],  previous_state[flattened_key .. "_marker"], self.battle_spots)
                self.spots[i].is_triggered = previous_state[flattened_key .. "_is_triggered"]
                
                if self.spots[i].is_triggered then
                    activate_battle_spot_index = i
                end
            end
        end
    end
    return activate_battle_spot_index
end


function Zone:reinstate_spot_basic_data(spot_index, event, deactivation_countdown, marker_id, flagged_spots)
    --out("LEAPOI - Spot data:{index=" .. spot_index ..", deactivation_countdown=" .. tostring(deactivation_countdown) .. ", marker_id=" .. marker_id .. ", is_active=" .. tostring(self.spots[spot_index].is_active) .. "}")
    self.spots[spot_index].automatic_deactivation_countdown = deactivation_countdown
    self.spots[spot_index].marker_id = marker_id
    self.spots[spot_index]:set_event_from_string(event)
    flagged_spots[spot_index] = ACTIVE_STATE
end


-- TRIGGERING RELATED METHODS
-- Depending of the spot type a different kind of event will trigger controlled via inheritance
function Zone:trigger_spot_event(context, spot_index)
    local can_be_removed = self.spots[spot_index]:trigger_event(context)
    if can_be_removed then
        self:deactivate_spot(spot_index)
    end
end


function Zone:trigger_spot_dilemma_by_choice(invasion_battle_manager, context, spot_index)
    local can_be_removed = self.spots[spot_index]:trigger_dilemma_by_choice(invasion_battle_manager, self, spot_index, context)
    if can_be_removed then
        self:deactivate_spot(spot_index)
    end
end


-- DESTRUCTION RELATED METHODS
function Zone:deactivate_spot(spot_index)
    local spot_type = self.spots[spot_index]:get_class()
    -- only this spot types can be removed, no other of the types can.
    if spot_type == "TreasureSpot" then
        self.treasure_spots[spot_index] = ERASED_FLAG 
    elseif spot_type == "BattleSpot" then
        self.battle_spots[spot_index] = ERASED_FLAG
    end
    self.prohibited_spots[spot_index] = SPOT_TURN_ACTIVATION_COOLDOWN -- entering cooldown till 0 and can be reselected
    
    self.spots[spot_index]:deactivate()
end

-------------------------
--- Constructors
-------------------------
function Zone:new()
    local t = { name = "Unknown", spots = {}, treasure_spots = {}, treasure_spots_count = 0, max_treasures_count = 0, battle_spots = {}, battle_spots_count = 0, prohibited_spots = {}, max_battles_count = 0, total_spots = 0 }
    setmetatable(t, self)
    self.__index = self
    return t
end

return Zone