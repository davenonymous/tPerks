#pragma semicolon 1

#include <sourcemod>
#include <tperks>
#include <tf2items>
#include <tf2_stocks>
#include <sdkhooks>

#define PL_VERSION		"0.0.1"

enum Buffs {
	PYRO_AIRBLAST = 0
}

new g_iOffsetAmmo;

new g_bButtonDown[MAXPLAYERS+1] = {false, ...};
new g_bCanBoost[MAXPLAYERS+1] = {true, ...};

new g_iIDs[Buffs];
new g_bRegister = false;

new Handle:g_hCvarPower;

new Float:g_fPower;

public Plugin:myinfo = {
	name        = "tPerks, TF2, Pyro Airblast",
	author      = "Thrawn",
	description = "Powerups for players, Pyro Airblast.",
	version     = PL_VERSION,
	url         = "http://aaa.wallbash.com"
};

public OnPluginStart() {
	g_iOffsetAmmo = FindSendPropInfo("CTFPlayer", "m_iAmmo");
	g_hCvarPower = CreateConVar("sm_tperks_tf_airblast_power", "300.0", "Airblast power. (Def.: 300.0)", FCVAR_PLUGIN, true, 0.0);

	HookConVarChange(g_hCvarPower, Cvar_Changed);

	HookEvent("player_spawn", OnPlayerSpawn);
}

public OnConfigsExecuted()
{
	g_fPower = GetConVarFloat(g_hCvarPower);
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
		g_iIDs[PYRO_AIRBLAST] = Perks_Register("Pyro - Blast yourself into the air", "PYRO_AIRBLAST", false);
	}
}

public OnMapEnd() {
	if(g_bRegister)
		Perks_UnRegister();
}

public OnPlayerSpawn(Handle:event, const String:name[], bool:dontBroadcast) {
	new iClient = GetClientOfUserId(GetEventInt(event, "userid"));

	if(Perks_GetClientHas(iClient, g_iIDs[PYRO_AIRBLAST]) && TF2_GetPlayerClass(iClient) == TFClass_Pyro) {
		SDKHook(iClient, SDKHook_PreThink, PyroBlast_OnPreThink);
	}
}

public PyroBlast_OnPreThink(client) {
	if(!IsPlayerAlive(client) || TF2_GetPlayerClass(client) != TFClass_Pyro) {
		SDKUnhook(client, SDKHook_PreThink, PyroBlast_OnPreThink);
		return;
	}

	new iButtons = GetClientButtons(client);
	if(iButtons & IN_ATTACK2) {
		if(!g_bButtonDown[client]) {
			AirBoost(client);

			g_bButtonDown[client] = true;
		}
	} else {
		g_bButtonDown[client] = false;
	}
}


AirBoost(client)
{
    new ammo = GetEntData(client, g_iOffsetAmmo+4, 4);

    if(!(GetEntityFlags(client)&FL_ONGROUND) && ammo >= 20 && g_bCanBoost[client])
    {
    	//Does not work for backburner
		new iEnt = GetPlayerWeaponSlot(client, 0);
		new iItemDefinition = GetEntProp(iEnt, Prop_Send, "m_iItemDefinitionIndex");

		if(iItemDefinition != 21)
			return;

		decl Float:vecAng[3], Float:vecVel[3];
		GetClientEyeAngles(client, vecAng);
		GetEntPropVector(client, Prop_Data, "m_vecVelocity", vecVel);
		vecAng[0] *= -1.0;
		vecAng[0] = DegToRad(vecAng[0]);
		vecAng[1] = DegToRad(vecAng[1]);
		vecVel[0] -= g_fPower*Cosine(vecAng[0])*Cosine(vecAng[1]);
		vecVel[1] -= g_fPower*Cosine(vecAng[0])*Sine(vecAng[1]);
		vecVel[2] -= g_fPower*Sine(vecAng[0]);
		TeleportEntity(client, NULL_VECTOR, NULL_VECTOR, vecVel);
		g_bCanBoost[client] = false;

		CreateTimer(1.0,Timer_CanBoostAgain,client);
    }
}

public Action:Timer_CanBoostAgain(Handle:timer, any:client)
{
    g_bCanBoost[client] = true;
}