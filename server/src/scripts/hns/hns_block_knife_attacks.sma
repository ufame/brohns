#include <amxmodx>
#include <fakemeta>
#include <hamsandwich>
#include <reapi>

public plugin_init() {
  register_plugin("HNS: Block knife attack", "1.0.1", "ufame")

  RegisterHam(Ham_Weapon_PrimaryAttack, "weapon_knife", "primaryKnifeAttack")
  RegisterHam(Ham_Weapon_SecondaryAttack, "weapon_knife", "secondaryKnifeAttack")

  register_forward(FM_UpdateClientData, "UpdateClientData_Post", true)
}

public primaryKnifeAttack(entity) {
  if (is_nullent(entity))
    return HAM_IGNORED

  new player = get_member(entity, m_pPlayer)
  if (get_member(player, m_iTeam) != TEAM_CT)
    return HAM_SUPERCEDE

  ExecuteHamB(Ham_Weapon_SecondaryAttack, entity)

  return HAM_SUPERCEDE
}

public secondaryKnifeAttack(entity) {
  if (is_nullent(entity))
    return HAM_IGNORED

  new player = get_member(entity, m_pPlayer)
  return (get_member(player, m_iTeam) == TEAM_TERRORIST) ? HAM_SUPERCEDE : HAM_IGNORED
}

public UpdateClientData_Post(id, sendweapons, cd) {
  if (!is_user_alive(id) || get_member(id, m_iTeam) == TEAM_CT)
    return

  new activeItem = get_member(id, m_pActiveItem)

  if (is_nullent(activeItem))
    return

  if (get_member(activeItem, m_iId) != WEAPON_KNIFE) // or impulse
    return

  set_cd(cd, CD_flNextAttack, get_gametime() + 0.001)
}