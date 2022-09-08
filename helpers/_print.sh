#!/bin/bash

########################################################################################################################
# Colour methods #######################################################################################################
########################################################################################################################

########################################################################################################################
# ----- Mac Colour Escape Codes -----
# NOTE - this was the old escape characters for mac
# bash_color_code_mac="\033["

# # NOTE - escape characters for mac, more compatible with bash and more colour range.
bash_color_code_mac="\033[38;5;"
# NOTE - escape character for mac to clear any set console colour/style.
bash_color_code_mac_close="\033[0m"

########################################################################################################################
# ----- Linux Colour Escape Codes -----
# NOTE - I need to verify if this works on linux or sh?
#bash_color_code_linux="\e"

########################################################################################################################
# Colour print - a wrapper for the printf command that allows the use of colour codes.
# A helper to print stdout in color
# $1 - the colour to use in the print e.g. 'blue2' or 'b2'
# $2 - the text to print, it will be wrapped with the colour escape code.
cprint() {
  local text=
  # TODO FIXME - check environment here before setting this code
  local code=$bash_color_code_mac
  local closing_code=$bash_color_code_mac_close
  case "$1" in
    nocolor | nc)  color="${code}0m";;
    red     |  r)  color="${code}1m";;
    pink    | pk)  color="${code}5m";;
    litegray| lg)  color="${code}7m";;
    darkgray| dg)  color="${code}8m";;
    yellow  |  y)  color="${code}11m";;
    white   | wh)  color="${code}15m";;
    blue1   | b1)  color="${code}21m";;
    blue    |  b)  color="${code}27m";;
    green   |  g)  color="${code}28m";;
    black   | bk)  color="${code}30m";;
    cyan    |  c)  color="${code}45m";;
    red2    | r2)  color="${code}52m";;
    purple  |  p)  color="${code}57m";;
    blue2   | b2)  color="${code}75m";;
    green2  | g2)  color="${code}82m";;
    purple2 | p2)  color="${code}105m";;
    gray    | gr)  color="${code}102m";;
    coral   | co)  color="${code}168m";;
    hotpink | hp)  color="${code}200m";;
    orange  | or)  color="${code}130m";;
    orange2 | or2) color="${code}214m";;
    coral2  | co2) color="${code}216m";;
    *) text="$1"
  esac
  [ -z "$text" ] && text="$color$2${closing_code}"
  echo -en "$text"
}

########################################################################################################################
# Colour echo - a wrapper for cprint with a new line (replicating echo)
# $1 - the colour to use in the print e.g. 'blue2' or 'b2'
# $2 - the text to print, it will be wrapped with the colour escape code.
cecho() {
  cprint "$1" "$2" && echo
}

########################################################################################################################
# The word "colours" with each char in different colours
colors_text="$(cecho r c)$(cecho g o)$(cecho p l)$(cecho b o)$(cecho y u)$(cecho c r)$(cecho pk s)"
export colors_text


########################################################################################################################
# Set up our own script loggers with color
log_debug() {
  if [ "$_verbose_mode" = true ]; then
    cecho c "[DEBUG] $1";
  fi
}
log_info() { cecho  g "[INFO] $1"; }
log_warn() { cecho  y "[WARN] $1"; }
log_error() { cecho r "[ERROR] $1"; }

########################################################################################################################
cline() {
  local _separator_star="*******************************************************************************"
  local _separator_dash="-------------------------------------------------------------------------------"
  local _separator_equals="==============================================================================="

  # get args
  local color=${1:-gray}
  local char=${2:-"*"}
  # try to match char from arg to get the character for the line.
  local line=
  case $char in
    -) line=$_separator_dash ;;
    =) line=$_separator_equals ;;
    \*) line=$_separator_star ;;
    \?) line=$_separator_star ;;
  esac
  cecho "$color" "$line"
}

########################################################################################################################
# ctitle - Colour Line - Print a line in a given colour with a centered title text.
# $1 - the colour to use in the print e.g. 'blue2' or 'b2'
# $2 - the character to use for the line, using "=" for titles and "-" for subtitles.
# $3 - the text to print, it will be wrapped with the colour escape code and padded with characters.
#
# Example usage: print_console_line red "=" "This is a red line"
# Output: =================================== This is a red line ===================================
ctitle() {
  # get color and text to output with the padding
  color=${1}
  local char=${2}
  local input_text=${3}
  # get terminal width to set length of line
  # termwidth="$(tput cols)"
  # Force line output to a fixed length (80 limit so 80-1 is 79)
  local termwidth=79
  local padding=
  local line=
  padding="$(printf '%0.1s' "$char"{1..500})"
  line=$(printf '%*.*s %s %*.*s\n' 0 "$(((termwidth-2-${#3})/2))" "$padding" "$input_text" 0 "$(((termwidth-1-${#3})/2))" "$padding")
  cecho "$color" "$line"
}

########################################################################################################################
# Escapes unicode characters to be used in bash scripts.
# TODO - check if bash is less than version 4.2 and use the unicode or alternative character.
_unicode_char() {
  echo -e "\U$1"
}

########################################################################################################################
# NOTE - LEGACY - not using this method for colour printing as it is a limited selection of colours.
print_colors_v1_simple() {
  echo -e "\n\n Print basic color codes... \n"
  local code_bash="\033["
  local clear_format_bash="\033[0m"
  for colorcode in $(seq 0 9; seq 30 37; seq 40 47; seq 90 97; seq 100 107); do
    local text_bash="${code_bash}${colorcode}m"
    echo -e "$text_bash color code: $colorcode $clear_format_bash"
  done
}

########################################################################################################################
# NOTE - LEGACY - not using this method for colour printing as it is a limited selection of colours.
print_colors_v2_table() {
  echo -e "\n\n Print detailed table of color codes... \n"
  # the test text to print in all the colors
  local sample_text='hello'
  echo -e "\n                    40m       41m       42m       43m\
       44m       45m       46m       47m";
  for FGs in '    m' '   1m' '  30m' '1;30m' '  31m' '1;31m' '  32m' \
            '1;32m' '  33m' '1;33m' '  34m' '1;34m' '  35m' '1;35m' \
            '  36m' '1;36m' '  37m' '1;37m';
    do local FG=${FGs// /}
    echo -en " $FGs \033[$FG  $sample_text  "
    for BG in 40m 41m 42m 43m 44m 45m 46m 47m;
      do echo -en "$EINS \033[$FG\033[$BG  $sample_text  \033[0m";
    done
    echo;
  done
  echo
}

########################################################################################################################
# NOTE - we are using this table to print colours which can be used easily with `cecho`, `cprint`,
# `print_line` and `cline`
print_colors_v3_rainbow() {
  echo -e "\n\n Print rainbow color codes... \n"
  for colour in {1..225}
    do echo -en "\033[38;5;${colour}m38;5;${colour} \n"
  done | column -x
}

########################################################################################################################
_table_col3_print_row() {
  # TODO - check there should be exactly 3 arguments.
  printf "\t%-14s\t%-40s\t%s\n" "$1" "$2" "$3"
}

_table_col3_print_row_sm() {
  # TODO - check there should be exactly 3 arguments.
  printf "\t%-22s\t%-22s\t%s\n" "$1" "$2" "$3"
}

########################################################################################################################
_table_col2_print_row() {
  # TODO - check there should be exactly 2 arguments.
  printf "\t%-30s\t%-40s\n" "$1" "$2"
}
