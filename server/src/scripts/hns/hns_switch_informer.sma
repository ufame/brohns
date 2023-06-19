#include <amxmodx>
#include <reapi>

new const LangMessages[TeamName][] = {
  "",
  "WIN_TERRORISTS",
  "WIN_CTS",
  ""
}

new const BlockedMessages[][] = {
  "#CTs_Win",
  "#Round_Draw",
  "#Target_Saved",
  "Round is Over!",
  "#Terrorists_Win"
}

new const WinSounds[TeamName][] = {
  "",
  "sound/brohns/weaknesses_won.mp3",
  "sound/brohns/seekers_won.mp3",
  ""
}

new g_hexColor[TeamName][8]
new g_rgbColor[TeamName][3]

new g_hudPosition[TeamName][16]
new Float: g_positionHud[TeamName][2]

public plugin_precache() {
  precache_generic(WinSounds[TEAM_TERRORIST])
  precache_generic(WinSounds[TEAM_CT])
}

public plugin_init() {
  register_plugin("HNS: Switch Team Informer", "1.0.0", "ufame")

  register_dictionary("hns_switch_informer.txt")

  registerCvars()
  AutoExecConfig(.name = "hns_switch_informer")

  g_rgbColor[TEAM_TERRORIST] = parseHEXColor(g_hexColor[TEAM_TERRORIST])
  g_rgbColor[TEAM_CT] = parseHEXColor(g_hexColor[TEAM_CT])

  g_positionHud[TEAM_TERRORIST] = parseHUDPosition(g_hudPosition[TEAM_TERRORIST])
  g_positionHud[TEAM_CT] = parseHUDPosition(g_hudPosition[TEAM_CT])

  register_message(get_user_msgid("TextMsg"), "messageTextMsg")
  register_message(get_user_msgid("SendAudio"), "messageSendAudio")

  RegisterHookChain(RG_RoundEnd, "roundEnd", true)
}

public messageTextMsg() {
  new message[16]
  get_msg_arg_string(2, message, charsmax(message))

  for (new i; i < sizeof BlockedMessages; i++) {
    if (!strcmp(message, BlockedMessages[i]))
      return PLUGIN_HANDLED
  }

  return PLUGIN_CONTINUE
}

public messageSendAudio() {
  new message[16]
  get_msg_arg_string(2, message, charsmax(message))

  switch (message[7]) {
    case 't', 'c': {
      return PLUGIN_HANDLED
    }
  }

  return PLUGIN_CONTINUE
}

public roundEnd(WinStatus: status, ScenarioEventEndRound: event, Float: tmDelay) {
  if (status == WINSTATUS_DRAW)
    return

  new TeamName: team = (status == WINSTATUS_CTS) ? TEAM_CT : TEAM_TERRORIST

  set_dhudmessage(
    g_rgbColor[team][0],
    g_rgbColor[team][1],
    g_rgbColor[team][2],
    g_positionHud[team][0],
    g_positionHud[team][1],
    .holdtime = 4.0
  )

  show_dhudmessage(0, "%L", LANG_PLAYER, LangMessages[team])

  client_cmd(0, "mp3 play ^"%s^"", WinSounds[team])
}

registerCvars() {
  bind_pcvar_string(
    create_cvar(
      "hns_switch_informer_color_t",
      "#FF0000"
    ),
    g_hexColor[TEAM_TERRORIST],
    charsmax(g_hexColor[])
  )

  bind_pcvar_string(
    create_cvar(
      "hns_switch_informer_color_ct",
      "#0000FF"
    ),
    g_hexColor[TEAM_CT],
    charsmax(g_hexColor[])
  )

  bind_pcvar_string(
    create_cvar(
      "hns_switch_informer_pos_t",
      "-1.0 0.15"
    ),
    g_hudPosition[TEAM_TERRORIST],
    charsmax(g_hudPosition[])
  )

  bind_pcvar_string(
    create_cvar(
      "hns_switch_informer_pos_ct",
      "-1.0 0.15"
    ),
    g_hudPosition[TEAM_CT],
    charsmax(g_hudPosition[])
  )
}

//https://dev-cs.ru/threads/222/post-33411
parseHEXColor(const value[]) {
  new result[3];
  if (value[0] != '#' && strlen(value) != 7)
    return result;

  result[0] = parse16bit(value[1], value[2])
  result[1] = parse16bit(value[3], value[4])
  result[2] = parse16bit(value[5], value[6])

  return result
}

parse16bit(ch1, ch2) {
  return parseHex(ch1) * 16 + parseHex(ch2)
}

parseHex(const ch) {
  switch (ch) {
    case '0'..'9': {
      return ch - '0'
    }

    case 'a'..'f': {
      return 10 + ch - 'a'
    }

    case 'A'..'F': {
      return 10 + ch - 'A'
    }
  }

  return 0
}

Float: parseHUDPosition(const value[]) {
  new Float: result[2]

  new argX[6], argY[6]
  parse(value, argX, charsmax(argX), argY, charsmax(argY))

  result[0] = str_to_float(argX)
  result[1] = str_to_float(argY)

  return result
}
