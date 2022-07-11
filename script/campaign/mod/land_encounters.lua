------------------------------------------------
--- Constant values of the class [DO NOT CHANGE]
------------------------------------------------
local IS_PERSISTENT_LISTENER = true

--[[
    This file only contains the logic related to the game functions. 
    The mod logic is in scripts/land_encounters for order and maintainability.
--]]
--[[ Coordinates of the warhammer 3 maps --]]
local ie_encounter_land_locations = require("script/land_encounters/constants/coordinates/inmortal_empires_coordinates")
local roc_encounter_land_locations = require("script/land_encounters/constants/coordinates/realm_of_chaos_coordinates")

--[[ Dilemma Events created for this script --]]
local battle_events = require("script/land_encounters/constants/events/battle_type_events")

--[[ Model of the the land encounters functionality --]]
local LandEncounterManager = require("script/land_encounters/controller/land_encounter_manager")
local InvasionBattleManager = require("script/land_encounters/controller/invasion_battle_manager")
--[[ Instance of the Model of the the land encounters functionality --]]
local manager = nil

--[[ Triggered on campaign first tick.
Initializes the land encounters by instantiating a LandEncounterModel
--]]
cm:add_first_tick_callback(
	function()
        --initialize_land_encounters()
		--out("LEAPOI - reinitialised listeners")
	end
)


--[[ Triggered every player turn
Updates the land_encounters so that some are automatically disposed if their time has run up. Adds more encounters when this happens
--]]
core:add_listener(
	"land_enc_and_poi_faction_turn_start_update",
	"FactionTurnStart",
    function(context)
        return context:faction():is_human() == true
    end,
	function(context)
        if manager then
            -- land encounter model has been initialized so we can proceed with the update logic
            --out("LEAPOI - Beginning update process")
            manager:update_land_encounters()
        --else
            --initialize_land_encounters()
        end
	end,
	IS_PERSISTENT_LISTENER
)


--[[ Triggered every time someone enters any area. 
To just treat the land encounters, we use the first function that checks wether tthe area id contains the library special marker.
triggers an encounter
--]]
core:add_listener(
	"land_enc_and_poi_area_entered_trigger_event",
	"AreaEntered",
	function(context)
        local triggering_character = context:family_member():character()
        local marker_id = context:area_key()
        return manager:check_if_is_triggerable_land_encounter(triggering_character, marker_id)
	end,
	function(context)
        manager:trigger_encounter(context)
	end,
	IS_PERSISTENT_LISTENER
)


--[[ Triggered when the event triggered by the marker is a dilemma. 
If it's a battle spot: Triggers a battle. Example: wh2_dlc11_cst_vampire_coast_encounters
If it's a tavern spot (TODO): Gives an option to recruit an unit at a low price if the cooldown has expired
If it's a smith spot (TODO): Should open Mixu's interactable shop if this is not possible another dilemma
If it's a resource spot (TODO): (Don't know yet but should be a fight for control of such resource: Permanent buffs like nagash books that the player and the AI should vie for as well as a zone around the marker if possible)
--]]
core:add_listener(
	"land_enc_and_poi_dilemma_choice",
	"DilemmaChoiceMadeEvent",
    function(context)
        local dilemma = context:dilemma()
        for i=1, #battle_events do
            if dilemma == battle_events[i].dilemma then
                return true
            end
        end
        return false
    end,
	function(context)
        manager:trigger_dilemma_by_choice(context)
	end,
	IS_PERSISTENT_LISTENER
)


--[[ STATE MANAGEMENT --]]
--[[
    Saves the land_encounters state variables when the game is about to close
--]]
local FLATTENED_SPOTS_STATE = "flattened_spots_state"
local DEFAULT_FLATTENED_SPOTS_VALUE = {}

cm:add_saving_game_callback(
	function(context)
        --out("LEAPOI - Saving State")
        cm:save_named_value(FLATTENED_SPOTS_STATE, manager:export_state_as_table(), context)
        --cm:save_named_value(FLATTENED_INVASION_STATE, manager.invasion_battle_manager:export_state_as_table(), context)
	end
);

--[[
    Loads the land_encounters state variables when the game is 
--]]
cm:add_loading_game_callback(
	function(context)
        --out("LEAPOI - State restoration")
        local land_encounters_state = cm:load_named_value(FLATTENED_SPOTS_STATE, DEFAULT_FLATTENED_SPOTS_VALUE, context)
        initialize_land_encounters(land_encounters_state)
	end
);


--[[ LINK TO OTHER MODS --]]
--[[
    TODO: MCT related logic. Uncomment when ready
--]]
--[[
core:add_listener(
	"land_encounter_mct_options",
	"MctInitialized",
	true,
	function(context)
		local mct = context:mct()
		local mct_mod = mct:get_mod_by_key("land_encounters")

		local encounter_start_option = mct_mod:get_option_by_key("encounter_start")
		local start_num = encounter_start_option:get_finalized_setting()

		encounter_start_option:set_uic_locked(true, "Can only change this option before starting a new campaign.")

		encounter_number_start = start_num
	end,
	true
)
--]]

function initialize_land_encounters(land_encounters_state)
    --out("LEAPOI - Starting up v1.16")
    --if land_encounters_state ~= nil then
    --    out("LEAPOI - PREVIOUS_STATE: " .. tostring(#land_encounters_state))
    --else
    --    out("LEAPOI - PREVIOUS_STATE: NULL")
    --end
        
    local invasion_battle_manager = InvasionBattleManager:newFrom(core, random_army_manager, invasion_manager)
    if(invasion_battle_state) then
        invasion_battle_manager:reset()
    end
    
    -- land_encounter_model has not been initialized and the initial seed for the points must be created
    if manager == nil then
        manager = LandEncounterManager:newFrom(core, invasion_battle_manager)
        if cm:get_campaign_name() == "wh3_main_chaos" then
            if land_encounters_state == nil then
                manager:generate_land_encounters(roc_encounter_land_locations)
            else
                manager:restore_from_previous_state(roc_encounter_land_locations, land_encounters_state)
            end
        end 
    end
end
