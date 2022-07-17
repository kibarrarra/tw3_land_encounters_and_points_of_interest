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
return {
    ------------------------------------------------------------------------------------
    -- Bandits: The weakest forces, withouth heroes and low chances on dangerous units
    ------------------------------------------------------------------------------------
    -- Empire (W)
    ["land_enc_dilemma_bandits_emp"] = {
        faction = "wh_main_emp_empire_qb1", -- Do not create new factions as recommended by Vandy.
        lord = { 
            possible_subtypes = { 
                "wh_main_emp_lord",
                "wh_dlc04_emp_arch_lector",
                "wh2_dlc13_emp_cha_huntsmarshal"
            }, 
            level_ranges = {5, 20}, 
            possible_forenames = { "2048091270", "350864146", "1904032251", "2147357032", "2147344111", "2147357145", "2147357030", "2147357011", "2147355314" }, -- or names
            possible_clan_names = {}, 
            possible_family_names = { "2147356839", "2147356736", "2147356796", "2147356888", "2147354914" } -- or surnames 
        },
        unit_experience_amount = 2,
        units = { -- 19 units
            -- unit{id, quantity, appeareance_chance, alternative_chance, alternative}
            { "wh_main_emp_inf_halberdiers", 4, 100, 0, nil }, -- 5
            { "wh_main_emp_inf_crossbowmen", 4, 100, 0, nil }, -- 9
            { "wh_main_emp_art_mortar", 2, 100, 0, nil }, -- 11 basic army (if lucky this will be the only army the player will need to beat for the reward
            { "wh2_dlc13_emp_inf_huntsmen_0", 2, 70, 30, "wh_main_emp_inf_greatswords" }, -- 13
            { "wh_main_emp_inf_handgunners", 2, 20, 20, "wh_main_emp_inf_crossbowmen" }, -- 15
            { "wh_main_emp_art_helstorm_rocket_battery", 2, 10, 20, "wh_main_emp_veh_steam_tank" }, -- 17
            { "wh_main_emp_cav_outriders_0", 1, 5, 5, "wh_main_emp_veh_steam_tank" }, -- 18
            { "wh_main_emp_art_great_cannon", 1, 5, 5, "wh_main_emp_art_helstorm_rocket_battery" }, -- 19
            { "wh_main_emp_art_helblaster_volley_gun", 1, 5, 5, "wh_main_emp_cav_demigryph_knights_0" } -- 20
        },
    },
    -- Wood Elves (W)
    ["land_enc_dilemma_bandits_wef"] = {
        faction = "wh_dlc05_wef_wood_elves_qb1",
        lord = { 
            possible_subtypes = { 
                "wh_dlc05_wef_glade_lord", 
                "wh2_dlc16_wef_spellweaver_life"
            },
            level_ranges = {5, 20}, 
            possible_forenames = { "2048091270" },
            possible_clan_names = {}, 
            possible_family_names = { "2147356839" }
        },
        unit_experience_amount = 2,
        units = {
            { "wh_dlc05_wef_inf_glade_guard_0", 6, 100, 0, nil }, -- 7
            { "wh_dlc05_wef_inf_eternal_guard_0", 2, 100, 0, nil }, -- 9
            { "wh_dlc05_wef_cav_wild_riders_1", 2, 100, 0, nil }, -- 11 basic army
            { "wh_dlc05_wef_inf_dryads_0", 2, 20, 0, nil }, --  13
            { "wh_dlc05_wef_inf_deepwood_scouts_1", 2, 10, 50, "wh_dlc05_wef_cav_wild_riders_0" }, -- 15
            { "wh_dlc05_wef_inf_wardancers_0", 2, 5, 0, nil }, -- 17
            { "wh_dlc05_wef_inf_waywatchers_0", 2, 5, 60, "wh_dlc05_wef_inf_deepwood_scouts_0" },  -- 19
            { "wh_dlc05_wef_forest_dragon_0", 1, 1, 50, "wh_dlc05_wef_cha_ancient_treeman_0" } -- 20
        }
    }, 
    -- Norsca (W)
    ["land_enc_dilemma_bandits_nor"] = {
        faction = "wh_main_nor_norsca_qb1",
        lord = { 
            possible_subtypes = { 
                "wh_main_nor_marauder_chieftain", 
                "wh_dlc08_nor_wulfrik"
            },
            level_ranges = {5, 20}, 
            possible_forenames = {}, -- or names
            possible_clan_names = {}, 
            possible_family_names = {} -- or surnames
        },
        unit_experience_amount = 2,
        units = {
            { "wh_main_nor_cav_marauder_horsemen_0", 6, 100, 0, nil }, -- 7
            { "wh_dlc08_nor_inf_marauder_hunters_0", 4, 100, 0, nil}, -- 11 basic army
            { "wh_dlc08_nor_inf_marauder_berserkers_0", 2, 100, 2, "wh_dlc08_nor_mon_norscan_giant_0" }, -- 13
            { "wh_main_nor_cav_chaos_chariot", 2, 20, 0, nil  }, -- 15
            { "wh_dlc08_nor_mon_skinwolves_1", 2, 10, 50, "wh_main_nor_mon_chaos_warhounds_1" }, -- 17
            { "wh_dlc08_nor_mon_fimir_1", 2, 5, 0, nil }, -- 19
            { "wh_dlc08_nor_mon_war_mammoth_0", 1, 5, 0, nil } -- 20
        }
     },
    ------------------------------------------------------------------------------------
    -- Incursions: Small invasions of stronger races with better armies
    ------------------------------------------------------------------------------------
    -- High Elves (W)
    ["land_enc_dilemma_incursion_army_hef"] = {
        faction = "wh2_main_hef_high_elves_qb1",
        lord = { 
            possible_subtypes = { 
                "wh2_main_hef_princess", 
                "wh2_dlc15_hef_archmage_life",
                "wh2_dlc15_hef_eltharion"
            },
            level_ranges = {20, 30}, 
            possible_forenames = {}, -- or names
            possible_clan_names = {}, 
            possible_family_names = {} -- or surnames
        },
        unit_experience_amount = 4,
        units = {
            { "wh2_main_hef_inf_lothern_sea_guard_0", 6, 100, 0, nil }, -- 7
            { "wh2_main_hef_inf_white_lions_of_chrace_0", 4, 100, 0, nil}, -- 11 basic army
            { "wh2_main_hef_art_eagle_claw_bolt_thrower", 2, 100, 50, "wh2_main_hef_cav_tiranoc_chariot" }, -- 13
            
            { "wh2_main_hef_inf_swordmasters_of_hoeth_0", 2, 50, 10, "wh2_main_hef_inf_lothern_sea_guard_1" }, -- 15
            { "wh2_main_hef_cav_ithilmar_chariot", 2, 30, 30, "wh2_main_hef_mon_moon_dragon" }, -- 17
            { "wh2_main_hef_mon_phoenix_flamespyre", 2, 20, 50, "wh2_main_hef_mon_phoenix_frostheart" }, -- 19
            { "wh2_main_hef_mon_star_dragon", 1, 5, 0, nil } -- 20
        }
    },
    
    -- Lizardmen (W)
    ["land_enc_dilemma_incursion_army_lzd"] = {
        faction = "wh2_main_lzd_lizardmen_qb1",
        lord = { 
            possible_subtypes = { 
                "wh2_main_lzd_saurus_old_blood",
                "wh2_dlc12_lzd_tiktaqto", 
                "wh2_dlc12_lzd_tehenhauin", 
                "wh2_dlc17_lzd_oxyotl",
                "wh2_dlc13_lzd_nakai" 
            },
            level_ranges = {20, 30}, 
            possible_forenames = {},
            possible_clan_names = {}, 
            possible_family_names = {}
        },
        unit_experience_amount = 4,
        units = { -- 19 units
            -- unit{id, quantity, appeareance_chance, alternative_chance, alternative}
            { "wh2_main_lzd_inf_skink_skirmishers_0", 4, 100, 0, nil }, -- 5
            { "wh2_main_lzd_inf_temple_guards", 4, 100, 0, nil }, -- 9
            { "wh2_main_lzd_mon_kroxigors", 2, 100, 0, nil }, -- 11 basic army (if lucky this will be the only army the player will need to beat for the reward
            { "wh2_dlc12_lzd_mon_ancient_stegadon_1", 2, 50, 30, "wh2_dlc12_lzd_inf_skink_red_crested_0" }, -- 13
            { "wh2_dlc17_lzd_inf_chameleon_stalkers_0", 2, 20, 20, "wh2_dlc13_lzd_mon_razordon_pack_0" }, -- 15
            { "wh2_main_lzd_inf_saurus_spearmen_1", 2, 10, 20, "wh2_dlc12_lzd_cav_ripperdactyl_riders_0" }, -- 17
            { "wh2_main_lzd_mon_ancient_stegadon", 1, 10, 5, "wh2_main_lzd_mon_stegadon_blessed_1" }, -- 18
            { "wh2_dlc17_lzd_mon_coatl_0", 1, 10, 5, "wh2_dlc12_lzd_cav_ripperdactyl_riders_ror_0" }, -- 19
            { "wh2_dlc13_lzd_mon_dread_saurian_1", 1, 5, 0, nil } -- 20
        }
    },
    
    -- Vampire Coast (W)
    ["land_enc_dilemma_incursion_army_vco"] = {
        faction = "wh2_dlc11_cst_vampire_coast_qb1",
        lord = { 
            possible_subtypes = { 
                "wh2_dlc11_cst_admiral_fem_vampires",
                "wh2_dlc11_cst_admiral_fem_deep",
                "wh2_dlc11_cst_cylostra"
            },
            level_ranges = {20, 30}, 
            possible_forenames = { "names_name_242277685" },
            possible_clan_names = {}, 
            possible_family_names = { "names_name_2147345188" }
        },
        unit_experience_amount = 4,
        units = { -- 19 units
            -- unit{id, quantity, appeareance_chance, alternative_chance, alternative}
            { "wh2_dlc11_cst_inf_depth_guard_0", 4, 100, 0, nil }, -- 5
            { "wh2_dlc11_cst_inf_syreens", 4, 100, 0, nil }, -- 9
            { "wh2_dlc11_cst_inf_deck_gunners_0", 2, 100, 0, nil }, -- 11 basic army (if lucky this will be the only army the player will need to beat for the reward
            { "wh2_dlc11_cst_mon_bloated_corpse_0", 2, 70, 0, nil }, -- 13
            { "wh2_dlc11_cst_inf_zombie_deckhands_mob_1", 2, 50, 20, "wh2_dlc11_cst_mon_animated_hulks_0" }, -- 15
            { "wh2_dlc11_cst_mon_scurvy_dogs", 2, 20, 20, "wh2_dlc11_cst_cav_deck_droppers_ror_0" }, -- 17
            { "wh2_dlc11_cst_art_carronade", 1, 5, 15, "wh2_dlc11_cst_mon_terrorgheist" }, -- 18
            { "wh2_dlc11_cst_mon_mournguls_0", 1, 5, 10, "wh2_dlc11_cst_mon_necrofex_colossus_0" }, -- 19
            { "wh2_dlc11_cst_mon_necrofex_colossus_0", 1, 5, 5, "wh2_dlc11_cst_art_queen_bess" } -- 20
        }
    },
    ------------------------------------------------------------------------------------
    -- Surprise Attack: Killer armies
    ------------------------------------------------------------------------------------
    -- Beastmen
    ["land_enc_dilemma_surprise_attack_bst"] = {
        faction = "wh_dlc03_bst_beastmen_qb1",
        lord = { 
            possible_subtypes = { 
                "wh_dlc03_bst_beastlord",
                "wh_dlc05_bst_morghur", 
                "wh_dlc03_bst_khazrak"
            },
            level_ranges = {30, 40}, 
            possible_forenames = {},
            possible_clan_names = {}, 
            possible_family_names = {}
        },
        unit_experience_amount = 6,
        units = {
            -- unit{id, quantity, appeareance_chance, alternative_chance, alternative}
            { "wh_pro04_bst_inf_bestigor_herd_ror_0", 4, 100, 0, nil },
            { "wh_dlc03_bst_inf_ungor_raiders_0", 6, 100, 0, nil  }, -- 11 basic army
            { "wh_dlc03_bst_inf_cygor_0", 3, 80, 50, "wh2_dlc17_bst_mon_ghorgon_0" }, -- 14 
            { "wh_dlc03_bst_inf_ungor_herd_1", 2, 40, 30, "wh2_dlc17_bst_cha_wargor_2"}, -- 16
            { "wh_dlc03_bst_inf_chaos_warhounds_1", 2, 30, 50, "wh2_dlc17_bst_mon_ghorgon_0" }, -- 18
            { "wh_dlc03_bst_cav_razorgor_chariot_0", 2, 20, 50, "wh2_dlc17_bst_mon_jabberslythe_0" } -- 20
        }
    },
    
    -- Skaven
    ["land_enc_dilemma_surprise_attack_skv"] = {
        faction = "wh2_main_skv_skaven_qb1",
        lord = { 
            possible_subtypes = { 
                "wh2_dlc12_skv_warlock_master", 
                "wh2_dlc14_skv_master_assassin", 
                "wh2_dlc09_skv_tretch_craventail", 
                --"wh2_dlc12_skv_ikit_claw" 
            },
            level_ranges = {30, 40}, 
            possible_forenames = {},
            possible_clan_names = {}, 
            possible_family_names = {}
        },
        unit_experience_amount = 6,
        units = {
            { "wh2_main_skv_inf_stormvermin", 4, 100, 10, "wh2_main_skv_inf_clanrat_spearmen_1" },
            { "wh2_dlc14_skv_inf_eshin_triads_0", 6, 100, 10, "wh2_dlc12_skv_veh_doom_flayer_0" }, -- 11 basic army
            { "wh2_dlc12_skv_inf_warplock_jezzails_0", 3, 80, 50, "wh2_dlc14_skv_inf_poison_wind_mortar_0" }, -- 14 
            { "wh2_main_skv_mon_hell_pit_abomination", 2, 40, 30, "wh2_main_skv_mon_rat_ogres"}, -- 16
            { "wh2_main_skv_veh_doomwheel", 2, 30, 50, "wh2_main_skv_inf_gutter_runners_1" }, -- 18
            { "wh2_main_skv_inf_night_runners_1", 2, 20, 50, "wh2_main_skv_inf_plague_monks" } -- 20
        }
    },
    
    ------------------------------------------------------------------------------------
    -- Battlefields: Thematic doomstacks with reinforcements and legendary lords
    ------------------------------------------------------------------------------------
    -- Greenskins
    ["land_enc_dilemma_battlefield_grn"] = {
        faction = "wh_main_grn_greenskins_qb1",
        lord = { 
            possible_subtypes = { 
                "wh_main_grn_goblin_great_shaman",
                "wh_main_grn_orc_warboss",
                "wh_dlc06_grn_skarsnik",
                "wh_dlc06_grn_wurrzag_da_great_prophet",
                "wh_main_grn_grimgor_ironhide"
            },
            level_ranges = {40, 50}, 
            possible_forenames = {},
            possible_clan_names = {}, 
            possible_family_names = {}
        },
        unit_experience_amount = 6,
        units = {
            { "wh2_dlc15_grn_mon_river_trolls_ror_0", 1, 100, 0, nil }, -- 2
            { "wh2_dlc15_grn_mon_river_trolls_0", 4, 100, 0, nil }, -- 10
            { "wh2_dlc15_grn_mon_stone_trolls_0", 4, 100, 0, nil }, -- 6
            { "wh2_dlc15_grn_veh_snotling_pump_wagon_ror_0", 1, 100, 0, nil}, -- 11
            { "wh2_dlc15_grn_veh_snotling_pump_wagon_roller_0", 2, 100, 0, nil}, -- 13
            { "wh_main_grn_mon_arachnarok_spider_0", 6, 100, 0, nil}, -- 19
            { "wh_dlc15_grn_mon_arachnarok_spider_waaagh_0", 1, 100, 0, nil } -- 20 Should be one. Testing with 5 if it generates 2 armies
        },
    },
    -- Dark Elves (W)
    ["land_enc_dilemma_battlefield_def"] = {
        faction = "wh2_main_def_dark_elves_qb1",
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
        }
    },
    
    -- Vampires
    ["land_enc_dilemma_battlefield_vmp"] = {
        faction = "wh_main_vmp_vampire_counts_qb1",
        lord = { 
            possible_subtypes = { 
                "wh_dlc04_vmp_helman_ghorst", 
                --"wh_dlc04_vmp_vlad_con_carstein",
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
        }
    },
    
    -- Tomb Kings
    ["land_enc_dilemma_battlefield_tmb"] = {
        faction = "wh2_dlc09_tmb_tombking_qb1",
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
        }
    }
    
}