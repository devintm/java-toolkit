#!/bin/bash

########################################################################################################################
# ##### DEVELOPER CONFIGURATION #####
########################################################################################################################

# ---- Path to the maven java project ----
_project_path="/Users/dev/repos/java-backend"

# ---- Default postgres database User for flyway ----
# NOTE - the command line argument -d / --dbname will take precedent.
_arg_db_user=postgres

# ---- Default postgres database name for flyway ----
# NOTE - the command line argument -u / --user will take precedent.
_arg_db_name=backend

# ---- Verbose mode logging to stdout console ----
# NOTE - the command line argument -v / --verbose will take precedent.
_verbose_mode=false
