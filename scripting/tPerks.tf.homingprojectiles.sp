#pragma semicolon 1

#include <sourcemod>
#include <tperks>
#include <sidewinder>

#define PL_VERSION		"0.0.1"

enum Buffs {
	SOLDIER_HOMINGROCKETS = 0,
	PYRO_HOMINGFLARES = 1,
	SNIPER_HOMINGARROWS = 2,
	DEMO_HOMINGPIPES = 3,
	MEDIC_HOMINGNEEDLES = 4,
	ENGIE_HOMINGSENTRY = 5
}

new g_iIDs[Buffs];
new g_bRegister = false;
/*
new g_iTrackChanceArrow = 4;
new g_iTrackChanceRocket = 5;
new g_iTrackChancePipe = 5;
new g_iTrackChanceNeedle = 6;
new g_iTrackChanceFlare = 7;
new g_iTrackChanceSentry = 10;
new Float:g_fTrackChanceArrow = 0.04;
new Float:g_fTrackChanceRocket = 0.50;
new Float:g_fTrackChancePipe = 0.05;
new Float:g_fTrackChanceNeedle = 0.06;
new Float:g_fTrackChanceFlare = 0.07;
new Float:g_fTrackChanceSentry = 0.10;
*/

new Handle:g_hCvarChance;

new g_iTrackChance = 5;

public Plugin:myinfo = {
	name        = "tPerks, TF2, Homing Projectiles",
	author      = "Thrawn",
	description = "Powerups for players, Homing Projectiles.",
	version     = PL_VERSION,
	url         = "http://aaa.wallbash.com"
};

public OnPluginStart() {
	//SidewinderControl(true, false, SidewinderSentry|SidewinderRocket|SidewinderArrow|SidewinderFlare|SidewinderPipe|SidewinderSyringe, SidewinderDisabled);
	SidewinderControl(true, false);
	g_hCvarChance = CreateConVar("sm_tperks_tf_homing_chance", "5", "Chance a projectile is homing", FCVAR_PLUGIN, true, 0.0, true, 100.0);

	HookConVarChange(g_hCvarChance, Cvar_Changed);

	HookEvent("player_spawn", OnPlayerSpawn);
	HookEvent("player_death", OnPlayerDeath);
}

public OnConfigsExecuted() {
	g_iTrackChance = GetConVarInt(g_hCvarChance);
}

public Cvar_Changed(Handle:convar, const String:oldValue[], const String:newValue[]) {
	OnConfigsExecuted();
}

public OnAllPluginsLoaded() {
	if(LibraryExists("tperks")) {
		g_bRegister = true;
	}
}

public OnMapStart() {
	if(g_bRegister) {
		g_iIDs[SOLDIER_HOMINGROCKETS] = Perks_Register("Soldier - Homing rockets", "SOLDIER_HOMINGROCKETS", false);
		g_iIDs[PYRO_HOMINGFLARES] = Perks_Register("Pyro - Homing flares", "PYRO_HOMINGFLARES", false);
		g_iIDs[SNIPER_HOMINGARROWS] = Perks_Register("Sniper - Homing arrows", "SNIPER_HOMINGARROWS", false);
		g_iIDs[DEMO_HOMINGPIPES] = Perks_Register("Demo - Homing pipes", "DEMO_HOMINGPIPES", false);
		g_iIDs[MEDIC_HOMINGNEEDLES] = Perks_Register("Medic - Homing needles", "MEDIC_HOMINGNEEDLES", false);
		g_iIDs[ENGIE_HOMINGSENTRY] = Perks_Register("Engie - Homing sentry rockets", "ENGIE_HOMINGSENTRY", true);
	}
}

public OnMapEnd() {
	if(g_bRegister)Perks_UnRegister();
}

public Action:OnPlayerSpawn(Handle:event, const String:name[], bool:dontBroadcast) {
	if(!Perks_IsEnabled())
		return Plugin_Continue;

	new client = GetClientOfUserId(GetEventInt(event, "userid"));

	ResetClient(client);
	EnableTracking(client);

	return Plugin_Continue;
}

public Action:OnPlayerDeath(Handle:event, const String:name[], bool:dontBroadcast) {
	if(!Perks_IsEnabled())
		return Plugin_Continue;

	new client = GetClientOfUserId(GetEventInt(event, "userid"));
	ResetClient(client);

	return Plugin_Continue;
}

ResetClient(client) {
	new SidewinderClientFlags:flags;
	flags = NormalSentryRockets | NormalRockets | NormalArrows |
			NormalFlares | NormalPipes | NormalSyringe;

	SidewinderFlags(client, flags, false);
	SidewinderTrackChance(client, 0);
}

EnableTracking(iClient) {
	new SidewinderClientFlags:flags;

	if(Perks_GetClientHas(iClient, g_iIDs[SOLDIER_HOMINGROCKETS])) {
		flags |= TrackingRockets;
	} else {
		flags |= NormalRockets;
	}

	if(Perks_GetClientHas(iClient, g_iIDs[PYRO_HOMINGFLARES])) {
		flags |= TrackingFlares;
	} else {
		flags |= NormalFlares;
	}

	if(Perks_GetClientHas(iClient, g_iIDs[SNIPER_HOMINGARROWS])) {
		flags |= TrackingArrows;
	} else {
		flags |= NormalArrows;
	}

	if(Perks_GetClientHas(iClient, g_iIDs[DEMO_HOMINGPIPES])) {
		flags |= TrackingPipes;
	} else {
		flags |= NormalPipes;
	}

	if(Perks_GetClientHas(iClient, g_iIDs[MEDIC_HOMINGNEEDLES])) {
		flags |= TrackingSyringe;
	} else {
		flags |= NormalSyringe;
	}

	if(Perks_GetClientHas(iClient, g_iIDs[ENGIE_HOMINGSENTRY])) {
		flags |= TrackingSentryRockets;
	} else {
		flags |= NormalSentryRockets;
	}

	SidewinderFlags(iClient, flags, false);
	SidewinderTrackChance(iClient, g_iTrackChance);
	SidewinderSentryCritChance(iClient, 0);

}

/*
public Action:OnSidewinderSeek(iClient, SidewinderEnableFlags:projectile, bool:critical, &TrackType:value) {
	LogMessage("OnSidewinderSeek");
	if(Perks_GetClientHas(iClient, g_iIDs[SOLDIER_HOMINGROCKETS]) && projectile == SidewinderRocket) {
		if(GetRandomFloat() <= g_fTrackChanceRocket)
			value = TrackAll;
		return Plugin_Changed;
	}
	if(Perks_GetClientHas(iClient, g_iIDs[PYRO_HOMINGFLARES]) && projectile == SidewinderFlare) {
		if(GetRandomFloat() <= g_fTrackChanceFlare)
			value = TrackAll;
		return Plugin_Changed;
	}
	if(Perks_GetClientHas(iClient, g_iIDs[SNIPER_HOMINGARROWS]) && projectile == SidewinderArrow) {
		if(GetRandomFloat() <= g_fTrackChanceArrow)
			value = TrackAll;
		return Plugin_Changed;
	}
	if(Perks_GetClientHas(iClient, g_iIDs[DEMO_HOMINGPIPES]) && projectile == SidewinderPipe) {
		PrintToChat(iClient, "checking track chance");
		if(GetRandomFloat() <= g_fTrackChancePipe)
			value = TrackAll;
		return Plugin_Changed;
	}
	if(Perks_GetClientHas(iClient, g_iIDs[MEDIC_HOMINGNEEDLES]) && projectile == SidewinderSyringe) {
		if(GetRandomFloat() <= g_fTrackChanceNeedle)
			value = TrackAll;
		return Plugin_Changed;
	}
	if(Perks_GetClientHas(iClient, g_iIDs[ENGIE_HOMINGSENTRY]) && projectile == SidewinderSentry) {
		if(GetRandomFloat() <= g_fTrackChanceSentry)
			value = TrackAll;
		return Plugin_Changed;
	}

	return Plugin_Continue;
}
*/