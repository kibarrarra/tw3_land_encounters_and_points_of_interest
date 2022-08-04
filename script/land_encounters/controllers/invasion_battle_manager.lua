local Spot = require("script/land_encounters/models/spots/abstract_classes/Spot")

-------------------------
--- Constant values of the class [DO NOT CHANGE]
-------------------------
local DEFAULT_ENEMY_FORCE = "encounter_force"
local DEFAULT_ENEMY_INVASION = "encounter_invasion"

local DEFAULT_ENEMY_REINFORCEMENT_FORCE = "encounter_force_reinforcement"

local DEFAULT_DEFENDER_FORCE = "defender_force"
local DEFAULT_DEFENDER_INVASION = "defender_invasion"

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
-- Preconditions: is defending a 
-- Enemy_character: is at war with the player faction or is the player faction at war with the defending faction. 
-- Army: Is a template of the army of the player faction or the controlling faction that is defending the defendable spot.
-- Defender_lat_lng: is the defender army spawning point
function InvasionBattleManager:generate_defense_battle(defender_army, enemy_character, defender_lat_lng)
    local force_cqi = enemy_character:military_force():command_queue_index()
    local enemy_faction_name = enemy_character:faction():name()
    
    self.event_army = defender_army
    self.event_army:randomize_units(self.random_army_manager)
    
    local defender_force = self.random_army_manager:generate_force(DEFAULT_DEFENDER_FORCE)
    local defence = self:setup_invasion(DEFAULT_DEFENDER_INVASION, enemy_character, enemy_faction_name, defender_force, defender_lat_lng)
    defence:start_invasion(
        function(created_defender_force)
            cm:force_attack_of_opportunity(created_defender_force:get_general():military_force():command_queue_index(), force_cqi, false)
        end,
        false,
        false,
        false
    )
end


function InvasionBattleManager:generate_battle(offensive_army, player_character, enemy_lat_lng)
    local force_cqi = player_character:military_force():command_queue_index()
    local player_faction_name = player_character:faction():name()
    
    self.event_army = offensive_army
    self.event_army:randomize_units(self.random_army_manager)

    local invader_force = self.random_army_manager:generate_force(DEFAULT_ENEMY_FORCE)
    --out("LEAPOI - InvasionBattleManager:generate_battle - Event_army.faction:" .. self.event_army.faction)
    local invasion = self:setup_invasion(DEFAULT_ENEMY_INVASION, player_character, player_faction_name, invader_force, enemy_lat_lng)
    invasion:start_invasion(
        function(invasion_force)
            self.core:add_listener(
                "land_enc_and_poi_encounter_engage_invader",
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
end


function InvasionBattleManager:setup_invasion(invasion_identifier, objective_character, objective_faction_name, force, force_lat_lng)
    local character_cqi = objective_character:command_queue_index()
    -- create invasion
    if self.invasion_manager:get_invasion(invasion_identifier) then
        self.invasion_manager:remove_invasion(invasion_identifier)
    end
    local invasion = self.invasion_manager:new_invasion(invasion_identifier, self.event_army.faction, force, force_lat_lng)
    invasion:set_target("CHARACTER", character_cqi, objective_faction_name)
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
    

function InvasionBattleManager:setup_encounter_force_removal(invasion_identifier)
    out("LEAPOI - InvasionBattleManager:setup_encounter_force_removal setted for invasion_identifier=" .. tostring(invasion_identifier))
	self.core:add_listener(
        "land_enc_and_poi_encounter_removal",
        "FactionTurnStart", 
        true,
        function(context)
            --out("LEAPOI - InvasionBattleManager:setup_encounter_force_removal runned")
            local force = self.invasion_manager:get_invasion(invasion_identifier)
            if force then
                out("LEAPOI - InvasionBattleManager:setup_encounter_force_removal force triggered and killed")
                cm:disable_event_feed_events(true, "", "", "diplomacy_faction_destroyed")
                cm:disable_event_feed_events(true, "wh_event_category_character", "", "")
                force:kill()
                cm:callback(function() cm:disable_event_feed_events(false, "", "", "diplomacy_faction_destroyed") end, 1)
                cm:callback(function() cm:disable_event_feed_events(false, "wh_event_category_character", "", "") end, 1)
            end 
        end,
        IS_NOT_PERSISTENT_LISTENER
	)
end


function InvasionBattleManager:set_auxiliary_army_for_reset(army)
    --out("LEAPOI - InvasionBattleManager-set_auxiliary_army_for_reset - Army being setted:" .. battle_event)
    self.event_army = army
end


function InvasionBattleManager:reset_state_post_battle(zone, spot_type, spot_index, invasion_type)
    out("LEAPOI - InvasionBattleManager-reset_state_post_battle setted")
	self.core:add_listener(
        "land_enc_and_poi_encounter_post_battle",
        "BattleCompleted", 
        true,
        function(context)
            local found_encounter_faction = false
            local player_won_battle = false
    
            --out("LEAPOI - InvasionBattleManager-reset_state_post_battle - triggered")
            local attacker_was_victorious = cm:pending_battle_cache_attacker_victory()
            local defender_was_victorious = cm:pending_battle_cache_defender_victory()

            local player_faction_name = cm:get_local_faction_name()
            local encounter_invasion = self.invasion_manager:get_invasion(invasion_type)
    
            -- Changed because defensive type battles I cannot track the enemy easily
            -- TODO: check wheter this extra logic is neccesary: and cm:pending_battle_cache_faction_is_defender(self.event_army.faction)
            if cm:pending_battle_cache_faction_is_attacker(player_faction_name) then
                found_encounter_faction = true
                if attacker_was_victorious then
                    player_won_battle = true
                end
    
                if encounter_invasion then
                    self:silently_remove_encounter_invasion(encounter_invasion)
                end
            -- TODO: check wheter this extra logic is neccesary:  and cm:pending_battle_cache_faction_is_attacker(self.event_army.faction) 
            elseif cm:pending_battle_cache_faction_is_defender(player_faction_name)then
                found_encounter_faction = true
                if defender_was_victorious then
                    player_won_battle = true
                end
    
                if encounter_invasion then
                    self:silently_remove_encounter_invasion(encounter_invasion)
                end
            end
            
            cm:callback(function() cm:disable_event_feed_events(false, "","","diplomacy_faction_destroyed") end, 1)
            cm:callback(function() cm:disable_event_feed_events(false, "wh_event_category_character", "", "") end, 1)
            
            if found_encounter_faction == true then
                local uim = cm:get_campaign_ui_manager()
                uim:override("retreat"):unlock()
                zone:trigger_event_given_battle_result(spot_type, spot_index, player_won_battle)
            end
        end,
        IS_NOT_PERSISTENT_LISTENER
	)
end


function InvasionBattleManager:silently_remove_encounter_invasion(encounter_invasion)
    cm:disable_event_feed_events(true, "","","diplomacy_faction_destroyed")
	cm:disable_event_feed_events(true, "wh_event_category_character", "", "")
	encounter_invasion:kill()
	cm:callback(function() cm:disable_event_feed_events(false, "","","diplomacy_faction_destroyed") end, 1)
	cm:callback(function() cm:disable_event_feed_events(false, "wh_event_category_character", "", "") end, 1)
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