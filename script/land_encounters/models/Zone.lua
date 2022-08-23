require("script/land_encounters/utils/random")

local treasure_events = require("script/land_encounters/constants/events/treasure_type_events")

local Spot = require("script/land_encounters/models/spots/abstract_classes/Spot")
local TreasureSpot = require("script/land_encounters/models/spots/TreasureSpot")
local BattleSpot = require("script/land_encounters/models/spots/BattleSpot")
local SmithySpot = require("script/land_encounters/models/spots/SmithySpot")

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
    --out("LEAPOI - Zone:initialize_from_zone_with_coordinates - " .. zone_name .. ", #zone_coordinates : " ..  #zone_coordinates)
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
    if turn_number < 40 then
        -- 0 - 40        easy (90%) >>> mid (8%) >>> hard (2%)
        self.max_battles_count_easy = math.floor(self.max_battles_count * 0.9)
        self.max_battles_count_mid = math.floor(self.max_battles_count * 0.08)
        self.max_battles_count_hard = self.max_battles_count - self.max_battles_count_easy - self.max_battles_count_mid
    elseif turn_number >= 40 and turn_number < 80 then
        --40 - 80        mid (70%) >>> hard (20%) >>> easy (10%)
        self.max_battles_count_mid = math.floor(self.max_battles_count * 0.7)
        self.max_battles_count_hard = math.floor(self.max_battles_count * 0.2)
        self.max_battles_count_easy = self.max_battles_count - self.max_battles_count_mid - self.max_battles_count_hard
    else -- turn_number => 80
        --80 - +         hard (60%) >>> mid (30%) >>> easy (10%)
        self.max_battles_count_hard = math.floor(self.max_battles_count * 0.6)
        self.max_battles_count_mid = math.floor(self.max_battles_count * 0.3)
        self.max_battles_count_easy = self.max_battles_count - self.max_battles_count_mid - self.max_battles_count_hard
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


function Zone:add_land_encounters(battle_event_factory)
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
            --self.spots[i].marker_id = "land_enc_marker_" .. self.name .. "_" .. i
            --out("LEAPOI - Zone:reinstate - index=" .. tostring(i) .. ", key=" .. flattened_key ..", zone_name=" .. self.name ..", spot_type=" .. spot_type .. ", is_active=" .. tostring(self.spots[i].is_active))
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
                end
                
                if self.spots[i].is_triggered then
                    activate_battle_spot_index = i
                end
            elseif self.spots[i].is_active and self:can_add_land_encounters() then
                --out("LEAPOI - Regenerating Spot")
                -- this means that somewhat the point exists but bugged becoming an abstract Spot. We recreate the spot
                self:set_spot_info(i, battle_event_factory)
            end
        end
    end
    
    for i=1, #self.spots do
        
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
    
    --out("LEAPOI - Zone:set_battle_spot_info - {max_battles_count_hard=" .. tostring(self.max_battles_count_hard) .. ", battle_spots_hard=" .. tostring(self.battle_spots_hard) .. "}, {max_battles_count_mid=" .. tostring(self.max_battles_count_mid) .. ", battle_spots_mid=" .. tostring(self.battle_spots_mid) .. "}, {battle_spots_easy=" .. tostring(self.battle_spots_easy) .. ", max_battles_count_easy=" .. tostring(self.max_battles_count_easy) .. "}")
    
    local level = 0
    if self.battle_spots_hard < self.max_battles_count_hard then 
        level = 3
        self.battle_spots_hard = self.battle_spots_hard + 1
    elseif self.battle_spots_mid < self.max_battles_count_mid then
        level = 2
        self.battle_spots_mid = self.battle_spots_mid + 1
    else
        level = 1
        self.battle_spots_easy = self.battle_spots_easy + 1
    end
    
    local random_event = battle_event_factory:assign_event(level, self.name)

    self.spots[index] = BattleSpot:newFrom(self.spots[index]) 
    --out("LEAPOI - Zone:set_battle_spot_info - Battle spot:{zone_name=" .. self.name .. ", index=" .. tostring(index) .. ", random_event=" .. random_event.dilemma .. "}")
    --out("LEAPOI - Battle spot created")
    return random_event
end


function Zone:set_treasure_spot_info(index)
    self.treasure_spots[index] = ACTIVE_STATE
    random_event = treasure_events[random_number(#treasure_events)]
    self.spots[index] = TreasureSpot:newFrom(self.spots[index])  
    --out("LEAPOI - Zone:set_treasure_spot_info - Treasure spot:{index=" .. tostring(index) .. ",random_event=" .. random_event .. "}")
    return random_event
end


-- TRIGGERING RELATED METHODS
-- Depending of the spot type a different kind of event will trigger controlled via inheritance
function Zone:trigger_spot_event(context, spot_index, spot_type, invasion_battle_manager)
    local can_be_removed = false
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
    --out("LEAPOI - spot_index=" .. tostring(spot_index) .. ", can_be_removed=" .. tostring(can_be_removed))
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

        if self.spots[spot_index].event.dilemma.difficulty_level == 1 then
            self.battle_spots_easy = self.battle_spots_easy - 1
        elseif self.spots[spot_index].event.dilemma.difficulty_level == 2 then
            self.battle_spots_mid = self.battle_spots_mid - 1
        elseif self.spots[spot_index].event.dilemma.difficulty_level == 3 then
            self.battle_spots_hard = self.battle_spots_hard - 1
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


function Zone:update_points_of_interest_by_turn(turn_number)
    for i=1, #self.points_of_interest do
        self.points_of_interest[i]:update_state_through_turn_passing()
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
    out("LEAPOI - Zone-reinstate_points_of_interest")
    local poi_index_triggered = nil
    for i=1, #self.points_of_interest do
        local poi_type = self.points_of_interest[i]:get_class()
        if poi_type == "SmithySpot" then
            out("LEAPOI - Zone-reinstate_points_of_interest Reactivating smithy")
            local flattened_key = self.name .. "_smithy_" .. tostring(self.points_of_interest[i].index)
            
            -- it could be that we have added a new poi. So we need to check wether if it previously existed.
            local is_battle_triggered = false
            if previous_state[flattened_key .. "_active"] ~= nil then
                out("LEAPOI - Zone-reinstate_points_of_interest Restoring smithy")
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