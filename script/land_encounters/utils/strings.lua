local LAND_ENCOUNTER_TYPE = 0
local SMITHY_TYPE = 1

-- The id of the marker would be: "land_enc_marker_" .. zone_name .. "_" .. self.index
-- land_enc_marker_ = 16 chars
function process_marker_id(marker_id)
    
    beginning_index, ending_index = string.find(marker_id, "_smithy_")
    if beginning_index ~= nil then
        -- means the marker was a place of interest not a land encounter
        local zone_name = string.sub(marker_id, 17, beginning_index - 1)
        local spot_index = string.sub(marker_id, ending_index + 1, #marker_id)
        return { zone_name, tonumber(spot_index), SMITHY_TYPE } -- smithy_type
    end
    
    -- The maximum number of points in a zone would be <99 so we take the last 3 to check where is the last _
    beginning_index, ending_index = string.find(marker_id, "_", (#marker_id - 3))
    local zone_name = string.sub(marker_id, 17, beginning_index - 1)
    local spot_index = string.sub(marker_id, ending_index + 1, #marker_id)
    --out("LEAPOI - process_marker_id {zone_name:" .. zone_name .. ", spot_index:" .. spot_index .. "}")
    return { zone_name, tonumber(spot_index), LAND_ENCOUNTER_TYPE } -- 0 for land_encounter
end


-- Used for splitting the optional variables of the flattened state of the land encounters
function split_by_regex(splittable_string, separator)
    local string_parts = {}
    for part in string.gmatch(splittable_string, '([^' .. separator .. ']+)') do
        table.insert(string_parts, part)
    end
    return string_parts
end