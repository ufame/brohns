#if defined _util_commands_included
#endinput
#endif

#define _util_commands_included

/**
* Register commands in console, say and say_team by register_clcmd
*
* @note For a list of possible access flags, see the ADMIN_* constants in
*       amxconst.inc
* @note Opting in to FlagManager enables the admin privileges to be overwritten
*       by the end user via the cmdaccess.ini config file.
* @note Automatic detection for FlagManager will only include a command if it
*       has required privileges (flags is not -1) and it is not a command
*       starting with "say".
*
* @param client_cmd    Command to register
* @param function      Callback function
* @param flags         Admin privilege flags required
* @param info          Command description
* @param FlagManager   0 opts out of flag manager, 1 opts in, -1 selects
*                      automatically
* @param info_ml       If true, the parameter "info" will be looked up as multilingual key
*
* @return              noreturn
* @error               If an invalid callback function is specified, an error
*                      will be thrown.
* */
stock UTIL_RegisterClientCommand(
  const client_cmd[],
  const function[],
  flags = -1,
  const info[] = "",
  FlagManager = -1,
  bool: info_ml = false
) {
  register_clcmd(client_cmd, function, flags, info, FlagManager, info_ml)
  register_clcmd(fmt("say /%s", client_cmd), function, flags, info, FlagManager, info_ml)
  register_clcmd(fmt("say_team /%s", client_cmd), function, flags, info, FlagManager, info_ml)
}