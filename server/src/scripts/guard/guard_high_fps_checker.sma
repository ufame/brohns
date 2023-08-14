#include <amxmodx>
#include <reapi>

enum _:FpsData
{
  fps_values[10],
  fps_current_index,
  Float: fps_start_time
};

new g_playerFps[MAX_PLAYERS + 1][FpsData]

public plugin_init() {
  register_plugin("Median fps", "1.0.0", "the_hunter")
  RegisterHookChain(RG_CBasePlayer_PreThink, "OnPlayerPreThink")
}

public client_connect(id) {
  ResetFpsData(id)
}

ResetFpsData(id) {
  arrayset(g_playerFps[id], 0, FpsData)
  g_playerFps[id][fps_current_index] = -1
}

public OnPlayerPreThink(const id) {
  new Float: game_time = get_gametime()
 
  // Если значение current_index == -1, значит мы еще не считали фпс для этого игрока.
  if (g_playerFps[id][fps_current_index] == -1) {
    g_playerFps[id][fps_values][0]++
    g_playerFps[id][fps_current_index] = 0
    g_playerFps[id][fps_start_time] = game_time
  }
  else {
    g_playerFps[id][fps_values][g_playerFps[id][fps_current_index]]++
 
    if ((game_time - g_playerFps[id][fps_start_time]) >= 1.0) {
      g_playerFps[id][fps_current_index]++
      g_playerFps[id][fps_start_time] = game_time

      if (g_playerFps[id][fps_current_index] == 9) {
        CheckMedianFPS(id)
        ResetFpsData(id)
      }
    }
  }
}

CheckMedianFPS(id) {
  SortIntegers(g_playerFps[id][fps_values], sizeof(g_playerFps[][fps_values]))
 
  // После сортировки массива, среднее значение фпс будет в середине массива (fps_values[5])
  // Чтобы еще больше сгладить неточности, возмем среднее значение от средних значений.
  // Т.е. (fps_values[4] + fps_values[5] + fps_values[6]) / 3 - 1
  new median_fps =
    (g_playerFps[id][fps_values][4] + g_playerFps[id][fps_values][5] + g_playerFps[id][fps_values][6]) / 3 - 1

  //TODO: to cvars
  if (median_fps > 100) {
    server_cmd("kick #%d ^"median fps is %d. Max 100.^"", median_fps)
  }
}