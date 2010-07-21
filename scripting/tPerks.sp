#pragma semicolon 1

#include <sourcemod>
#include <tperks>

#define PL_VERSION		"0.0.1"

#define MAX_PERKS		32

public Plugin:myinfo = {
	name        = "tPerks",
	author      = "Thrawn",
	description = "Powerups to players.",
	version     = PL_VERSION,
	url         = "http://aaa.wallbash.com"
};

enum PERK_INFO {
	id = 0,
	plugin,
	Handle:timer = INVALID_HANDLE,
	bool:adminOnly,
	String:text[MSG_SIZE],
	String:unique[MSG_SIZE]
}


new Handle:g_hCvarEnable;

new bool:g_bEnabled;

new g_hPerks[MAX_PERKS][PERK_INFO];
new g_iCount = 0;

new g_bHasPerk[MAXPLAYERS+1][MAX_PERKS];

public OnPluginStart() {
	CreateConVar("sm_tperks_version", PL_VERSION, "Powerups to players", FCVAR_PLUGIN|FCVAR_SPONLY|FCVAR_REPLICATED|FCVAR_NOTIFY);

	g_hCvarEnable        = CreateConVar("sm_tperks_enabled", "1", "Enable/disable tPerks.", FCVAR_PLUGIN, true, 0.0, true, 1.0);
}

stock TogglePlayerBuffs(iClient, bool:stati = false) {
	for(new i = 0; i < g_iCount; i++) {
		g_bHasPerk[iClient][i] = stati;
	}
}

public OnClientDisconnect(client) {
	TogglePlayerBuffs(client, false);
}

public OnMapEnd() {
	for(new i = 1; i <= MaxClients; i++) {
		TogglePlayerBuffs(i, false);
	}

	g_iCount = 0;

	for(new i=0; i < MAX_PERKS; i++) {
		strcopy(g_hPerks[i][text], MSG_SIZE, "");
		g_hPerks[i][adminOnly] = true;
		g_hPerks[i][plugin] = 0;
		g_hPerks[i][id] = 0;
	}
}

#if SOURCEMOD_V_MAJOR >= 1 && SOURCEMOD_V_MINOR >= 3
	public APLRes:AskPluginLoad2(Handle:myself, bool:late, String:error[], err_max)
#else
	public bool:AskPluginLoad(Handle:myself, bool:late, String:error[], err_max)
#endif
{
	RegPluginLibrary("tperks");

	CreateNative("Perks_GetCount", Native_GetCount);
	CreateNative("Perks_GetText", Native_GetText);
	CreateNative("Perks_GetID", Native_GetID);
	CreateNative("Perks_IsAdminOnly", Native_IsAdminOnly);
	CreateNative("Perks_IsEnabled", Native_IsEnabled);
	CreateNative("Perks_GetClientHas", Native_GetClientHas);
	CreateNative("Perks_SetClientHas", Native_SetClientHas);
	CreateNative("Perks_Register", Native_Register);
	CreateNative("Perks_UnRegister", Native_UnRegister);
	CreateNative("Perks_GetByUnique", Native_GetByUnique);
	CreateNative("Perks_GetUnique", Native_GetUnique);
	#if SOURCEMOD_V_MAJOR >= 1 && SOURCEMOD_V_MINOR >= 3
		return APLRes_Success;
	#else
		return true;
	#endif
}

public OnConfigsExecuted() {
	g_bEnabled = GetConVarBool(g_hCvarEnable);
}

public Native_GetClientHas(Handle:hPlugin, iNumParams) {
	new iClient = GetNativeCell(1);
	new iPerkId = GetNativeCell(2);
	//LogMessage("Checking if client has %i (%s)", iPerkId, g_bHasPerk[iClient][iPerkId] ? "on" : "off");
	return g_bHasPerk[iClient][iPerkId];
}

public Native_IsAdminOnly(Handle:hPlugin, iNumParams) {
	new iPerkId = GetNativeCell(1);

	return g_hPerks[iPerkId][adminOnly];
}

public Native_IsEnabled(Handle:hPlugin, iNumParams) {
	return g_bEnabled;
}

public Native_GetID(Handle:hPlugin, iNumParams) {
	new index = GetNativeCell(1);

	return g_hPerks[index][id];
}

public Native_SetClientHas(Handle:hPlugin, iNumParams) {
	new iClient = GetNativeCell(1);
	new iPerkId = GetNativeCell(2);
	new bool:bState = GetNativeCell(3);

	LogMessage("Client %N now has %s %s", iClient, g_hPerks[iPerkId][text], bState ? "enabled" : "disabled");
	g_bHasPerk[iClient][iPerkId] = bState;
}


public Native_GetCount(Handle:hPlugin, iNumParams) {
	return g_iCount;
}

public Native_GetText(Handle:hPlugin, iNumParams) {
	new iPerkId = GetNativeCell(1);
	new iPerkSize = GetNativeCell(2);

	SetNativeString(2, g_hPerks[iPerkId][text], iPerkSize, false);
}

public Native_GetUnique(Handle:hPlugin, iNumParams) {
	new iPerkId = GetNativeCell(1);
	new iPerkSize = GetNativeCell(2);

	SetNativeString(2, g_hPerks[iPerkId][unique], iPerkSize, false);
}

public Native_GetByUnique(Handle:hPlugin, iNumParams)
{
	new String:sText[MSG_SIZE];
	GetNativeString(1, sText, MSG_SIZE+1);

	for(new i = 0; i < MAX_PERKS; i++) {
		if(StrEqual(g_hPerks[i][unique],sText))
			return g_hPerks[i][id];
	}

	return -1;
}

//native Perks_Register(String:text[], bool:adminOnly);
public Native_Register(Handle:hPlugin, iNumParams) {
	new String:sText[MSG_SIZE];
	GetNativeString(1, sText, MSG_SIZE+1);

	if(g_iCount == MAX_PERKS) {
		LogMessage("Could not register perk, too many perks already: %s", sText);
		return -1;
	}

	new String:sUnique[MSG_SIZE];
	GetNativeString(2, sUnique, MSG_SIZE+1);

	new bool:bAdminOnly = GetNativeCell(3);

	new thisid = g_iCount;
	strcopy(g_hPerks[g_iCount][text], MSG_SIZE, sText);
	strcopy(g_hPerks[g_iCount][unique], MSG_SIZE, sUnique);
	g_hPerks[g_iCount][adminOnly] = bAdminOnly;
	g_hPerks[g_iCount][plugin] = _:hPlugin;
	g_hPerks[g_iCount][id] = thisid;

	LogMessage("Registered Perk: %s (%i)", sText, thisid);
	g_iCount++;

	return thisid;
}

public Native_UnRegister(Handle:hPlugin, iNumParams) {
	for(new i = 0; i < MAX_PERKS; i++) {
		if(g_hPerks[i][plugin] == _:hPlugin) {
			g_hPerks[i][id] = 0;
			g_hPerks[i][plugin] = 0;
			g_hPerks[i][adminOnly] = false;
			strcopy(g_hPerks[i][text], MSG_SIZE, "");
		}
	}
}