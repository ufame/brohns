#include <amxmodx>
#include <reapi>

enum Settings {
  Setting_HEXColor[8]
}

new g_globalSettings[Settings]
new Float: g_colorRGB[3]

public plugin_init() {
  register_plugin("HNS: Colored flash", "1.0.0", "ufame")

  registerCvars()
  AutoExecConfig(.name = "hns_colored_flash")

  g_colorRGB = parseHEXColor(g_globalSettings[Setting_HEXColor])

  RegisterHookChain(RG_PlayerBlind, "playerBlind")
}

public playerBlind(const index, const inflictor, const attacker, const Float: fadeTime, const Float: fadeHold, const alpha, Float: color[3]) {
  color = g_colorRGB
}

registerCvars() {
  bind_pcvar_string(
    create_cvar(
      "hns_flash_color",
      "#32CD32",
      .description = "Color in HEX"
    ),
    g_globalSettings[Setting_HEXColor],
    charsmax(g_globalSettings[Setting_HEXColor])
  )
}

//https://dev-cs.ru/threads/222/post-33411
Float: parseHEXColor(const value[]) {
  new Float: result[3];
  if (value[0] != '#' && strlen(value) != 7)
    return result;

  result[0] = float(parse16bit(value[1], value[2]))
  result[1] = float(parse16bit(value[3], value[4]))
  result[2] = float(parse16bit(value[5], value[6]))

  return result
}

parse16bit(ch1, ch2) {
  return parseHex(ch1) * 16 + parseHex(ch2)
}

parseHex(const ch) {
  switch (ch) {
    case '0'..'9': {
      return ch - '0'
    }

    case 'a'..'f': {
      return 10 + ch - 'a'
    }

    case 'A'..'F': {
      return 10 + ch - 'A'
    }
  }

  return 0
}
