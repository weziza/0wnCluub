// This is a comment
// uncomment the line below if you want to write a filterscript
#define FILTERSCRIPT

#include <a_samp>
#include <a_http>
#if defined FILTERSCRIPT

public OnFilterScriptInit()
{
	print("\n--------------------------------------");
	print("        Anti Proxy by Gnikllort         ");
	print("--------------------------------------\n");
	return 1;
}

public OnFilterScriptExit()
{
	return 1;
}

forward MyHttpResponse(playerid, response_code, data[]);



public OnPlayerConnect(playerid)
{
	new ip[16], string[59];
	GetPlayerIp(playerid, ip, sizeof ip);
	format(string, sizeof string, "www.shroomery.org/ythan/proxycheck.php?ip=%s", ip);
	HTTP(playerid, HTTP_GET, string, "", "MyHttpResponse");
    return 1;
}

 
public MyHttpResponse(playerid, response_code, data[])
{
	new name[MAX_PLAYERS],string[256];
	new ip[16];
	GetPlayerName(playerid, name, sizeof(name));
	GetPlayerIp(playerid, ip, sizeof ip);
	if(strcmp(ip, "127.0.0.1", true) == 0)
	{
		format(string, 256, "[LOCALHOST] %s(%d) has joined the server.", name, playerid);
	    SendClientMessageToAll( 0x09F7DFC8, string);
        return 1;
	}
	if(response_code == 200)
	{	
		if(data[0] == 'Y')
		{
			format(string, 256, "[Anti-VPN] %s(%d) has been kicked from the server.", name, playerid);
	    	SendClientMessageToAll( 0xFF0000FF, string);
	    	SendClientMessage(playerid, 0xFF0000FF, "_________Please disable your proxy/VPN and rejoin!_________");
	    	SetTimerEx("DelayedKick", 100, false, "i", playerid);
		}
		if(data[0] == 'N')
		{
			//format(string, 256, "[PROXY NOT DETECTED] %s(%d) thank you for joining!", name, playerid);
	    	//SendClientMessageToAll( 0x09F7DFC8, string );
		}
		if(data[0] == 'X')
		{
			printf("WRONG IP FORMAT");
		}
		else
		{
			printf("The request failed! The response code was: %d", response_code);
		}
	}
	return 1;
}

forward DelayedKick(playerid);
public DelayedKick(playerid)
{
    Kick(playerid);
    return 1;
}


#endif