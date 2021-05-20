# TRUD Import Tool

## Preparation
You will need the FULL UK Clinical Snomed release, and FULL UK Drug Snomed release, extracted to a common folder
You will also need a backup of the concept, concept_property_object and document tables from live Information Manager

## Generate patch
Run the TRUD Import application, passing the directory containing the snomed data files, and a jdbc connection string for the live IM backup
Once the application has finished, run the `import_tct.sql` script to import the generated transitive closure table

## Transfer
Create a backup of the `concept_new`, `cpo_delete`, `cpo_new` and `tct_new` tables.

## Patch
After restoring the above backup to its own `im_live_patch` schema, run the `patch_live.sql` script
