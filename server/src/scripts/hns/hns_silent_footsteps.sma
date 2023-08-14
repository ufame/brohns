#include <amxmodx>
#include <reapi>

enum Settings {
  bool: Setting_SilentFootsteps
}

new g_globalSettings[Settings][TeamName]

public plugin_init() {
  register_plugin("HNS: Silent Footsteps", "1.0.0", "ufame")

  registerCvars()
  AutoExecConfig(.name = "hns_silent_footsteps")

  RegisterHookChain(RG_CBasePlayer_Spawn, "playerSpawn", 1)
}

public playerSpawn(const player) {
  if (!is_user_alive(player))
    return

  new TeamName: team = get_member(player, m_iTeam)

  if (g_globalSettings[Setting_SilentFootsteps][team])
    rg_set_user_footsteps(player, true)
}

registerCvars() {
  bind_pcvar_num(
    create_cvar(
      "hns_silent_footsteps_t",
      "1"
    ),
    g_globalSettings[Setting_SilentFootsteps][TEAM_TERRORIST]
  )

  bind_pcvar_num(
    create_cvar(
      "hns_silent_footsteps_ct",
      "0"
    ),
    g_globalSettings[Setting_SilentFootsteps][TEAM_CT]
  )
}