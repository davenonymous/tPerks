#include <sourcemod>
#include <sdktools>
#include <tperks>
#include <tfiller>
#include <colors>

#pragma semicolon 1
#define PLUGIN_VERSION "0.1.0"

new g_iSpawns[MAXPLAYERS+1];
new g_iAnnounceInterval = 5;
new g_iClientHasPerk[MAXPLAYERS+1] = {-1,...};

////////////////////////
//P L U G I N  I N F O//
////////////////////////
public Plugin:myinfo =
{
	name = "tPerks, tFiller, ClientMenu",
	author = "Thrawn",
	description = "A plugin for tPerks, providing admins with a menu.",
	version = PLUGIN_VERSION,
	url = "http://thrawn.de"
}

//////////////////////////
//P L U G I N  S T A R T//
//////////////////////////
public OnPluginStart()
{
	RegConsoleCmd("sm_buff", ShowPerkMenu);

	HookEvent("player_spawn", OnPlayerSpawn);
}

public OnClientPutInServer(client) {
	g_iClientHasPerk[client] = -1;

	if(tFiller_IsFiller(client)) {
		new String:sBuff[MSG_SIZE];
		tFiller_GetBuff(client, sBuff, sizeof(sBuff));
		LogMessage("tfiller buff: %s", sBuff);

		if(!(StrEqual(sBuff, "unknown") || StrEqual(sBuff, ""))) {
			new iPerkID = Perks_GetByUnique(sBuff);

			if(iPerkID != -1) {
				Perks_SetClientHas(client, iPerkID, true);
				g_iClientHasPerk[client] = iPerkID;
			}
		}
	}
}

public Action:OnPlayerSpawn(Handle:event, const String:name[], bool:dontBroadcast) {
	if(!Perks_IsEnabled())
		return Plugin_Continue;

	new client = GetClientOfUserId(GetEventInt(event, "userid"));

	if(tFiller_IsFiller(client) && g_iSpawns[client] % g_iAnnounceInterval == 0) {
		CreateTimer(3.0, Timer_FillerJustSpawned, client);
	}
	g_iSpawns[client]++;
	return Plugin_Continue;
}

public Action:Timer_FillerJustSpawned(Handle:timer, any:client) {
	CreateChooserMenu(client);
}

public Action:ShowPerkMenu(client, args)
{
	if(tFiller_IsFiller(client)) {
		CreateChooserMenu(client);
	} else {
		ReplyToCommand(client, "Only server fillers can access this command.\nBe earlier next time ;)");
	}
}

public CreateChooserMenu(client) {
	if(g_iClientHasPerk[client] != -1) {
		new String:sText[MSG_SIZE];
		Perks_GetText(g_iClientHasPerk[client], sText, sizeof(sText));

		CPrintToChat(client, "You've chosen: {olive}%s", sText);
		return;
	}

	new Handle:menu = CreateMenu(ChooserMenu_Handler);

	SetMenuTitle(menu, "Available perks:");

	new iCount = Perks_GetCount();

	new iPerkID;
	for(new i = 0; i < iCount; i++) {
		iPerkID = Perks_GetID(i);

		new String:sText[MSG_SIZE];
		Perks_GetText(iPerkID, sText, sizeof(sText));

		Format(sText, sizeof(sText), "%s (%s)", sText, Perks_GetClientHas(client, iPerkID) ? "on" : "off");

		new String:sID[3];
		IntToString(iPerkID, sID, 4);

		AddMenuItem(menu, sID, sText);
	}

	SetMenuExitButton(menu, true);

	DisplayMenu(menu, client, 20);
}


public ChooserMenu_Handler(Handle:menu, MenuAction:action, param1, param2) {
	//param1:: client
	//param2:: item

	if(action == MenuAction_Select) {
		new String:sID[4];

		/* Get item info */
		GetMenuItem(menu, param2, sID, sizeof(sID));
		new iPerkID = StringToInt(sID);

		Perks_SetClientHas(param1, iPerkID, !Perks_GetClientHas(param1, iPerkID));

		new String:sUnique[MSG_SIZE];
		Perks_GetUnique(iPerkID, sUnique, sizeof(sUnique));
		tFiller_SetBuff(param1, sUnique);

		new String:sText[MSG_SIZE];
		Perks_GetText(iPerkID, sText, sizeof(sText));

		CPrintToChat(param1, "You've chosen: {olive}%s", sText);
	} else if (action == MenuAction_Cancel) {
	} else if (action == MenuAction_End) {
		CloseHandle(menu);
	}
}