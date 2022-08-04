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
-- Surprise Attack: Killer armies
------------------------------------------------------------------------------------
return {
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
                "wh2_dlc12_skv_ikit_claw" 
            },
            level_ranges = {30, 40}, 
            possible_forenames = {},
            possible_clan_names = {}, 
            possible_family_names = {}
        },
        unit_experience_amount = 6,
        units = {
            { "wh2_main_skv_inf_stormvermin_0", 4, 100, 10, "wh2_main_skv_inf_clanrat_spearmen_1" },
            { "wh2_dlc14_skv_inf_eshin_triads_0", 6, 100, 10, "wh2_dlc12_skv_veh_doom_flayer_0" }, -- 11 basic army
            { "wh2_dlc12_skv_inf_warplock_jezzails_0", 3, 80, 50, "wh2_dlc14_skv_inf_poison_wind_mortar_0" }, -- 14 
            { "wh2_main_skv_mon_hell_pit_abomination", 2, 40, 30, "wh2_main_skv_mon_rat_ogres"}, -- 16
            { "wh2_main_skv_veh_doomwheel", 2, 30, 50, "wh2_main_skv_inf_gutter_runners_1" }, -- 18
            { "wh2_main_skv_inf_night_runners_1", 2, 20, 50, "wh2_main_skv_inf_plague_monks" } -- 20
        }
    },
    
}