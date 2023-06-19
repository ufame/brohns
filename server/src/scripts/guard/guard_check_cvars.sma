#include <amxmodx>

const TASK_CHECK_ID = 12392;

enum ClientCvars {
  fps_max,
  fps_override,
  developer,
  cl_sidespeed,
  cl_forwardspeed,
  cl_backspeed,
  cl_yawspeed,
  cl_pitchspeed
}

new const CvarNames[ClientCvars][] = {
  "fps_max",
  "fps_override",
  "developer",
  "cl_sidespeed",
  "cl_forwardspeed",
  "cl_backspeed",
  "cl_yawspeed",
  "cl_pitchspeed"
}

new const CvarValues[ClientCvars][] = {
  "100", //fps_max
  "0", //fps_override
  "0", //developer
  "400", //cl_sidespeed
  "400", //cl_forwardspeed
  "400", //cl_backspeed
  "210", //cl_yawspeed
  "225" //cl_pitchspeed
}

public plugin_init() {
  register_plugin("Guard: Check user cvars", "1.0.0", "ufame")
}

public client_connect(id) {
  taskCheckCvars(id + TASK_CHECK_ID)
}

public client_putinserver(id) {
  set_task(10.0, "taskCheckCvars", id + TASK_CHECK_ID, .flags = "b")
}

public client_disconnected(id) {
  remove_task(id + TASK_CHECK_ID)
}

public taskCheckCvars(id) {
  id -= TASK_CHECK_ID

  for (new ClientCvars: cvar = fps_max; cvar <= cl_pitchspeed; cvar++) {
    query_client_cvar(id, CvarNames[cvar], "checkClientCvars")
  }
}

public checkClientCvars(id, const clientCvar[], const clientCvarValue[]) {
  new clientCvarNum = str_to_num(clientCvarValue)

  for (new ClientCvars: cvar = fps_max; cvar <= cl_pitchspeed; cvar++) {
    if (
      equal(clientCvar, CvarNames[cvar]) &&
      clientCvarNum > str_to_num(CvarValues[cvar])
    ) {
      userKick(id, cvar)
      break
    }
  }
}

userKick(const id, const ClientCvars: cvar) {
  server_cmd(
    "kick #%d <Set %s %s>",
    get_user_userid(id),
    CvarNames[cvar],
    CvarValues[cvar]
  )
}
