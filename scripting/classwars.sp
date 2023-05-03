#include <sdkhooks>
#include <sdktools>
#include <sourcemod>
#include <tf2_stocks>
#include <tf2>
#include <halflife>

#pragma newdecls required
#pragma semicolon 1

public Plugin myinfo =
{
	name		= "Class Wars",
	author		= "Gabriel Medici",
	description = "Selects a random class for each team to play with for the whole round",
	version		= "0.1.0",
	url			= "https://github.com/gabrielmedici/classwars"
};

TFClassType bluClass;
TFClassType redClass;

public void OnPluginStart()
{
	HookEvent("player_spawn", OnPlayerSpawn);
	HookEvent("teamplay_round_start", OnRoundStart);
}

void SelectRoundClasses()
{
	bluClass = view_as<TFClassType>(GetRandomInt(1, 9));
	redClass = view_as<TFClassType>(GetRandomInt(1, 9));
}

void AssignClassToPlayer(int client)
{
	if (!IsClientConnected(client))
		return;

	TFTeam clientTeam = TF2_GetClientTeam(client);
	if (clientTeam == TFTeam_Red)
		TF2_SetPlayerClass(client, redClass, true /*ignored*/, true);
	else if (clientTeam == TFTeam_Blue)
		TF2_SetPlayerClass(client, bluClass, true /*ignored*/, true);

	TF2_RegeneratePlayer(client);
}

void AssignClassesToAll()
{
	for (int i = 1; i <= MaxClients; i++)
		AssignClassToPlayer(i);
}

// ==================== Events =======================
public void OnMapStart()
{
	SelectRoundClasses();
}

void OnRoundStart(Event event, const char[] name, bool dontBroadcast)
{
	SelectRoundClasses();
	AssignClassesToAll();
}

void OnPlayerSpawn(Event event, const char[] name, bool dontBroadcast)
{
	int client = GetClientOfUserId(GetEventInt(event, "userid"));

	if (TF2_GetClientTeam(client) != TFTeam_Red && TF2_GetClientTeam(client) != TFTeam_Blue)
		return;

	AssignClassToPlayer(client);
}
