#!/bin/bash

########################################################################################################################
print_main_menu() {
  local _db_display_name
  _db_display_name=$(cecho red $_arg_db_name)
  ctitle gr "=" "Java Spring Boot Toolkit"
  cecho cyan "\t database name: $_db_display_name"
  cecho cyan "\t database user: $_arg_db_user"
  cline gr "="
  # --------------------------------- Project Tools -------------------------------
  ctitle g "-" "Project Tools"
  cecho g2  "$ibox 1) $icheck Validate flyway."
  cecho g   "$ibox 2) ${_icons[refresh2]} Update maven project dependencies."
  cecho g2  "$ibox 3) ${_icons[tool_hammer]} Rebuild spring boot project!"
  cecho g   "$ibox 4) ${_icons[tool_testtube]} Run tests!"
  cecho g2  "$ibox 5) ${_icons[directory_dividers]}  Print git status"
  cecho g  "$ibox 6) $irun  Run spring boot!"
  # ----------------------------------- mvn help ----------------------------------
  ctitle r "-" "mvn help"
  cecho r2  "$ibox 7) ${_icons[books]} mvn CMD help"
  cecho red "$ibox 8) ${_icons[book_green]} mvn PLUGIN help or mvn PLUGIN:GOAL help"
  # ------------------------------- mvn clean install -----------------------------
  ctitle or2 "-" "mvn clean:install"
  cecho or  "$ibox 10) ${_icons[tool_hammer]} mvn clean install [log level: ERROR ${_icons[notification_off]}] [run tests: $ix_red]"
  cecho or2 "$ibox 11) ${_icons[tool_hammer]} mvn clean install [log level: DEBUG ${_icons[bug]} ] [run tests: $ix_red] $istar"
  cecho or  "$ibox 12) ${_icons[tools]}  mvn clean install [log level: DEBUG ${_icons[bug]} ] [run tests: $icheck]"
  # --------------------------------- flyway:info ----------------------------------
  ctitle co "-" "mvn flyway:info"
  cecho co2 "$ibox 20) $ibox_i  flyway info"
  cecho co  "$ibox 21) $ibox_ok flyway info (Check all status types) $istar"
  cecho co2 "$ibox 22) $iwarn  flyway info ('$OUT_OF_ORDER' migrations)"
  cecho co  "$ibox 23) $imissing flyway info ('$MISSING' migrations)"
  cecho co2 "$ibox 24) $iquestion_white flyway info ('$PENDING' migrations)"
  cecho co  "$ibox 25) $ix_red flyway info ('$FAILED' migrations)"
  cecho co2 "$ibox 26) $icalendar flyway info ('$FUTURE' migrations)"
  # -------------------------------- flyway scripts -------------------------------
  ctitle co "-" "flyway scripts"
  cecho co2 "$ibox 30) $icheck flyway validate"
  cecho co  "$ibox 31) $inext  flyway migrate - database: $_db_display_name  $istar"
  cecho co2 "$ibox 35) $iskull drop + rebuild db - database: $_db_display_name  $iskull"
  cecho co  "$ibox 36) $istop Rollback migration history"
  # ----------------------------------- mvn test ----------------------------------
  ctitle or2 "-" "mvn test"
  cecho or  "$ibox 40) ${_icons[tool_testtube]} mvn test"
  cecho or2 "$ibox 41) ${_icons[tool_testtube]} mvn test (fail fast) - TODO - only works with an additional surefire plugin."
  # -------------------------------- mvn dependency -------------------------------
  ctitle b2 "-" "mvn:dependency"
  cecho b1  "$ibox 50) ${_icons[book_blue]} mvn dependency:help"
  cecho b2  "$ibox 51) ${_icons[refresh2]} mvn dependency:resolve"
  cecho b1  "$ibox 52) ${_icons[tree]} mvn dependency:tree"
  cecho b2  "$ibox 53) ${_icons[tool_magnifying_glass2]} mvn dependency:analyze"
  cecho b1  "$ibox 54) ${_icons[page2]} mvn dependency:list"
  cecho b2  "$ibox 55) ${_icons[globe]} mvn dependency:list-repositories"
  # ----------------------------------- postgres ----------------------------------
  ctitle p2 "-"  "postgres"
  cecho p   "$ibox 60) ${_icons[elephant]} Drop postgres connections (psql) for $_db_display_name"
  # ------------------------------ this (shell/bash) ------------------------------
  ctitle p2 "-" "this (shell/bash)"
  cprint p  "$ibox 90) ${_icons[rainbow]} Print all " && printf "%s" "$colors_text" && cecho p2 " (${_icons[mac_cmd_key]} Mac bash compatible)"
  cecho p2  "$ibox 91) ${_icons[tada]} Print unicode icons $unicode_row"
  cecho p   "$ibox 99) $iquestion_white Print help menu (-h or --help)"
  cecho p2  "$ibox 0)  Exit"
  cline gr "-"
  echo -e "\c"
  get_input
  cline gray "="
}

########################################################################################################################
get_input() {
  unset _selected_menu_item
  echo "Choose an option (0-99):  "
  while :; do
    # get menu option input and set to _selected_menu_item
    local input=
    read -r -p ">" -n 4 input
    [[ $input =~ ^[0-9]+$ ]] || { continue; }
    if ((input >= 0 && input <= 99)); then
      # Break if input is between 0 - 99
      _selected_menu_item=$input
      break
    else
      echo -e "\n  Input a valid number (1-99)."
    fi
  done
}

########################################################################################################################
main_menu() {
  case $_selected_menu_item in
  # validate flyway migrations
  1) _mvn "-V" "flyway:validate" ;;
  # update maven project dependencies
  2) _mvn "--debug" "dependency:resolve" ;;
  # rebuild spring boot and skip tests
  3) _mvn "-Dorg.slf4j.simpleLogger.defaultLogLevel=DEBUG -DskipTests" "clean install" ;;
  # run the project tests
  4) _mvn "--debug" "test" ;;
  # print the project git status
  5) print_git_status ;;
  # run the spring boot project from the command line:
  #     The arguments passed after the spring-boot:run command do the following:
  #       - Disable the springboot banner in the console output
  #       - Disable the JOOQ banner in the console output
  #       - Pass JVM options to open a debugger on port 5005
  6) _mvn "-f $_project_path/pom.xml -DjvmArgs=\"-Xdebug -Xrunjdwp:transport=dt_socket,server=y,suspend=n,address=5005\"" "spring-boot:run" "-Dspring.main.banner-mode=off -Dorg.jooq.no-logo=true" ;;
  # mvn help
  7) _mvn_print_help ;;
  8) _mvn_print_help ;;
  # mvn clean install
  10) log_info "Building the project..." && _mvn "--quiet -DskipTests" "clean install" "--fail-fast --offline" ;;
  11) _mvn "-Dorg.slf4j.simpleLogger.defaultLogLevel=DEBUG -DskipTests" "clean install" "--fail-fast --offline" ;;
  12) _mvn "-Dorg.slf4j.simpleLogger.defaultLogLevel=DEBUG" "clean install" "--fail-fast --offline" ;;
  # flyway:info
  20) _mvn "--debug" "flyway:info" ;;
  21) flyway_check_all_migration_states ;;
  22) flyway_check_migration_by_status "$PENDING" && _print_migration_header && _print_migration_row "$PENDING" green ;;
  23) flyway_check_migration_by_status "$OUT_OF_ORDER" && _print_migration_header && _print_migration_row "$OUT_OF_ORDER" yellow ;;
  24) flyway_check_migration_by_status "$MISSING" && _print_migration_header && _print_migration_row "$MISSING" red ;;
  25) flyway_check_migration_by_status "$FAILED" && _print_migration_header && _print_migration_row "$FAILED" red ;;
  26) flyway_check_migration_by_status "$FUTURE" && _print_migration_header && _print_migration_row "$FUTURE" yellow ;;
  # flyway:validate
  30) _mvn "-V" "flyway:validate" ;;
  # flyway:validate
  31) flyway_migrate "$_arg_db_name" ;;
  # flyway scripts
  35) rebuild_database && flyway_migrate "$_arg_db_name" ;;
  36) rollback_migrations ;;
  # mvn test
  40) _mvn "--debug" "test" ;;
  41) _mvn "--debug" "test" "--fail-fast" ;;
  #  42) _mvn "--debug" "test" "--fail-fast" "--coverage" ;;
  50) _mvn "--V" "dependency:help" ;;
  51) _mvn "--debug" "dependency:resolve" ;;
  52) _mvn "-V" "dependency:tree";;
  53) _mvn "-V" "dependency:analyze" ;;
  54) _mvn "-V" "dependency:list" ;;
  55) _mvn "-V" "dependency:list-repositories" ;;
  60) _postgres_close_connections "$_arg_db_name" ;;
  # this (shell/bash)
  90) print_colors_v1_simple && print_colors_v2_table && print_colors_v3_rainbow ;;
  91) print_unicode_icons ;;
  99) cecho blue2 "$(docstring)" && cecho cyan "$(usage)" ;;
  0) echo "Exiting. Bye bye." && exit 0 ;;
  *) echo "Wrong option." exit 1 ;;
  esac
}
