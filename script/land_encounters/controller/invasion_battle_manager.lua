local Spot = require("script/land_encounters/models/Spot")
local Army = require("script/land_encounters/models/battle/Army")

local battle_forces = require("script/land_encounters/constants/battles/battle_forces")

-------------------------
--- Constant values of the class [DO NOT CHANGE]
-------------------------
local DEFAULT_ENEMY_ARMY_FACTION = "wh2_main_def_dark_elves_qb1"
local IS_NOT_PERSISTENT_LISTENER = false

-------------------------
--- Properties definition
-------------------------
local InvasionBattleManager = {
    -- Core is the main manager for listeners.
    core = nil,
    -- For managing invasions
    random_army_manager = nil,
    invasion_manager = nil,
    --  the current army fighting
    event_army = nil 
}

-------------------------
--- Class Methods
-------------------------
function InvasionBattleManager:generate_battle(context, battle_event, player_character, enemy_lat_lng)
    local force_cqi = player_character:military_force():command_queue_index()
    local player_faction_name = player_character:faction():name()
    
    self.event_army = Army:newFrom(battle_forces[battle_event])
    self.event_army:randomize_units(self.random_army_manager)

    local force = self.random_army_manager:generate_force("encounter_force")
    --out("LEAPOI - InvasionBattleManager:generate_battle - Event_army.faction:" .. self.event_army.faction)
    local invasion = self:setup_invasion(player_character, player_faction_name, force, enemy_lat_lng)
    invasion:start_invasion(
        function(invasion_force)
            self.core:add_listener(
                "land_enc_and_poi_encounter_engage",
                "FactionLeaderDeclaresWar",
                true,
                function(local_context)
                    --out("LEAPOI - InvasionBattleManager:generate_battle - FactionLeaderDeclaresWar")
                    local faction_being_declared_war_to = local_context:character():faction():name()
                    if faction_being_declared_war_to == self.event_army.faction then
                        cm:force_attack_of_opportunity(invasion_force:get_general():military_force():command_queue_index(), force_cqi, false)
                    end
                end,
                IS_NOT_PERSISTENT_LISTENER
            )
            local call_player_allies_to_war = false
            local call_faction_allies_to_war = false
            cm:force_declare_war(self.event_army.faction, player_faction_name, call_player_allies_to_war, call_faction_allies_to_war)
        end,
        false,
        false,
        false
    ) 
    self:setup_encounter_force_removal()
end

function InvasionBattleManager:setup_invasion(player_character, player_faction_name, force, enemy_lat_lng)
    local character_cqi = player_character:command_queue_index()
    -- create invasion
    if self.invasion_manager:get_invasion("encounter_invasion") then
        self.invasion_manager:remove_invasion("encounter_invasion")
    end
    local invasion = self.invasion_manager:new_invasion("encounter_invasion", self.event_army.faction, force, enemy_lat_lng)
    invasion:set_target("CHARACTER", character_cqi, player_faction_name)
    invasion:apply_effect("wh_main_bundle_military_upkeep_free_force", -1)
    -- create general for the invasion
    local make_faction_leader = false
    invasion:create_general(make_faction_leader, self.event_army.lord.subtype, self.event_army.lord.forename, self.event_army.lord.clan_name, self.event_army.lord.family_name, self.event_army.lord.other_name)
    --out("LEAPOI - InvasionBattleManager:setup_invasion - Lord:{type=" .. self.event_army.lord.subtype .. ", forename=" .. self.event_army.lord.forename .. ", clan_name=" .. self.event_army.lord.clan_name .. ", family_name=" .. self.event_army.lord.family_name .. ", other_name=" .. self.event_army.lord.other_name .. "}")
    -- adds an experience level to the invasion forces
    local by_level = true
    invasion:add_character_experience(self.event_army.lord.level, by_level)
    invasion:add_unit_experience(self.event_army.unit_experience_amount)
    --out("LEAPOI - Invasion setup finished")
    return invasion
end
    

function InvasionBattleManager:setup_encounter_force_removal()
    --out("LEAPOI - InvasionBattleManager:setup_encounter_force_removal setted")
	self.core:add_listener(
        "land_enc_and_poi_encounter_removal",
        "FactionTurnStart", 
        true,
        function(context)
            --out("LEAPOI - InvasionBattleManager:setup_encounter_force_removal runned")
            local enemy_force = self.invasion_manager:get_invasion("encounter_invasion")
            if enemy_force then
                --out("LEAPOI - InvasionBattleManager:setup_encounter_force_removal enemy_force triggered and killed")
                cm:disable_event_feed_events(true, "", "", "diplomacy_faction_destroyed")
                cm:disable_event_feed_events(true, "wh_event_category_character", "", "")
                enemy_force:kill()
                cm:callback(function() cm:disable_event_feed_events(false, "", "", "diplomacy_faction_destroyed") end, 1)
                cm:callback(function() cm:disable_event_feed_events(false, "wh_event_category_character", "", "") end, 1)
            end 
        end,
        IS_NOT_PERSISTENT_LISTENER
	)
end


function InvasionBattleManager:set_auxiliary_army_for_reset(battle_event)
    --out("LEAPOI - InvasionBattleManager:set_auxiliary_army_for_reset - Army being setted:" .. battle_event)
    self.event_army = Army:newFrom(battle_forces[battle_event])
end


function InvasionBattleManager:reset_state_post_battle(zone, spot_index)
    --out("LEAPOI - InvasionBattleManager:reset_state_post_battle setted")
	self.core:add_listener(
        "land_enc_and_poi_encounter_post_battle",
        "BattleCompleted", 
        true,
        function(context)
            --out("LEAPOI - InvasionBattleManager:reset_state_post_battle - triggered")
            local found_encounter_faction = false
            local trigger_positive_event_result = false

            local encounter_invasion = self.invasion_manager:get_invasion("encounter_invasion")
            local pending_number_of_battles = cm:pending_battle_cache_num_attackers()
            if pending_number_of_battles >= 1 then
                for i = 1, pending_number_of_battles do
                    local char_cqi, military_force_cqi, current_faction_name = cm:pending_battle_cache_get_attacker(i)
                    local result = self:find_if_it_is_event_army_and_was_beaten(current_faction_name, char_cqi, encounter_invasion)
                    if result[1] then
                        found_encounter_faction = true
                        trigger_positive_event_result = result[2]
                        break
                    end
                end
            end

            if (not found_encounter_faction) and (cm:pending_battle_cache_num_defenders() >= 1) then
                for i = 1, cm:pending_battle_cache_num_defenders() do
                    local char_cqi, military_force_cqi, current_faction_name = cm:pending_battle_cache_get_defender(i)
                    local result = self:find_if_it_is_event_army_and_was_beaten(current_faction_name, char_cqi, encounter_invasion)
                    if result[1] then
                        found_encounter_faction = true
                        trigger_positive_event_result = result[2]
                        break
                    end
                end
            end
            --out("LEAPOI - InvasionBattleManager:reset_state_post_battle - checking if post trigger_positive_event_result option is needed")
            cm:callback(function() cm:disable_event_feed_events(false, "","","diplomacy_faction_destroyed") end, 1)
            cm:callback(function() cm:disable_event_feed_events(false, "wh_event_category_character", "", "") end, 1)
            if found_encounter_faction == true then
                local uim = cm:get_campaign_ui_manager()
                uim:override("retreat"):unlock()
                if trigger_positive_event_result then
                    --out("LEAPOI - triggering trigger_positive_event_result event")
                    zone.spots[spot_index]:trigger_victory_incident()
                    zone:deactivate_spot(spot_index)
                else
                    --out("LEAPOI - triggering trigger_negative_event_result event")
                    zone:deactivate_spot(spot_index)
                end
            end
        end,
        IS_NOT_PERSISTENT_LISTENER
	)
end


function InvasionBattleManager:find_if_it_is_event_army_and_was_beaten(current_faction_name, char_cqi, encounter_invasion)
    local event_army_found = false
    local trigger_positive_event_result = false
    if current_faction_name == self.event_army.faction then
        event_army_found = true
        if self:has_enemy_character_lost_event_battle(char_cqi) then
            trigger_positive_event_result = true
        end
        if encounter_invasion then
            self:silently_remove_encounter_invasion(encounter_invasion)
        end
    end
    return { event_army_found, trigger_positive_event_result }
end

    
function InvasionBattleManager:has_enemy_character_lost_event_battle(char_cqi)
    --out("LEAPOI - InvasionBattleManager:has_enemy_character_lost_event_battle - char_cqi = " .. tostring(char_cqi))
    local character = cm:model():character_for_command_queue_index(player_char_cqi)
    local character_does_not_have_interface = character:is_null_interface()
    return character_does_not_have_interface or (not character_does_not_have_interface and character:won_battle())
end


function InvasionBattleManager:silently_remove_encounter_invasion(encounter_invasion)
    cm:disable_event_feed_events(true, "","","diplomacy_faction_destroyed")
	cm:disable_event_feed_events(true, "wh_event_category_character", "", "")
	encounter_invasion:kill()
	cm:callback(function() cm:disable_event_feed_events(false, "","","diplomacy_faction_destroyed") end, 1)
	cm:callback(function() cm:disable_event_feed_events(false, "wh_event_category_character", "", "") end, 1)
end


function InvasionBattleManager:reset()
    self:setup_encounter_force_removal()
    
    -- Does it not work withouth this?
    local uim = cm:get_campaign_ui_manager()
    uim:override("retreat"):unlock()
end

-------------------------
--- Constructors
-------------------------
function InvasionBattleManager:newFrom(core, random_army_manager, invasion_manager)
    local t = { core = core, random_army_manager = random_army_manager, invasion_manager = invasion_manager }
    setmetatable(t, self)
    self.__index = self
    return t
end

return InvasionBattleManager