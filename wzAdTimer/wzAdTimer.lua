wzAdTimer = {
	bActive = false,
	bIsInit = false,
	nLastTime = 0,
}

function wzAdTimer.OnFrameCreate()
end

function wzAdTimer.OnFrameBreathe()
	if wzAdTimer.bActive then
		local player = GetClientPlayer()
		if not player then
			return
		end
		
		if bIsInit == false then
			wzAdTimer.nLastTime = GetTime()
			wzAdTimer.bIsInit = true
		end
		
		diff = GetTime() - wzAdTimer.nLastTime
		if diff >= wzAdTimerOption.nInterval then
			wzAdTimer:DoSay(player)
			wzAdTimer.nLastTime = GetTime()
		end
	else
		if wzAdTimer.bIsInit == true then
			wzAdTimer.bIsInit = false
		end
	end
end

function wzAdTimer:DoSay(player)
	local tSay = wzUtil.Talk_EmotionTableFromString(wzAdTimerOption.szContent)
	if wzAdTimerOption.bChNearby then
		player.Talk(PLAYER_TALK_CHANNEL.NEARBY, "", tSay)
	end
	if wzAdTimerOption.bChMap then
		player.Talk(PLAYER_TALK_CHANNEL.SENCE, "", tSay)
	end
	if wzAdTimerOption.bChGuild then
		player.Talk(PLAYER_TALK_CHANNEL.TONG, "", tSay)
	end
	if wzAdTimerOption.bChWorld then
		player.Talk(PLAYER_TALK_CHANNEL.WORLD, "", tSay)
	end
	if wzAdTimerOption.bChTeam then
		player.Talk(PLAYER_TALK_CHANNEL.TEAM, "", tSay)
	end
	if wzAdTimerOption.bChCamp then
		player.Talk(PLAYER_TALK_CHANNEL.CAMP, "", tSay)
	end
	if wzAdTimerOption.bChRaid then
		player.Talk(PLAYER_TALK_CHANNEL.RAID, "", tSay)
	end
	if wzAdTimerOption.bChForce then
		player.Talk(PLAYER_TALK_CHANNEL.FORCE, "", tSay)
	end
	if wzAdTimerOption.bChFriends then
		player.Talk(PLAYER_TALK_CHANNEL.FRIENDS, "", tSay)
	end
end

function wzAdTimerOpen()
	Wnd.OpenWindow("interface\\wzAdTimer\\wzAdTimer.ini", "wzAdTimer")
	OutputMessage("MSG_SYS", "定时喊话插件加载成功！\n（by 网通 叶芷青 程云丈）\n")
end

function wzAdTimerOption()
	local frame = Station.Lookup("Normal/wzAdTimerOption")
	if frame then
		if frame:IsVisible() then
			frame:Hide()
		else
			frame:Show()
		end
	else
		frame = Wnd.OpenWindow("interface\\wzAdTimer\\wzAdTimerOption.ini", "wzAdTimerOption")
		frame:Show()
	end
end

function wzAdTimerSwitch()
	if not wzAdTimer.bActive then
		wzAdTimer.bActive = true
		OutputMessage("MSG_SYS", "定时喊话开始\n")
	else
		wzAdTimer.bActive = false
		OutputMessage("MSG_SYS", "定时喊话停止\n")
	end
end

Hotkey.AddBinding("wzAdTimerSwitch", "定时喊话开关", "定时喊话", wzAdTimerSwitch, nil)
--HotKey.AddBinding("wzAdTimerOption", "设置开关", "", wzAdTimerOption, nil)
Hotkey.AddBinding("wzAdTimerOption", "设置开关", "", wzAdTimerOption, nil)
wzAdTimerOpen()