#include <amxmodx>

public plugin_init() {
  register_plugin("Utility: Admin commands", "1.0.0", "ufame")

  register_clcmd("rrmap", "commandRestartMap")
  register_clcmd("rr", "commandRestartRounds")
}

public commandRestartMap(const id) {
  if (~get_user_flags(id) & ADMIN_BAN)
    return PLUGIN_HANDLED

  server_cmd("restart")

  return PLUGIN_HANDLED
}

public commandRestartRounds(const id) {
  if (~get_user_flags(id) & ADMIN_BAN)
    return PLUGIN_HANDLED

  server_cmd("sv_restartround 3")

  return PLUGIN_HANDLED
}