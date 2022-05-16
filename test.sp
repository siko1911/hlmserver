#include <sourcemod>
#include <cstrike>
#include <colorvariables>
#include <sdktools_sound>

#pragma semicolon 1
#pragma newdecls required

#define PLUGIN_VERSION "0.00"

int Items[32][2];

public Plugin myinfo = 
{
	name = "Test Plugins By 曹达华",
	author = "曹达华",
	description = "简单测试信息输出",
	version = "1.0",
	url = "NO-URL-YET"
};

public void OnPluginStart()
{
	RegConsoleCmd("sm_sn", Cmd_SetNumber, "");
	RegConsoleCmd("sm_gn", Cmd_GetNumber, "");
	
	RegConsoleCmd("sm_green", c_green);
	RegConsoleCmd("sm_red", c_red);
	RegConsoleCmd("sm_lime", c_lime);
	PrecacheSound("*/go.mp3",true);
	RegConsoleCmd("sm_hm", Cmd_hm);
	RegConsoleCmd("sm_cm", Cmd_cm);
	
	RegConsoleCmd("sm_menu", Cmd_menu, "");
}

public void OnClientPutInServer(int client)
{
	char name[32];
	char authid[32];
	
	GetClientName(client, name, sizeof(name));
	GetClientAuthId(client, AuthId_Steam3, authid, sizeof(authid));
	
	CPrintToChatAll("{red}【服务器消息】{green}%s[%s]加入游戏！", name, authid);
	CPrintToChatAll("{lime}-===========-欢迎这个逼！！！-===========-");
	EmitSoundToAll("*/go.mp3" );
	
	CreateTimer(1.0, HUD, client, TIMER_REPEAT);
	
	
}

public Action HUD(Handle timer, any client)
{
	if(IsClientConnected(client) && IsClientInGame(client))
	{
		char uname[32];
		char mapname[128];
		char nextmapname[128];
		GetClientName(client, uname, sizeof(uname));
		GetCurrentMap(mapname, sizeof(mapname));
		GetNextMap(nextmapname, sizeof(nextmapname));
		SetHudTextParams(0.1, 0.1, 20.0, 0, 200, 0, 100, 0, 6.0, 1.0, 1.0);
		ShowHudText(client, -1, "哈哈哈哈哈哈\n%s真的是牛逼！\n当前地图是：%s\n下一张地图是：%s", uname, mapname, nextmapname);
		
	}
	return Plugin_Handled;
}

public Action c_green(int client, int args)
{
	CPrintToChatAll("{green}绿色-Green");
	return Plugin_Handled;
}

public Action c_red(int client, int args)
{
	CPrintToChatAll("{red}红色-Red");
	return Plugin_Handled;
}

public Action c_lime(int client, int args)
{
	CPrintToChatAll("{lime}浅绿色-lime");
	return Plugin_Handled;
}

public Action Cmd_SetNumber(int client, int args)
{
	if (args < 1)
	{
		CPrintToChat(client, "{red}[SM] {lime}请输入一个数字！");
		return Plugin_Handled;
	}
	
	char arg1[32];
	int arg1int;
	
	GetCmdArg(1, arg1, sizeof(arg1));
	
	arg1int = StringToInt(arg1);
	
	Items[client][0] = arg1int;
	Items[client][1] = arg1int * 2;
	CPrintToChat(client, "{red}[SM] {lime}数字%d已经被存储!", Items[client][0]);
	
	return Plugin_Handled;
}

public Action Cmd_GetNumber(int client, int args)
{
	if (Items[client][0] == 0)
	{
		CPrintToChat(client, "{red}[SM] {lime}没有输入任何数字使用!sn <数字>来设置！");
		return Plugin_Handled;
	} else {
		CPrintToChat(client, "{red}[SM] {lime}你存储的数字是%d。翻倍以后是%d", Items[client][0], Items[client][1]);
		return Plugin_Handled;
	}
}

public Action Cmd_hm(int client, int args)
{
	PrintHintTextToAll("这是hint消息");
	return Plugin_Handled;
}

public Action Cmd_cm(int client, int args)
{
	PrintCenterTextAll("这是center消息");
	return Plugin_Handled;
}

public Action Cmd_menu(int client, int args)
{
	Menu menu = new Menu(Menu_Callback);
	menu.SetTitle("菜单导航");
	menu.AddItem("option1", "选择武器/刀的皮肤");
	menu.AddItem("option2", "选择刀型");
	menu.AddItem("option3", "选择手套");
	menu.AddItem("option4", "选择人物模型");
	menu.AddItem("option5", "选择武器贴纸");
	menu.Display(client, 30);
	return Plugin_Handled;
}

public int Menu_Callback(Menu menu, MenuAction action, int arg1, int arg2)
{
	switch (action) {
		case MenuAction_Select:
		{
			char item[32];
			menu.GetItem(arg2, item, sizeof(item));
			
			if (StrEqual(item, "option1"))
			{
				CPrintToChat(arg1, "{red}[菜单]{lime}你选择的是（%s）", item);
				FakeClientCommand(arg1, "say !ws");
			} 
			else if (StrEqual(item, "option2"))
			{
				CPrintToChat(arg1, "{red}[菜单]{lime}你选择的是（%s）", item);
				FakeClientCommand(arg1, "say !knife");
			}
			else if (StrEqual(item, "option3"))
			{
				CPrintToChat(arg1, "{red}[菜单]{lime}你选择的是（%s）", item);
				FakeClientCommand(arg1, "say !gloves");
			}
			else if (StrEqual(item, "option4"))
			{
				CPrintToChat(arg1, "{red}[菜单]{lime}你选择的是（%s）", item);
				FakeClientCommand(arg1, "say !models");
			}
			else if (StrEqual(item, "option5"))
			{
				CPrintToChat(arg1, "{red}[菜单]{lime}你选择的是（%s）", item);
				FakeClientCommand(arg1, "say !stickers");
			}
		}
		case MenuAction_End:
		{
			delete menu;
		}
	}
	return 1;
}