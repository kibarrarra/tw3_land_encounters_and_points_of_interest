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
-- Bandits: The weakest forces, withouth heroes and low chances on dangerous units
------------------------------------------------------------------------------------
return {

    -- Empire
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
    
    -- Wood Elves
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
    
    -- Norsca
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
    
}