--[[
The types of battles one can encounter with this mod. There will always be a variation given an extra _modifier in the name. The Bandits, Incursions, Surprise attacks are common armies. If I can the battlefields will be a multi army battle.

Every dilemma needs:
=============================
DILEMMA
=============================
Use this if you want the player to have more agency in their decision making.

== DB
1. cdir_events_dilemma_choice_details_tables (Binds the choices of a dilemma to such dilemma. Without this table you cannot declare the .loc and describe the dilemmas that appear on screen).
2. cdir_events_dilemma_option_junctions_tables (Chance to trigger, conditions, follow up and target)
3. cdir_events_dilemma_payloads_tables (The X choice keys and their effects)
4. dilemmas_tables (Declare the dilemma here)

== LOC
1. cdir_events_dilemma_choice_details.loc (Describe the text that the options will hold)
- Format
cdir_events_dilemma_choice_details_localised_choice_label_ (fixed) + land_enc_dilemma_bandits_emp (dilemma id) + FIRST/SECOND/THIRD (number of choice)

2. dilemmas.loc
Here goes the description and title of the declared dilemma. In combination with the details, this declares all the strings in a dilemmma.
dilemmas_localised_description_ + <dilemman_key: land_enc_dilemma_bandits_emp>
dilemmas_localised_title_ + <land_enc_dilemma_bandits_emp>

TODO: 
1. Variations of this events, more varied armies
--]]
local battle_events = {
    ---------------------------------------------------------------------------
    -- (Easiest) Skirmishes
    ---------------------------------------------------------------------------
    { 
        dilemma = "land_enc_dilemma_skirmish_cth", 
        victory_incident = "land_enc_incident_battle_won_skirmish", 
        avoidance_incident = "land_enc_incident_battle_avoided_skirmish",
        difficulty_level = 1,
        is_exclusive_to_zone = true,
        zone = "cathay"
    },
    
    { 
        dilemma = "land_enc_dilemma_skirmish_kis", 
        victory_incident = "land_enc_incident_battle_won_skirmish", 
        avoidance_incident = "land_enc_incident_battle_avoided_skirmish",
        difficulty_level = 1,
        is_exclusive_to_zone = true,
        zone = "kislev"
    },
    
    { 
        dilemma = "land_enc_dilemma_skirmish_ogr", 
        victory_incident = "land_enc_incident_battle_won_skirmish", 
        avoidance_incident = "land_enc_incident_battle_avoided_skirmish",
        difficulty_level = 1,
        is_exclusive_to_zone = true,
        zone = "mountainsofmourn"
    },
    
    { 
        dilemma = "land_enc_dilemma_skirmish_nur", 
        victory_incident = "land_enc_incident_battle_won_skirmish", 
        avoidance_incident = "land_enc_incident_battle_avoided_skirmish",
        difficulty_level = 1,
        is_exclusive_to_zone = true,
        zone = "chaoswastes"
    },
    
    { 
        dilemma = "land_enc_dilemma_skirmish_tze", 
        victory_incident = "land_enc_incident_battle_won_skirmish", 
        avoidance_incident = "land_enc_incident_battle_avoided_skirmish",
        difficulty_level = 1,
        is_exclusive_to_zone = true,
        zone = "chaoswastes"

    },
    
    ---------------------------------------------------------------------------
    -- (Easier) Underground Rebellions
    ---------------------------------------------------------------------------
    { 
        dilemma = "land_enc_dilemma_underground_cth", 
        victory_incident = "land_enc_incident_battle_won_underground", 
        avoidance_incident = "land_enc_incident_battle_avoided_underground",
        difficulty_level = 1,
        is_exclusive_to_zone = true,
        zone = "cathay"
    },
    
    { 
        dilemma = "land_enc_dilemma_underground_kis", 
        victory_incident = "land_enc_incident_battle_won_underground", 
        avoidance_incident = "land_enc_incident_battle_avoided_underground",
        difficulty_level = 1,
        is_exclusive_to_zone = true,
        zone = "kislev"
    },
    
    { 
        dilemma = "land_enc_dilemma_underground_ogr",
        victory_incident = "land_enc_incident_battle_won_underground", 
        avoidance_incident = "land_enc_incident_battle_avoided_underground",
        difficulty_level = 1,
        is_exclusive_to_zone = true,
        zone = "mountainsofmourn"
    },
        
    { 
        dilemma = "land_enc_dilemma_underground_tze",
        victory_incident = "land_enc_incident_battle_won_underground", 
        avoidance_incident = "land_enc_incident_battle_avoided_underground",
        difficulty_level = 1,
        is_exclusive_to_zone = true,
        zone = "chaoswastes"
    },
    
    ---------------------------------------------------------------------------
    -- (Easy) Bandits can be Empire, Wood Elves, Norscans
    ---------------------------------------------------------------------------
    {
        dilemma = "land_enc_dilemma_bandits_emp", 
        victory_incident = "land_enc_incident_battle_won_bandits", 
        avoidance_incident = "land_enc_incident_battle_avoided_bandits",
        difficulty_level = 1,
        is_exclusive_to_zone = false,
        zone = "_"
    },
    
    {
        dilemma = "land_enc_dilemma_bandits_wef",
        victory_incident = "land_enc_incident_battle_won_bandits", 
        avoidance_incident = "land_enc_incident_battle_avoided_bandits",
        difficulty_level = 1,
        is_exclusive_to_zone = false,
        zone = "_"
    },
    
    {
        dilemma = "land_enc_dilemma_bandits_nor", 
        victory_incident = "land_enc_incident_battle_won_bandits", 
        avoidance_incident = "land_enc_incident_battle_avoided_bandits",
        difficulty_level = 1,
        is_exclusive_to_zone = false,
        zone = "_"
    },

    ---------------------------------------------------------------------------    
    -- (Mid) Incursions can be High Elves, Lizardmen, Vampire Coast
    ---------------------------------------------------------------------------
    {
        dilemma = "land_enc_dilemma_incursion_army_hef",
        victory_incident = "land_enc_incident_battle_won_incursion_hef",
        avoidance_incident = "land_enc_incident_battle_avoided_incursion",
        difficulty_level = 2,
        is_exclusive_to_zone = false,
        zone = "_"
    },
    
    {
        dilemma = "land_enc_dilemma_incursion_army_lzd",
        victory_incident = "land_enc_incident_battle_won_incursion_lzd",
        avoidance_incident = "land_enc_incident_battle_avoided_incursion",
        difficulty_level = 2,
        is_exclusive_to_zone = false,
        zone = "_"
    },
    
    {
        dilemma = "land_enc_dilemma_incursion_army_vco",
        victory_incident = "land_enc_incident_battle_won_incursion_vco",
        avoidance_incident = "land_enc_incident_battle_avoided_incursion",
        difficulty_level = 2,
        is_exclusive_to_zone = false,
        zone = "_"
    },
    
    ---------------------------------------------------------------------------    
    -- (Mid) Waystone defenses can be High Elves only. Knife ears will try to defend their places of power
    -- Differences: Makes the region in which the battle was fought tempestous. Chaos corruption + 5 in the area. Gives army buff that grants magic regeneration by +30 to the beater army
    ---------------------------------------------------------------------------
    --{
    --    difficulty_level = 2,
    --    dilemma = "land_enc_dilemma_waystone_defense_army_hef",
    --    is_exclusive_to_zone = false,
    --    victory_incident = "land_enc_waystone_defense_won_incursion_hef",
    --    avoidance_incident = "land_enc_waystone_defense_avoided_incursion"
    --},
    
    ---------------------------------------------------------------------------
    -- (Mid Upper) Surprise Attacks can be Beastmen, Skaven
    ---------------------------------------------------------------------------
    {
        dilemma = "land_enc_dilemma_surprise_attack_bst",
        victory_incident = "land_enc_incident_battle_won_surprise_bst",
        avoidance_incident = "land_enc_incident_battle_avoided_surprise",
        difficulty_level = 2,
        is_exclusive_to_zone = false,
        zone = "_"
    },
    
    {
        dilemma = "land_enc_dilemma_surprise_attack_skv",
        victory_incident = "land_enc_incident_battle_won_surprise_skv",
        avoidance_incident = "land_enc_incident_battle_avoided_surprise",
        difficulty_level = 2,
        is_exclusive_to_zone = false,
        zone = "_"
    },
    
    ---------------------------------------------------------------------------
    -- (Mid Upper) Daemonic Invasion
    ---------------------------------------------------------------------------
    --{
    --    difficulty_level = 2,
    --    dilemma = "land_enc_dilemma_surprise_attack_skv",
    --    is_exclusive_to_zone = false,
    --    victory_incident = "land_enc_incident_battle_won_surprise_skv",
    --    losing_incident = "",
    --    avoidance_incident = "land_enc_incident_battle_avoided_surprise"
    --},
    
    ---------------------------------------------------------------------------
    -- (Hard) Battlefields can be Greenskins, Dark Elves, Vampires, Tomb Kings, Warriors of Chaos, Daemons Undivided and Demons of Khorne (for the ancillaries IM ONLY), Demons of Slaneesh (for the ancillaries IM ONLY)
    ---------------------------------------------------------------------------
    {
        dilemma = "land_enc_dilemma_battlefield_grn",
        victory_incident = "land_enc_incident_battle_won_battlefield_grn",
        avoidance_incident = "land_enc_incident_battle_avoided_battlefield",
        difficulty_level = 3,
        is_exclusive_to_zone = false,
        zone = "_"
    },
    
    {
        dilemma = "land_enc_dilemma_battlefield_def",
        victory_incident = "land_enc_incident_battle_won_battlefield_def",
        avoidance_incident = "land_enc_incident_battle_avoided_battlefield",
        difficulty_level = 3,
        is_exclusive_to_zone = false,
        zone = "_"
    },
    
    {
        dilemma = "land_enc_dilemma_battlefield_vmp",
        victory_incident = "land_enc_incident_battle_won_battlefield_vmp",
        avoidance_incident = "land_enc_incident_battle_avoided_battlefield",
        difficulty_level = 3,
        is_exclusive_to_zone = false,
        zone = "_"
    },
    
    {
        dilemma = "land_enc_dilemma_battlefield_tmb",
        victory_incident = "land_enc_incident_battle_won_battlefield_tmb",
        avoidance_incident = "land_enc_incident_battle_avoided_battlefield",
        difficulty_level = 3,
        is_exclusive_to_zone = false,
        zone = "_"
    },
    
    --{ --TODO
    --    difficulty_level = 3,
    --    dilemma = "land_enc_dilemma_battlefield_wco",
    --    is_exclusive_to_zone = false,
    --    zone = false,
    --    victory_incident = "land_enc_incident_battle_won_battlefield_wco",
    --    avoidance_incident = "land_enc_incident_battle_avoided_battlefield"
    --},
    
    --{ --TODO
    --    difficulty_level = 3,
    --    dilemma = "land_enc_dilemma_battlefield_doc",
    --    is_exclusive_to_zone = false,
    --    zone = false,
    --    victory_incident = "land_enc_incident_battle_won_battlefield_doc",
    --    avoidance_incident = "land_enc_incident_battle_avoided_battlefield"
    --},
    
    --{ --TODO
    --    difficulty_level = 3,
    --    dilemma = "land_enc_dilemma_battlefield_kho",
    --    is_exclusive_to_zone = false,
    --    zone = false,
    --    victory_incident = "land_enc_incident_battle_won_battlefield_kho",
    --    avoidance_incident = "land_enc_incident_battle_avoided_battlefield"
    --},
    
    --{ --TODO
    --    difficulty_level = 3,
    --    dilemma = "land_enc_dilemma_battlefield_sla",
    --    is_exclusive_to_zone = false,
    --    zone = false,
    --    victory_incident = "land_enc_incident_battle_won_battlefield_sla",
    --    avoidance_incident = "land_enc_incident_battle_avoided_battlefield"
    --}
    
    ---------------------------------------------------------------------------
    -- (Harder) Three way battlefields
    ---------------------------------------------------------------------------
    
    
    ---------------------------------------------------------------------------
    -- (Hardest) Last stand: Give a trait: The ultimate fighter
    ---------------------------------------------------------------------------
    
}

return battle_events