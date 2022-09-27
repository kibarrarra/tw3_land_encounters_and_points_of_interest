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
    -- Cathay
    ["land_enc_dilemma_underground_cth"] = {
        faction = "wh3_main_cth_cathay_qb1",
        identifier = "encounter_force",
        invasion_identifier = "encounter_invasion",
        lord = { 
            possible_subtypes = { 
                "wh3_main_cth_dragon_blooded_shugengan_yin",
            }, 
            level_ranges = {1, 5}, 
            possible_forenames = { },
            possible_clan_names = { }, 
            possible_family_names = { }
        },
        unit_experience_amount = 1,
        units = { -- 19 units
            -- unit{id, quantity, appeareance_chance, alternative_chance, alternative}
            { "wh3_main_cth_inf_peasant_spearmen_1", 4, 100, 0, nil }, -- 5
            { "wh3_main_cth_inf_peasant_archers_0", 4, 100, 0, nil }, -- 9
            { "wh3_main_cth_cav_peasant_horsemen_0", 2, 70, 0, nil }, -- 11
            { "wh3_main_cth_inf_iron_hail_gunners_0", 2, 50, 0, nil } -- 13
        },
        reinforcing_ally_armies = false,
        reinforcing_enemy_armies = false
    },
    
    -- Kislev
    ["land_enc_dilemma_underground_kis"] = {
        faction = "wh3_main_ksl_kislev_qb1",
        identifier = "encounter_force",
        invasion_identifier = "encounter_invasion",
        lord = { 
            possible_subtypes = { 
                "wh3_main_ksl_boyar",
            }, 
            level_ranges = {1, 5}, 
            possible_forenames = { },
            possible_clan_names = { }, 
            possible_family_names = { }
        },
        unit_experience_amount = 1,
        units = { -- 19 units
            -- unit{id, quantity, appeareance_chance, alternative_chance, alternative}
            { "wh3_main_ksl_inf_armoured_kossars_1", 4, 100, 0, nil }, -- 5
            { "wh3_main_ksl_inf_kossars_0", 4, 100, 0, nil }, -- 9
            { "wh3_main_ksl_cav_horse_archers_0", 2, 70, 0, nil }, -- 11 basic army (if lucky this will be the only army the player will need to beat for the reward
            { "wh3_main_ksl_inf_streltsi_0", 2, 50, 0, nil }
        },
        reinforcing_ally_armies = false,
        reinforcing_enemy_armies = false
    },

    -- Ogre Kingdoms
    ["land_enc_dilemma_underground_ogr"] = {
        faction = "wh3_main_ogr_ogre_kingdoms_qb1",
        identifier = "encounter_force",
        invasion_identifier = "encounter_invasion",
        lord = { 
            possible_subtypes = { 
                "wh3_main_ogr_tyrant",
                "wh3_main_ogr_slaughtermaster_beasts",
            }, 
            level_ranges = {1, 5}, 
            possible_forenames = { },
            possible_clan_names = { }, 
            possible_family_names = { }
        },
        unit_experience_amount = 1,
        units = { -- 19 units
            -- unit{id, quantity, appeareance_chance, alternative_chance, alternative}
            { "wh3_main_ogr_inf_gnoblars_0", 4, 100, 0, nil }, -- 5
            { "wh3_main_ogr_inf_ogres_0", 4, 100, 0, nil }, -- 9
            { "wh3_main_ogr_inf_maneaters_0", 2, 70, 0, nil }, -- 11 basic army (if lucky this will be the only army the player will need to beat for the reward
            { "wh3_main_ogr_mon_gorgers_0", 2, 50, 0, nil }
        },
        reinforcing_ally_armies = false,
        reinforcing_enemy_armies = false
    },
    
    -- Tzeencth
    ["land_enc_dilemma_underground_tze"] = {
        faction = "wh3_main_tze_tzeentch_qb1",
        identifier = "encounter_force",
        invasion_identifier = "encounter_invasion",
        lord = { 
            possible_subtypes = { 
                "wh3_main_tze_herald_of_tzeentch_tzeentch",
            }, 
            level_ranges = {1, 5}, 
            possible_forenames = { },
            possible_clan_names = { }, 
            possible_family_names = { }
        },
        unit_experience_amount = 1,
        units = { -- 19 units
            -- unit{id, quantity, appeareance_chance, alternative_chance, alternative}
            { "wh3_main_tze_inf_forsaken_0", 4, 100, 0, nil }, -- 5
            { "wh3_main_tze_inf_blue_horrors_0", 4, 100, 0, nil }, -- 9
            { "wh3_main_tze_mon_screamers_0", 2, 80, 0, nil }, -- 11 basic army (if lucky this will be the only army the player will need to beat for the reward
            { "wh3_main_tze_mon_flamers_0", 2, 50, 0, nil }
        },
        reinforcing_ally_armies = false,
        reinforcing_enemy_armies = false
    },
    
}