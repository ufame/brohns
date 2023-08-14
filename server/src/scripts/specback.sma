#include <amxmodx>
#include <reapi>
#include <util_commands>

public plugin_init() {
  register_plugin("Spec&Back", "1.0.0", "ufame")

  new const commands[][] = {
    "spec", "back"
  }

  for (new i; i < sizeof commands; i++) {
    UTIL_RegisterClientCommand(commands[i], "commandSpec")
  }
}

public commandSpec(const id) {
  if (get_member(id, m_iTeam) != TEAM_SPECTATOR) {
    if (is_user_alive(id))
      user_silentkill(id)

    rg_set_user_team(id, TEAM_SPECTATOR)
  } else {
    new teamCountAlive[TeamName], teamCount[TeamName]
    rg_initialize_player_counts(teamCountAlive[TEAM_TERRORIST], teamCountAlive[TEAM_CT], teamCount[TEAM_TERRORIST], teamCount[TEAM_CT])

    new teams[TeamName]
    teams[TEAM_TERRORIST] = teamCountAlive[TEAM_TERRORIST] + teamCount[TEAM_TERRORIST]
    teams[TEAM_CT] = teamCountAlive[TEAM_CT] + teamCount[TEAM_CT]

    new TeamName: teamToJoin

    if ((teams[TEAM_TERRORIST] - teams[TEAM_CT]) >= 2) {
      teamToJoin = TEAM_CT
    } else ((teams[TEAM_CT] - teams[TEAM_TERRORIST]) >= 2) {
      teamToJoin = TEAM_TERRORIST
    }

    rg_set_user_team(id, teamToJoin)
  }

  return PLUGIN_HANDLED
}
