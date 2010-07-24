#pragma semicolon 1

#include <sourcemod>
#include <tperks>
#include <tf2items>
#include <tf2_stocks>


#define PL_VERSION		"0.0.1"

enum Buffs {
	MULTI_PAINTRAIN = 0,
	DEMO_EXTRAPIPES = 1,
	SOLDIER_EXTRAROCKETS = 2,
	HEAVY_FISTSGIVESPEED = 3,
	SNIPER_BLEEDINGHUNTSMAN = 4,
	MEDIC_UBERSAWBUFF = 5,
	SPY_NORMALWATCHBUFF = 6,
	MEDIC_GOODSTART = 7,
	SOLDIER_EXTRAROCKETAMMO = 8,
	DEMO_EXTRAPIPEAMMO = 9
}

new g_iIDs[Buffs];
new g_iQuality = 6;
new g_bRegister = false;

public Plugin:myinfo = {
	name        = "tPerks, TF2, TF2Items",
	author      = "Thrawn",
	description = "Powerups to players, modified weapons.",
	version     = PL_VERSION,
	url         = "http://aaa.wallbash.com"
};

public OnAllPluginsLoaded() {
	if(LibraryExists("tperks")) {
		g_bRegister = true;
	}
}

public OnMapStart() {
	if(g_bRegister) {
		//g_iIDs[ENGINEER_MOREMETAL] = Perks_Register("Engineer - More Metal", "ENGINEER_MOREMETAL", false);
		g_iIDs[DEMO_EXTRAPIPES] = Perks_Register("Demoman - Extra Pipes", "DEMO_EXTRAPIPES", true);
		g_iIDs[DEMO_EXTRAPIPEAMMO] = Perks_Register("Demoman - Extra Pipe ammo", "DEMO_EXTRAPIPEAMMO", false);
		g_iIDs[SOLDIER_EXTRAROCKETS] = Perks_Register("Soldier - Extra Rockets", "SOLDIER_EXTRAROCKETS", true);
		g_iIDs[SOLDIER_EXTRAROCKETAMMO] = Perks_Register("Soldier - Extra Rocket ammo", "SOLDIER_EXTRAROCKETAMMO", false);
		g_iIDs[HEAVY_FISTSGIVESPEED] = Perks_Register("Heavy - Movement speed bonus with fists", "HEAVY_FISTSGIVESPEED", false);
		g_iIDs[SNIPER_BLEEDINGHUNTSMAN] = Perks_Register("Sniper - Huntsman does bleeding damage", "SNIPER_BLEEDINGHUNTSMAN", false);
		g_iIDs[MEDIC_UBERSAWBUFF] = Perks_Register("Medic - Ubersaw gives 35% charge on hit", "MEDIC_UBERSAWBUFF", false);
		g_iIDs[SPY_NORMALWATCHBUFF] = Perks_Register("Spy - Normal watch: Decreased consume rate", "SPY_NORMALWATCHBUFF", false);
		g_iIDs[MEDIC_GOODSTART] = Perks_Register("Medic - Spawn with 20% charge", "MEDIC_GOODSTART", false);
		g_iIDs[MULTI_PAINTRAIN] = Perks_Register("Demo/Soli - Better Paintrain", "MULTI_PAINTRAIN", false);
	}
}

public OnMapEnd() {
	if(g_bRegister)
		Perks_UnRegister();
}

public Action:TF2Items_OnGiveNamedItem(iClient, String:strClassName[], iItemDefinitionIndex, &Handle:hItemOverride) {
	if (hItemOverride != INVALID_HANDLE)
		return Plugin_Continue; // Plugin_Changed

	if (StrEqual(strClassName, "tf_weapon_grenadelauncher") && Perks_GetClientHas(iClient, g_iIDs[DEMO_EXTRAPIPES])) {
		new Handle:hTest = TF2Items_CreateItem(OVERRIDE_ATTRIBUTES|OVERRIDE_ITEM_QUALITY);
		TF2Items_SetNumAttributes(hTest, 1);
		TF2Items_SetAttribute(hTest, 0,  4, 1.5);				// give 50% more pipes
		TF2Items_SetQuality(hTest, g_iQuality);
		hItemOverride = hTest;
		return Plugin_Changed;
	}

	if (StrEqual(strClassName, "tf_weapon_grenadelauncher") && Perks_GetClientHas(iClient, g_iIDs[DEMO_EXTRAPIPEAMMO])) {
		new Handle:hTest = TF2Items_CreateItem(OVERRIDE_ATTRIBUTES|OVERRIDE_ITEM_QUALITY);
		TF2Items_SetNumAttributes(hTest, 1);
		TF2Items_SetAttribute(hTest, 0,  37, 1.3);				// give 30% more ammo
		TF2Items_SetQuality(hTest, g_iQuality);
		hItemOverride = hTest;
		return Plugin_Changed;
	}

	if (StrEqual(strClassName, "tf_weapon_rocketlauncher") && Perks_GetClientHas(iClient, g_iIDs[SOLDIER_EXTRAROCKETS])) {
		new Handle:hTest = TF2Items_CreateItem(OVERRIDE_ATTRIBUTES|OVERRIDE_ITEM_QUALITY);
		TF2Items_SetNumAttributes(hTest, 1);
		TF2Items_SetAttribute(hTest, 0,  4, 1.5);				// give 50% more rockets
		TF2Items_SetQuality(hTest, g_iQuality);
		hItemOverride = hTest;
		return Plugin_Changed;
	}

	if (StrEqual(strClassName, "tf_weapon_rocketlauncher_directhit") && Perks_GetClientHas(iClient, g_iIDs[SOLDIER_EXTRAROCKETS])) {
		new Handle:hTest = TF2Items_CreateItem(OVERRIDE_ATTRIBUTES|OVERRIDE_ITEM_QUALITY);
		TF2Items_SetNumAttributes(hTest, 5);
		TF2Items_SetAttribute(hTest, 0,  4, 1.5);				// give 50% more rockets
		TF2Items_SetAttribute(hTest, 1,  100, 0.3);
		TF2Items_SetAttribute(hTest, 2,  103, 1.8);
		TF2Items_SetAttribute(hTest, 3,  2, 1.25);
		TF2Items_SetAttribute(hTest, 4,  114, 1.0);
		TF2Items_SetQuality(hTest, g_iQuality);
		hItemOverride = hTest;
		return Plugin_Changed;
	}

	if (StrEqual(strClassName, "tf_weapon_rocketlauncher") && Perks_GetClientHas(iClient, g_iIDs[SOLDIER_EXTRAROCKETAMMO])) {
		new Handle:hTest = TF2Items_CreateItem(OVERRIDE_ATTRIBUTES|OVERRIDE_ITEM_QUALITY);
		TF2Items_SetNumAttributes(hTest, 1);
		TF2Items_SetAttribute(hTest, 0,  37, 1.2);				// give 20% more ammo
		TF2Items_SetQuality(hTest, g_iQuality);
		hItemOverride = hTest;
		return Plugin_Changed;
	}

	if (StrEqual(strClassName, "tf_weapon_rocketlauncher_directhit") && Perks_GetClientHas(iClient, g_iIDs[SOLDIER_EXTRAROCKETAMMO])) {
		new Handle:hTest = TF2Items_CreateItem(OVERRIDE_ATTRIBUTES|OVERRIDE_ITEM_QUALITY);
		TF2Items_SetNumAttributes(hTest, 5);
		TF2Items_SetAttribute(hTest, 0,  37, 1.2);				// give 20% more ammo
		TF2Items_SetAttribute(hTest, 1,  100, 0.3);
		TF2Items_SetAttribute(hTest, 2,  103, 1.8);
		TF2Items_SetAttribute(hTest, 3,  2, 1.25);
		TF2Items_SetAttribute(hTest, 4,  114, 1.0);
		TF2Items_SetQuality(hTest, g_iQuality);
		hItemOverride = hTest;
		return Plugin_Changed;
	}


	if (iItemDefinitionIndex == 43 && Perks_GetClientHas(iClient, g_iIDs[HEAVY_FISTSGIVESPEED])) {
		new Handle:hTest = TF2Items_CreateItem(OVERRIDE_ATTRIBUTES|OVERRIDE_ITEM_QUALITY);
		TF2Items_SetNumAttributes(hTest, 4);
		TF2Items_SetAttribute(hTest, 0,  107, 1.3);				// give 30% more movement speed
		TF2Items_SetAttribute(hTest, 1,  31, 5.0);
		TF2Items_SetAttribute(hTest, 2,  5, 1.2);
		TF2Items_SetAttribute(hTest, 3,  128, 1.0);				// when equipped only
		TF2Items_SetQuality(hTest, g_iQuality);
		hItemOverride = hTest;
		return Plugin_Changed;
	}

	if (iItemDefinitionIndex == 5 && Perks_GetClientHas(iClient, g_iIDs[HEAVY_FISTSGIVESPEED])) {
		new Handle:hTest = TF2Items_CreateItem(OVERRIDE_ATTRIBUTES|OVERRIDE_ITEM_QUALITY);
		TF2Items_SetNumAttributes(hTest, 2);
		TF2Items_SetAttribute(hTest, 0,  107, 1.3);				// give 30% more movement speed
		TF2Items_SetAttribute(hTest, 1,  128, 1.0);				// when equipped only
		TF2Items_SetQuality(hTest, g_iQuality);
		hItemOverride = hTest;
		return Plugin_Changed;
	}

	if (iItemDefinitionIndex == 56 && Perks_GetClientHas(iClient, g_iIDs[SNIPER_BLEEDINGHUNTSMAN])) {
		new Handle:hTest = TF2Items_CreateItem(OVERRIDE_ATTRIBUTES|OVERRIDE_ITEM_QUALITY);
		TF2Items_SetNumAttributes(hTest, 2);
		TF2Items_SetAttribute(hTest, 0,  37, 0.5);
		TF2Items_SetAttribute(hTest, 1,  149, 5.0);				// 5s bleeding damage
		TF2Items_SetQuality(hTest, g_iQuality);
		hItemOverride = hTest;
		return Plugin_Changed;
	}

	if (iItemDefinitionIndex == 37 && Perks_GetClientHas(iClient, g_iIDs[MEDIC_UBERSAWBUFF])) {
		new Handle:hTest = TF2Items_CreateItem(OVERRIDE_ATTRIBUTES|OVERRIDE_ITEM_QUALITY);
		TF2Items_SetNumAttributes(hTest, 2);
		TF2Items_SetAttribute(hTest, 0,  17, 0.35);
		TF2Items_SetAttribute(hTest, 1,  5, 1.25);
		TF2Items_SetQuality(hTest, g_iQuality);
		hItemOverride = hTest;
		return Plugin_Changed;
	}

	if (iItemDefinitionIndex == 30 && Perks_GetClientHas(iClient, g_iIDs[SPY_NORMALWATCHBUFF])) {
		new Handle:hTest = TF2Items_CreateItem(OVERRIDE_ATTRIBUTES|OVERRIDE_ITEM_QUALITY);
		TF2Items_SetNumAttributes(hTest, 1);
		TF2Items_SetAttribute(hTest, 0,  34, 0.5);
		TF2Items_SetQuality(hTest, g_iQuality);
		hItemOverride = hTest;
		return Plugin_Changed;
	}

	if (iItemDefinitionIndex == 154 && Perks_GetClientHas(iClient, g_iIDs[MULTI_PAINTRAIN])) {
		new Handle:hTest = TF2Items_CreateItem(OVERRIDE_ATTRIBUTES|OVERRIDE_ITEM_QUALITY);
		TF2Items_SetNumAttributes(hTest, 1);
		TF2Items_SetAttribute(hTest, 0,  68, 1.0);
		TF2Items_SetQuality(hTest, g_iQuality);
		hItemOverride = hTest;
		return Plugin_Changed;
	}

	if((iItemDefinitionIndex == 35 || iItemDefinitionIndex == 29) && Perks_GetClientHas(iClient, g_iIDs[MEDIC_GOODSTART])) {
		CreateTimer(0.1, Medic_FillChargeMeter, iClient);
	}

	return Plugin_Continue;
}

public Action:Medic_FillChargeMeter(Handle:timer, any:data) {
	new weapon = GetPlayerWeaponSlot(data, 1);
	if (IsValidEntity(weapon))
	{
		if(GetEntPropFloat(weapon, Prop_Send, "m_flChargeLevel") <= 0.21)
			SetEntPropFloat(weapon, Prop_Send, "m_flChargeLevel", 0.21);
	}
}
