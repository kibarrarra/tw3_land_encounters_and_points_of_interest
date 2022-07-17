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
2. While the campaign is more advanced, so too the frequency of certain battles
--]]
local battles = {
    ---------------------------------------------------------------------------
    -- (Easiest) Skirmishes
    ---------------------------------------------------------------------------
    
    
    ---------------------------------------------------------------------------
    -- (Easier) Underground Rebellions
    ---------------------------------------------------------------------------
    
    
    ---------------------------------------------------------------------------
    -- (Easy) Bandits can be Empire, Wood Elves, Norscans
    ---------------------------------------------------------------------------
    {
        dilemma = "land_enc_dilemma_bandits_emp", 
        victory_incident = "land_enc_incident_battle_won_bandits", 
        avoidance_incident = "land_enc_incident_battle_avoided_bandits"
    },
    {
        dilemma = "land_enc_dilemma_bandits_wef",
        victory_incident = "land_enc_incident_battle_won_bandits", 
        avoidance_incident = "land_enc_incident_battle_avoided_bandits"
    },
    {
        dilemma = "land_enc_dilemma_bandits_nor", 
        victory_incident = "land_enc_incident_battle_won_bandits", 
        avoidance_incident = "land_enc_incident_battle_avoided_bandits"
    },

    ---------------------------------------------------------------------------    
    -- (Mid) Incursions can be High Elves, Lizardmen, Vampire Coast
    ---------------------------------------------------------------------------
    {
        dilemma = "land_enc_dilemma_incursion_army_hef",
        victory_incident = "land_enc_incident_battle_won_incursion_hef",
        avoidance_incident = "land_enc_incident_battle_avoided_incursion"
    },
    {
        dilemma = "land_enc_dilemma_incursion_army_lzd",
        victory_incident = "land_enc_incident_battle_won_incursion_lzd",
        avoidance_incident = "land_enc_incident_battle_avoided_incursion"
    },
    {
        dilemma = "land_enc_dilemma_incursion_army_vco",
        victory_incident = "land_enc_incident_battle_won_incursion_vco",
        avoidance_incident = "land_enc_incident_battle_avoided_incursion"
    },
    
    ---------------------------------------------------------------------------    
    -- (Mid) Waystone defenses can be High Elves only. Knife ears will try to defend their places of power
    -- Differences: Makes the region in which the battle was fought tempestous. Chaos corruption + 5 in the area. Gives army buff that grants magic regeneration by +30 to the beater army
    ---------------------------------------------------------------------------
    --{
    --    dilemma = "land_enc_dilemma_waystone_defense_army_hef",
    --    victory_incident = "land_enc_waystone_defense_won_incursion_hef",
    --    avoidance_incident = "land_enc_waystone_defense_avoided_incursion"
    --},
    
    ---------------------------------------------------------------------------
    -- (Mid Upper) Surprise Attacks can be Beastmen, Skaven
    ---------------------------------------------------------------------------
    {
        dilemma = "land_enc_dilemma_surprise_attack_bst",
        victory_incident = "land_enc_incident_battle_won_surprise_bst",
        avoidance_incident = "land_enc_incident_battle_avoided_surprise"
    },
    
    {
        dilemma = "land_enc_dilemma_surprise_attack_skv",
        victory_incident = "land_enc_incident_battle_won_surprise_skv",
        avoidance_incident = "land_enc_incident_battle_avoided_surprise"
    },
    
    ---------------------------------------------------------------------------
    -- (Mid Upper) Daemonic Invasion
    ---------------------------------------------------------------------------
    
    
    ---------------------------------------------------------------------------
    -- (Hard) Battlefields can be Greenskins, Dark Elves, Vampires, Tomb Kings, Warriors of Chaos, Daemons Undivided and Demons of Khorne (for the ancillaries IM ONLY), Demons of Slaneesh (for the ancillaries IM ONLY)
    ---------------------------------------------------------------------------
    {
        dilemma = "land_enc_dilemma_battlefield_grn",
        victory_incident = "land_enc_incident_battle_won_battlefield_grn",
        avoidance_incident = "land_enc_incident_battle_avoided_battlefield"
    },
    
    {
        dilemma = "land_enc_dilemma_battlefield_def",
        victory_incident = "land_enc_incident_battle_won_battlefield_def",
        avoidance_incident = "land_enc_incident_battle_avoided_battlefield"
    },
    
    {
        dilemma = "land_enc_dilemma_battlefield_vmp",
        victory_incident = "land_enc_incident_battle_won_battlefield_vmp",
        avoidance_incident = "land_enc_incident_battle_avoided_battlefield"
    },
    
    {
        dilemma = "land_enc_dilemma_battlefield_tmb",
        victory_incident = "land_enc_incident_battle_won_battlefield_tmb",
        avoidance_incident = "land_enc_incident_battle_avoided_battlefield"
    },
    
    --{
    --    dilemma = "land_enc_dilemma_battlefield_wco",
    --    victory_incident = "land_enc_incident_battle_won_battlefield_wco",
    --    avoidance_incident = "land_enc_incident_battle_avoided_battlefield"
    --},
    
    --{
    --    dilemma = "land_enc_dilemma_battlefield_doc",
    --    victory_incident = "land_enc_incident_battle_won_battlefield_doc",
    --    avoidance_incident = "land_enc_incident_battle_avoided_battlefield"
    --},
    
    --{
    --    dilemma = "land_enc_dilemma_battlefield_kho",
    --    victory_incident = "land_enc_incident_battle_won_battlefield_kho",
    --    avoidance_incident = "land_enc_incident_battle_avoided_battlefield"
    --}
    
    --{
    --    dilemma = "land_enc_dilemma_battlefield_sla",
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

return battles