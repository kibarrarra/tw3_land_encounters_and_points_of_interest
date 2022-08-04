-- Defenders by culture and level given the faction that has control of the defensive spot
local smithy_defenders =  {
    --WH1
    --Dwarfs
    ["wh_main_sc_dwf_dwarfs"] = {
        lord = { 
            possible_subtypes = { 
                "wh_dlc06_dwf_cha_runelord"
            },
            level_ranges = { 5, 20 }, 
            possible_forenames = { },
            possible_clan_names = { }, 
            possible_family_names = { }
        },
        armies_by_level = {
            [1] = {
                unit_experience_amount = 2,
                units = {
                    { "wh_main_dwf_inf_longbeards", 4, 100, 0, nil },
                    { "wh_main_dwf_inf_quarrellers_1", 4, 100, 0, nil },
                    { "wh_main_dwf_art_grudge_thrower", 4, 100, 0, nil }
                }
            },
            [2] = {
                unit_experience_amount = 5,
                units = {
                    { "wh_main_dwf_inf_longbeards_1", 4, 100, 0, nil },
                    { "wh_main_dwf_inf_thunderers_0", 8, 100, 0, nil },
                    { "wh_main_dwf_art_cannon", 4, 100, 0, nil }
                }
            },
            [3] = {
                unit_experience_amount = 7,
                units = {
                    { "wh_main_dwf_inf_ironbreakers", 4, 100, 0, nil },
                    { "wh_main_dwf_inf_thunderers_0", 8, 100, 0, nil },
                    { "wh_main_dwf_art_organ_gun", 4, 100, 0, nil },
                    { "wh_main_dwf_veh_gyrocopter_1", 2, 100, 0, nil },
                    { "wh_main_dwf_veh_gyrobomber", 1, 100, 0, nil }
                }
            }
        }
    },
    --Greenskins
    ["wh_main_sc_grn_greenskins"] = {
        lord = { 
            possible_subtypes = { 
                "wh_main_grn_goblin_great_shaman"
            },
            level_ranges = { 5, 20 }, 
            possible_forenames = { },
            possible_clan_names = { }, 
            possible_family_names = { }
        },
        armies_by_level = {
            [1] = {
                unit_experience_amount = 2,
                units = {
                    { "wh_dlc06_grn_inf_nasty_skulkers_0", 4, 100, 0, nil },
                    { "wh_main_grn_inf_goblin_archers", 6, 100, 0, nil },
                    { "wh_main_grn_art_goblin_rock_lobber", 2, 100, 0, nil }
                }
            },
            [2] = {
                unit_experience_amount = 5,
                units = {
                    { "wh_main_grn_inf_orc_big_uns", 4, 100, 0, nil },
                    { "wh_main_grn_inf_night_goblin_fanatics_1", 4, 100, 0, nil },
                    { "wh_main_grn_mon_arachnarok_spider_0", 4, 100, 0, nil },
                    { "wh_main_grn_art_doom_diver_catapult", 3, 100, 0, nil }
                }
            },
            [3] = {
                unit_experience_amount = 7,
                units = {
                    { "wh_main_grn_inf_black_orcs", 6, 100, 0, nil },
                    { "wh2_dlc15_grn_mon_stone_trolls_0", 6, 100, 0, nil },
                    { "wh2_dlc15_grn_mon_river_trolls_0", 2, 100, 0, nil },
                    { "wh_main_grn_mon_arachnarok_spider_0", 5, 100, 0, nil }
                }
            }
        }
    },
    --The Empire
    ["wh_main_sc_emp_empire"] = {
        lord = { 
            possible_subtypes = { 
                "wh_main_emp_lord"
            },
            level_ranges = { 5, 20 }, 
            possible_forenames = { },
            possible_clan_names = { }, 
            possible_family_names = { }
        },
        armies_by_level = {
            [1] = {
                unit_experience_amount = 2,
                units = {
                    { "wh_dlc04_emp_inf_free_company_militia_0", 4, 100, 0, nil },
                    { "wh_main_emp_inf_crossbowmen", 6, 100, 0, nil },
                    { "wh_main_emp_art_mortar", 2, 100, 0, nil }
                }
            },
            [2] = {
                unit_experience_amount = 5,
                units = {
                    { "wh_main_emp_inf_halberdiers", 4, 100, 0, nil },
                    { "wh_main_emp_inf_crossbowmen", 4, 100, 0, nil },
                    { "wh_main_emp_inf_handgunners", 4, 100, 0, nil },
                    { "wh_main_emp_art_helstorm_rocket_battery", 3, 100, 0, nil }
                }
            },
            [3] = {
                unit_experience_amount = 7,
                units = {
                    { "wh_main_emp_inf_greatswords", 4, 100, 0, nil },
                    { "wh2_dlc13_emp_inf_huntsmen_0", 4, 100, 0, nil },
                    { "wh_main_emp_inf_handgunners", 4, 100, 0, nil },
                    { "wh_main_emp_art_helstorm_rocket_battery", 4, 100, 0, nil },
                    { "wh_main_emp_art_helblaster_volley_gun", 3, 100, 0, nil }
                }
            }
        }
    },
    --Vampire Counts
    ["wh_main_sc_vmp_vampire_counts"] = {
        lord = { 
            possible_subtypes = { 
                "wh2_dlc11_vmp_bloodline_necrarch"
            },
            level_ranges = { 5, 20 }, 
            possible_forenames = { },
            possible_clan_names = { }, 
            possible_family_names = { }
        },
        armies_by_level = {
            [1] = {
                unit_experience_amount = 2,
                units = {
                    { "wh_main_vmp_inf_skeleton_warriors_1", 4, 100, 0, nil },
                    { "wh_main_vmp_mon_vargheists", 4, 100, 0, nil },
                    { "wh2_dlc11_vmp_inf_crossbowmen", 4, 100, 0, nil }
                }
            },
            [2] = {
                unit_experience_amount = 5,
                units = {
                    { "wh_main_vmp_inf_grave_guard_0", 6, 100, 0, nil },
                    { "wh_main_vmp_mon_vargheists", 4, 100, 0, nil },
                    { "wh_main_vmp_mon_varghulf", 2, 100, 0, nil },
                    { "wh2_dlc11_vmp_inf_handgunners", 4, 100, 0, nil }
                }
            },
            [3] = {
                unit_experience_amount = 7,
                units = {
                    { "wh_main_vmp_inf_grave_guard_1", 8, 100, 0, nil },
                    { "wh_main_vmp_inf_cairn_wraiths", 3, 100, 0, nil },
                    { "wh2_dlc11_vmp_inf_handgunners", 4, 100, 0, nil },
                    { "wh_dlc04_vmp_veh_mortis_engine_0", 1, 100, 0, nil },
                    { "wh_main_vmp_mon_varghulf", 3, 100, 0, nil }
                }
            }
        }
    },
    --Warriors of Chaos
    ["wh_main_sc_chs_chaos"] = {
        lord = { 
            possible_subtypes = { 
                "wh_dlc01_chs_cha_chaos_lord"
            },
            level_ranges = { 5, 20 }, 
            possible_forenames = { },
            possible_clan_names = { }, 
            possible_family_names = { }
        },
        armies_by_level = {
            [1] = {
                unit_experience_amount = 2,
                units = {
                    { "wh_main_chs_inf_chaos_warriors_0", 4, 100, 0, nil },
                    { "wh_dlc01_chs_inf_chosen_2", 4, 100, 0, nil },
                    { "wh_dlc01_chs_inf_forsaken_0", 2, 100, 0, nil },
                    { "wh_main_chs_art_hellcannon", 2, 100, 0, nil }
                }
            },
            [2] = {
                unit_experience_amount = 5,
                units = {
                    { "wh_dlc01_chs_inf_chosen_2", 5, 100, 0, nil },
                    { "wh_dlc01_chs_inf_forsaken_0", 5, 100, 0, nil },
                    { "wh_dlc06_chs_inf_aspiring_champions_0", 3, 100, 0, nil },
                    { "wh_main_chs_art_hellcannon", 3, 100, 0, nil }
                }
            },
            [3] = {
                unit_experience_amount = 7,
                units = {
                    { "wh_dlc06_chs_inf_aspiring_champions_0", 4, 100, 0, nil },
                    { "wh_dlc01_chs_inf_chosen_2", 6, 100, 0, nil },
                    { "wh_dlc01_chs_mon_dragon_ogre_shaggoth", 6, 100, 0, nil },
                    { "wh_main_chs_art_hellcannon", 3, 100, 0, nil }
                }
            }
        }
    },
    --Beastmen
    ["wh_dlc03_sc_bst_beastmen"] = {
        lord = { 
            possible_subtypes = { 
                "wh_dlc03_bst_beastlord"
            },
            level_ranges = { 5, 20 }, 
            possible_forenames = { },
            possible_clan_names = { }, 
            possible_family_names = { }
        },
        armies_by_level = {
            [1] = {
                unit_experience_amount = 2,
                units = {
                    { "wh_dlc03_bst_inf_ungor_spearmen_1", 4, 100, 0, nil },
                    { "wh_dlc03_bst_inf_ungor_raiders_0", 4, 100, 0, nil },
                    { "wh_dlc03_bst_inf_minotaurs_0", 2, 100, 0, nil },
                    { "wh_dlc03_bst_inf_cygor_0", 2, 100, 0, nil }
                }
            },
            [2] = {
                unit_experience_amount = 5,
                units = {
                    { "wh_dlc03_bst_inf_bestigor_herd_0", 4, 100, 0, nil },
                    { "wh_dlc03_bst_inf_ungor_raiders_0", 4, 100, 0, nil },
                    { "wh_dlc03_bst_inf_minotaurs_2", 4, 100, 0, nil },
                    { "wh_dlc03_bst_inf_cygor_0", 4, 100, 0, nil }
                }
            },
            [3] = {
                unit_experience_amount = 7,
                units = {
                    { "wh_dlc03_bst_inf_bestigor_herd_0", 6, 100, 0, nil },
                    { "wh_dlc03_bst_inf_minotaurs_2", 4, 100, 0, nil },
                    { "wh_dlc03_bst_inf_cygor_0", 4, 100, 0, nil },
                    { "wh_dlc03_bst_feral_manticore", 2, 100, 0, nil },
                    { "wh2_dlc17_bst_mon_ghorgon_0", 2, 100, 0, nil },
                    { "wh2_dlc17_bst_mon_jabberslythe_0", 1, 100, 0, nil }
                }
            }
        }
    },
    --Bretonnia
    ["wh_main_sc_brt_bretonnia"] = {
        lord = { 
            possible_subtypes = { 
                "wh_main_brt_cha_lord"
            },
            level_ranges = { 5, 20 }, 
            possible_forenames = { },
            possible_clan_names = { }, 
            possible_family_names = { }
        },
        armies_by_level = {
            [1] = {
                unit_experience_amount = 2,
                units = {
                    { "wh_dlc07_brt_inf_foot_squires_0", 4, 100, 0, nil },
                    { "wh_dlc07_brt_inf_peasant_bowmen_2", 6, 100, 0, nil },
                    { "wh_main_brt_art_field_trebuchet", 2, 100, 0, nil }
                }
            },
            [2] = {
                unit_experience_amount = 5,
                units = {
                    { "wh_dlc07_brt_inf_foot_squires_0", 4, 100, 0, nil },
                    { "wh_dlc07_brt_cav_questing_knights_0", 4, 100, 0, nil },
                    { "wh_dlc07_brt_inf_peasant_bowmen_2", 6, 100, 0, nil },
                    { "wh_main_brt_art_field_trebuchet", 2, 100, 0, nil },
                    { "wh_dlc07_brt_art_blessed_field_trebuchet_0", 1, 100, 0, nil }
                }
            },
            [3] = {
                unit_experience_amount = 7,
                units = {
                    { "wh_dlc07_brt_cav_grail_guardians_0", 7, 100, 0, nil },
                    { "wh_dlc07_brt_cav_questing_knights_0", 7, 100, 0, nil },
                    { "wh_dlc07_brt_cav_royal_hippogryph_knights_0", 5, 100, 0, nil }
                }
            }
        }
    },
    --Wood Elves
    ["wh_dlc05_sc_wef_wood_elves"] = {
        lord = { 
            possible_subtypes = { 
                "wh_dlc05_wef_glade_lord"
            },
            level_ranges = { 5, 20 }, 
            possible_forenames = { },
            possible_clan_names = { }, 
            possible_family_names = { }
        },
        armies_by_level = {
            [1] = {
                unit_experience_amount = 2,
                units = {
                    { "wh_dlc05_wef_inf_glade_guard_0", 12, 100, 0, nil }
                }
            },
            [2] = {
                unit_experience_amount = 5,
                units = {
                    { "wh_dlc05_wef_inf_wardancers_0", 4, 100, 0, nil },
                    { "wh_dlc05_wef_mon_treekin_0", 4, 100, 0, nil },
                    { "wh_dlc05_wef_inf_deepwood_scouts_1", 8, 100, 0, nil }
                }
            },
            [3] = {
                unit_experience_amount = 7,
                units = {
                    { "wh2_dlc16_wef_inf_bladesingers_0", 6, 100, 0, nil },
                    { "wh_dlc05_wef_inf_waywatchers_0", 10, 100, 0, nil },
                    { "wh_dlc05_wef_cha_ancient_treeman_0", 3, 100, 0, nil }
                }
            }
        }
    },
    --Norsca
    ["wh_dlc08_sc_nor_norsca"] = {
        lord = { 
            possible_subtypes = { 
                "wh_main_nor_marauder_chieftain"
            },
            level_ranges = { 5, 20 }, 
            possible_forenames = { },
            possible_clan_names = { }, 
            possible_family_names = { }
        },
        armies_by_level = {
            [1] = {
                unit_experience_amount = 2,
                units = {
                    { "wh_main_nor_inf_chaos_marauders_1", 4, 100, 0, nil },
                    { "wh_dlc08_nor_inf_marauder_hunters_0", 4, 100, 0, nil },
                    { "wh_main_nor_cav_marauder_horsemen_1", 3, 100, 0, nil }
                }
            },
            [2] = {
                unit_experience_amount = 5,
                units = {
                    { "wh_dlc08_nor_inf_marauder_berserkers_0", 4, 100, 0, nil },
                    { "wh_dlc08_nor_inf_marauder_hunters_0", 4, 100, 0, nil },
                    { "wh_dlc08_nor_mon_skinwolves_0", 4, 100, 0, nil },
                    { "wh_main_nor_cav_chaos_chariot", 2, 100, 0, nil },
                    { "wh_dlc08_nor_mon_war_mammoth_1", 1, 100, 0, nil }
                }
            },
            [3] = {
                unit_experience_amount = 7,
                units = {
                    { "wh_dlc08_nor_inf_marauder_champions_1", 4, 100, 0, nil },
                    { "wh_dlc08_nor_mon_fimir_1", 4, 100, 0, nil },
                    { "wh_dlc08_nor_mon_skinwolves_0", 4, 100, 0, nil },
                    { "wh_dlc08_nor_mon_war_mammoth_2", 2, 100, 0, nil },
                    { "wh_dlc08_nor_mon_frost_wyrm_0", 1, 100, 0, nil }
                }
            }
        }
    },

    --WH2
    --Dark Elves
    ["wh2_main_sc_def_dark_elves"] = {
        lord = { 
            possible_subtypes = { 
                "wh2_main_def_dreadlord_fem"
            },
            level_ranges = { 5, 20 }, 
            possible_forenames = { },
            possible_clan_names = { }, 
            possible_family_names = { }
        },
        armies_by_level = {
            [1] = {
                unit_experience_amount = 2,
                units = {
                    { "wh2_main_def_inf_black_ark_corsairs_1", 4, 100, 0, nil },
                    { "wh2_main_def_inf_darkshards_1", 4, 100, 0, nil },
                    { "wh2_main_def_inf_shades_0", 2, 100, 0, nil },
                    { "wh2_main_def_art_reaper_bolt_thrower", 2, 100, 0, nil }
                }
            },
            [2] = {
                unit_experience_amount = 5,
                units = {
                    { "wh2_main_def_inf_black_guard_0", 3, 100, 0, nil },                         
                    { "wh2_main_def_inf_har_ganeth_executioners_0", 3, 100, 0, nil },
                    { "wh2_main_def_inf_shades_1", 6, 100, 0, nil },
                    { "wh2_main_def_art_reaper_bolt_thrower", 3, 100, 0, nil }
                }
            },
            [3] = {
                unit_experience_amount = 7,
                units = {
                    { "wh2_main_def_mon_war_hydra", 4, 100, 0, nil },
                    { "wh2_main_def_inf_black_guard_0", 4, 100, 0, nil },
                    { "wh2_main_def_inf_shades_2", 11, 100, 0, nil }
                }
            }
        }
    },
    --High Elves
    ["wh2_main_sc_hef_high_elves"] = {
        lord = { 
            possible_subtypes = { 
                "wh2_main_hef_princess"
            },
            level_ranges = { 5, 20 }, 
            possible_forenames = { },
            possible_clan_names = { }, 
            possible_family_names = { }
        },
        armies_by_level = {
            [1] = {
                unit_experience_amount = 2,
                units = {
                    { "wh2_dlc15_hef_inf_rangers_0", 4, 100, 0, nil },
                    { "wh2_main_hef_inf_archers_1", 6, 100, 0, nil },
                    { "wh2_main_hef_art_eagle_claw_bolt_thrower", 2, 100, 0, nil }
                }
            },
            [2] = {
                unit_experience_amount = 5,
                units = {
                    { "wh2_dlc15_hef_inf_silverin_guard_0", 4, 100, 0, nil },
                    { "wh2_main_hef_inf_lothern_sea_guard_1", 8, 100, 0, nil },
                    { "wh2_main_hef_mon_phoenix_flamespyre", 4, 100, 0, nil },
                    { "wh2_main_hef_art_eagle_claw_bolt_thrower", 3, 100, 0, nil }
                }
            },
            [3] = {
                unit_experience_amount = 7,
                units = {
                    { "wh2_main_hef_inf_swordmasters_of_hoeth_0", 3, 100, 0, nil },
                    { "wh2_main_hef_inf_phoenix_guard", 3, 100, 0, nil },
                    { "wh2_dlc10_hef_inf_sisters_of_avelorn_0", 10, 100, 0, nil },
                    { "wh2_main_hef_mon_star_dragon", 2, 100, 0, nil },
                    { "wh2_dlc15_hef_mon_arcane_phoenix_0", 1, 100, 0, nil }
                }
            }
        }
    },
    --Lizardmen
    ["wh2_main_sc_lzd_lizardmen"] = {
        lord = { 
            possible_subtypes = { 
                "wh2_main_lzd_saurus_old_blood"
            },
            level_ranges = { 5, 20 }, 
            possible_forenames = { },
            possible_clan_names = { }, 
            possible_family_names = { }
        },
        armies_by_level = {
            [1] = {
                unit_experience_amount = 2,
                units = {
                    { "wh2_main_lzd_inf_saurus_spearmen_1", 2, 100, 0, nil },
                    { "wh2_main_lzd_inf_temple_guards", 2, 100, 0, nil },
                    { "wh2_dlc17_lzd_inf_chameleon_stalkers_0", 8, 100, 0, nil }
                }
            },
            [2] = {
                unit_experience_amount = 5,
                units = {
                    { "wh2_main_lzd_inf_temple_guards", 5, 100, 0, nil },
                    { "wh2_main_lzd_mon_kroxigors", 3, 100, 0, nil },
                    { "wh2_dlc17_lzd_inf_chameleon_stalkers_0", 5, 100, 0, nil },
                    { "wh2_main_lzd_mon_stegadon_1", 3, 100, 0, nil }
                }
            },
            [3] = {
                unit_experience_amount = 7,
                units = {
                    { "wh2_main_lzd_mon_carnosaur_0", 4, 100, 0, nil },
                    { "wh2_dlc12_lzd_mon_ancient_stegadon_1", 4, 100, 0, nil },
                    { "wh2_dlc17_lzd_mon_troglodon_0", 2, 100, 0, nil },
                    { "wh2_main_lzd_mon_stegadon_1", 6, 100, 0, nil },
                    { "wh2_dlc17_lzd_mon_coatl_0", 2, 100, 0, nil },
                    { "wh2_dlc13_lzd_mon_dread_saurian_1", 1, 100, 0, nil }
                }
            }
        }
    },
    --Skaven
    ["wh2_main_sc_skv_skaven"] = {
        lord = { 
            possible_subtypes = { 
                "wh2_dlc12_skv_warlock_master"
            },
            level_ranges = { 5, 20 }, 
            possible_forenames = { },
            possible_clan_names = { }, 
            possible_family_names = { }
        },
        armies_by_level = {
            [1] = {
                unit_experience_amount = 2,
                units = {
                    { "wh2_dlc14_skv_inf_eshin_triads_0", 4, 100, 0, nil },
                    { "wh2_main_skv_inf_night_runners_1", 4, 100, 0, nil },
                    { "wh2_dlc12_skv_inf_ratling_gun_0", 2, 100, 0, nil },
                    { "wh2_main_skv_art_plagueclaw_catapult", 2, 100, 0, nil }
                }
            },
            [2] = {
                unit_experience_amount = 5,
                units = {
                    { "wh2_main_skv_inf_stormvermin_0", 4, 100, 0, nil },
                    { "wh2_dlc14_skv_inf_eshin_triads_0", 2, 100, 0, nil },
                    { "wh2_main_skv_inf_night_runners_1", 2, 100, 0, nil },
                    { "wh2_dlc12_skv_inf_warplock_jezzails_0", 2, 100, 0, nil },
                    { "wh2_dlc12_skv_inf_ratling_gun_0", 2, 100, 0, nil },
                    { "wh2_main_skv_art_plagueclaw_catapult", 3, 100, 0, nil }
                }
            },
            [3] = {
                unit_experience_amount = 7,
                units = {
                    { "wh2_main_skv_inf_stormvermin_1", 5, 100, 0, nil },
                    { "wh2_dlc12_skv_inf_warplock_jezzails_0", 3, 100, 0, nil },
                    { "wh2_dlc12_skv_inf_ratling_gun_0", 5, 100, 0, nil },
                    { "wh2_dlc14_skv_inf_poison_wind_mortar_0", 2, 100, 0, nil },
                    { "wh2_main_skv_art_plagueclaw_catapult", 2, 100, 0, nil },
                    { "wh2_main_skv_art_warp_lightning_cannon", 2, 100, 0, nil }
                }
            }
        }
    },
    --Tomb Kings
    ["wh2_dlc09_sc_tmb_tomb_kings"] = {
        lord = { 
            possible_subtypes = { 
                "wh2_dlc09_tmb_tomb_king"
            },
            level_ranges = { 5, 20 }, 
            possible_forenames = { },
            possible_clan_names = { }, 
            possible_family_names = { }
        },
        armies_by_level = {
            [1] = {
                unit_experience_amount = 2,
                units = {
                    { "wh2_dlc09_tmb_inf_nehekhara_warriors_0", 2, 100, 0, nil },
                    { "wh2_dlc09_tmb_mon_ushabti_0", 2, 100, 0, nil },
                    { "wh2_dlc09_tmb_inf_skeleton_archers_0", 7, 100, 0, nil },
                    { "wh2_dlc09_tmb_art_screaming_skull_catapult_0", 2, 100, 0, nil }
                }
            },
            [2] = {
                unit_experience_amount = 5,
                units = {
                    { "wh2_dlc09_tmb_inf_tomb_guard_0", 4, 100, 0, nil },
                    { "wh2_dlc09_tmb_inf_skeleton_archers_0", 4, 100, 0, nil },
                    { "wh2_dlc09_tmb_mon_ushabti_1", 4, 100, 0, nil },
                    { "wh2_dlc09_tmb_mon_tomb_scorpion_0", 2, 100, 0, nil },
                    { "wh2_dlc09_tmb_art_casket_of_souls_0", 1, 100, 0, nil }
                }
            },
            [3] = {
                unit_experience_amount = 7,
                units = {
                    { "wh2_dlc09_tmb_mon_tomb_scorpion_0", 6, 100, 0, nil },
                    { "wh2_dlc09_tmb_mon_necrosphinx_0", 4, 100, 0, nil },
                    { "wh2_dlc09_tmb_veh_khemrian_warsphinx_0", 4, 100, 0, nil },
                    { "wh2_dlc09_tmb_mon_heirotitan_0", 2, 100, 0, nil },
                    { "wh2_dlc09_tmb_mon_ushabti_1", 3, 100, 0, nil }
                }
            }
        }
    },
    --Vampire Coast
    ["wh2_dlc11_sc_cst_vampire_coast"] = {
        lord = { 
            possible_subtypes = { 
                "wh2_dlc11_cst_admiral_fem_vampires"
            },
            level_ranges = { 5, 20 }, 
            possible_forenames = { },
            possible_clan_names = { }, 
            possible_family_names = { }
        },
        armies_by_level = {
            [1] = {
                unit_experience_amount = 2,
                units = {
                    { "wh2_dlc11_cst_inf_zombie_gunnery_mob_3", 4, 100, 0, nil },
                    { "wh2_dlc11_cst_mon_bloated_corpse_0", 2, 100, 0, nil },
                    { "wh2_dlc11_cst_inf_deck_gunners_0", 2, 100, 0, nil },
                    { "wh2_dlc11_cst_art_mortar", 4, 100, 0, nil }
                }
            },
            [2] = {
                unit_experience_amount = 5,
                units = {
                    { "wh2_dlc11_cst_inf_depth_guard_1", 4, 100, 0, nil },
                    { "wh2_dlc11_cst_inf_zombie_gunnery_mob_3", 4, 100, 0, nil },
                    { "wh2_dlc11_cst_inf_deck_gunners_0", 2, 100, 0, nil },
                    { "wh2_dlc11_cst_art_carronade", 2, 100, 0, nil },
                    { "wh2_dlc11_cst_mon_rotting_leviathan_0", 2, 100, 0, nil },
                    { "wh2_dlc11_cst_mon_necrofex_colossus_0", 1, 100, 0, nil }
                }
            },
            [3] = {
                unit_experience_amount = 7,
                units = {
                    { "wh2_dlc11_cst_inf_depth_guard_1", 8, 100, 0, nil },
                    { "wh2_dlc11_cst_inf_zombie_gunnery_mob_3", 2, 100, 0, nil },
                    { "wh2_dlc11_cst_inf_deck_gunners_0", 2, 100, 0, nil },
                    { "wh2_dlc11_cst_mon_rotting_leviathan_0", 4, 100, 0, nil },
                    { "wh2_dlc11_cst_mon_necrofex_colossus_0", 3, 100, 0, nil }
                }
            }
        }
    },

    --WH3
    ["wh3_main_sc_ksl_kislev"] = {
        lord = { 
            possible_subtypes = { 
                "wh3_main_ksl_ataman"
            },
            level_ranges = { 5, 20 }, 
            possible_forenames = { },
            possible_clan_names = { }, 
            possible_family_names = { }
        },
        
        armies_by_level = {
            [1] = {
                unit_experience_amount = 2,
                units = { 
                    { "wh3_main_ksl_inf_armoured_kossars_0", 4, 100, 0, nil },
                    { "wh3_main_ksl_inf_kossars_1", 4, 100, 0, nil },
                    { "wh3_main_ksl_cav_horse_archers_0", 4, 100, 0, nil },
                }
            },
            [2] = {
                unit_experience_amount = 5,
                units = { 
                    { "wh3_main_ksl_inf_tzar_guard_0", 2, 100, 0, nil },
                    { "wh3_main_ksl_inf_armoured_kossars_0", 2, 100, 0, nil },
                    { "wh3_main_ksl_inf_kossars_1", 2, 100, 0, nil },
                    { "wh3_main_ksl_inf_ice_guard_0", 2, 100, 0, nil },
                    { "wh3_main_ksl_veh_light_war_sled_0", 3, 100, 0, nil },
                    { "wh3_main_ksl_inf_streltsi_0", 4, 100, nil }
                }
            },
            [3] = {
                unit_experience_amount = 7,
                units = {
                    { "wh3_main_ksl_inf_tzar_guard_0", 2, 100, 0, nil },
                    { "wh3_main_ksl_cav_war_bear_riders_1", 4, 100, 0, nil },
                    { "wh3_main_ksl_inf_streltsi_0", 4, 100, 0, nil },
                    { "wh3_main_ksl_inf_ice_guard_1", 7, 100, 0, nil },
                    { "wh3_main_ksl_veh_little_grom_0", 2, 100, nil }
                }
            }            
        }

    },

    ["wh3_main_sc_dae_daemons"] = {
        lord = { 
            possible_subtypes = { 
                "wh3_main_kho_herald_of_khorne",
                "wh3_main_nur_herald_of_nurgle_death",
                "wh3_main_sla_herald_of_slaanesh_slaanesh",
                "wh3_main_tze_herald_of_tzeentch_metal"
            },
            level_ranges = { 5, 20 }, 
            possible_forenames = { },
            possible_clan_names = { }, 
            possible_family_names = { }
        },
        armies_by_level = {
            [1] = {
                unit_experience_amount = 2,
                units = {
                    { "wh3_main_nur_inf_plaguebearers_0", 4, 100, 0, nil },
                    { "wh3_main_kho_inf_bloodletters_0", 4, 100, 0, nil },
                    { "wh3_main_sla_inf_daemonette_0", 4, 100, 0, nil }
                }
            },
            [2] = {
                unit_experience_amount = 5,
                units = {
                    { "wh3_main_nur_inf_plaguebearers_0", 4, 100, 0, nil },
                    { "wh3_main_kho_inf_bloodletters_0", 4, 100, 0, nil },
                    { "wh3_main_sla_inf_daemonette_0", 4, 100, 0, nil },
                    { "wh3_main_tze_inf_pink_horrors_0", 3, 100, 0, nil }
                }
            },
            [3] = {
                unit_experience_amount = 7,
                units = {
                    { "wh3_main_nur_inf_plaguebearers_1", 4, 100, 0, nil },
                    { "wh3_main_kho_inf_bloodletters_1", 4, 100, 0, nil },
                    { "wh3_main_sla_inf_daemonette_1", 4, 100, 0, nil },
                    { "wh3_main_tze_inf_pink_horrors_0", 4, 100, 0, nil },
                    { "wh3_main_kho_mon_soul_grinder_0", 1, 100, 0, nil },
                    { "wh3_main_sla_mon_soul_grinder_0", 1, 100, 0, nil },
                    { "wh3_main_tze_mon_soul_grinder_0", 1, 100, 0, nil }
                }
            }
        }
    },

    ["wh3_main_sc_cth_cathay"] = {
        lord = { 
            possible_subtypes = { 
                "wh3_main_cth_dragon_blooded_shugengan_yang",
                "wh3_main_cth_dragon_blooded_shugengan_yin"
            },
            level_ranges = { 5, 20 }, 
            possible_forenames = { },
            possible_clan_names = { }, 
            possible_family_names = { }
        },
        armies_by_level = {
            [1] = {
                unit_experience_amount = 2,
                units = {
                    { "wh3_main_cth_inf_jade_warriors_0", 4, 100, 0, nil },
                    { "wh3_main_cth_inf_iron_hail_gunners_0", 4, 100, 0, nil },
                    { "wh3_main_cth_inf_peasant_archers_0", 4, 100, 0, nil }
                }
            },
            [2] = {
                unit_experience_amount = 5,
                units = {
                    { "wh3_main_cth_inf_jade_warriors_0", 4, 100, 0, nil },
                    { "wh3_main_cth_inf_jade_warrior_crossbowmen_1", 4, 100, 0, nil },
                    { "wh3_main_cth_inf_crane_gunners_0", 2, 100, 0, nil },
                    { "wh3_main_cth_art_grand_cannon_0", 3, 100, 0, nil },
                    { "wh3_main_cth_veh_war_compass_0", 1, 100, 0, nil },
                    { "wh3_main_cth_veh_sky_junk_0", 1, 100, 0, nil }
                }
            },
            [3] = {
                unit_experience_amount = 7,
                units = {
                    { "wh3_main_cth_inf_dragon_guard_0", 5, 100, 0, nil },
                    { "wh3_main_cth_mon_terracotta_sentinel_0", 2, 100, 0, nil },
                    { "wh3_main_cth_inf_crane_gunners_0", 2, 100, 0, nil },
                    { "wh3_main_cth_inf_dragon_guard_crossbowmen_0", 5, 100, 0, nil },
                    { "wh3_main_cth_art_grand_cannon_0", 3, 100, 0, nil },
                    { "wh3_main_cth_veh_sky_junk_0", 2, 100, 0, nil }
                }
            }
        }
    },
    
    ["wh3_main_sc_ogr_ogre_kingdoms"] = {
        lord = { 
            possible_subtypes = { 
                "wh3_main_ogr_tyrant"
            },
            level_ranges = { 5, 20 }, 
            possible_forenames = { },
            possible_clan_names = { }, 
            possible_family_names = { }
        },
        armies_by_level = {
            [1] = {
                unit_experience_amount = 2,
                units = {
                    { "wh3_main_ogr_inf_ogres_1", 4, 100, 0, nil },
                    { "wh3_main_ogr_cav_mournfang_cavalry_0", 4, 100, 0, nil },
                    { "wh3_main_ogr_inf_maneaters_3", 4, 100, 0, nil }
                }
            },
            [2] = {
                unit_experience_amount = 5,
                units = {
                    { "wh3_main_ogr_inf_maneaters_2", 3, 100, 0, nil },
                    { "wh3_main_ogr_inf_maneaters_3", 3, 100, 0, nil },
                    { "wh3_main_ogr_cav_mournfang_cavalry_0", 4, 100, 0, nil },
                    { "wh3_main_ogr_inf_leadbelchers_0", 3, 100, 0, nil },
                    { "wh3_main_ogr_mon_stonehorn_0", 1, 100, 0, nil },
                    { "wh3_main_ogr_veh_gnoblar_scraplauncher_0", 1, 100, 0, nil }
                }                
            },
            [3] = {
                unit_experience_amount = 7,
                units = {
                    { "wh3_main_ogr_inf_ironguts_0", 4, 100, 0, nil },
                    { "wh3_main_ogr_inf_maneaters_3", 4, 100, 0, nil },
                    { "wh3_main_ogr_inf_leadbelchers_0", 4, 100, 0, nil },
                    { "wh3_main_ogr_mon_stonehorn_1", 4, 100, 0, nil },
                    { "wh3_main_ogr_veh_gnoblar_scraplauncher_0", 3, 100, 0, nil }
                }
            }
        }
    },
    
    ["wh3_main_sc_nur_nurgle"] = {
        lord = { 
            possible_subtypes = { 
                "wh3_main_nur_exalted_great_unclean_one_nurgle"
            },
            level_ranges = { 5, 20 }, 
            possible_forenames = { },
            possible_clan_names = { }, 
            possible_family_names = { }
        },
        armies_by_level = {
            [1] = {                
                unit_experience_amount = 2,
                units = {
                    { "wh3_main_nur_inf_nurglings_0", 4, 100, 0, nil },
                    { "wh3_main_nur_inf_plaguebearers_0", 4, 100, 0, nil },
                    { "wh3_main_nur_mon_plague_toads_0", 4, 100, 0, nil }
                }
            },
            [2] = {
                unit_experience_amount = 5,
                units = {
                    { "wh3_main_nur_inf_plaguebearers_0", 2, 100, 0, nil },
                    { "wh3_main_nur_inf_plaguebearers_1", 2, 100, 0, nil },
                    { "wh3_main_nur_inf_forsaken_0", 4, 100, 0, nil },
                    { "wh3_main_nur_mon_spawn_of_nurgle_0", 3, 100, 0, nil },
                    { "wh3_main_nur_mon_beast_of_nurgle_0", 3, 100, 0, nil },
                    { "wh3_main_nur_mon_soul_grinder_0", 1, 100, 0, nil }
                }                
            },
            [3] = {
                unit_experience_amount = 7,
                units = {
                    { "wh3_main_nur_inf_plaguebearers_1", 2, 100, 0, nil },
                    { "wh3_main_nur_cav_pox_riders_of_nurgle_0", 2, 100, 0, nil },
                    { "wh3_main_nur_cav_plague_drones_1", 2, 100, 0, nil },
                    { "wh3_main_nur_mon_great_unclean_one_0", 4, 100, 0, nil },
                    { "wh3_main_nur_mon_soul_grinder_0", 2, 100, 0, nil }                    
                }
            }
        }
    },

    ["wh3_main_sc_kho_khorne"] = {
        lord = { 
            possible_subtypes = { 
                "wh3_main_kho_exalted_bloodthirster"
            },
            level_ranges = { 5, 20 }, 
            possible_forenames = { },
            possible_clan_names = { }, 
            possible_family_names = { }
        },
        armies_by_level = {
            [1] = {
                unit_experience_amount = 2,
                units = {
                    { "wh3_main_kho_inf_bloodletters_0", 4, 100, 0, nil },
                    { "wh3_main_kho_inf_chaos_warriors_0", 4, 100, 0, nil },
                    { "wh3_main_kho_inf_chaos_warriors_1", 2, 100, 0, nil },
                    { "wh3_main_kho_inf_chaos_warriors_2", 2, 100, 0, nil }
                }
            },
            [2] = {
                unit_experience_amount = 5,
                units = {
                    { "wh3_main_kho_inf_bloodletters_0", 2, 100, 0, nil },
                    { "wh3_main_kho_inf_bloodletters_1", 4, 100, 0, nil },
                    { "wh3_main_kho_inf_flesh_hounds_of_khorne_0", 2, 100, 0, nil },
                    { "wh3_main_kho_mon_khornataurs_0", 2, 100, 0, nil },
                    { "wh3_main_kho_veh_skullcannon_0", 2, 100, 0, nil },
                    { "wh3_main_kho_cav_bloodcrushers_0", 3, 100, 0, nil },
                    { "wh3_main_kho_mon_soul_grinder_0", 1, 100, 0, nil }
                }
            },
            [3] = {
                unit_experience_amount = 7,
                units = {
                    { "wh3_main_kho_inf_bloodletters_1", 8, 100, 0, nil },
                    { "wh3_main_kho_veh_blood_shrine_0", 2, 100, 0, nil },
                    { "wh3_main_kho_veh_skullcannon_0", 2, 100, 0, nil },
                    { "wh3_main_kho_cav_skullcrushers_0", 2, 100, 0, nil },
                    { "wh3_main_kho_cav_gorebeast_chariot", 2, 100, 0, nil },
                    { "wh3_main_kho_mon_bloodthirster_0", 2, 100, 0, nil },
                    { "wh3_main_kho_mon_soul_grinder_0", 2, 100, 0, nil }
                }
            }
        }
    },

    ["wh3_main_sc_sla_slaanesh"] = {
        lord = { 
            possible_subtypes = { 
                "wh3_main_sla_exalted_keeper_of_secrets_shadow"
            },
            level_ranges = { 5, 20 }, 
            possible_forenames = { },
            possible_clan_names = { }, 
            possible_family_names = { }
        },
        armies_by_level = {
            [1] = {
                unit_experience_amount = 2,
                units = {
                    { "wh3_main_sla_inf_marauders_0", 4, 100, 0, nil },
                    { "wh3_main_sla_cav_hellstriders_0", 4, 100, 0, nil },
                    { "wh3_main_sla_inf_daemonette_0", 4, 100, 0, nil }
                }
            },
            [2] = {
                unit_experience_amount = 5,
                units = {
                    { "wh3_main_sla_inf_marauders_2", 2, 100, 0, nil },
                    { "wh3_main_sla_inf_daemonette_0", 4, 100, 0, nil },
                    { "wh3_main_sla_inf_daemonette_1", 2, 100, 0, nil },
                    { "wh3_main_sla_cav_seekers_of_slaanesh_0", 4, 100, 0, nil },
                    { "wh3_main_sla_mon_fiends_of_slaanesh_0", 3, 100, 0, nil },
                    { "wh3_main_sla_mon_soul_grinder_0", 1, 100, 0, nil }
                }
            },
            [3] = {
                unit_experience_amount = 7,
                units = {
                    { "wh3_main_sla_inf_daemonette_1", 8, 100, 0, nil },
                    { "wh3_main_sla_mon_fiends_of_slaanesh_0", 4, 100, 0, nil },
                    { "wh3_main_sla_veh_exalted_seeker_chariot_0", 4, 100, 0, nil },
                    { "wh3_main_sla_mon_soul_grinder_0", 2, 100, 0, nil },
                    { "wh3_main_sla_mon_keeper_of_secrets_0", 2, 100, 0, nil }
                }
            }
        }
    },
    
    ["wh3_main_sc_tze_tzeentch"] = {
        lord = { 
            possible_subtypes = { 
                "wh3_main_tze_exalted_lord_of_change_tzeentch"
            },
            level_ranges = { 5, 20 }, 
            possible_forenames = { },
            possible_clan_names = { }, 
            possible_family_names = { }
        },
        armies_by_level = {
            [1] = {
                unit_experience_amount = 2,
                units = {
                    { "wh3_main_tze_inf_forsaken_0", 2, 100, 0, nil },
                    { "wh3_main_tze_inf_blue_horrors_0", 6, 100, 0, nil },
                    { "wh3_main_tze_inf_pink_horrors_0", 2, 100, 0, nil },
                    { "wh3_main_tze_mon_flamers_0", 2, 100, 0, nil }
                }
            },
            [2] = {
                unit_experience_amount = 5,
                units = {
                    { "wh3_main_tze_inf_pink_horrors_0", 6, 100, 0, nil },
                    { "wh3_main_tze_mon_flamers_0", 2, 100, 0, nil },
                    { "wh3_main_tze_cav_doom_knights_0", 4, 100, 0, nil },
                    { "wh3_main_tze_cav_doom_knights_0", 3, 100, 0, nil },
                    { "wh3_main_tze_mon_soul_grinder_0", 1, 100, 0, nil }
                }
            },
            [3] = {
                unit_experience_amount = 7,
                units = {
                    { "wh3_main_tze_inf_pink_horrors_0", 8, 100, 0, nil },
                    { "wh3_main_tze_mon_flamers_0", 2, 100, 0, nil },
                    { "wh3_main_tze_veh_burning_chariot_0", 2, 100, 0, nil },
                    { "wh3_main_tze_cav_doom_knights_0", 4, 100, 0, nil },
                    { "wh3_main_tze_mon_soul_grinder_0", 2, 100, 0, nil },
                    { "wh3_main_tze_mon_lord_of_change_0", 2, 100, 0, nil }
                }
            }
        }
    }

}

return smithy_defenders