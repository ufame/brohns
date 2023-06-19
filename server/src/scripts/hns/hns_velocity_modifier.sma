#include <amxmodx>
#include <reapi>

public plugin_init() {
  register_plugin("HNS: Don't velocity modify", "1.0.0", "ufame")

  RegisterHookChain(RG_CBasePlayer_TakeDamage, "playerTakeDamage", true)
}

public playerTakeDamage(const this) {
  if (!is_user_alive(this))
    return

  set_member(this, m_flVelocityModifier, 1.0)
}