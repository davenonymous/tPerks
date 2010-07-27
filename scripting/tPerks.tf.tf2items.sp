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
	DEMO_EXTRAPIPEAMMO = 9,
	SNIPER_FASTERCHARGE = 10,
	SCOUT_SCATTERRELOAD = 11,
	MEDIC_ANTISAPPER = 12,
	HEAVY_HEALTHYCHOCOLATE = 13,
	ENGINEER_METALPISTOL = 14,
	ENGINEER_BUILDINGPUMPGUN = 15,
	HEAVY_FASTERSPIN = 16,
	SOLDIER_BIGBLAST = 17,
	DEMO_MOREALIVESTICKS = 18,
//	HEAVY_ACCURATENATASHA = 19
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
		g_iIDs[DEMO_EXTRAPIPES] = Perks_Register("Demoman - Extra Pipes", "DEMO_EXTRAPIPES", true);
		g_iIDs[DEMO_EXTRAPIPEAMMO] = Perks_Register("Demoman - Extra Pipe ammo", "DEMO_EXTRAPIPEAMMO", false);
		g_iIDs[SOLDIER_EXTRAROCKETS] = Perks_Register("Soldier - Extra Rockets", "SOLDIER_EXTRAROCKETS", true);
		g_iIDs[SOLDIER_EXTRAROCKETAMMO] = Perks_Register("Soldier - Extra Rocket ammo", "SOLDIER_EXTRAROCKETAMMO", false);
		g_iIDs[HEAVY_FISTSGIVESPEED] = Perks_Register("Heavy - Movement speed bonus with fists", "HEAVY_FISTSGIVESPEED", false);
		g_iIDs[SNIPER_BLEEDINGHUNTSMAN] = Perks_Register("Sniper - Huntsman does bleeding damage", "SNIPER_BLEEDINGHUNTSMAN", false);
		g_iIDs[MEDIC_UBERSAWBUFF] = Perks_Register("Medic - Ubersaw gives more charge on hit", "MEDIC_UBERSAWBUFF", false);
		g_iIDs[SPY_NORMALWATCHBUFF] = Perks_Register("Spy - Normal watch: Decreased consume rate", "SPY_NORMALWATCHBUFF", false);
		g_iIDs[MEDIC_GOODSTART] = Perks_Register("Medic - Spawn with 20% charge", "MEDIC_GOODSTART", false);
		g_iIDs[MULTI_PAINTRAIN] = Perks_Register("Demo/Soli - Better Paintrain", "MULTI_PAINTRAIN", false);
		g_iIDs[SNIPER_FASTERCHARGE] = Perks_Register("Sniper - Charge Rifle faster", "SNIPER_FASTERCHARGE", false);
		g_iIDs[SCOUT_SCATTERRELOAD] = Perks_Register("Scout - Faster scattergun reload", "SCOUT_SCATTERRELOAD", false);
		g_iIDs[MEDIC_ANTISAPPER] = Perks_Register("Medic - Needles can remove sappers", "MEDIC_ANTISAPPER", false);
		g_iIDs[HEAVY_HEALTHYCHOCOLATE] = Perks_Register("Heavy - Chocolate gives extra heal from medics", "HEAVY_HEALTHYCHOCOLATE", false);
		g_iIDs[ENGINEER_METALPISTOL] = Perks_Register("Engineer - Metalregeneration when wearing pistol", "ENGINEER_METALPISTOL", false);
		g_iIDs[ENGINEER_BUILDINGPUMPGUN] = Perks_Register("Engineer - Shotgun has increased damage vs buildings", "ENGINEER_BUILDINGPUMPGUN", false);
		g_iIDs[HEAVY_FASTERSPIN] = Perks_Register("Heavy - Faster sasha spinup", "HEAVY_FASTERSPIN", false);
		g_iIDs[SOLDIER_BIGBLAST] = Perks_Register("Soldier - Increased blast radius", "SOLDIER_BIGBLAST", false);
		g_iIDs[DEMO_MOREALIVESTICKS] = Perks_Register("Demoman - Place more stickies", "DEMO_MOREALIVESTICKS", false);
		//g_iIDs[HEAVY_ACCURATENATASHA] = Perks_Register("Heavy - Increased natasha accuracy", "HEAVY_ACCURATENATASHA", false);
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

	if (iItemDefinitionIndex == 13 && Perks_GetClientHas(iClient, g_iIDs[SCOUT_SCATTERRELOAD])) {
		new Handle:hTest = TF2Items_CreateItem(OVERRIDE_ATTRIBUTES|OVERRIDE_ITEM_QUALITY);
		TF2Items_SetNumAttributes(hTest, 1);
		TF2Items_SetAttribute(hTest, 0,  97, 0.8);		// only takes 80% of time to reload
		TF2Items_SetQuality(hTest, g_iQuality);
		hItemOverride = hTest;
		return Plugin_Changed;
	}

	if (iItemDefinitionIndex == 14 && Perks_GetClientHas(iClient, g_iIDs[SNIPER_FASTERCHARGE])) {
		new Handle:hTest = TF2Items_CreateItem(OVERRIDE_ATTRIBUTES|OVERRIDE_ITEM_QUALITY);
		TF2Items_SetNumAttributes(hTest, 1);
		TF2Items_SetAttribute(hTest, 0,  90, 1.2);		// 20% faster charge
		TF2Items_SetQuality(hTest, g_iQuality);
		hItemOverride = hTest;
		return Plugin_Changed;
	}

	if (iItemDefinitionIndex == 17 && Perks_GetClientHas(iClient, g_iIDs[MEDIC_ANTISAPPER])) {
		new Handle:hTest = TF2Items_CreateItem(OVERRIDE_ATTRIBUTES|OVERRIDE_ITEM_QUALITY);
		TF2Items_SetNumAttributes(hTest, 1);
		TF2Items_SetAttribute(hTest, 0,  146, 1.0);		// Damage applies to sappers
		TF2Items_SetQuality(hTest, g_iQuality);
		hItemOverride = hTest;
		return Plugin_Changed;
	}

	if (iItemDefinitionIndex == 36 && Perks_GetClientHas(iClient, g_iIDs[MEDIC_ANTISAPPER])) {
		new Handle:hTest = TF2Items_CreateItem(OVERRIDE_ATTRIBUTES|OVERRIDE_ITEM_QUALITY);
		TF2Items_SetNumAttributes(hTest, 3);
		TF2Items_SetAttribute(hTest, 0,  146, 1.0);		// Damage applies to sappers
		TF2Items_SetAttribute(hTest, 1,  16, 3.0);
		TF2Items_SetAttribute(hTest, 2,  129, -3.0);
		TF2Items_SetQuality(hTest, g_iQuality);
		hItemOverride = hTest;
		return Plugin_Changed;
	}


	if (iItemDefinitionIndex == 159 && Perks_GetClientHas(iClient, g_iIDs[HEAVY_HEALTHYCHOCOLATE])) {
		new Handle:hTest = TF2Items_CreateItem(OVERRIDE_ATTRIBUTES|OVERRIDE_ITEM_QUALITY);
		TF2Items_SetNumAttributes(hTest, 2);
		TF2Items_SetAttribute(hTest, 0,  70, 1.15);		// 15% faster heal from medics
		TF2Items_SetAttribute(hTest, 1,  139, 1.0);
		TF2Items_SetQuality(hTest, g_iQuality);
		hItemOverride = hTest;
		return Plugin_Changed;
	}

	if (iItemDefinitionIndex == 22 && Perks_GetClientHas(iClient, g_iIDs[ENGINEER_METALPISTOL])) {
		new Handle:hTest = TF2Items_CreateItem(OVERRIDE_ATTRIBUTES|OVERRIDE_ITEM_QUALITY);
		TF2Items_SetNumAttributes(hTest, 2);
		TF2Items_SetAttribute(hTest, 0,  113, 15.0);		// 15 metal every 5s
		TF2Items_SetAttribute(hTest, 1,  128, 1.0);			// only when active weapon
		TF2Items_SetQuality(hTest, g_iQuality);
		hItemOverride = hTest;
		return Plugin_Changed;
	}

	if (iItemDefinitionIndex == 9 && Perks_GetClientHas(iClient, g_iIDs[ENGINEER_BUILDINGPUMPGUN])) {
		new Handle:hTest = TF2Items_CreateItem(OVERRIDE_ATTRIBUTES|OVERRIDE_ITEM_QUALITY);
		TF2Items_SetNumAttributes(hTest, 1);
		TF2Items_SetAttribute(hTest, 0,  137, 1.2);		// 20% more damage vs buildings
		TF2Items_SetQuality(hTest, g_iQuality);
		hItemOverride = hTest;
		return Plugin_Changed;
	}

	if (iItemDefinitionIndex == 15 && Perks_GetClientHas(iClient, g_iIDs[HEAVY_FASTERSPIN])) {
		new Handle:hTest = TF2Items_CreateItem(OVERRIDE_ATTRIBUTES|OVERRIDE_ITEM_QUALITY);
		TF2Items_SetNumAttributes(hTest, 1);
		TF2Items_SetAttribute(hTest, 0,  87, 0.6);		// 40% faster minigun spinup
		TF2Items_SetQuality(hTest, g_iQuality);
		hItemOverride = hTest;
		return Plugin_Changed;
	}

	if (iItemDefinitionIndex == 18 && Perks_GetClientHas(iClient, g_iIDs[SOLDIER_BIGBLAST])) {
		new Handle:hTest = TF2Items_CreateItem(OVERRIDE_ATTRIBUTES|OVERRIDE_ITEM_QUALITY);
		TF2Items_SetNumAttributes(hTest, 1);
		TF2Items_SetAttribute(hTest, 0,  99, 1.3);		// 30% increased blast radius
		TF2Items_SetQuality(hTest, g_iQuality);
		hItemOverride = hTest;
		return Plugin_Changed;
	}

	if (iItemDefinitionIndex == 20 && Perks_GetClientHas(iClient, g_iIDs[DEMO_MOREALIVESTICKS])) {
		new Handle:hTest = TF2Items_CreateItem(OVERRIDE_ATTRIBUTES|OVERRIDE_ITEM_QUALITY);
		TF2Items_SetNumAttributes(hTest, 1);
		TF2Items_SetAttribute(hTest, 0,  88, 2.0);		// 2 more life stickies
		TF2Items_SetQuality(hTest, g_iQuality);
		hItemOverride = hTest;
		return Plugin_Changed;
	}
/*
	if (iItemDefinitionIndex == 41 && Perks_GetClientHas(iClient, g_iIDs[HEAVY_ACCURATENATASHA])) {
		new Handle:hTest = TF2Items_CreateItem(OVERRIDE_ATTRIBUTES|OVERRIDE_ITEM_QUALITY);
		TF2Items_SetNumAttributes(hTest, 3);
		TF2Items_SetAttribute(hTest, 0,  106, 0.8);		// 20% less spread
		TF2Items_SetAttribute(hTest, 0,  32, 1.0);
		TF2Items_SetAttribute(hTest, 0,  1, 0.75);
		TF2Items_SetQuality(hTest, g_iQuality);
		hItemOverride = hTest;
		return Plugin_Changed;
	}
*/




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
