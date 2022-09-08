#!/bin/bash

########################################################################################################################
# TODO - check if bash is less than version 4.2 and use the unicode or alternative character.
_unicode_char() {
  echo -e "\U$1"
}

########################################################################################################################
declare -A _icons=(
  # ----------------------------------- large icons -----------------------------------
  # heavy unicode icons
  [star]="$(echo -e '\U2B50')"

  [tada]="$(echo -e '\U1F389')"
  [exclamation1]="$(echo -e '\U2755')"
  [exclamation2]="$(echo -e '\U2757')"
  [exclamation3]="$(echo -e '\U203C')"
  [exclamation4]="$(echo -e '\U2049')"
  [question_mark_red]="$(echo -e '\U2753')"
  [question_mark_white]="$(echo -e '\U2754\UFE0F')"

#  [red_x]="$(echo -e '\U274C')"
  [red_circle]="$(echo -e '\U2B55')"
  [orange_circle]="$(echo -e '\U1F7E0')"
  [collision]="$(echo -e '\U1F4A5')"
  [plus]="$(echo -e '\U2795')"
  [directory]="$(echo -e '\U1F4C1')"
  [directory_open]="$(echo -e '\U1F4C2')"
  [directory_dividers]="$(echo -e '\U1F5C2')"
  [notification]="$(echo -e '\U1F514')"
  [notification_off]="$(echo -e '\U1F515')"
  [package]="$(echo -e '\U1F4E6')"
  [controls]="$(echo -e '\U1F39B')"
  [construction]="$(echo -e '\U1F3D7')"
  [tag]="$(echo -e '\U1F3F7')"
  [thumbsup]="$(echo -e '\U1F44D')"
  [thumbsdown]="$(echo -e '\U1F44E')"
  [clapping]="$(echo -e '\U1F44F')"
  [anger]="$(echo -e '\U1F4A2')"
  [skull]="$(echo -e '\U1F480')"
  [bomb]="$(echo -e '\U1F4A3')"
  [100]="$(echo -e '\U1F4AF')"
  [save]="$(echo -e '\U1F4BE')"
  [page]="$(echo -e '\U1F4C3')"
  [page2]="$(echo -e '\U1F4C4')"
  [chart1]="$(echo -e '\U1F4CA')"
  [book_blue]="$(echo -e '\U1F4D8')"
  [book_green]="$(echo -e '\U1F4D7')"
  [book_orange]="$(echo -e '\U1F4D9')"
  [book_red]="$(echo -e '\U1F4D5')"
  [book_yellow]="$(echo -e '\U1F4D4')"
  [books_notes]="$(echo -e '\U1F4D3')"
  [books_open]="$(echo -e '\U1F4D6')"
  [books]="$(echo -e '\U1F4DA')"
  [bookmarks]="$(echo -e '\U1F4D1')"
  [clipboard]="$(echo -e '\U1F4CB')"
  [ledger]="$(echo -e '\U1F4D2')"
  # large unicode icons (misc)
  [calendar]="$(echo -e '\U1F4C5')"
  [timer]="$(echo -e '\U23F1')"
  [hourglass]="$(echo -e '\U23F3')"
  [airplane]="$(echo -e '\U1F6EB')"
  [coffee]="$(echo -e '\U2615')"
  [tree]="$(echo -e '\U1F332')"
  [feather]="$(echo -e '\U1FAB6')"
  [electrical]="$(echo -e '\U26A1\UFE0F')"
  [puzzle]="$(echo -e '\U1F9E9')"
  [refresh1]="$(echo -e '\U1F503')"
  [refresh2]="$(echo -e '\U1F504')"
  [tool_bright]="$(echo -e '\U1F506')"
  [tool_testtube]="$(echo -e '\U1F9EA')"
  [tool_magnifying_glass]="$(echo -e '\U1F50D')"
  [tool_magnifying_glass2]="$(echo -e '\U1F50E')"
  [computer]="$(echo -e '\U1F5A5')"

  [rainbow]="$(echo -e '\U1F308')"
  [shield]="$(echo -e '\U15E2')"
  [shield2]="$(echo -e '\U1F530')"
  [sign_stop]="$(echo -e '\U1F6D1')"
  [sign_noentry]="$(echo -e '\U26D4')"
  [sign_warn]="$(echo -e '\U26A0\UFE0F')"
  [sign_construction]="$(echo -e '\U1F6A7')"

  [toolbox]="$(echo -e '\U1F9F0')"
  [tools]="$(echo -e '\U1F6E0')"
  [tool_hammer]="$(echo -e '\U1F528')"
  [tool_wrench]="$(echo -e '\U1F527')"
  [tool_link]="$(echo -e '\U1F517')"
  [tool_lock]="$(echo -e '\U1F512')"
  [tool_unlock]="$(echo -e '\U1F513')"
  [tool_bolt]="$(echo -e '\U1F511')"
  [tool_gear]="$(echo -e '\U2699\UFE0F')"
  [tool_bolt]="$(echo -e '\U1F529')"
  [tool_screwdriver]="$(echo -e '\U1FA9B')"
  [tool_shield]="$(echo -e '\U1F6E1')"
  [ufo]="$(echo -e '\U1F6F8')"

  # Nature unicode icons
  [brick]="$(echo -e '\U1F9F1')"
  [logs]="$(echo -e '\U1FAB5')"
  [rock]="$(echo -e '\U1faa8')"
  [beach1]="$(echo -e '\U1f3d6')"
  [beach2]="$(echo -e '\U1f3dd')"
  [tea]="$(echo -e '\U1f375')"
  [teapot]="$(echo -e '\U1FAD6')"
  [chili]="$(echo -e '\U1f336')"
  [bellpepper]="$(echo -e '\U1FAD1')"
  [globe]="$(echo -e '\U1F30F')"

  [avocado]="$(echo -e '\U1f951')"
  [olive]="$(echo -e '\U1fad2')"

  [play]=$(echo -e '\U25B6\UFE0F')
  [playpause]=$(echo -e '\U23EF')

  [bug]="$(echo -e '\U1fab2')"
  [bug2]="$(echo -e '\U1F41E')"
  [whale]="$(echo -e '\U1f433')"
  [peacock]="$(echo -e '\U1f99a')"
  [elephant]="$(echo -e '\U1F418')"
  [penguin]="$(echo -e '\U1F427')"
  [faceslap]="$(echo -e '\U1f926')"
  [pray]="$(echo -e '\U1f64f')"

  [flag_red]="$(echo -e '\U1F6A9')"
  [flag_race]="$(echo -e '\U1F3C1')"
  [angerbubble]="$(echo -e '\U1F5EF')"
  [trashbin]="$(echo -e '\U1F5D1')"
  [print]="$(echo -e '\U1F5A8')"
  [clock]="$(echo -e '\U1F563')"

  [box_white]="$(echo -e '\U1F532')"
  [box_black]="$(echo -e '\U1F533')"

  [box_check]="$(echo -e '\U2705')"
  [box_free]="$(echo -e '\U1F193')"
  [box_i]="$(echo -e '\U2139\UFE0F')"
  [box_id]="$(echo -e '\U1F194')"
  [box_new]="$(echo -e '\U1F195')"
  [box_open]="$(echo -e '\U1F196')"
  [box_next]="$(echo -e '\U21AA\UFE0F')"
  [box_ok]="$(echo -e '\U1F197')"
  [box_sos]="$(echo -e '\U1F198')"
  [box_x_green]="$(echo -e '\U274E')"
  [box_x_red]="$(echo -e '\U274C')"

  [radio_button]="$(echo -e '\U1F518')"
  [red_up]="$(echo -e '\U1F53A')"
  [red_down]="$(echo -e '\U1F53B')"
  [diamond]="$(echo -e '\U1F4A0')"

  # ----------------------------------- medium icons -----------------------------------
  # medium unicode icons
  [arrow_down]="$(echo -e '\U25BC')"
  [arrow_up]="$(echo -e '\U25B2')"
  [asterisk]="$(echo -e '\U2731')"
  [box]="$(echo -e '\U2751')"
  [bullet]="$(echo -e '\U2022')"
  [dots]="$(echo -e '\U10B3D')"

  [hotspring]="$(echo -e '\U2668')"
  [star_small]="$(echo -e '\U2605')"
  [star_small2]="$(echo -e '\U02729')"
  [mac_cmd_key]="$(echo -e '\U2318')"

  # ----------------------------------- medium symbols ----------------------------------
  # medium unicode symbols
  [deer]="$(echo -e '\U10082')"
  [horse]="$(echo -e '\U10083')"
  [glyph_man]="$(echo -e '\U10982')"
  [glyph_symbol]="$(echo -e '\U1099F')"
  [glyph_eye]="$(echo -e '\U1099D')"
  [glyph_owl]="$(echo -e '\U10989')"
  [lotus]="$(echo -e '\U1104D')"
  # ----------------------------------- small icon -----------------------------------
  # small unicode icons
  [checkbox_small]="$(echo -e '\U2714')"
  [down_arrow_sm]="$(echo -e '\U2193')"
  [down_arrow_md]="$(echo -e '\U21E9')"
  [x_sm]="$(echo -e '\U2718')"

  [z1_sm]=$(echo -e '\U102FB')
  [z2_sm]=$(echo -e '\U10906')
  [z3_sm]=$(echo -e '\U2124')
)

########################################################################################################################
print_unicode_icons() {
  ctitle p "=" "Unicode Icons"
  # print 3 column table header row
  cecho p2 "       Icon        	Unicode                            Reference"
  cline p "-"
  # disabling the warning about prefer map or read -r as this is working fine and not critical
  # shellcheck disable=SC2207
  local sorted_keys=($(echo "${!_icons[@]}" | tr ' ' $'\n' | sort))
  # print all icons with their unicode and reference in a 3 column table.
  for key in "${sorted_keys[@]}"; do
    local icon_name=
    icon_name=$(cprint cyan "${key}")
    local icon_value=${_icons[$key]}
    local icon_ref="\${_icons[$icon_name]}"
    _table_col3_print_row "$icon_value" "$icon_name" "$icon_ref"
  done
  cline p "-"
}

# Export a row of unicode icons for the menu item
export unicode_row="${_icons[dots]} ${_icons[orange_circle]} ${_icons[diamond]} ${_icons[coffee]} ${_icons[shield]} ${_icons[red_circle]} ${_icons[mac_cmd_key]} ${_icons[timer]}   ${_icons[arrow_up]} ${_icons[arrow_down]} ${_icons[star_small2]}"

# Export some shortcuts for icons
export ibox=${_icons[box]}
export ibox_i=${_icons[box_i]}
export ibox_ok=${_icons[box_ok]}
export icalendar=${_icons[calendar]}
export iclipboard=${_icons[clipboard]}
export icheck=${_icons[box_check]}
export iskull=${_icons[skull]}
export ielectrical=${_icons[electrical]}
export imissing=${_icons[tool_magnifying_glass]}
export inext=${_icons[box_next]}
export ipackage=${_icons[package]}
export irun=${_icons[play]}
export iquestion_white=${_icons[question_mark_white]}
export iquestion_red=${_icons[question_mark_red]}
export istar=${_icons[star]}
export istop=${_icons[sign_stop]}
export iwarn=${_icons[sign_warn]}
export iwarn2=${_icons[exclamation2]}
export ix_green=${_icons[box_x_green]}
export ix_red=${_icons[box_x_red]}
