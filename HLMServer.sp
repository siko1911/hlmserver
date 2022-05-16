#include <sourcemod>
#include <cstrike>
#include <multicolors>
#include <sdktools_sound>

#pragma semicolon 1
#pragma newdecls required

public Plugin myinfo = 
{
	name = "红浪漫服务器基本插件 By 曹达华",
	author = "曹达华",
	description = "红浪漫服务器基本功能插件",
	version = "1.0",
	url = "HLM.NET"
};

public void OnPluginStart()
{
	RegConsoleCmd("sm_nav", Cmd_nav, ""); //注册!nav命令

}

public bool OnClientConnect(int client)
{
	//当用户连接服务器时，给出提示
	char name[32];
	GetClientName(client, name, sizeof(name));
	CPrintToChatAll("{red}[HLM服务器消息]{lime}-%s-正在连接服务器...", name);
	
	return true;
}

public void OnClientConnected(int client)
{
	//当用户连接服务器成功时，给出提示
	char name[32];
	GetClientName(client, name, sizeof(name));
	CPrintToChatAll("{red}[HLM服务器消息]{lime}-%s-连接服务器成功！", name);
}

public void OnClientPutInServer(int client)
{
	//当用户进入服务器时，给出欢迎信息
	char name[32];
	char uid[32];
	GetClientName(client, name, sizeof(name));
	GetClientAuthId(client, AuthId_Steam3, uid, sizeof(uid));
	CPrintToChatAll("{red}[HLM服务器消息]{lime}欢迎%s[%s]进入游戏！祝您玩的愉快！", name, uid);

	//当用户进入服务器时，播放声音并绑定按键

	for (int i = 1; i < MaxClients ; i++)
	{
		if (IsClientInGame(i) && IsClientConnected(i))
		{
			ClientCommand(i, "play *go.mp3"); //播放声音
			FakeClientCommandEx(i, "bind F3 \"say !nav\""); //绑定按键

			//HUD消息提示，测试功能
			SetHudTextParams(-1.0, 0.2, 10.0, 0, 0, 255, 100, 2, 6.0, 1.0, 2.0);
			ShowHudText(i, -1, "欢迎加入红浪漫会所，祝您玩的愉快！");

		}
	}

	
}

public Action Cmd_nav(int client, int args)
{
	Menu nav_menu = new Menu(MenuCallback);
	nav_menu.SetTitle("[HLM服务器]导航菜单");
	nav_menu.AddItem("options1", "选择刀的类型[记得先选刀再选刀的皮肤]");
	nav_menu.AddItem("options2", "选择武器或者刀的皮肤");
	nav_menu.AddItem("options3", "选择手套以及皮肤");
	nav_menu.AddItem("options4", "选择贴纸");
	nav_menu.AddItem("options5", "选择探员或者自定义模型");
	nav_menu.AddItem("options6", "管理员菜单[需要管理权限]");
	nav_menu.Display(client, 30);
	return Plugin_Handled;
}

public int MenuCallback(Menu nav_menu, MenuAction action, int client, int options)
{
	switch (action)
	{
		case MenuAction_Select:
		{
			char user_select[32];
			nav_menu.GetItem(options, user_select, sizeof(user_select));
			
			if (StrEqual(user_select, "options1"))
			{
				FakeClientCommand(client,"say !knife");
			}else if (StrEqual(user_select, "options2")){
				FakeClientCommand(client, "say !ws");
			}else if (StrEqual(user_select, "options3")){
				FakeClientCommand(client, "say !gloves");
			}else if (StrEqual(user_select, "options4")){
				FakeClientCommand(client, "say !stickers");
			}else if (StrEqual(user_select, "options5")){
				FakeClientCommand(client, "say !models");
			}else if (StrEqual(user_select, "options6")){
				FakeClientCommand(client, "say !admin");
			}
		}
		
		case MenuAction_End:
		{
			delete nav_menu;
		}
	}
	
	return 1;
}