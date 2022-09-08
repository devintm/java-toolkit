#!/bin/bash

########################################################################################################################
# Flyway global variables ##############################################################################################
########################################################################################################################

readonly PENDING="Pending"
readonly PENDING_ACTION=$PENDING"_action"
readonly PENDING_ICON=$PENDING"_icon"

readonly IGNORED="Ignored"
readonly IGNORED_ACTION="_action"
readonly IGNORED_ICON="_icon"

readonly OUT_OF_ORDER="Out of Order"
readonly OUT_OF_ORDER_ACTION=$OUT_OF_ORDER"_action"
readonly OUT_OF_ORDER_ICON=$OUT_OF_ORDER"_icon"

readonly MISSING="Missing"
readonly MISSING_ACTION=$MISSING"_action"
readonly MISSING_ICON=$MISSING"_icon"

readonly FAILED="Failed"
readonly FAILED_ACTION=$FAILED"_action"
readonly FAILED_ICON=$FAILED"_icon"

readonly FUTURE="Future"
readonly FUTURE_ACTION=$FUTURE"_action"
readonly FUTURE_ICON=$FUTURE"_icon"

readonly BAD_MIGRATIONS_NO="$icheck No"
readonly BAD_MIGRATIONS_YES="$iwarn  Yes"
readonly BAD_MIGRATIONS_UNKNOWN="$iquestion_red Unknown"

declare -A db_status=(
  # status - set default to unknown
  [$PENDING]="$BAD_MIGRATIONS_UNKNOWN"
  [$IGNORED]="$BAD_MIGRATIONS_UNKNOWN"
  [$OUT_OF_ORDER]="$BAD_MIGRATIONS_UNKNOWN"
  [$MISSING]="$BAD_MIGRATIONS_UNKNOWN"
  [$FAILED]="$BAD_MIGRATIONS_UNKNOWN"
  [$FUTURE]="$BAD_MIGRATIONS_UNKNOWN"
  # icons
  [$PENDING_ICON]="$iquestion_white"
  [$IGNORED_ICON]="$iquestion_red"
  [$OUT_OF_ORDER_ICON]="$iwarn"
  [$MISSING_ICON]="$imissing"
  [$FAILED_ICON]="$ix_red"
  [$FUTURE_ICON]="$icalendar"
  # migration status - default to empty status
  [$PENDING_ACTION]="-"
  [$IGNORED_ACTION]="-"
  [$OUT_OF_ORDER_ACTION]="-"
  [$MISSING_ACTION]="-"
  [$FAILED_ACTION]="-"
  [$FUTURE_ACTION]="-"
)

########################################################################################################################
# Flyway methods #######################################################################################################
########################################################################################################################

########################################################################################################################
flyway_migrate() {
  cprint gr "Running 'mvn flyway:migrate' for database: "; cecho red "$1"
  _mvn "-V" "flyway:migrate" "-Dflyway.url=jdbc:postgresql://localhost:5432/$1 -Dflyway.outOfOrder=true"
}

########################################################################################################################
flyway_check_migration_by_status() {
  local flyway_status=$1
  local migration_status_output
  migration_status_output=$(_mvn "-V" "flyway:info" "-Dflyway.url=jdbc:postgresql://localhost:5432/'$_arg_db_name' -Dflyway.outOfOrder=true" | grep -E "$flyway_status")
  # echo $migration_status_output
  if [ -z "${migration_status_output-x}" ]; then
    db_status[$flyway_status]=$BAD_MIGRATIONS_NO
  else
    db_status[$flyway_status]=$BAD_MIGRATIONS_YES
    db_status["$flyway_status"_action]="(See below)"
    db_status["$flyway_status"_output]="$migration_status_output"
    # set migration status only if the migration status are present.
    set_migration_status_details "$flyway_status"
  fi
}

########################################################################################################################
set_migration_status_details() {
  local status=$1
  # No migrations found with this status code
  if [ "$status" == "$PENDING" ]; then
    db_status[$PENDING"_error"]="\n\tMigrations are pending and need to be applied.\n"
  elif [ "$status" == "$IGNORED" ]; then
    db_status[$IGNORED"_error"]="\n\tSome migration(s) are Ignored! Is the flyway 'outOfOrder' \n\t option set to true? \n"
  elif [ "$status" == "$OUT_OF_ORDER" ]; then
    db_status[$OUT_OF_ORDER"_error"]="\n\tOut of Order migrations happen when migrations where applied\n\t in a different order than the production schema. This happens \n\t when you develop and apply a migration in a local branch.\n\n\t (These are expected but can cause problems with database column order.)\n"
  elif [ "$status" == "$MISSING" ]; then
    db_status[$MISSING"_error"]="\n\tThe migration file is missing. It was applied but the \n\t file no longer exist on the system. Was it deleted or renamed? \n\t The migration will need to be removed from the migration history.\n"
  elif [ "$status" == "$FAILED" ]; then
    db_status[$FAILED"_error"]="\n\tThe migration failed and must be fixed.\n"
  elif [ "$status" == "$FUTURE" ]; then
    db_status[$FUTURE"_error"]="\n\tFlyway migrations applied from the future (e.g. migrations from \n\t master not yet in staging branch) This happens when you switch \n\t branches and have migrations applied from the old branch.\n"
  fi
}

########################################################################################################################
_print_migration_header() {
  ctitle p "=" "Flyway Status"
  cecho p2 "$(_table_col3_print_row_sm "Migration Status" "Status Present" "Action")"
  cline p "="
}

########################################################################################################################
_print_migration_row() {
  local status=$1
  local error_color="$2"
  _table_col3_print_row_sm "${db_status[$status"_icon"]} $status" "${db_status[$status]}" "${db_status[$status"_action"]}"
  cecho "$error_color" "${db_status[$status"_error"]}"
  cline p2 "-"
}

########################################################################################################################
print_flyway_status_table() {
  # Print table header
  _print_migration_header
  # Print table rows
  _print_migration_row $PENDING green
  _print_migration_row $IGNORED yellow
  _print_migration_row "$OUT_OF_ORDER" yellow
  _print_migration_row $MISSING red
  _print_migration_row $FAILED red
  _print_migration_row $FUTURE yellow
}

########################################################################################################################
flyway_check_all_migration_states() {
  # TODO - refactor to store flyway info output and grep through n times instead of running the command n times...
  flyway_check_migration_by_status "$OUT_OF_ORDER" && log_debug "Getting migration status for $OUT_OF_ORDER." && printf "." 
  flyway_check_migration_by_status "$IGNORED" && log_debug "Getting migration status for $IGNORED." && printf "."
  flyway_check_migration_by_status "$MISSING" && log_debug "Getting migration status for $MISSING." && printf "."
  flyway_check_migration_by_status "$FUTURE" && log_debug "Getting migration status for $FUTURE." && printf "."
  flyway_check_migration_by_status "$FAILED" && log_debug "Getting migration status for $FAILED." && printf "."
  flyway_check_migration_by_status "$PENDING" && log_debug "Getting migration status for $PENDING." && echo "."
  print_flyway_status_table
}

########################################################################################################################
rollback_migrations() {
  flyway_check_all_migration_states
  cecho dg "Bad migrations rows:"
  cecho red "${db_status[$MISSING"_output"]}"
  cecho red "${db_status[$FUTURE"_output"]}"
  cecho red "${db_status[$FAILED"_output"]}"

  cecho dg "Bad migrations names - select the earliest (lowest) number to rollback to."
  cecho cyan "$(echo "${db_status[$MISSING"_output"]}" | head -n 1 | cut -d "|" -f3 | xargs)"
  cecho cyan "$(echo "${db_status[$FUTURE"_output"]}"  | head -n 1 | cut -d "|" -f3 | xargs)"
  cecho cyan "$(echo "${db_status[$FAILED"_output"]}"  | head -n 1 | cut -d "|" -f3 | xargs)"

  cprint dg "Enter the migration name to rollback: "
  local migration_name
  # Get migration name in cyan colour - the same colour as the migration names above.
  echo -en '\033[38;5;45m' && read -r migration_name && echo -en '\033[0m'
  if [ -z "$migration_name" ]; then
    cecho red "No migration name entered. Exiting."
    exit 1
  fi

  # Get the installed rank from flyway_schema_history table
  local sql_select_statement="select installed_rank from flyway_schema_history where script like '%$migration_name%';"
  log_debug "SQL SELECT statement:  $sql_select_statement"

  # Get the flyway installed rank for the oldest invalid migration from the '$_arg_db_name' database
  local installed_rank=
  installed_rank=$(psql -U postgres -d $_arg_db_name -c "${sql_select_statement}" | tail -n 3 | head -n 1 | xargs)
  log_debug "Last bad migration installed rank:  $installed_rank"

  # Log a warning and wait for user input to continue
  log_warn "Do you want to remove the bad migrations from the migration history?"
  log_warn "** WARNING!!! This has side effects! Don't do this unless you know what you are doing! **"
  ask_to_continue_prompt

  # Print the records which will be removed
  local sql_select_from_where_fragment="FROM public.flyway_schema_history WHERE installed_rank >= $installed_rank;"
  local sql_select_from_where_statement="SELECT installed_rank, script ${sql_select_from_where_fragment}"

  log_debug "SQL SELECT WHERE statement:  $sql_select_statement"
  log_info "Database:  $_arg_db_name"
  log_info "These are the migrations which will be removed from flyway_schema_history table:"
  psql -U postgres -d "$_arg_db_name" -c "$sql_select_from_where_statement"

  # Confirm with the user that the records will be deleted
  local sql_delete_statement="DELETE ${sql_select_from_where_fragment}"
  log_info "SQL DELETE statement:  $sql_delete_statement"
  cecho red "Are you sure you want to execute the above query and remove the records?"
  ask_to_continue_prompt

  # Delete the records
  psql -U postgres -d "$_arg_db_name" -c "$sql_delete_statement"

  local previous_migration=$((installed_rank-1))
  log_info "Migration history is rolled back to installed rank: ${previous_migration}"
}