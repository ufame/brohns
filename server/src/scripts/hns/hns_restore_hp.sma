#include <amxmodx>
#include <reapi>

enum Settings {
  Setting_MaxRegenHealth
}

new g_globalSettings[Settings]

public plugin_init() {
  register_plugin("Fall Damage HP Restore", "1.0.0", "ufame")

  registerCvars()
  AutoExecConfig(.name = "hns_restore_hp")

  RegisterHookChain(RG_CSGameRules_FlPlayerFallDamage, "playerFallDamage", true)
}

public playerFallDamage(id) {
  new Float: fallDamage = Float: GetHookChainReturn(ATYPE_FLOAT)

  set_member(id, m_idrowndmg, min(g_globalSettings[Setting_MaxRegenHealth], floatround(fallDamage)))
  set_member(id, m_idrownrestored, 0)
}

registerCvars() {
  bind_pcvar_num(
    create_cvar(
      "hns_max_restore_health",
      "35.0"
    ),
    g_globalSettings[Setting_MaxRegenHealth]
  )
}
