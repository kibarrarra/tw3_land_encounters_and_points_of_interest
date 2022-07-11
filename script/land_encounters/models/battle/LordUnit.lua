-------------------------
--- Properties definition
-------------------------
local LordUnit = {
    level_ranges = {},
    possible_subtypes = {},
    possible_forenames = {},
    possible_clan_names = {},
    possible_family_names = {},
    possible_other_names = {}
}


-------------------------
--- Class Methods
-------------------------
function LordUnit:generate_random_level()
    return cm:random_number(self.level_ranges[2], self.level_ranges[1])
end


function LordUnit:generate_subtype()
    if #self.possible_subtypes > 0 then
        return self.possible_subtypes[cm:random_number(#self.possible_subtypes)]
    end
    return ""
end


function LordUnit:generate_random_forename()
    if #self.possible_forenames > 0 then
        return self.possible_forenames[cm:random_number(#self.possible_forenames)]
    end
    return ""
end


function LordUnit:generate_random_clan_name()
    if #self.possible_clan_names > 0 then
        return self.possible_clan_names[cm:random_number(#self.possible_clan_names)]
    end
    return ""
end


function LordUnit:generate_random_family_name()
    if #self.possible_family_names > 0 then
        return self.possible_family_names[cm:random_number(#self.possible_family_names)]
    end
    return ""
end


function LordUnit:generate_random_other_name()
    if #self.possible_other_names > 0 then
        return self.possible_other_names[cm:random_number(#self.possible_other_names)]
    end
    return ""
end

-------------------------
--- Constructors
-------------------------
function LordUnit:newFrom(lord_data)
    local t = { 
        subtype= nil, 
        level_ranges= lord_data.level_ranges, 
        possible_subtypes = lord_data.possible_subtypes,
        possible_forenames= lord_data.possible_forenames, 
        possible_clan_names= lord_data.possible_clan_names,
        possible_family_names= lord_data.possible_family_names,
        possible_other_names= lord_data.possible_other_names
    }
    setmetatable(t, self)
    self.__index = self
    return t
end

return LordUnit