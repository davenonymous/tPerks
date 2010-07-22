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

new Float:g_fTrackChanceArrow = 0.04;
new Float:g_fTrackChanceRocket = 0.05;
new Float:g_fTrackChancePipe = 0.05;
new Float:g_fTrackChanceNeedle = 0.06;
new Float:g_fTrackChanceFlare = 0.07;
new Float:g_fTrackChanceSentry = 0.10;

public Plugin:myinfo = {
	name        = "tPerks, TF2, Homing Projectiles",
	author      = "Thrawn",
	description = "Powerups for players, Homing Projectiles.",
	version     = PL_VERSION,
	url         = "http://aaa.wallbash.com"
};

public OnPluginStart() {
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
		g_iIDs[ENGIE_HOMINGSENTRY] = Perks_Register("Engie - Homing sentry rockets", "ENGIE_HOMINGSENTRY", false);
	}
}

public OnMapEnd() {
	if(g_bRegister)Perks_UnRegister();
}

public Action:OnSidewinderSeek(iClient, SidewinderEnableFlags:projectile, bool:critical, &TrackType:value) {
	if(Perks_GetClientHas(iClient, g_iIDs[SOLDIER_HOMINGROCKETS]) && projectile == SidewinderRocket) {
		if(GetRandomFloat() <= g_fTrackChanceRocket)
			value = TrackAll;
		return Plugin_Continue;
	}
	if(Perks_GetClientHas(iClient, g_iIDs[PYRO_HOMINGFLARES]) && projectile == SidewinderFlare) {
		if(GetRandomFloat() <= g_fTrackChanceFlare)
			value = TrackAll;
		return Plugin_Continue;
	}
	if(Perks_GetClientHas(iClient, g_iIDs[SNIPER_HOMINGARROWS]) && projectile == SidewinderArrow) {
		if(GetRandomFloat() <= g_fTrackChanceArrow)
			value = TrackAll;
		return Plugin_Continue;
	}
	if(Perks_GetClientHas(iClient, g_iIDs[DEMO_HOMINGPIPES]) && projectile == SidewinderPipe) {
		if(GetRandomFloat() <= g_fTrackChancePipe)
			value = TrackAll;
		return Plugin_Continue;
	}
	if(Perks_GetClientHas(iClient, g_iIDs[MEDIC_HOMINGNEEDLES]) && projectile == SidewinderSyringe) {
		if(GetRandomFloat() <= g_fTrackChanceNeedle)
			value = TrackAll;
		return Plugin_Continue;
	}
	if(Perks_GetClientHas(iClient, g_iIDs[ENGIE_HOMINGSENTRY]) && projectile == SidewinderSentry) {
		if(GetRandomFloat() <= g_fTrackChanceSentry)
			value = TrackAll;
		return Plugin_Continue;
	}

	return Plugin_Continue;
}