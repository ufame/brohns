#include <amxmodx>
#include <reapi>

public plugin_init() {
  register_plugin("HNS: No flash", "1.0.0", "ufame")

  RegisterHookChain(RG_PlayerBlind, "playerBlind")
}

public playerBlind(const index, const inflictor, const attacker, const Float: fadeTime, const Float: fadeHold, const alpha, Float: color[3]) {
  return (is_user_alive(index) && get_member(index, m_iTeam) == TEAM_CT) ? HC_CONTINUE : HC_SUPERCEDE
}
