require("script/land_encounters/utils/random")

local battle_events = require("script/land_encounters/constants/events/battle_spot_events")

-------------------------
--- Constant values of the class [DO NOT CHANGE]
-------------------------
-- MEMORY_REFRESH_TRESHOLD helps us refresh the mod when updating it so that new events are taken into account after some turns and no refresh is needed
local MEMORY_REFRESH_TRESHOLD = 15
local REFRESH_CONSTANT = 0

-------------------------
--- Properties definition
-------------------------
local BattleEventFactory = {
    memory = {
        common = {},
        exclusive = {}
    },
    turn_number = 0
}

-------------------------
--- Class Methods
-------------------------
function BattleEventFactory:assign_event(level, zone_name)
    local options = self:find_all_of_level_excluding_exclusives(level)
    local exclusive_options = self:find_all_exclusives_of_zone_by_level(level, zone_name)
    if exclusive_options ~= nil and #exclusive_options > 0 then
        for i = 1, #exclusive_options do
            table.insert(options, exclusive_options[i])
        end
    end
    --out("LEAPOI - BattleEventFactory:assign_event options.count=".. tostring(#options))
    return options[random_number(#options)]
end


function BattleEventFactory:find_all_of_level_excluding_exclusives(level)
    --out("LEAPOI - BattleEventFactory:find_all_of_level_excluding_exclusives current level=".. tostring(level))
    if self.turn_number % MEMORY_REFRESH_TRESHOLD == REFRESH_CONSTANT or self.memory.common[level] == nil then
        --out("LEAPOI - BattleEventFactory:find_all_of_level_excluding_exclusives Refreshing common events")
        --out("LEAPOI - BattleEventFactory:find_all_of_level_excluding_exclusives battle_events_count=".. tostring(#battle_events))
        local common_level_events = {}
        for i=1, #battle_events do
            --out("LEAPOI - BattleEventFactory:find_all_of_level_excluding_exclusives {iterate=".. tostring(i) .. ", difficulty_level=" .. tostring(battle_events[i].difficulty_level) .. ", exclusivity=" .. tostring(battle_events[i].is_exclusive_to_zone) .. "}")
            if battle_events[i].difficulty_level == level and not battle_events[i].is_exclusive_to_zone then
                --out("LEAPOI - BattleEventFactory:find_all_of_level_excluding_exclusives ADDED")
                table.insert(common_level_events, battle_events[i])
            end
        end
        self.memory.common[level] = common_level_events
    end
    return self.memory.common[level]
end


function BattleEventFactory:find_all_exclusives_of_zone_by_level(level, zone_name)
    local zone_by_level_key = zone_name .. "_" .. level
    --out("LEAPOI - BattleEventFactory:find_all_exclusives_of_zone_by_level current level=".. tostring(level) .. ", current_zone=" .. zone_name .. ", memory.exclusive.count=")
    if self.turn_number % MEMORY_REFRESH_TRESHOLD == REFRESH_CONSTANT or self.memory.exclusive[zone_by_level_key] == nil then
        --out("LEAPOI - BattleEventFactory:find_all_exclusives_of_zone_by_level Refreshing exclusive events")
        local exclusive_level_events = {}
        for i=1, #battle_events do
            if battle_events[i].difficulty_level == level and battle_events[i].is_exclusive_to_zone and battle_events[i].zone == zone_name then
                --out("LEAPOI - BattleEventFactory:find_all_exclusives_of_zone_by_level ADDED")
                table.insert(exclusive_level_events, battle_events[i])
            end
        end
        self.memory.exclusive[zone_by_level_key] = exclusive_level_events
    end
    return self.memory.exclusive[zone_by_level_key]
end

-------------------------
--- Constructors
-------------------------
function BattleEventFactory:new()
    local t = { memory = { common = {}, exclusive = {} }, turn_number = 0 }
    setmetatable(t, self)
    self.__index = self
    return t
end

return BattleEventFactory