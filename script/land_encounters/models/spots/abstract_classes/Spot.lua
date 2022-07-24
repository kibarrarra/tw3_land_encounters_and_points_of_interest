require("script/land_encounters/utils/random")

-------------------------
--- Constant values of the class [DO NOT CHANGE]
-------------------------
local AUTOMATIC_DEACTIVATION_COOLDOWN = 10
local IGNORE_INCIDENT_PARAMETER_FLAG = 0

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
    local marker_number = random_number(12) + 33
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
function Spot:is_human_and_it_is_its_turn(faction)
    return faction:is_human() and cm:is_human_factions_turn()
end


function Spot:trigger_event(context)
    --out("LEAPOI - Abstract method to be overriden by the spot_type that implements it. We trigger it to destroy this bugged stuff. We just give some gold and experience for the character helping us clean up this mess.")

    local character = context:family_member():character()
    self:trigger_incident_for_character("land_enc_incident_clean_up_event", character, { character = true, force = false, faction = false, region = false })
    
    return true
end


function Spot:character_can_trigger_dilemma(character)
    return character:military_force():active_stance() == "MILITARY_FORCE_ACTIVE_STANCE_TYPE_DEFAULT"
end


function Spot:trigger_incident(incident_key, character, targets)
    -- if the campaign has been reloaded from a battle and we don't have the current player we have to obtain it back from the cm
    if character == nil then
        local faction_name = cm:get_local_faction_name()
        local only_general = true
        local is_garrison_commander = false
        local local_character, distance = cm:get_closest_character_to_position_from_faction(faction_name, self.coordinates[1], self.coordinates[2], only_general, is_garrison_commander)
        character = local_character
    end
    
    -- Only for the human it should trigger. Otherwise ignore
    if self:is_human_and_it_is_its_turn(character:faction()) then 
        self:trigger_incident_for_character(incident_key, character, targets)
    end
end

function Spot:trigger_incident_for_character(incident_key, character, targets)
    local faction_cqi = character:faction():command_queue_index()

    local target_faction_cqi = IGNORE_INCIDENT_PARAMETER_FLAG
    if targets.faction then
        target_faction_cqi = faction_cqi
    end
    
    local secondary_faction_cqi = IGNORE_INCIDENT_PARAMETER_FLAG
    
    local character_cqi = IGNORE_INCIDENT_PARAMETER_FLAG
    if targets.character then
        character_cqi = character:command_queue_index()
    end
    
    local military_force_cqi = IGNORE_INCIDENT_PARAMETER_FLAG
    if targets.force then
        military_force_cqi = character:military_force():command_queue_index()
    end

    local region_cqi = IGNORE_INCIDENT_PARAMETER_FLAG    
    if targets.region then
    end

    local settlement_cqi = IGNORE_INCIDENT_PARAMETER_FLAG
    
    cm:trigger_incident_with_targets(faction_cqi, incident_key, target_faction_cqi, secondary_faction_cqi, character_cqi, military_force_cqi, region_cqi, settlement_cqi)
    --out("LEAPOI - Triggered targeted battle victory/avoidance land encounter incident")    
end


function Spot:check_if_active_and_countdown_reached()
    if self.is_active == true and self.automatic_deactivation_countdown == 0 then
        return true
    elseif self.is_active == true then
        self.automatic_deactivation_countdown = self.automatic_deactivation_countdown - 1        
    end
    return false
end


function Spot:deactivate(zone_name)
    -- Remove the marker from the campaing map so the event is no longer reachable
    --out("LEAPOI - Spot:deactivate() marker_id=" .. self.marker_id)
    if self.marker_id == "" then
        self.marker_id = "land_enc_marker_" .. zone_name .. "_" .. self.index
        --out("LEAPOI - Spot:deactivate() corrected marker_id=" .. self.marker_id)
    end
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