-- Mod libs
local ArmyUnit = require("script/land_encounters/models/battle/ArmyUnit")
local LordUnit = require("script/land_encounters/models/battle/LordUnit")

local bandits = require("script/land_encounters/constants/battles/bandits")
local battlefields = require("script/land_encounters/constants/battles/battlefields")
local daemonic_invasions = require("script/land_encounters/constants/battles/daemonic_invasions")
local incursions = require("script/land_encounters/constants/battles/incursions")
local last_stands = require("script/land_encounters/constants/battles/last_stands")
local rebellions = require("script/land_encounters/constants/battles/nascent_rebellions")
local skirmishes = require("script/land_encounters/constants/battles/skirmishes")
local surprise_attacks = require("script/land_encounters/constants/battles/surprise_attacks")
local waystones = require("script/land_encounters/constants/battles/waystones")

------------------------------------------------
--- Constant values of the class [DO NOT CHANGE | ALWAYS DECLARE FIRST]
------------------------------------------------
local DEFAULT_FORCE_IDENTIFIER = "encounter_force"

-------------------------
--- Properties definition
-------------------------
local Army = {
    faction = "",
    force_identifier = DEFAULT_FORCE_IDENTIFIER,
    -- units of the army base and generators
    units_pool = {},
    units = {},
    unit_experience_amount = 0,
    -- lords of the army generator
    lord_pool = {},
    lord = {}
}

-------------------------
--- Class Methods
-------------------------
function Army:randomize_units(random_army_manager)
    self:randomize_army_composition_and_declare(random_army_manager)
    self:randomize_lord()
end


function Army:randomize_army_composition_and_declare(random_army_manager)
    random_army_manager:remove_force(self.force_identifier)
    random_army_manager:new_force(self.force_identifier)
    out("LEAPOI - Army new force created - " .. self.force_identifier)
    local randomized_units = {}
    for i=1, #self.units_pool do
        local randomized_unit = self.units_pool[i]:generate_winner_unit()
        if randomized_unit ~= nil then 
            self:declare_army_unit(random_army_manager, randomized_unit.id, randomized_unit.count) 
        end
        table.insert(randomized_units, randomized_unit)
    end
    self.units = randomized_units
end

function Army:randomize_lord()
    self.lord.subtype = self.lord_pool:generate_subtype()
    self.lord.level = self.lord_pool:generate_random_level()
    self.lord.forename = self.lord_pool:generate_random_forename()
    self.lord.clan_name = self.lord_pool:generate_random_clan_name()
    self.lord.family_name = self.lord_pool:generate_random_family_name()
    self.lord.other_name = self.lord_pool:generate_random_other_name()
end


function Army:declare_army_unit(random_army_manager, unit_id, unit_count)
    random_army_manager:add_mandatory_unit(self.force_identifier, unit_id, unit_count)
end


function Army:size()
    return #self.units
end

-------------------------
--- Constructors
-------------------------
function Army:newFrom(battle_event, identifier)
    -- Determine the force
    local force_data = false
    if string.find(battle_event, "bandit") then
        force_data = bandits[battle_event]
    elseif string.find(battle_event, "battlefield") then
        force_data = battlefields[battle_event]
    elseif string.find(battle_event, "daemonic") then
        force_data = daemonic_invasions[battle_event]
    elseif string.find(battle_event, "incursions") then
        force_data = incursions[battle_event]
    elseif string.find(battle_event, "stands") then
        force_data = stands[battle_event]
    elseif string.find(battle_event, "rebellions") then
        force_data = rebellions[battle_event]
    elseif string.find(battle_event, "skirmish") then
        force_data = skirmishes[battle_event]
    elseif string.find(battle_event, "surprise") then
        force_data = surprise_attacks[battle_event]
    elseif string.find(battle_event, "waystone") then
        force_data = waystones[battle_event]
    end
    
    -- Check if the force is a defensive, offensive or reinforcing force
    if identifier == nil then
        identifier = DEFAULT_FORCE_IDENTIFIER
    end
    
    -- Create the invasion army
    local t = {
        faction = force_data.faction,
        force_identifier = identifier,
        units_pool = {}, 
        units = {}, 
        unit_experience_amount = force_data.unit_experience_amount, 
        lord_pool = {}, 
        lord = {}
    }
    
    for i=1, #force_data.units do
        local unit = ArmyUnit:newFrom(force_data.units[i])
        table.insert(t.units_pool, unit)
    end
    
    t.lord_pool = LordUnit:newFrom(force_data.lord)
    
    setmetatable(t, self)
    self.__index = self
    return t
end

return Army