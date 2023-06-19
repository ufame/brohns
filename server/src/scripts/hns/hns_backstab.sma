#include <amxmodx>
#include <reapi>

const Float: KNIFE_STAB_DAMAGE = 65.0
const Float: KNIFE_BACKSTAB_DAMAGE = 195.0

public plugin_init() {
  register_plugin("HNS: Backstab damage", "1.0.0", "ufame")

  RegisterHookChain(RG_CBasePlayer_TakeDamage, "playerTakeDamage")
}

public playerTakeDamage(const this, pevInflictor, pevAttacker, Float: flDamage, bitsDamageType) {
  if (!pevAttacker || pevAttacker == this)
    return
  
  if (get_member(this, m_iTeam) != TEAM_TERRORIST || get_member(pevAttacker, m_iTeam) != TEAM_CT)
    return

  if (get_member(this, m_LastHitGroup) == HITGROUP_HEAD)
    return

  new activeItem = get_member(pevAttacker, m_pActiveItem)

  if (is_nullent(activeItem) || get_member(activeItem, m_iId) != WEAPON_KNIFE)
    return

  if (flDamage >= KNIFE_BACKSTAB_DAMAGE)
    SetHookChainArg(4, ATYPE_FLOAT, KNIFE_STAB_DAMAGE)
}
