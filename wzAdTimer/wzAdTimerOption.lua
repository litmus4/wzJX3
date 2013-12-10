wzAdTimerOption = {
	szContent = "这里填写内容",
	nInterval = 10000,
	
	bChNearby = true,
	bChMap = false,
	bChGuild = false,
	bChWorld = false,
	bChTeam = false,
	bChCamp = false,
	bChRaid = false,
	bChForce = false,
	bChFriends = false
}

RegisterCustomData("wzAdTimerOption.szContent")
RegisterCustomData("wzAdTimerOption.nInterval")
RegisterCustomData("wzAdTimerOption.bChNearby")
RegisterCustomData("wzAdTimerOption.bChMap")
RegisterCustomData("wzAdTimerOption.bChGuild")
RegisterCustomData("wzAdTimerOption.bChWorld")
RegisterCustomData("wzAdTimerOption.bChTeam")
RegisterCustomData("wzAdTimerOption.bChCamp")
RegisterCustomData("wzAdTimerOption.bChRaid")

function wzAdTimerOption.OnFrameCreate()
	local frame = Station.Lookup("Normal/wzAdTimerOption")
	if not frame then
		return
	end
	local title = frame:Lookup("", "Text_Title")
	title:SetText("定时喊话设置")
	
	local text_content = frame:Lookup("", "Text_Content")
	text_content:SetText("喊话内容：")
	local edit_content = frame:Lookup("Edit_Content")
	edit_content:SetText(wzAdTimerOption.szContent)
	local text_time = frame:Lookup("", "Text_Time")
	text_time:SetText("喊话间隔时间（单位：秒）：")
	local edit_time = frame:Lookup("Edit_Time")
	edit_time:SetText(tostring(wzAdTimerOption.nInterval / 1000))
	
	local text_channel = frame:Lookup("", "Text_Channel")
	text_channel:SetText("喊话频道：")
	
	this:Lookup("CheckBox_Nearby"):Check(wzAdTimerOption.bChNearby)
	this:Lookup("CheckBox_Nearby", "Text_Nearby"):SetText("近聊频道")
	this:Lookup("CheckBox_Map"):Check(wzAdTimerOption.bChMap)
	this:Lookup("CheckBox_Map", "Text_Map"):SetText("地图频道")
	this:Lookup("CheckBox_Guild"):Check(wzAdTimerOption.bChGuild)
	this:Lookup("CheckBox_Guild", "Text_Guild"):SetText("帮会频道")
	this:Lookup("CheckBox_World"):Check(wzAdTimerOption.bChWorld)
	this:Lookup("CheckBox_World", "Text_World"):SetText("世界频道")
	this:Lookup("CheckBox_Team"):Check(wzAdTimerOption.bChTeam)
	this:Lookup("CheckBox_Team", "Text_Team"):SetText("队伍频道")
	this:Lookup("CheckBox_Camp"):Check(wzAdTimerOption.bChCamp)
	this:Lookup("CheckBox_Camp", "Text_Camp"):SetText("阵营频道")
	this:Lookup("CheckBox_Raid"):Check(wzAdTimerOption.bChRaid)
	this:Lookup("CheckBox_Raid", "Text_Raid"):SetText("团队频道")
	this:Lookup("CheckBox_Force"):Check(wzAdTimerOption.bChForce)
	this:Lookup("CheckBox_Force", "Text_Force"):SetText("门派频道")
	this:Lookup("CheckBox_Friends"):Check(wzAdTimerOption.bChFriends)
	this:Lookup("CheckBox_Friends", "Text_Friends"):SetText("好友频道")
	
	this:Lookup("Btn_Ok", "Text_Ok"):SetText("确 定")
	this:Lookup("Btn_Cancel", "Text_Cancel"):SetText("取 消")
end

function wzAdTimerOption.OnFrameBreathe()
	local frame = Station.Lookup("Normal/wzAdTimerOption")
	if not frame then
		return
	end
	local state = frame:Lookup("", "Text_State")
	if wzAdTimer.bActive then
		state:SetText("喊话已开启")
	else
		state:SetText("喊话已关闭")
	end
end

function wzAdTimerOption.OnCheckBoxCheck()
	local szName = this:GetName()
	if szName == "CheckBox_Nearby" then
		wzAdTimerOption.bChNearby = true
	elseif szName == "CheckBox_Map" then
		wzAdTimerOption.bChMap = true
	elseif szName == "CheckBox_Guild" then
		wzAdTimerOption.bChGuild = true
	elseif szName == "CheckBox_World" then
		wzAdTimerOption.bChWorld = true
	elseif szName == "CheckBox_Team" then
		wzAdTimerOption.bChTeam = true
	elseif szName == "CheckBox_Camp" then
		wzAdTimerOption.bChCamp = true
	elseif szName == "CheckBox_Raid" then
		wzAdTimerOption.bChRaid = true
	elseif szName == "CheckBox_Force" then
	    wzAdTimerOption.bChForce = true
	elseif szName == "CheckBox_Friends" then
	    wzAdTimerOption.bChFriends = true
	end
end

function wzAdTimerOption.OnCheckBoxUncheck()
	local szName = this:GetName()
	if szName == "CheckBox_Nearby" then
		wzAdTimerOption.bChNearby = false
	elseif szName == "CheckBox_Map" then
		wzAdTimerOption.bChMap = false
	elseif szName == "CheckBox_Guild" then
		wzAdTimerOption.bChGuild = false
	elseif szName == "CheckBox_World" then
		wzAdTimerOption.bChWorld = false
	elseif szName == "CheckBox_Team" then
		wzAdTimerOption.bChTeam = false
	elseif szName == "CheckBox_Camp" then
		wzAdTimerOption.bChCamp = false
	elseif szName == "CheckBox_Raid" then
		wzAdTimerOption.bChRaid = false
	elseif szName == "CheckBox_Force" then
	    wzAdTimerOption.bChForce = false
	elseif szName == "CheckBox_Friends" then
	    wzAdTimerOption.bChFriends = false
	end	
end

function wzAdTimerOption.OnLButtonClick()
	local szName = this:GetName()
	if szName == "Btn_Ok" then
		local frame = Station.Lookup("Normal/wzAdTimerOption")
		if not frame then
			return
		end
		local edit_time = frame:Lookup("Edit_Time")
		local time = tonumber(edit_time:GetText())
		if not time then
			OutputMessage("MSG_SYS", "间隔时间格式不正确！\n")
			return
		end
		if time <= 0 or time > 600 then
			OutputMessage("MSG_SYS", "间隔时间超过范围！应该设置在0~600秒（不包括0）\n")
			return
		end
		wzAdTimerOption.nInterval = time * 1000
		local edit_content = frame:Lookup("Edit_Content")
		wzAdTimerOption.szContent = edit_content:GetText()
		frame:Hide()
	elseif szName == "Btn_Cancel" then
		local frame = Station.Lookup("Normal/wzAdTimerOption")
		if not frame then
			return
		end
		local edit_content = frame:Lookup("Edit_Content")
		edit_content:SetText(wzAdTimerOption.szContent)
		local edit_time = frame:Lookup("Edit_Time")
		edit_time:SetText(tostring(wzAdTimerOption.nInterval / 1000))
		frame:Hide()
	end
end

--Wnd.OpenWindow("interface\\wzAdTimer\\wzAdTimer.ini", "wzAdTimer")