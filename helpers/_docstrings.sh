#!/bin/bash

########################################################################################################################
# Print the help menu on -h or --help option
usage() {
#  cline
  cat << EOF

Usage:
  $0 [-c, --cmd=<COMMAND_NUMBER>] [-d, --dbname=<DB_NAME>]
     [-u, --user=<DB_USER>] [-v, --verbose] [-h, --help]

  Options:
    -c | --cmd <cmd_number> : The command number from the main menu to execute.
    -d | --dbname <db name> : The postgres database used for the script.
    -u | --user <db_user>   : Optionally specify the postgres superuser for
                               the CREATE and DROP commands. (default: postgres)
    -v | --verbose          : Put program in verbose logging mode.
    -h, --help              : Show this help menu.

EOF
}

########################################################################################################################
docstring() { cat << EOF

  ############################################################
  # Java Spring Boot Toolkit                                 #
  ############################################################
  ############################################################
  # This script is more of a multi-tool to help build the    #
  # project, debug and many other useful commands for mvn,   #
  # flyway, bash, etc.                                       #
  #                                                          #
  ############################################################

EOF
}

########################################################################################################################
_rebuild_prompt() { cat << EOF
  ############################################################
  #                                                          #
  # WARNING - only continue if you know what you are doing!  #
  # This command will DROP i.e. delete the database set in   #
  # the configuration. Backup your data first!!              #
  ############################################################

EOF
}
