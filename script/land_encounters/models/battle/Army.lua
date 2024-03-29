-- TODO: Pass a is_player flag in the constructor to double check units and pass alternatives in case they are needed.
-- Make logic to check dlc ownership given subculture. Should a Unit or Lord type be DLC only, replace those units with its more close main variant or pass it in its constructor.

-- Mod libs
local ArmyUnit = require("script/land_encounters/models/battle/ArmyUnit")
local LordUnit = require("script/land_encounters/models/battle/LordUnit")

-- smithy defenders
local smithy_defenders = require("script/land_encounters/constants/battles/smithy/defenders")

-- battle spots battle types
local bandits = require("script/land_encounters/constants/battles/bandits")
local battlefields = require("script/land_encounters/constants/battles/battlefields")
local daemonic_gifts = require("script/land_encounters/constants/battles/daemonic_gifts")
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


-------------------------
--- Properties definition
-------------------------
local Army = {
    faction = "",
    force_identifier = "",
    invasion_identifier = "",
    -- units of the army base and generators
    units_pool = {},
    units = {},
    unit_experience_amount = 0,
    -- lords of the army generator
    lord_pool = {},
    lord = {},
    -- Reinforcements
    reinforcing_ally_armies = false,
    reinforcing_enemy_armies = false
}

-------------------------
--- Class Methods
-------------------------
function Army:randomize_units(random_army_manager)
    self:randomize_army_composition_and_declare(random_army_manager)
    self:randomize_lord()
    
    if self:has_offensive_reinforcements() then
        for i=1, #self.reinforcing_enemy_armies do
            self.reinforcing_enemy_armies[i]:randomize_army_composition_and_declare(random_army_manager)
            self.reinforcing_enemy_armies[i]:randomize_lord()
        end
    end
end


function Army:randomize_army_composition_and_declare(random_army_manager)
    random_army_manager:remove_force(self.force_identifier)
    random_army_manager:new_force(self.force_identifier)

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


function Army:has_ally_reinforcements()
    return self.reinforcing_ally_armies ~= false
end


function Army:has_offensive_reinforcements()
    return self.reinforcing_enemy_armies ~= false
end


function Army:check_if_faction_is_from_army(visiting_faction)
    if self.faction == visiting_faction then
        return true
    end
    
    if self:has_offensive_reinforcements() then
        for i=1, #self.reinforcing_enemy_armies do
            if self.reinforcing_enemy_armies[i].faction == visiting_faction then
                return true
            end
        end
    end
    
    return false
end


function Army:size()
    return #self.units
end

-------------------------
--- Constructors
-------------------------
function Army:new_from_event(battle_event)
    -- Determine the force
    local force_data = false
    if string.find(battle_event, "bandit") then
        force_data = bandits[battle_event]
    elseif string.find(battle_event, "battlefield") then
        force_data = battlefields[battle_event]
    elseif string.find(battle_event, "daemonic_gift") then
        force_data = daemonic_gifts[battle_event]
    elseif string.find(battle_event, "daemonic_invasion") then
        force_data = daemonic_invasions[battle_event]
    elseif string.find(battle_event, "incursion") then
        force_data = incursions[battle_event]
    elseif string.find(battle_event, "stands") then
        force_data = stands[battle_event]
    elseif string.find(battle_event, "underground") then
        force_data = rebellions[battle_event]
    elseif string.find(battle_event, "skirmish") then
        force_data = skirmishes[battle_event]
    elseif string.find(battle_event, "surprise") then
        force_data = surprise_attacks[battle_event]
    elseif string.find(battle_event, "waystone") then
        force_data = waystones[battle_event]
    end
    
    -- if reinforcement armies are present we declare them here
    -- we declare allied armies
    local reinforcing_ally_armies = false
    if force_data.reinforcing_ally_armies ~= false then
        reinforcing_ally_armies = {}
        for i=1, #force_data.reinforcing_ally_armies do
            table.insert(reinforcing_ally_armies, Army:create_from(force_data.reinforcing_ally_armies[i]))
        end
    end
    
    -- we declare enemy armies
    local reinforcing_enemy_armies = false 
    if force_data.reinforcing_enemy_armies ~= false then
        reinforcing_enemy_armies = {}
        for i=1, #force_data.reinforcing_enemy_armies do
            table.insert(reinforcing_enemy_armies, Army:create_from(force_data.reinforcing_enemy_armies[i]))
        end
    end
    
    local army = Army:create_from(force_data)
    army.reinforcing_ally_armies = reinforcing_ally_armies
    army.reinforcing_enemy_armies = reinforcing_enemy_armies
    
    return army
end


-- Create the invasion army
function Army:create_from(force)
    local t = {
        faction = force.faction,
        force_identifier = force.identifier,
        invasion_identifier = force.invasion_identifier,
        units_pool = {}, 
        units = {}, 
        unit_experience_amount = force.unit_experience_amount, 
        lord_pool = {}, 
        lord = {},
        reinforcing_ally_armies = false,
        reinforcing_enemy_armies = false
    }
    t.lord_pool = LordUnit:newFrom(force.lord)
        
    for i=1, #force.units do
        local unit = ArmyUnit:newFrom(force.units[i])
        table.insert(t.units_pool, unit)
    end
    
    setmetatable(t, self)
    self.__index = self
    
    return t
end


function Army:new_from_faction_and_subculture_and_level(faction_name, subculture, level)
    local force_data = smithy_defenders[subculture]
    local forces_of_level = force_data.armies_by_level[level]
    
    -- Create the defender army
    local t = {
        faction = faction_name,
        force_identifier = force_data.identifier,
        invasion_identifier = force_data.invasion_identifier,
        units_pool = {}, 
        units = {}, 
        unit_experience_amount = forces_of_level.unit_experience_amount, 
        lord_pool = {}, 
        lord = {},
        reinforcing_ally_armies = false,
        reinforcing_enemy_armies = false
    }
    t.lord_pool = LordUnit:newFrom(force_data.lord)
    
    for i=1, #forces_of_level.units do
        local unit = ArmyUnit:newFrom(forces_of_level.units[i])
        table.insert(t.units_pool, unit)
    end
    
    setmetatable(t, self)
    self.__index = self
    return t
end


return Army