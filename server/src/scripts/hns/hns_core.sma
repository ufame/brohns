#include <amxmodx>
#include <reapi>

enum Settings {
  Setting_StartTime,
  Setting_GiveFlash,
  bool: Setting_GiveSmoke
}

new g_globalSettings[Settings]

public plugin_init() {
  register_plugin("HNS: Core", "1.0.0", "ufame")

  registerCvars()
  AutoExecConfig(.name = "hns_core")

  RegisterHookChain(RG_CBasePlayer_Spawn, "playerSpawn", true)
  RegisterHookChain(RG_RoundEnd, "roundEnd", true)
}

public playerSpawn(id) {
  if (!is_user_alive(id) || get_member(id, m_iTeam) != TEAM_TERRORIST)
    return

  if (g_globalSettings[Setting_GiveFlash]) {
    rg_give_item(id, "weapon_flashbang")
    rg_set_user_bpammo(id, WEAPON_FLASHBANG, g_globalSettings[Setting_GiveFlash])
  }

  if (g_globalSettings[Setting_GiveSmoke]) {
    rg_give_item(id, "weapon_smokegrenade")
  }
}

public roundEnd(WinStatus:status, ScenarioEventEndRound:event, Float:tmDelay) {
  if (status == WINSTATUS_CTS) {
    rg_swap_all_players()
  }
}

public plugin_natives() {
  register_native("hns_get_start_time", "native_get_start_time")
  register_native("hns_set_start_time", "native_set_start_time")
}

public native_get_start_time() {
  return g_globalSettings[Setting_StartTime]
}

public native_set_start_time() {
  enum {
    arg_time = 1
  }

  new startTime = get_param(arg_time)

  if (startTime < 0)
    startTime = 0

  g_globalSettings[Setting_StartTime] = startTime
}

registerCvars() {
  bind_pcvar_num(
    create_cvar(
      "hns_start_time",
      "4",
      .description = "How second's CT freeze in round start"
    ),
    g_globalSettings[Setting_StartTime]
  )

  bind_pcvar_num(
    create_cvar(
      "hns_give_flash",
      "1",
      .description = "Give flash to the terrorists?^n0 - Don't give^nOther - flash count",
      .has_min = true,
      .min_val = 0.0
    ),
    g_globalSettings[Setting_GiveFlash]
  )

  bind_pcvar_num(
    create_cvar(
      "hns_give_smoke",
      "1",
      .description = "Give smoke to the terrorists?",
      .has_min = true,
      .min_val = 0.0,
      .has_max = true,
      .max_val = 1.0
    ),
    g_globalSettings[Setting_GiveSmoke]
  )
}
