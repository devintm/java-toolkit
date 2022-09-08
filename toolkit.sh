#!/opt/homebrew/bin/bash
#!/bin/bash

DIR="${BASH_SOURCE%/*}"
if [[ ! -d "$DIR" ]]; then DIR="$PWD"; fi
. "$DIR/helpers/_config.sh"
. "$DIR/helpers/_unicode.sh"
. "$DIR/helpers/_docstrings.sh"
. "$DIR/helpers/_print.sh"
. "$DIR/helpers/_menu.sh"
. "$DIR/helpers/_git.sh"
. "$DIR/helpers/flyway.sh"
. "$DIR/helpers/maven.sh"

########################################################################################################################
# ##### PRIVATE VARIABLES #####
########################################################################################################################
# Get all the arguments passed to the script
# NOTE - disabling this inspection "Assigning an array to a string! Assign as array, or use * instead of @ to
# concatenate."
#   as it's currently working as expected.
# shellcheck disable=SC2124
_args="$@"
_script_path=$(pwd)

_mvn_cmd_exit_code=-1

# Don't set this manually. This will be set after init to a stylized output for the menu.
_db_display_name=

# ### options set from the developer ###
# Assume yes to all prompts with the default values
_selected_menu_item=


########################################################################################################################
# ##### PRIVATE FUNCTIONS #####
########################################################################################################################
# A helper to ask the user to continue
ask_to_continue_prompt() {
  printf "Press Enter to continue or CTRL+C to quit..."
  read -r
}

########################################################################################################################
# This variable will store the command value input from the user
arg_cmd_number=
check_arguments() {
  for i in $_args; do
  case $i in
    -c=*|--cmd=*)
      arg_cmd_number="${i#*=}"
      log_debug "-c / --cmd argument detected- $arg_cmd_number"
      shift # past argument=value
      ;;
    -d=*|--dbname=*)
      _arg_db_name="${i#*=}"
      shift # past argument=value
      log_debug "-d / --db argument detected- $_arg_db_name"
      ;;
    -h|--help)
      log_debug "-h / -help argument detected."
      usage; exit; ;;
    -u=*|--user=*)
      _arg_db_user="${i#*=}"
      shift # past argument=value
      log_debug "-u / --user argument detected- $_arg_db_user"
      ;;
    -v|--verbose)
      _verbose_mode=true
      shift # past argument with no value
      log_debug "-v / --verbose argument detected."
      ;;
    -*)
      log_error "Invalid option. Use '-h' for usage help."; exit 1 ;;
    *)
      ;;
  esac
  done
}

########################################################################################################################
confirm_prompt() {
  cecho red "$(_rebuild_prompt)"
  ask_to_continue_prompt
}

########################################################################################################################
activate_env_vars() {
  log_info "Activating env vars from .env file..."
  _activate_env_vars
}

_activate_env_vars() {
  log_debug "Activating env vars from .env file..."
  # NOTE - not doubling quoting this command as it works as expected to load the env vars.
  # shellcheck disable=SC2046
  export $(grep -v '^#' .env | xargs)
}

_drop_db() {
  log_info "Dropping $_arg_db_name database..."
  psql -U $_arg_db_user -d postgres -c "DROP DATABASE IF EXISTS $_arg_db_name;"
  return $?
}

_create_db() {
  log_info "Dropping $_arg_db_name database..."
  psql -U $_arg_db_user -d postgres -c "CREATE DATABASE $_arg_db_name OWNER $_arg_db_user;"
  return $?
}

_postgres_close_connections() {
  local db_name="$1"
  local drop_connections_output=
  local dropped_connection_rows=
  log_info "Trying to close active database connections/clients to database '$db_name'..."
  drop_connections_output=$(psql -U $_arg_db_user -d postgres -c "select pg_terminate_backend(pid) from pg_stat_activity where datname='$db_name';")
  local dropped_connection_cmd_status=$?
  if [ $dropped_connection_cmd_status -eq 0 ]; then {
    # We need to disable this inspection which says we should not wrap our variable in double-quotes.
    # shellcheck disable=SC2059
    dropped_connection_rows=$(printf -- "$drop_connections_output"|tail -1| head -1)
    log_info "Dropped connection rows: $dropped_connection_rows"
  } else {
    :
  } fi
  log_info "Closing postgres connections..."
  psql -U $_arg_db_user -d postgres -c "SELECT pg_terminate_backend(pid) FROM pg_stat_activity WHERE datname = '$_arg_db_name';"
  return $?
}

########################################################################################################################
rebuild_database() {
  confirm_prompt
  # Drop the database if it exists
  if ! _drop_db; then
    # Failed, try dropping db connection and attempt to DROP again
    log_debug "Failed to drop $_arg_db_name database. Closing postgres connections and trying again..."
    _postgres_close_connections '$_arg_db_name'
    if ! _drop_db; then
      log_error "Failed to drop $_arg_db_name database."; exit 1
    fi
  else
    # Create new database
    log_debug "Creating '$_arg_db_name' database with OWNER '$_arg_db_user'..."
    _create_db
  fi
}

########################################################################################################################
cd_project_path() {
    cd "$_project_path" || exit
}

########################################################################################################################
cd_script_path() {
    cd "$_script_path" || exit
}

########################################################################################################################
# Bash methods #########################################################################################################
########################################################################################################################

########################################################################################################################
print_bash_status() {
  echo -e "\n\n Bash version: "; echo -e "$(bash --version)"
  echo -e "\n\n Bash config: "; echo -e "$(bash --config)"
}

########################################################################################################################
get_main_menu_input() {
  # if argument command is empty, print menu with list of commands.
  if [[ -z $arg_cmd_number ]]; then
    print_main_menu
  else
    # cmd argument is not empty
    if ((arg_cmd_number >= 0 && arg_cmd_number <= 99)); then
      _selected_menu_item=$arg_cmd_number
    else
      print_main_menu
    fi
  fi
}

print_script_execution_status() {
  cline "dg" "="
  if (( _mvn_cmd_exit_code == -1 )); then
    log_info "Script execution is done. Good day!"
  elif (( _mvn_cmd_exit_code == 0 )); then
    log_info "mvn command(s) ran successfully! Good day!"
  else
    log_error "The script failed to finish."
  fi
  cline "dg" "="
}

########################################################################################################################
# Main method ##########################################################################################################
########################################################################################################################
main() {
  # Check all arguments are valid.
  check_arguments "$_args"

  _db_display_name=$(cecho red $_arg_db_name)
  # Print basic environment/script settings
  log_debug "Script path: $_script_path"
  log_debug "Project path: $_project_path"
  log_debug "Database name: $_db_display_name"
  log_debug "Database user: $_arg_db_user"
  log_info "Verbose logging: $_verbose_mode"

  # Check if input menu command is between 1-99
  get_main_menu_input

  # Show the main menu for the user to select an option
  main_menu

  # Print the script execution status
  print_script_execution_status
}

########################################################################################################################
# The main program execution starts here
main
