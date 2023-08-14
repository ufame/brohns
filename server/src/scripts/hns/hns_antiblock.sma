#include <amxmodx>
#include <fakemeta>
#include <hamsandwich>

new bool:g_bIsTouched[33];
new bool:g_bIsBlocked[33];
new g_szTouchedName[33][33];

public plugin_init()
{
	register_plugin("Block Return", "0.1b", "Garey");
	
	RegisterHam( Ham_Player_PreThink, "player", "fwd_PlayerPreThink", 0 );
	RegisterHam( Ham_Touch, "player", "fwd_TouchPlayer", 0 );
	RegisterHam( Ham_TakeDamage, "player", "Ham_TakeDamagePlayer" );
} 

public fwd_TouchPlayer( id, entity )
{
	if( get_user_team( id ) != 2 || !is_user_alive( entity ))
		return;
		
	if( get_user_team( entity ) != 1 )
		return;

	if( pev(entity, pev_movetype) != MOVETYPE_FLY)
		return;
	
	get_user_name( entity, g_szTouchedName[ id ], 32 );
	
	new flVelocity[3]
	pev(id, pev_velocity, flVelocity);
	// Check if player was in Air
	if(flVelocity[2] != 0.0)
	{
		g_bIsTouched[id] = true;
	}
}


public Ham_TakeDamagePlayer(iVictim, iInflictor, iAttacker, Float:flDamage, iDamageBits)
{
	if( is_user_alive(iVictim) && flDamage >= get_user_health(iVictim) && iDamageBits & DMG_FALL )
	{		
		if( get_user_team(iVictim) == 2 )
		{
			if(g_bIsTouched[iVictim])
			{
				new szName[ 33 ];
				get_user_name( iVictim, szName, 32 );
				g_bIsBlocked[iVictim] = true;
				client_print_color( 0, 0, "[^4BroHNS^1]^3 %s^1 blocked^3 %s", g_szTouchedName[ iVictim ], szName );
			}
		}
	}
}

public fwd_PlayerPreThink( id )
{
	if(is_user_alive(id))
	{
		if(!g_bIsBlocked[id])
		{
		if((pev(id, pev_flags) & FL_ONGROUND) || pev(id, pev_movetype) == MOVETYPE_FLY)
			g_bIsTouched[id] = false;
		}
		else
		{
			g_bIsBlocked[id] = false;
		}
	}
}