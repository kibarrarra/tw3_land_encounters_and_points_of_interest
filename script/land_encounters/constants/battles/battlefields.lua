--[[
Creates the battle forces to fight in the battles 

Every force needs:
==================
BATTLE FORCE
==================
== DB
faction_agent_permitted_subtypes_tables (declares the hero units the faction can use [Reuse old factions in this case])
faction_rebellion_units_junctions_tables (declares the common units the faction can use)
(get names from campaign_rogue_army_leaders_table)
== LOC
None

--]]
------------------------------------------------------------------------------------
-- Battlefields: Thematic doomstacks with reinforcements and legendary lords
------------------------------------------------------------------------------------
return {
    -- Greenskins
    ["land_enc_dilemma_battlefield_grn"] = {
        faction = "wh_main_grn_greenskins_qb1",
        identifier = "encounter_force",
        invasion_identifier = "encounter_invasion",
        lord = { 
            possible_subtypes = { 
                "wh_main_grn_goblin_great_shaman",
                "wh_main_grn_orc_warboss",
                "wh_dlc06_grn_skarsnik",
                "wh_dlc06_grn_wurrzag_da_great_prophet"
            },
            level_ranges = {40, 50}, 
            possible_forenames = {},
            possible_clan_names = {}, 
            possible_family_names = {}
        },
        unit_experience_amount = 9,
        units = {
            { "wh2_dlc15_grn_mon_river_trolls_ror_0", 1, 100, 0, nil }, -- 2
            { "wh2_dlc15_grn_mon_river_trolls_0", 4, 100, 0, nil }, -- 10
            { "wh2_dlc15_grn_mon_stone_trolls_0", 4, 100, 0, nil }, -- 6
            { "wh2_dlc15_grn_veh_snotling_pump_wagon_ror_0", 1, 100, 0, nil}, -- 11
            { "wh2_dlc15_grn_veh_snotling_pump_wagon_roller_0", 2, 100, 0, nil}, -- 13
            { "wh_main_grn_mon_arachnarok_spider_0", 6, 100, 0, nil}, -- 19
            { "wh_dlc15_grn_mon_arachnarok_spider_waaagh_0", 1, 100, 0, nil } -- 20 Should be one. Testing with 5 if it generates 2 armies
        },
        reinforcing_ally_armies = false,
        reinforcing_enemy_armies = false
    },
    
    -- Dark Elves (W)
    ["land_enc_dilemma_battlefield_def"] = {
        faction = "wh2_main_def_dark_elves_qb1",
        identifier = "encounter_force",
        invasion_identifier = "encounter_invasion",
        lord = { 
            possible_subtypes = { 
                "wh2_dlc10_def_supreme_sorceress_fire",
                "wh2_main_def_dreadlord_fem",
                "wh2_main_def_malekith",
                "wh2_main_def_morathi",
                "wh2_dlc14_def_malus_darkblade"
            },
            level_ranges = {40, 50}, 
            possible_forenames = {},
            possible_clan_names = {}, 
            possible_family_names = {}
        },
        unit_experience_amount = 9,
        units = {
            { "wh2_main_def_inf_shades_2", 6, 100, 0, nil }, -- 7
            { "wh2_main_def_inf_black_guard_0", 2, 100, 0, nil }, -- 9
            { "wh2_dlc14_def_cav_scourgerunner_chariot_ror_0", 2, 100, 0, nil}, -- 11 basic army
            { "wh2_main_def_inf_shades_0", 3, 100, 10, "wh2_main_def_inf_shades_2" }, -- 14
            { "wh2_main_def_inf_shades_1", 2, 100, 10, "wh2_dlc10_def_inf_sisters_of_slaughter" }, -- 16
            { "wh2_main_def_cav_cold_one_knights_1", 2, 100, 0, nil }, -- 18
            { "wh2_main_def_mon_war_hydra", 2, 100, 30, "wh2_main_def_mon_black_dragon" } -- 20 Used to be 2
        },
        reinforcing_ally_armies = false,
        reinforcing_enemy_armies = false
    },
    
    -- Vampires
    ["land_enc_dilemma_battlefield_vmp"] = {
        faction = "wh_main_vmp_vampire_counts_qb1",
        identifier = "encounter_force",
        invasion_identifier = "encounter_invasion",
        lord = { 
            possible_subtypes = { 
                "wh_dlc04_vmp_helman_ghorst", 
                "wh_dlc04_vmp_vlad_con_carstein",
                "wh_pro02_vmp_isabella_von_carstein",
                "wh_main_vmp_heinrich_kemmler",
                "wh2_dlc11_vmp_bloodline_lahmian",
                "wh2_dlc11_vmp_bloodline_necrarch"
            },
            level_ranges = {40, 50}, 
            possible_forenames = {},
            possible_clan_names = {}, 
            possible_family_names = {}
        },
        unit_experience_amount = 9,
        units = { -- 19 units
            { "wh_main_vmp_mon_crypt_horrors", 4, 100, 0, nil }, -- 5
            { "wh2_dlc11_vmp_inf_handgunners", 4, 100, 0, nil }, -- 9
            { "wh_dlc02_vmp_cav_blood_knights_0", 2, 100, 0, nil }, -- 11 basic army (if lucky this will be the only army the player will need to beat for the reward
            { "wh_main_vmp_mon_varghulf", 2, 100, 20, "wh_main_vmp_mon_vargheists" }, -- 13
            { "wh_main_vmp_mon_vargheists", 2, 100, 30, "wh_dlc02_vmp_cav_blood_knights_0" }, -- 15
            { "wh_dlc02_vmp_cav_blood_knights_0", 2, 100, 20, "wh_main_vmp_mon_vargheists" }, -- 17
            { "wh_dlc04_vmp_mon_devils_swartzhafen_0", 1, 100, 5, "wh_main_vmp_mon_varghulf" }, -- 18
            { "wh_main_vmp_cav_hexwraiths", 1, 100, 5, "wh_dlc02_vmp_cav_blood_knights_0" }, -- 19
            { "wh_dlc04_vmp_cav_chillgheists_0", 1, 100, 5, "wh_main_vmp_cav_hexwraiths" } -- 20
        },
        reinforcing_ally_armies = false,
        reinforcing_enemy_armies = false
    },
    
    -- Tomb Kings
    ["land_enc_dilemma_battlefield_tmb"] = {
        faction = "wh2_dlc09_tmb_tombking_qb1",
        identifier = "encounter_force",
        invasion_identifier = "encounter_invasion",
        lord = { 
            possible_subtypes = { 
                "wh2_dlc09_tmb_tomb_king",
                "wh2_dlc09_tmb_khatep",
                "wh2_dlc09_tmb_settra"
            },
            level_ranges = {40, 50}, 
            possible_forenames = {},
            possible_clan_names = {}, 
            possible_family_names = {}
        },
        unit_experience_amount = 9,
        units = { -- 19 units
            -- unit{id, quantity, appeareance_chance, alternative_chance, alternative}
            { "wh2_dlc09_tmb_inf_tomb_guard_0", 2, 100, 0, nil }, -- 3
            { "wh2_dlc09_tmb_inf_tomb_guard_1", 2, 100, 30, "wh2_dlc09_tmb_inf_skeleton_archers_0" }, -- 5
            { "wh2_dlc09_tmb_inf_skeleton_archers_0", 2, 100, 0, nil }, -- 7
            { "wh2_dlc09_tmb_inf_skeleton_archers_ror", 1, 100, 1, "wh2_dlc09_tmb_art_casket_of_souls_0" }, -- 8
            { "wh2_dlc09_tmb_art_casket_of_souls_0", 2, 100, 0, nil }, -- 10
            { "wh2_dlc09_tmb_mon_necrosphinx_0", 2, 100, 20, "wh2_dlc09_tmb_inf_tomb_guard_1" }, -- 12
            { "wh2_dlc09_tmb_mon_tomb_scorpion_0", 4, 100, 20, "wh2_dlc09_tmb_mon_necrosphinx_0" }, -- 16
            { "wh2_dlc09_tmb_veh_khemrian_warsphinx_0", 2, 100, 5, "wh2_dlc09_tmb_mon_tomb_scorpion_0" }, -- 18
            { "wh2_dlc09_tmb_mon_necrosphinx_ror", 2, 100, 5, "wh2_dlc09_tmb_veh_khemrian_warsphinx_0" } -- 20
        },
        reinforcing_ally_armies = false,
        reinforcing_enemy_armies = false
    },
    
    -- Dwarfs
    ["land_enc_dilemma_battlefield_dwf"] = {
        faction = "wh_main_dwf_dwarfs_qb1",
        identifier = "encounter_force",
        invasion_identifier = "encounter_invasion",
        lord = { 
            possible_subtypes = { 
                "wh2_pro08_neu_gotrek"
            },
            level_ranges = {20, 30}, 
            possible_forenames = {},
            possible_clan_names = {}, 
            possible_family_names = {}
        },
        unit_experience_amount = 9,
        units = { -- 19 units
            -- unit{id, quantity, appeareance_chance, alternative_chance, alternative}
            { "wh2_pro08_neu_felix", 1, 100, 0, nil }, -- 2
            { "wh2_dlc10_dwf_inf_giant_slayers", 4, 100, 30, "wh_main_dwf_inf_slayers" }, -- 5
            { "wh2_dlc10_dwf_inf_giant_slayers", 4, 100, 30, "wh_main_dwf_inf_slayers" }, -- 9 basic army (if lucky this will be 
            { "wh2_dlc10_dwf_inf_giant_slayers", 4, 100, 30, "wh_main_dwf_inf_slayers" }, -- 13
            { "wh2_dlc10_dwf_inf_giant_slayers", 4, 100, 30, "wh_main_dwf_inf_slayers" }, -- 17
            { "wh2_dlc10_dwf_inf_giant_slayers", 3, 100, 30, "wh_main_dwf_inf_slayers" } -- 20                 
        },
        reinforcing_ally_armies = false,
        reinforcing_enemy_armies = false
    },
    
}