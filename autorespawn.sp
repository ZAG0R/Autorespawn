#pragma semicolon 1
#include <sourcemod>
#include <sdktools>
#include <tf2>
#include <morecolors>
new roundTime;
new currentTime; 
new bool:g_bRespawned[MAXPLAYERS + 1];

public OnPluginStart()
{
    HookEvent("teamplay_round_start", Event_RoundStart);
    HookEvent("player_death", Event_PlayerDeath);
}

public Event_RoundStart(Handle:event, const String:name[], bool:dontBroadcast)
{
    roundTime = GetTime();
    for (new i = 1; i <= MaxClients; i++)
        g_bRespawned[i] = false;
    CreateTimer(30.0, auto, _, TIMER_FLAG_NO_MAPCHANGE);
}

public Event_PlayerDeath(Handle:event, const String:name[], bool:dontBroadcast)
{
    currentTime = GetTime();
    
    if (currentTime-roundTime > 30)
        return;
    
    new userid = GetEventInt(event, "userid");
    new client = GetClientOfUserId(userid);
    if (GetClientTeam(client) == TFTeam_Red && !g_bRespawned[client])
        CreateTimer(1.0, ExecRespawn, userid);
    CPrintToChatAll("{tomato}[2.Hayat] {darkorange}%N {salmon}yeniden doğdu.", client);
}
public Action:auto(Handle:timer, any:id)
{
            CPrintToChatAll("{tomato}[2.Hayat] {salmon}yeniden doğma süresi bitti!");
}
public Action:ExecRespawn(Handle:timer, any:userid)
{
    new client = GetClientOfUserId(userid);
    if ( client && (!IsPlayerAlive(client)))
    {
        TF2_RespawnPlayer(client);
        g_bRespawned[client] = true;
    }    
    return Plugin_Stop;
} 

