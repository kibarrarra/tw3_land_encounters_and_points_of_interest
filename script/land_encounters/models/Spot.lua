-------------------------
--- Constant values of the class [DO NOT CHANGE]
-------------------------
local AUTOMATIC_DEACTIVATION_COOLDOWN = 10

-------------------------
--- Properties definition
-------------------------
local Spot = {
    -- logic properties
    index = 0, -- its almost hardcoded given that 
    coordinates = {0, 0},
    is_active = false,
    automatic_deactivation_countdown = 0, -- Should automatically dissapear after X turn
    -- marker properties
    marker_id = "",
    -- quest properties
    event = nil

}

-------------------------
--- Class Methods
-------------------------
function Spot:get_class()
    return "Spot. You shouldn't be using this class but it's children!"
end

function Spot:get_event_as_string()
    return self.event
end

function Spot:set_event_from_string(event)
    self.event = event
end

function Spot:initialize_from_coordinates(index, lat_lng)
    self.index = index
    self.coordinates = lat_lng -- Used to be "location"
    self.is_active = false -- Used to be "occupied"
    self.automatic_deactivation_countdown = 0 -- Used to be "cd"
end


function Spot:activate(zone_name, spot_event)
    -- LOGICAL DATA
    self.is_active = true
    self.automatic_deactivation_countdown = AUTOMATIC_DEACTIVATION_COOLDOWN
    
    -- EVENT DATA
    self.event = spot_event
    
    -- MARKER DATA
    -- we create the interactable marker in the map for the user
    self.marker_id = "land_enc_marker_" .. zone_name .. "_" .. self.index
    -- from campaign_interactable_marker_infos table
    -- there are 12 possible skins for the markers. From number 33 to 44 up
    local marker_number = cm:random_number(12) + 33
    local marker_key = "encounter_marker_"..tostring(marker_number)
    
    local x_coordinate = self.coordinates[1]
    local y_coordinate = self.coordinates[2]
    local radius = 4
    local faction_key = "" -- anyone can activate the marker
    local subculture_key = "" -- anyone can activate the marker
    --out("LEAPOI - Spot created={id:" .. self.marker_id .. ", spot_type:" .. self:get_class() .. ", (x,y):(".. x_coordinate .. "," .. y_coordinate .. "), marker_key:" .. marker_key .. "}")
    cm:add_interactable_campaign_marker(self.marker_id, marker_key, x_coordinate, y_coordinate, radius, faction_key, subculture_key)
end


-- SINGLE PLAYER ONLY = whose_turn_is_it_single
function Spot:is_human_and_it_is_its_turn()
    return cm:is_human_factions_turn()
end


function Spot:trigger_event(context)
    --out("abstract method to be overriden by the spot_type that implements it")
    return false
end


function Spot:check_if_active_and_countdown_reached()
    if self.is_active == true and self.automatic_deactivation_countdown == 0 then
        return true
    elseif self.is_active == true then
        self.automatic_deactivation_countdown = self.automatic_deactivation_countdown - 1        
    end
    return false
end


function Spot:deactivate()
    -- Remove the marker from the campaing map so the event is no longer reachable
    cm:remove_interactable_campaign_marker(self.marker_id)
    -- Remove the logical event data
    self.is_active = false
    self.automatic_deactivation_countdown = 0
    -- Remove the event data as it was already used
    self.marker_id = ""
    self.event = nil
end


-------------------------
--- Constructors
-------------------------
function Spot:new()
    local t = { index = 0, coordinates = {0, 0}, is_active = false, automatic_deactivation_countdown = 0, marker_id = "", event = nil }
    setmetatable(t, self)
    self.__index = self
    return t
end

return Spot