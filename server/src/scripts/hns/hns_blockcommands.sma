#include <amxmodx>

public plugin_init() {
  register_plugin("HNS: BlockCommands", "1.0.0", "ufame")

  register_clcmd("jointeam", "clientCommandBlock")
  register_clcmd("chooseteam", "clientCommandBlock")
  register_clcmd("joinclass", "clientCommandBlock")
}

public clientCommandBlock(const id) {
  return PLUGIN_HANDLED
}
