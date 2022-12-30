require("script/land_encounters/utils/random")

local treasure_events = require("script/land_encounters/constants/events/treasure_type_events")

local Spot = require("script/land_encounters/models/spots/abstract_classes/Spot")
local TreasureSpot = require("script/land_encounters/models/spots/TreasureSpot")
local BattleSpot = require("script/land_encounters/models/spots/BattleSpot")
local SmithySpot = require("script/land_encounters/models/spots/SmithySpot")

-------------------------
--- Constant values of the class [DO NOT CHANGE]
-------------------------
local EASY_BATTLE_DIFFICULTY = 1
local MEDIUM_BATTLE_DIFFICULTY = 2
local HARD_BATTLE_DIFFICULTY = 3
local HARDER_BATTLE_DIFFICULTY = 4

local SPOT_TURN_ACTIVATION_COOLDOWN = 6
local ACTIVE_STATE = 0
local ERASED_FLAG = nil

-------------------------
--- Properties definition
-------------------------
local Zone = {
    name = "Unknown",
    -- Dynamic spots
    spots = {},
    -- Indicators
    treasure_spots = {}, -- indexes of the current active treasure spots [index of a spot] = STATE[0 = Registered but not created in the map, 1 = created in the map, nil = inactive ]
    treasure_spots_count = 0,
    max_treasures_count = 0,
    
    battle_spots = {}, -- indexes of the current active battle spots [index of a spot] = STATE[0 = Registered but not created in the map, 1 = created in the map, nil = inactive ]
    battle_spots_count = 0,
    max_battles_count = 0,

    battle_spots_easy = 0,
    max_battles_count_easy = 0,
    
    battle_spots_mid = 0,
    max_battles_count_mid = 0,
    
    battle_spots_hard = 0,
    max_battles_count_hard = 0,
    
    battle_spots_harder = 0,
    max_battles_count_harder = 0,
    
    prohibited_spots = {},
    
    -- Fixed spots
    points_of_interest = {}, -- Smithy / Resource / Tavern
    
    total_spots = 0
}

-------------------------
--- Class Methods
-------------------------
function Zone:initialize_from_zone_with_coordinates(zone_name, zone_coordinates, active_spot_percentage, battle_percentage, turn_number)
    self.name = zone_name
    self.spots = {}
    for i = 1, #zone_coordinates do
        local spot = Spot:new()
        spot:initialize_from_coordinates(i, zone_coordinates[i])
        table.insert(self.spots, spot)
    end
    
    self:update_zone_indicators(active_spot_percentage, battle_percentage)
    self:set_battles_distribution_by_turn(turn_number)
end


-- 
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


function Zone:set_battles_distribution_by_turn(turn_number)
    if turn_number < 30 then
        -- 0 - 40        easy (70%) >>> mid (20%) >>> hard (5%) >>> harder (5%)
        self.max_battles_count_easy = math.floor(self.max_battles_count * 0.7)
        self.max_battles_count_mid = math.floor(self.max_battles_count * 0.2)
        self.max_battles_count_hard = math.floor(self.max_battles_count * 0.05)
        self.max_battles_count_harder = self.max_battles_count - (self.max_battles_count_easy + self.max_battles_count_mid + self.max_battles_count_hard)
    elseif turn_number >= 30 and turn_number < 70 then
        --40 - 80        mid (70%) >>> hard (20%) >>> harder (10%) >>> easy (10%)
        self.max_battles_count_mid = math.floor(self.max_battles_count * 0.6)
        self.max_battles_count_hard = math.floor(self.max_battles_count * 0.2)
        self.max_battles_count_harder = math.floor(self.max_battles_count * 0.1)
        self.max_battles_count_easy = self.max_battles_count - (self.max_battles_count_mid + self.max_battles_count_hard + self.max_battles_count_harder)
    else -- turn_number => 80
        --80 - +         hard (50%) >>> mid (25%) >> harder (20%) >>> easy (5%)
        self.max_battles_count_hard = math.floor(self.max_battles_count * 0.5)
        self.max_battles_count_mid = math.floor(self.max_battles_count * 0.25)
        self.max_battles_count_harder = math.floor(self.max_battles_count * 0.2)
        self.max_battles_count_easy = self.max_battles_count - (self.max_battles_count_mid + self.max_battles_count_hard + self.max_battles_count_harder)
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
            self:deactivate_spot(spot_index)
        end
    end
end


function Zone:add_land_encounters(battle_event_factory)
    local disordered_indexes = randomic_length_shuffle(self.total_spots)
    for i= 1, #disordered_indexes do
        -- after every land encounter added we should check that the total count does not surpass the total amount of encounters permitted
        if not self:can_add_land_encounters() then
            break
        end
        
        -- check if the current index is not registered as a treasure or battle spot
        local current_index = disordered_indexes[i]
        local random_event = self:set_spot_info(current_index, battle_event_factory)
        if random_event ~= nil then
            self.spots[current_index]:activate(self.name, random_event)
        end
    end
end


function Zone:reinstate(previous_state, battle_event_factory)
    local activate_battle_spot_index = nil
    for i=1, #self.spots do
        local flattened_key = self.name .. "_" .. tostring(self.spots[i].coordinates[1]) .. "_" .. tostring(self.spots[i].coordinates[2])
        local spot_type = previous_state[flattened_key .. "_type"]
        if spot_type ~= nil then
            self.spots[i].is_active = previous_state[flattened_key .. "_active"]
            if spot_type == "TreasureSpot" and self.spots[i].is_active then
                self.spots[i] = TreasureSpot:newFrom(self.spots[i])
                self.spots[i]:reinstate(previous_state, flattened_key)
                self.treasure_spots[i] = ACTIVE_STATE
            elseif spot_type == "BattleSpot" and self.spots[i].is_active then
                self.spots[i] = BattleSpot:newFrom(self.spots[i])
                self.spots[i]:reinstate(previous_state, flattened_key)
                self.battle_spots[i] = ACTIVE_STATE
                                
                if self.spots[i].event.dilemma.difficulty_level == 1 then
                    self.battle_spots_easy = self.battle_spots_easy + 1
                elseif self.spots[i].event.dilemma.difficulty_level == 2 then
                    self.battle_spots_mid = self.battle_spots_mid + 1
                elseif self.spots[i].event.dilemma.difficulty_level == 3 then
                    self.battle_spots_hard = self.battle_spots_hard + 1
                elseif self.spots[i].event.dilemma.difficulty_level == 4 then
                    self.battle_spots_harder = self.battle_spots_harder + 1
                end
                
                if self.spots[i].is_triggered then
                    activate_battle_spot_index = i
                end
            --elseif self.spots[i].is_active then
                -- this means that somewhat the point exists but bugged becoming an abstract Spot. We remove the spot
                --self:deactivate_spot(i)
            end
        end
    end
    return activate_battle_spot_index
end


function Zone:set_spot_info(index, battle_event_factory)
    local random_event = nil
    if (self.treasure_spots[index] == nil) and (self.battle_spots[index] == nil) and (self.prohibited_spots[index] == nil) then
        -- Add the battles first
        if self.battle_spots_count < self.max_battles_count then
            random_event = self:set_battle_spot_info(index, battle_event_factory)
        -- add the treasures later as they are less cool
        elseif self.treasure_spots_count < self.max_treasures_count then
            random_event = self:set_treasure_spot_info(index)
        end
    end
    return random_event
end


function Zone:set_battle_spot_info(index, battle_event_factory)
    self.battle_spots[index] = ACTIVE_STATE
        
    local level = 0
    if self.battle_spots_harder < self.max_battles_count_harder then
        level = HARDER_BATTLE_DIFFICULTY
        self.battle_spots_harder = self.battle_spots_harder + 1
    elseif self.battle_spots_hard < self.max_battles_count_hard then 
        level = HARD_BATTLE_DIFFICULTY
        self.battle_spots_hard = self.battle_spots_hard + 1
    elseif self.battle_spots_mid < self.max_battles_count_mid then
        level = MEDIUM_BATTLE_DIFFICULTY
        self.battle_spots_mid = self.battle_spots_mid + 1
    else
        level = EASY_BATTLE_DIFFICULTY
        self.battle_spots_easy = self.battle_spots_easy + 1
    end
    
    local random_event = battle_event_factory:assign_event(level, self.name)

    self.spots[index] = BattleSpot:newFrom(self.spots[index]) 
    return random_event
end


function Zone:set_treasure_spot_info(index)
    self.treasure_spots[index] = ACTIVE_STATE
    random_event = treasure_events[random_number(#treasure_events)]
    self.spots[index] = TreasureSpot:newFrom(self.spots[index])  
    return random_event
end


-- TRIGGERING RELATED METHODS
-- Depending of the spot type a different kind of event will trigger controlled via inheritance
function Zone:trigger_spot_event(context, spot_index, spot_type, invasion_battle_manager)
    local can_be_removed = false
    -- common: TreasureSpot and BattleSpot
    if spot_type == 0 then
        can_be_removed = self.spots[spot_index]:trigger_event(context)
    elseif spot_type == 1 then -- smithy
        --TODO: A rather stupid code smell. Fix later should access index directly
        for i=1, #self.points_of_interest do
            if self.points_of_interest[i].get_class() == "SmithySpot" and self.points_of_interest[i].index == spot_index then
                self.points_of_interest[i]:trigger_event(context, invasion_battle_manager, self, i)
                break
            end
        end
    end
    if can_be_removed then
        self:deactivate_spot(spot_index)
    end
end


function Zone:trigger_spot_dilemma_by_choice(invasion_battle_manager, context, spot_index, spot_type)
    local can_be_removed = false
    if spot_type == 0 then
        can_be_removed = self.spots[spot_index]:trigger_dilemma_by_choice(invasion_battle_manager, self, spot_index, context)
    elseif spot_type == 1 then -- smithy
        --TODO: A rather stupid code smell. Fix later should access index directly
        for i=1, #self.points_of_interest do
            if self.points_of_interest[i].get_class() == "SmithySpot" and self.points_of_interest[i].index == spot_index then
                self.points_of_interest[i]:trigger_dilemma_by_choice(invasion_battle_manager, self, spot_index, context)
                break
            end
        end
    end
    
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

        if self.spots[spot_index].event ~= nil then
            if self.spots[spot_index].event.dilemma.difficulty_level == EASY_BATTLE_DIFFICULTY then
                self.battle_spots_easy = self.battle_spots_easy - 1
            elseif self.spots[spot_index].event.dilemma.difficulty_level == MEDIUM_BATTLE_DIFFICULTY then
                self.battle_spots_mid = self.battle_spots_mid - 1
            elseif self.spots[spot_index].event.dilemma.difficulty_level == HARD_BATTLE_DIFFICULTY then
                self.battle_spots_hard = self.battle_spots_hard - 1
            elseif self.spots[spot_index].event.dilemma.difficulty_level == HARDER_BATTLE_DIFFICULTY then
                self.battle_spots_harder = self.battle_spots_harder - 1
            end
        end
    end
    self.prohibited_spots[spot_index] = SPOT_TURN_ACTIVATION_COOLDOWN -- entering cooldown till 0 and can be reselected
    
    self.spots[spot_index]:deactivate(self.name)
end


--
-- POINTS OF INTEREST (PERMANENT CONTROL SPOT)
-- 
function Zone:initialize_points_of_interest(points_of_interest_data)
    self:initialize_smithies(points_of_interest_data["smithies"])
    self:initialize_taverns(points_of_interest_data["taverns"])
    self:initialize_resources(points_of_interest_data["resources"])
end


function Zone:update_points_of_interest_by_turn(turn_number, mission_manager)
    for i=1, #self.points_of_interest do
        self.points_of_interest[i]:update_state_through_turn_passing(mission_manager)
    end
end


function Zone:initialize_smithies(smithies_data)
    self.points_of_interest = {}
    -- we get the player faction so that we never give him the smithy or any other poi initially
    local player_faction_name = cm:get_local_faction_name()
    if #smithies_data > 0 then
        for i=1, #smithies_data do
            local spot = Spot:new()
            spot:initialize_from_coordinates(i, smithies_data[i].coordinates)
            
            local initial_owner = ""
            if player_faction_name == smithies_data[i].initial_owner then
                initial_owner = smithies_data[i].owner_if_player
            else
                initial_owner = smithies_data[i].initial_owner
            end
            
            local smithy = SmithySpot:new_from_coordinates(spot, i, initial_owner)
            table.insert(self.points_of_interest, smithy)
        end
    end
end
    

function Zone:initialize_taverns(taverns_data)
    if #taverns_data > 0 then
        for i=1, #taverns_data do
            --TODO table.insert(self.points_of_interest, TavernSpot:newFrom(taverns_data[i]))
        end
    end
end


function Zone:initialize_resources(resources_data)
    if #resources_data > 0 then
        for i=1, #resources_data do
            --TODO table.insert(self.points_of_interest, ResourceSpot:newFrom(resources_data[i]))
        end
    end
end


function Zone:activate_points_of_interest()
    for i=1, #self.points_of_interest do
        self.points_of_interest[i]:activate(self.name, "")
    end
end


function Zone:reinstate_points_of_interest(previous_state)
    local poi_index_triggered = nil
    for i=1, #self.points_of_interest do
        local poi_type = self.points_of_interest[i]:get_class()
        if poi_type == "SmithySpot" then
            local flattened_key = self.name .. "_smithy_" .. tostring(self.points_of_interest[i].index)            
            -- it could be that we have added a new poi. So we need to check wether if it previously existed.
            local is_battle_triggered = false
            if previous_state[flattened_key .. "_active"] ~= nil then
                is_battle_triggered = self.points_of_interest[i]:reinstate(flattened_key, previous_state)
            end
            -- the battle type is irrelevant as we will delegate to the poi its logic    
            if is_battle_triggered then
                poi_index_triggered = i
            end
        end
    end
    return poi_index_triggered
end


function Zone:trigger_event_given_battle_result(spot_type, spot_index, player_won_battle)
    if spot_type == "BattleSpot" then
        if player_won_battle then
            self.spots[spot_index]:trigger_victory_incident()
        end
        self:deactivate_spot(spot_index)
    elseif spot_type == "SmithySpot" then
        if player_won_battle then
            self.points_of_interest[spot_index]:trigger_victory_event_given_battle_type()
        else
            self.points_of_interest[spot_index]:trigger_defeat_event_given_battle_type()
        end
    end
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