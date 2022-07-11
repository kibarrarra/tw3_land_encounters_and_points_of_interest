--[[
The types of treasures one can encounter with this mod. There are no variations.
Using incidents because no decision is needed to trigger a battle.

Every incident needs data in:
=============================
INCIDENT
=============================
=== DB
[Describes the incident data]
1. cdir_events_incident_option_junctions_tables (Objective + chance)
2. cdir_events_incident_payloads_tables (Rewards)
3. incidents_tables (Declaration of incidents)

=== LOC 
1.incidents
(join together then incidents_ key + required info + event_key (ex: land_enc_incident_tomb_robbing)
incidents_ localised_title_
           localised_description_

=============================
INCIDENT EFFECT (IF IT GIVES AN EFFECT NOT TREASURES OR ANCILLARIES)
=============================
=== DB
[If you want custom effects you need the following tables]
1. effect_bundles_tables (_NONE = automatically to all your faction / _)
2. effect_bundles_to_effects_junctions_tables

=== LOC 
1. effect_bundles
(join together then incidents_ key + required info + effect_key (ex: land_enc_incident_tomb_robbing)
effect_bundles_ localised_title_
                localised_description_
--]]
local treasures = {
    "land_enc_incident_tomb_robbing",
    "land_enc_incident_abandoned_camp",
    "land_enc_incident_buried_relics",
    "land_enc_incident_hidden_temple",
    "land_enc_incident_caravan_remnants",
    "land_enc_incident_legendary_bard",
    "land_enc_incident_whispers_of_the_gods",
}

return treasures