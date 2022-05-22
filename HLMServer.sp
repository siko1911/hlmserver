#include <sourcemod>
#include <cstrike>
#include <multicolors>
//#include <colorvariables>
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
	RegConsoleCmd("sm_hud", Cmd_hud, ""); //测试HUD消息
	RegConsoleCmd("sm_txt", Cmd_txt, ""); //测试消息

	HookEvent("player_death", player_death); //检测玩家死亡事件
	HookEvent("bomb_dropped", bomb_dropped); //检测C4扔掉
	HookEvent("bomb_pickup", bomb_pickup);   //检测C4捡起
	HookEvent("bomb_beginplant", bomb_bplant); //检测C4开始安装
	HookEvent("bomb_begindefuse", bomb_bdefuse); //检测C4开始被拆除
	HookEvent("grenade_thrown", grenade_thrown); //检测扔雷

	CreateTimer(30.0, ADMSG, _, TIMER_REPEAT);

	

}

public bool OnClientConnect(int client)
{
	//当用户连接服务器时，给出提示
	char name[32];
	GetClientName(client, name, sizeof(name));
	CPrintToChatAll("{darkred}[HLM服务器消息]{lime}-%s-正在连接服务器...", name);

	PrecacheSound("hlm/cnm.wav");
	PrecacheSound("hlm/die.mp3");
	PrecacheSound("hlm/nhs.wav");
	PrecacheSound("hlm/go.mp3");
	
	return true;
}

public void OnClientConnected(int client)
{
	//当用户连接服务器成功时，给出提示
	char name[32];
	GetClientName(client, name, sizeof(name));
	CPrintToChatAll("{darkred}[HLM服务器消息]{lime}-%s-连接服务器成功！", name);
}

public void OnClientPutInServer(int client)
{
	//当用户进入服务器时，给出欢迎信息
	char name[32];
	char uid[32];
	GetClientName(client, name, sizeof(name));
	GetClientAuthId(client, AuthId_Steam3, uid, sizeof(uid));
	CPrintToChatAll("{darkred}[HLM服务器消息]{lime}欢迎{orchid}%s[%s]{lime}进入游戏！祝您玩的愉快！", name, uid);
}

public void OnClientPostAdminCheck(int client)
{
	//当用户完全进入服务器时，播放声音

	for (int i = 1; i < MaxClients ; i++)
	{
		if (IsClientInGame(i) && IsClientConnected(i))
		{
			ClientCommand(i, "play hlm/go.mp3"); //播放声音

			//HUD消息提示，测试功能
			SetHudTextParams(-1.0, 0.2, 10.0, 255, 0, 255, 100, 1, 6.0, 1.0, 2.0);
			Handle hud = CreateHudSynchronizer();
			ShowSyncHudText(i, hud, "欢迎加入红浪漫会所，祝您玩的愉快！");
			//ShowHudText(i, -1, "");

		}
	}

	CPrintToChat(client, "{lightred}======================[HLM]服务器帮助======================");
	CPrintToChat(client, "{olive}● 输入{orchid}!nav{olive}打开聚合导航菜单");
	CPrintToChat(client, "{olive}● 可以打开控制台输入{darkred}[bind F2 \"say !nav\"]{olive}来绑定F2或者其他按键");
	CPrintToChat(client, "{olive}● 服务器已更新{purple}[2022安特卫普Major系列贴纸]");
}

public Action ADMSG(Handle Timer)
{
	CPrintToChatAll("{lightred}======================[HLM]服务器帮助======================");
	CPrintToChatAll("{olive}● 输入{orchid}!nav{olive}打开聚合导航菜单");
	CPrintToChatAll("{olive}● 可以打开控制台输入{darkred}[bind F2 \"say !nav\"]{olive}来绑定F2或者其他按键");
	CPrintToChatAll("{olive}● 服务器已更新{purple}[2022安特卫普Major系列贴纸]");
	return Plugin_Continue;
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


public Action Cmd_hud(int client, int args)
{
	//Handle hud = CreateHudSynchronizer();
	SetHudTextParamsEx(0.1, 0.65, 10.0, {127, 255, 212, 255}, {224, 255, 255, 10}, 2, 0.1, 0.1, 0.2);
	ShowHudText(client, -1, "测试HUD消息1！！！");

	SetHudTextParamsEx(0.1, 0.7, 10.0, {255, 0, 255, 255}, {238, 130, 238, 10}, 2, 0.1, 0.1, 0.2);
	ShowHudText(client, -1, "测试HUD消息2！！！");

	SetHudTextParamsEx(0.1, 0.75, 10.0, {225, 69, 69, 255}, {225, 69, 69, 10}, 3, 0.1, 0.1, 0.2);
	ShowHudText(client, -1, "测试HUD消息3！！！");

	SetHudTextParamsEx(0.1, 0.8, 10.0, {225, 69, 69, 255}, {225, 69, 69, 10}, 1, 0.1, 0.1, 0.2);
	ShowHudText(client, -1, "测试HUD消息3！！！");
	return Plugin_Handled;
}

public Action Cmd_txt(int client, int args)
{
	CPrintToChatAll("{lightred}曹{blue}达{lightgreen}华{purple}牛{gold}逼{green}！");
	CPrintToChatAll("{pink 哈哈哈哈哈}");
	ShowMOTDPanel(client, "TEST", "TESTMSG", MOTDPANEL_TYPE_TEXT);
	return Plugin_Handled;
}

public void player_death(Event event, const char[] name, bool dontBroadcast)
{
	char weapon[64];
	char aname[32];
	event.GetString("weapon", weapon, sizeof(weapon));
	int attackerID = event.GetInt("attacker");
	int attacker = GetClientOfUserId(attackerID);
	int victimID = event.GetInt("userid");
	int victim = GetClientOfUserId(victimID);
	GetClientName(attacker, aname, sizeof(aname));
	bool headshot = event.GetBool("headshot");
	int att_health = GetClientHealth(attacker);

	if (headshot)
	{
		Handle hud = CreateHudSynchronizer();
		SetHudTextParamsEx(0.2, 0.69, 5.0, {225, 69, 69, 255}, {225, 69, 69, 10}, 1, 0.1, 0.1, 0.2);
		ShowSyncHudText(victim, hud, "你被【%s】=爆头=击杀！\n击杀你的武器是：%s\n剩余血量：%d\n喊你队友来弄死他快！", aname, weapon, att_health);
	} else
	{
		Handle hud = CreateHudSynchronizer();
		SetHudTextParamsEx(0.2, 0.69, 5.0, {225, 69, 69, 255}, {225, 69, 69, 10}, 1, 0.1, 0.1, 0.2);
		ShowSyncHudText(victim, hud, "你被【%s】击杀！\n击杀你的武器是：%s\n剩余血量：%d\n喊你队友来弄死他快！", aname, weapon, att_health);
	}

	float ang[3];
	GetClientAbsAngles(victim, ang);
	EmitAmbientSound("hlm/die.mp3", ang, victim);

	//EmitSoundToClient(victim, "hlm/die.mp3");
	//FakeClientCommand(victim, "play go.mp3");
}

public void bomb_dropped(Event event, const char[] name, bool dontBroadcast)
{
	char dname[32];
	int uid = event.GetInt("userid");
	GetClientName(GetClientOfUserId(uid), dname, sizeof(dname));
	for (int i = 1; i < MaxClients; i++)
	{
		if (IsClientInGame(i) && IsClientConnected(i))
		{
			Handle hud = CreateHudSynchronizer();
			SetHudTextParamsEx(-1.0, 0.6, 3.0, {225, 69, 69, 255}, {225, 69, 69, 10}, 1, 0.1, 0.1, 0.2);
			ShowSyncHudText(i, hud, "【%s】丢掉了C4炸弹！！！", dname);
			//ShowHudText(i, -1, "【%s】丢掉了C4炸弹！！！", dname);
		}
	}
}

public void bomb_pickup(Event event, const char[] name, bool dontBroadcast)
{
	char pname[32];
	int uid = event.GetInt("userid");
	GetClientName(GetClientOfUserId(uid), pname, sizeof(pname));
	for (int i = 1; i < MaxClients; i++)
	{
		if (IsClientInGame(i) && IsClientConnected(i))
		{
			Handle hud = CreateHudSynchronizer();
			SetHudTextParamsEx(-1.0, 0.65, 3.0, {225, 69, 69, 255}, {225, 69, 69, 10}, 1, 0.1, 0.1, 0.2);
			ShowSyncHudText(i, hud, "【%s】捡起了C4炸弹！！！", pname);
		}
	}
}

public void bomb_bplant(Event event, const char[] name, bool dontBroadcast)
{
	char bname[32];
	int uid = event.GetInt("userid");
	GetClientName(GetClientOfUserId(uid), bname, sizeof(bname));
	for (int i = 1; i < MaxClients; i++)
	{
		if (IsClientInGame(i) && IsClientConnected(i))
		{
			Handle hud = CreateHudSynchronizer();
			SetHudTextParamsEx(-1.0, 0.69, 3.0, {225, 69, 69, 255}, {225, 69, 69, 10}, 1, 0.1, 0.1, 0.2);
			ShowSyncHudText(i, hud, "【%s】正在安装C4炸弹！！！", bname);
		}
	}
}

public void bomb_bdefuse(Event event, const char[] name, bool dontBroadcast)
{
	char bname[32];
	int uid = event.GetInt("userid");
	bool kit = event.GetBool("haskit");
	GetClientName(GetClientOfUserId(uid), bname, sizeof(bname));
	for (int i = 1; i < MaxClients; i++)
	{
		if (IsClientInGame(i) && IsClientConnected(i))
		{
			Handle hud = CreateHudSynchronizer();
			if(kit)
			{
				//Handle hud = CreateHudSynchronizer();
				SetHudTextParamsEx(-1.0, 0.7, 3.0, {225, 69, 69, 255}, {225, 69, 69, 10}, 1, 0.1, 0.1, 0.2);
				ShowSyncHudText(i, hud, "【%s】正在拆除C4炸弹！！！\n我靠他有钳子，快快快快！！！", bname);
			
			} else 
			{
				//Handle hud = CreateHudSynchronizer();
				SetHudTextParamsEx(-1.0, 0.75, 3.0, {225, 69, 69, 255}, {225, 69, 69, 10}, 1, 0.1, 0.1, 0.2);
				ShowSyncHudText(i, hud, "【%s】正在拆除C4炸弹！！！\n他没得钳子，快去干他！！！", bname);
			}
		}
	}
}

public void grenade_thrown(Event event, const char[] name, bool dontBroadcast)
{
	char gname[32];
	int uid;
	int cid;
	uid = event.GetInt("userid");
	cid = GetClientOfUserId(uid);
	event.GetString("weapon", gname, sizeof(gname));

	float ang[3];
	GetClientAbsAngles(cid, ang);
	//EmitSoundToClient(cid, "hlm/cnm.wav");
	EmitAmbientSound("hlm/cnm.wav", ang, cid);
	// if (StrEqual(gname, "hegrenade"))
	// {
	// 	PrintHintText(cid, "丢雷丢雷丢雷");
	// }
	

}

