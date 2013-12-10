wzAdTimerOption = {
	szContent = "������д����",
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
	title:SetText("��ʱ��������")
	
	local text_content = frame:Lookup("", "Text_Content")
	text_content:SetText("�������ݣ�")
	local edit_content = frame:Lookup("Edit_Content")
	edit_content:SetText(wzAdTimerOption.szContent)
	local text_time = frame:Lookup("", "Text_Time")
	text_time:SetText("�������ʱ�䣨��λ���룩��")
	local edit_time = frame:Lookup("Edit_Time")
	edit_time:SetText(tostring(wzAdTimerOption.nInterval / 1000))
	
	local text_channel = frame:Lookup("", "Text_Channel")
	text_channel:SetText("����Ƶ����")
	
	this:Lookup("CheckBox_Nearby"):Check(wzAdTimerOption.bChNearby)
	this:Lookup("CheckBox_Nearby", "Text_Nearby"):SetText("����Ƶ��")
	this:Lookup("CheckBox_Map"):Check(wzAdTimerOption.bChMap)
	this:Lookup("CheckBox_Map", "Text_Map"):SetText("��ͼƵ��")
	this:Lookup("CheckBox_Guild"):Check(wzAdTimerOption.bChGuild)
	this:Lookup("CheckBox_Guild", "Text_Guild"):SetText("���Ƶ��")
	this:Lookup("CheckBox_World"):Check(wzAdTimerOption.bChWorld)
	this:Lookup("CheckBox_World", "Text_World"):SetText("����Ƶ��")
	this:Lookup("CheckBox_Team"):Check(wzAdTimerOption.bChTeam)
	this:Lookup("CheckBox_Team", "Text_Team"):SetText("����Ƶ��")
	this:Lookup("CheckBox_Camp"):Check(wzAdTimerOption.bChCamp)
	this:Lookup("CheckBox_Camp", "Text_Camp"):SetText("��ӪƵ��")
	this:Lookup("CheckBox_Raid"):Check(wzAdTimerOption.bChRaid)
	this:Lookup("CheckBox_Raid", "Text_Raid"):SetText("�Ŷ�Ƶ��")
	this:Lookup("CheckBox_Force"):Check(wzAdTimerOption.bChForce)
	this:Lookup("CheckBox_Force", "Text_Force"):SetText("����Ƶ��")
	this:Lookup("CheckBox_Friends"):Check(wzAdTimerOption.bChFriends)
	this:Lookup("CheckBox_Friends", "Text_Friends"):SetText("����Ƶ��")
	
	this:Lookup("Btn_Ok", "Text_Ok"):SetText("ȷ ��")
	this:Lookup("Btn_Cancel", "Text_Cancel"):SetText("ȡ ��")
end

function wzAdTimerOption.OnFrameBreathe()
	local frame = Station.Lookup("Normal/wzAdTimerOption")
	if not frame then
		return
	end
	local state = frame:Lookup("", "Text_State")
	if wzAdTimer.bActive then
		state:SetText("�����ѿ���")
	else
		state:SetText("�����ѹر�")
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
			OutputMessage("MSG_SYS", "���ʱ���ʽ����ȷ��\n")
			return
		end
		if time <= 0 or time > 600 then
			OutputMessage("MSG_SYS", "���ʱ�䳬����Χ��Ӧ��������0~600�루������0��\n")
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