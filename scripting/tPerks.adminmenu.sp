#include <sourcemod>
#include <sdktools>
#include <tperks>
#include <colors>

#pragma semicolon 1
#define PLUGIN_VERSION "0.1.0"

////////////////////////
//P L U G I N  I N F O//
////////////////////////
public Plugin:myinfo =
{
	name = "tPerks, AdminMenu",
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
	RegAdminCmd("sm_perks", ShowPerkMenu, ADMFLAG_KICK);
}


public Action:ShowPerkMenu(client, args)
{
	CreateChooserMenu(client);
}

public CreateChooserMenu(client) {
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

		CreateChooserMenu(param1);
	} else if (action == MenuAction_Cancel) {
	} else if (action == MenuAction_End) {
		CloseHandle(menu);
	}
}