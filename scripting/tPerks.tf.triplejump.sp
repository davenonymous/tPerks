#pragma semicolon 1

#include <sourcemod>
#include <tperks>
#include <tf2items>
#include <tf2_stocks>
#include <sdkhooks>

#define PL_VERSION		"0.0.1"

enum Buffs {
	SCOUT_TRIPLEJUMP = 0
}

new g_iOffsetDash;

new bool:g_bWasOnGround[MAXPLAYERS+1];

new g_iIDs[Buffs];
new g_bRegister = false;

new Handle:g_hCvarAmount;

new g_iAmount = 3;

public Plugin:myinfo = {
	name        = "tPerks, TF2, Scout Multijump",
	author      = "Thrawn",
	description = "Powerups for players, Scout Multijump.",
	version     = PL_VERSION,
	url         = "http://aaa.wallbash.com"
};

public OnPluginStart() {
	g_iOffsetDash = FindSendPropInfo("CTFPlayer", "m_iAirDash");
}

public OnAllPluginsLoaded() {
	if(LibraryExists("tperks")) {
		g_bRegister = true;
	}
}

public OnMapStart() {
	if(g_bRegister) {
		g_iIDs[SCOUT_TRIPLEJUMP] = Perks_Register("Scout - Do multiple jumps", "SCOUT_TRIPLEJUMP", false);
	}
}

public OnMapEnd() {
	if(g_bRegister)Perks_UnRegister();
}

public Event_PlayerSpawn(Handle:event, const String:name[], bool:dontBroadcast) {
	new iClient = GetClientOfUserId(GetEventInt(event, "userid"));

	if(Perks_GetClientHas(iClient, g_iIDs[SCOUT_TRIPLEJUMP]) && TF2_GetPlayerClass(iClient) == TFClass_Scout) {
		SDKHook(iClient, SDKHook_PreThink, ScoutTripleJump_OnPreThink);
	}
}

public ScoutTripleJump_OnPreThink(client) {
	if(!IsPlayerAlive(client) || TF2_GetPlayerClass(client) != TFClass_Scout) {
		SDKUnhook(client, SDKHook_PreThink, ScoutTripleJump_OnPreThink);
		return;
	}

	if(GetEntityFlags(client) & FL_ONGROUND)
	{
		g_bWasOnGround[client] = true;
	} else if (g_bWasOnGround[client]) {
		g_bWasOnGround[client] = false;
		SetEntData(client, g_iOffsetDash, (g_iAmount - 1)*-1);
	}
}