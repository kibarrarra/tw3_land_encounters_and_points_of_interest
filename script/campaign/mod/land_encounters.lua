------------------------------------------------
--- Constant values of the class [DO NOT CHANGE]
------------------------------------------------
local IS_PERSISTENT_LISTENER = true

--[[
    This file only contains the logic related to the game functions. 
    The mod logic is in scripts/land_encounters for order and maintainability.
--]]
--[[ Coordinates of the warhammer 3 maps --]]
local ie_encounter_land_locations = require("script/land_encounters/constants/coordinates/inmortal_empires/treasures_and_spots")
local ie_points_of_interest = require("script/land_encounters/constants/coordinates/realm_of_chaos/points_of_interest")

local roc_encounter_land_locations = require("script/land_encounters/constants/coordinates/realm_of_chaos/treasures_and_spots")
local roc_points_of_interest = require("script/land_encounters/constants/coordinates/realm_of_chaos/points_of_interest")

--[[ Dilemma Events created for this script --]]
local smithy_events = require("script/land_encounters/constants/events/smithy_events")
local battle_events = require("script/land_encounters/constants/events/battle_spot_events")
local BattleEventFactory = require("script/land_encounters/factories/BattleEventFactory")

--[[ Model of the the land encounters functionality --]]
local LandEncounterManager = require("script/land_encounters/controllers/land_encounter_manager")
local InvasionBattleManager = require("script/land_encounters/controllers/invasion_battle_manager")
--[[ Instance of the Model of the the land encounters functionality --]]
local manager = nil

--[[ Triggered on campaign first tick.
Initializes the land encounters by instantiating a LandEncounterModel
--]]
cm:add_first_tick_callback(
    function()
        --out("LEAPOI - Starting up v1.18")
        --out("LEAPOI - INITIALIZE LAND ENCOUNTERS")

        local turn_number = cm:turn_number()

        if cm:get_campaign_name() == "wh3_main_chaos" then
            if manager:has_previous_state() then
                manager:restore_from_previous_state(roc_encounter_land_locations, roc_points_of_interest, turn_number)
            else
                manager:generate_land_encounters(roc_encounter_land_locations, roc_points_of_interest, turn_number)
            end
        end
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
            --out("LEAPOI - Beginning update process")
            local turn_number = cm:turn_number()
            manager:update_land_encounters(turn_number)
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
If it's a smith spot: Several dilemmas exist. We send to the poi itself to trigger what it needs
If it's a tavern spot (TODO): Gives an option to recruit an unit at a low price if the cooldown has expired
If it's a resource spot (TODO): (Don't know yet but should be a fight for control of such resource: Permanent buffs like nagash books that the player and the AI should vie for as well as a zone around the marker if possible)
--]]
core:add_listener(
	"land_enc_and_poi_dilemma_choice",
	"DilemmaChoiceMadeEvent",
    function(context)
        local dilemma = context:dilemma()
        --TODO in the future we should check all dilemmas from poi. Should join them all in a single list somehow
        -- smithy dilemmas
        for i=1, #smithy_events do
            if dilemma == smithy_events[i] then
                return true
            end
        end
        
        -- battles dilemmas
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


--[[
core:add_listener(
    "land_enc_and_poi_incident_ocurred",
    "IncidentOccuredEvent",
    function(context)
    
    end,
    function(context)
        local incident = context:dilemma();
        cm:callback(function()
            for i = 1, #harkon_personality_index do
                if incident == harkon_personality_events[harkon_personality_index[i] ] then
                    for j = 1, #harkon_personality_dummies do
                        cm:remove_effect_bundle(harkon_personality_dummies[j], harkon_faction);
                    end;
                end;
            end;	
        end, 0.5);
    end,
    true
);
]]--



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
    if manager == nil then
        local invasion_battle_manager = InvasionBattleManager:newFrom(core, random_army_manager, invasion_manager)
        local battle_event_factory = BattleEventFactory:new()
        
        manager = LandEncounterManager:newFrom(core, invasion_battle_manager, battle_event_factory)
    end
    
    if land_encounters_state ~= DEFAULT_FLATTENED_SPOTS_VALUE then
        --out("LEAPOI - PREVIOUS_STATE: " .. tostring(#land_encounters_state))
        manager.previous_state = land_encounters_state
    else
        --out("LEAPOI - PREVIOUS_STATE: NO PREVIOUS STATE")
    end
end
