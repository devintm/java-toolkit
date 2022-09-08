#!/bin/bash


########################################################################################################################
# Maven methods ########################################################################################################
########################################################################################################################

#log_level_option="-Dorg.slf4j.simpleLogger.defaultLogLevel"

# Default maven arguments
#default_mvn_args="--debug"

# mvn command -D args e.g. "mvn -DskipTests"
# mvn arg D commands
#skip_tests="-DskipTests"
#log_level_warn="-Dorg.slf4j.simpleLogger.defaultLogLevel=WARN"


# Setup mvn arguments: mvn args -D
#mvn_args="-Dorg.slf4j.simpleLogger.defaultLogLevel=WARN -DskipTests"
#mvn_sub_cmd="clean install"
#clean_install_args="--fail-fast --offline --show-version"


########################################################################################################################
## Build the project (Run migrations and compiles; this should fix issues in Intellij)
#build_maven_project() {
#  cd_project_path
#  # build the project and run the tests with "mvn clean verify"
#  # Load all env vars from env file. It ignores lines which start with '#' (comments)
#  export $(grep -v '^#' .env | xargs) && mvn clean install -DskipTests && _program_success=true
#  cd_script_path
#}

########################################################################################################################
## Utility to run any maven command (e.g. clean, install, etc.) with arguments 2 or 3 arguments
##  e.g. $ _run "-DskipTests" "clean install"
##   Argument 1: mvn args e.g. -DskipTests
##   Argument 2: mvn sub command e.g. clean install
##   Argument 3: mvn args e.g. --fail-fast --offline --show-version
_mvn() {
  log_debug "Running maven command..."
  log_debug "$(cprint gr "    $ " && cecho cyan "mvn $1 $2 $3")"
  cline "or" "-"
  # Go to project directory, activate the .env file, and run the maven command
  #  NOTE - disabling the double quote around the mvn command args because it causes the command to fail.
  #  shellcheck disable=SC2068
  cd_project_path && _activate_env_vars && cline "or" "-" && eval "mvn $1 $2 $3"
  _mvn_cmd_exit_code=$?
  # change back to script path
  cd_script_path
}

_mvn_quiet() {
  cd_project_path && _activate_env_vars && eval "mvn $1 $2 $3" && _mvn_cmd_exit_code=$? && cd_script_path
}

_mvn_print_help() {
  # print the manual/help menu for a mvn command
  log_info "Printing help for maven command... (Because --help is not supported by mvn plugins/goals)"
  cprint gr "Enter the maven command you want help with e.g. $ mvn " && cecho cyan "dependency:resolve"
  cprint gr "  $ mvn "
  local mvn_cmd=
  # set input colour to cyan and read input for the mvn command/goal, and clear the input colour
  echo -en '\033[38;5;45m' && read -r mvn_cmd && echo -en '\033[0m'

  local cmd1_result=
  local cmd2_result=
  cline "or" "-"
  _mvn "--quiet" "help:describe" "-Ddetail -Dcmd=$mvn_cmd"; cmd1_result=$_mvn_cmd_exit_code
  _mvn "--quiet" "$mvn_cmd:help"; cmd2_result=$_mvn_cmd_exit_code
  cline "or" "-"

  # Run the working commands
  if [ $cmd1_result -eq 0 ]; then
    _mvn "--errors" "help:describe" "-Ddetail -Dcmd=$mvn_cmd"
  fi
  cline "or" "-"
  if [ $cmd2_result -eq 0 ]; then
    _mvn "--errors" "$mvn_cmd:help"
  fi
  cline "or" "-"

  if [ $cmd1_result -eq 0 ]; then
#    echo -e $mvn_help_describe_cmd
    cprint b2 "  Maven help:describe command:  "; cecho g2 "$ mvn help:describe -Ddetail -Dcmd=$mvn_cmd"
  fi
  if [ $cmd2_result -eq 0 ]; then
    cprint b1 "  Maven command help:           "; cecho g  "$ mvn $mvn_cmd:help"
    cprint b2 "  Maven command help (verbose): "; cecho g2 "$ mvn $mvn_cmd:help -Ddetail"
  fi
  cline "or" "-"

#  RESULT=$?
#  if [ $RESULT -eq 0 ]; then
#    echo -e $mvn_help_describe_cmd
#  else
#    echo failed
#  fi


#  cline "or" "-" gray "="
#  _mvn "--errors" "$mvn_cmd:help"
#  cline "or" "-" gray "="

  # give commands to user for reference
#  log_debug "mvn help:describe -Ddetail -Dcmd=$mvn_cmd"
#  log_debug "mvn $mvn_plugin:help -Ddetail"
#  log_debug "mvn $mvn_plugin:help -Ddetail -Dgoal=$mvn_plugin_goal"

#  log_debug "Print commands which can help print the mvn command, plugin or goals info..."
#  if [[ $mvn_cmd == *":"* ]]; then
#    mvn_plugin=${mvn_cmd%:*}
#    mvn_plugin_goal=${mvn_cmd#*:}
#    log_debug "Print commands which can help print the mvn command, plugin or goals info..."
#    cecho b2 "$ mvn $mvn_plugin:help -Ddetail"
#    cecho b2 "$ mvn $mvn_plugin:help -Ddetail -Dgoal=$mvn_plugin_goal"
#  else
#    log_debug "mvn $mvn_cmd:help"
#    log_debug "mvn help:describe -Ddetail -Dcmd=$mvn_cmd"
#  fi
#  cecho red $mvn_cmd
#  cecho red $mvn_plugin
#  cecho red $mvn_plugin_goal
  # print the help for the mvn command
#  _mvn "--debug" "$mvn_plugin:help" "-Ddetail -Dgoal=$mvn_plugin_goal"
  #  mvn_help_cmd="_mvn $mvn_plugin:help -Ddetail -Dgoal=$mvn_plugin_goal"
  #  cecho cyan $mvn_help_cmd
  #  eval "$mvn_help_cmd"

  # print the help for the mvn command
  #  read -r mvn_cmd
  #  cecho cyan $mvn_cmd
  #  cecho cyan "$mvn_cmd"
  #  read -r $mvn_cmd </dev/tty

  #  PROMPT="Enter the maven command you want help with e.g. $ mvn "
  #  read -p PROMPT mvn_cmd

  #  echo "$_mvn_cmd"
  #  echo "$_mvn_cmd"
}
