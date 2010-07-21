#if defined _tperks_included_
	#endinput
#endif
#define _tperks_included_

#define MSG_SIZE 128

native Perks_GetCount();
native Perks_GetID(index);
native Perks_GetText(iPerkId, String:PerkText[], size);
native Perks_GetUnique(iPerkId, String:PerkUnique[], size);
native Perks_GetByUnique(String:PerkUnique[]);

native bool:Perks_GetClientHas(iClient, iPerkId);
native Perks_SetClientHas(iClient, iPerkId, bool:bState);
native Perks_Register(String:text[], String:unique[], bool:adminOnly);
native Perks_IsAdminOnly(iPerkId);
native Perks_IsEnabled();
native Perks_UnRegister();

//forward Action:Ads_OnSend(String:sText[],length);