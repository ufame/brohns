#include <amxmodx>
#include <reapi>

enum Settings {
  Setting_GameName[32]
}

new g_globalSettings[Settings]

public plugin_init() {
  register_plugin("HNS: Game name changer", "1.0.0", "ufame")

  registerCvars()
  AutoExecConfig(.name = "hns_game_name")

  set_member_game(m_GameDesc, g_globalSettings[Setting_GameName])
}

registerCvars() {
  bind_pcvar_string(
    create_cvar(
      "hns_game_name",
      "t.me/brocsx"
    ),
    g_globalSettings[Setting_GameName],
    charsmax(g_globalSettings[Setting_GameName])
  )
}
