#include <amxmodx>
#include <reapi>

const TASK_ID = 10438
const DMG_KNIFE = (DMG_NEVERGIB | DMG_BULLET)

enum Settings {
  Float: Setting_AntifragTime
}

new g_globalSettings[Settings]

public plugin_init() {
  register_plugin("HNS: Antifrag", "1.0.0", "ufame") //based on Antifrag by Kaido Ren

  createCvars()
  AutoExecConfig(.name = "hns_antifrag")

  RegisterHookChain(RG_CBasePlayer_TakeDamage, "playerTakeDamage")
  RegisterHookChain(RG_CBasePlayer_TakeDamage, "playerTakeDamagePost", true)
}

public playerTakeDamage(const this, pevInflictor, pevAttacker, Float: damage, bitsDamageType) {
  if (!pevAttacker || pevInflictor != pevAttacker || !rg_is_player_can_takedamage(this, pevAttacker))
    return HC_CONTINUE

  if (~bitsDamageType & DMG_KNIFE)
    return HC_CONTINUE

  if (task_exists(this + TASK_ID)) {
    SetHookChainArg(4, ATYPE_FLOAT, 0.0)

    return HC_SUPERCEDE
  }

  if (get_entvar(this, var_health) <= damage)
    return HC_CONTINUE

  client_print_color(this, print_team_default, "[^4BroHNS^1] Antifrag ^4%.0f ^1second's", g_globalSettings[Setting_AntifragTime]);
  client_print_color(pevAttacker, print_team_default, "[^4BroHNS^1] Antifrag ^4%.0f ^1second's", g_globalSettings[Setting_AntifragTime]);

  set_task(g_globalSettings[Setting_AntifragTime], "taskTick", this + TASK_ID)

  rg_set_rendering(this, kRenderFxGlowShell, 155, 0, 0, kRenderNormal, 15)

  return HC_CONTINUE
}

public taskTick(player) {
  player -= TASK_ID

  if (is_user_connected(player))
    rg_set_rendering(player)
}

createCvars() {
  bind_pcvar_float(
    create_cvar(
      "hns_antifrag_time",
      "3.0"
    ),
    g_globalSettings[Setting_AntifragTime]
  )
}

stock rg_set_rendering(entity, fx = kRenderFxNone, r = 255, g = 255, b = 255, render = kRenderNormal, amount = 16) {
    new Float:renderColor[3];
    renderColor[0] = float(r);
    renderColor[1] = float(g);
    renderColor[2] = float(b);

    set_entvar(entity, var_renderfx, fx);
    set_entvar(entity, var_rendercolor, renderColor);
    set_entvar(entity, var_rendermode, render);
    set_entvar(entity, var_renderamt, float(amount));

    return 1;
}