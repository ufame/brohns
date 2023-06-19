#include <amxmodx>
#include <reapi>

#define rg_get_user_team(%0) get_member(%0, m_iTeam)

new Float:g_flFlashUntil[MAX_PLAYERS + 1];
new Float:g_flFlashHoldTime[MAX_PLAYERS + 1];

new Float:g_flHudTime[MAX_PLAYERS + 1];

public plugin_init() {
	register_plugin("HNS Flash Notifier", "1.0.4", "OpenHNS"); // Juice, WessTorn
	
	RegisterHookChain(RG_PlayerBlind, "rgPlayerBlind", true);
	RegisterHookChain(RG_CBasePlayer_PreThink, "rgPlayerPreThink");
}

public client_putinserver(id) {
	g_flFlashUntil[id] = g_flFlashHoldTime[id] = 0.0;
}

public client_disconnected(id) {
	g_flFlashUntil[id] = g_flFlashHoldTime[id] = 0.0;
}

public rgPlayerBlind(id, inflictor, attacker, Float:fadeTime, Float:fadeHold, alpha, Float:color[3]) {
	if(!is_entity(attacker) || get_member(id, m_iTeam) == TEAM_TERRORIST)
		return

	g_flFlashUntil[id] = get_gametime() + fadeTime;
	g_flFlashHoldTime[id] = get_gametime() + fadeHold;

	if (alpha != 255 || fadeHold < 1.0)
		return
	
	for(new i = 0; i <= MaxClients; i++) {
		if (!is_user_connected(i))
			continue;
		
		if(rg_get_user_team(i) == TEAM_CT) {
			client_print_color(i, print_team_grey, "^1[^4BroHNS^1] ^3%n^1 flashed ^3%n", attacker, id);
		} else {
			client_print_color(i, print_team_grey, "^1[^4BroHNS^1] ^3%n^1 flashed ^3%n^1 for ^3%.2f^1 second", attacker, id, fadeHold);
		}
	}

	return
}

public rgPlayerPreThink(id) {
	if(rg_get_user_team(id) != TEAM_SPECTATOR) 
		return HC_CONTINUE;

	new iSpecMode = get_entvar(id, var_iuser1);

	if(iSpecMode != 2 && iSpecMode != 4)
		return HC_CONTINUE;

	new iTarget = get_entvar(id, var_iuser2);

	if(iTarget == id)
		return HC_CONTINUE;

	if(!is_user_alive(iTarget))
		return HC_CONTINUE;

	new Float:g_flGameTime = get_gametime();

	if(g_flFlashUntil[iTarget] <= g_flGameTime)
		return HC_CONTINUE;


	if((g_flHudTime[id] + 0.1) > g_flGameTime)
		return HC_CONTINUE;

	new bool:IsFullFlash = g_flFlashHoldTime[iTarget] > g_flGameTime ? true : false;

	static szFlashInfo[16];

	if (IsFullFlash) {
		set_dhudmessage(250, 0, 0, -1.0, 0.2, 0, 1.0, 0.2, 0.0, 0.0);
		formatex(szFlashInfo, charsmax(szFlashInfo), "Full flashed");
	} else {
		set_dhudmessage(0, 250, 0, -1.0, 0.2, 0, 1.0, 0.2, 0.0, 0.0);
		formatex(szFlashInfo, charsmax(szFlashInfo), "Flashed");
	}

	ScreenFade(id);
	show_dhudmessage(id, "%s", szFlashInfo);

	g_flHudTime[id] = g_flGameTime;

	return HC_CONTINUE;
}

public ScreenFade(id){
	static msg_screenfade;
	if(msg_screenfade || (msg_screenfade = get_user_msgid("ScreenFade"))) {
		message_begin(MSG_ONE, msg_screenfade, .player = id);
		write_short(UTIL_FixedUnsigned16(0.0, 1<<12));
		write_short(UTIL_FixedUnsigned16(0.0, 1<<12));
		write_short((1<<0));
		write_byte(0);
		write_byte(0);
		write_byte(0);
		write_byte(0);
		message_end();
	}
}

public UTIL_FixedUnsigned16(Float:Value, Scale)
    return clamp(floatround(Value * Scale), 0, 0xFFFF);