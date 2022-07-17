-- Mod libs
local ArmyUnit = require("script/land_encounters/models/battle/ArmyUnit")
local LordUnit = require("script/land_encounters/models/battle/LordUnit")

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
function Army:newFrom(force_data, identifier)
    if identifier == nil then
        identifier = DEFAULT_FORCE_IDENTIFIER
    end
    
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