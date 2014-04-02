----------框体对象----------
YgRemindOptions = {
	nX = 200, nY = 300,
}

CAT = {
	[1] = "Nearby_Once",
	[2] = "Nearby_Multi",
	[3] = "Party_Once",
	[4] = "Party_Multi",
	[5] = "Team_Once",
	[6] = "Team_Multi",
	[7] = "Whisper_Once",
	[8] = "Whisper_Multi",
}

RegisterCustomData("CAT")
RegisterCustonData("YgRemindOptions.nX")
RegisterCustonData("YgRemindOptions.nY")

----------系统函数----------
function YgRemindOptions.OnFrameCreate()
	this:RegisterEvent("CUSTOM_DATA_LOADED")
	local frame = Station.Lookup("Normal/YgRemindOptions")
	frame:Lookup("", "Text_Title"):SetText("目标运功提醒选项")
	frame:Lookup("", "Text_Content"):SetText("提醒内容：")
	frame:Lookup("", "Text_WhisperTarget"):SetText("密语目标：")
	frame:Lookup("", "Text_Channel"):SetText(szChannel)
end

function YgRemindOptions.OnFrameBreathe()
	local frame = Station.Lookup("Normal/YgRemindOptions")
	if not frame or not frame:IsVisible() then
		return
	end

	szContent = frame:Lookup("Edit_Content"):GetText()
	szWTarget = frame:Lookup("Edit_WhisperTarget"):GetText()
end

function YgRemindOptions.OnLButtonClick()
	local szName=this:GetName()
	local frame = Station.Lookup("Normal/YgRemindOptions")
	if szName == "Btn_Close" then
		frame:Hide()
	elseif szName == "Btn_Channel" then
		YgRemindOptions:Channel()
	end
end

function YgRemindOptions.OnLButtonUp()
	YgRemindOptions.nX, YgRemindOptions.nY =  Station.Lookup("Normal/YgRemindOptions"):GetRelPos()
end

function Dahan.OnEvent(event)
	local frame = Station.Lookup("Normal/YgRemindOptions")
	if event=="CUSTOM_DATA_LOADED" then
		if YgRemindOptions.nX~=0 and YgRemindOptions.nY~=0 then
			Station.Lookup("Normal/YgRemindOptions"):SetRelPos(tonumber(YgRemindOptions.nX), tonumber(YgRemindOptions.nY))
		else
			Station.Lookup("Normal/YgRemindOptions"):SetRelPos(100, 300)
		end
	end
end

----------自定义函数----------
function YgRemindOptions:Channel()
	local frame = Station.Lookup("Normal/YgRemindOptions")
	local text = frame:Lookup("", "Text_Channel")
	local xt, yt = text:GetAbsPos()
	local w, h = text:GetSize()
	local menu = {
		nMiniWidth = w,
		x = xt, y = yt + h,
		fnAction = function(UserData, bCheck)
			local frame = Station.Lookup("Normal/YgRemindOptions")
			YgRemindOptions:Select(UserData)
		end,
	}
	for i, s in pairs(CAT) do
		table.insert(menu, {szOption = s, UserData = i})
	end
	PopupMenu(menu)
end

function YgRemindOptions:Select(data)
	local frame = Station.Lookup("Normal/YgRemindOptions")
	if not frame or not frame:IsVisible() then
		return
	end
	if CAT[data] == "Nearby_Once" then
		nChannel = PLAYER_TALK_CHANNEL.NEARBY
		bOneTime = true
	elseif CAT[data] == "Nearby_Multi" then
		nChannel = PLAYER_TALK_CHANNEL.NEARBY
		bOneTime = false
	elseif CAT[data] == "Party_Once" then
		nChannel = PLAYER_TALK_CHANNEL.PARTY
		bOneTime = true
	elseif CAT[data] == "Party_Multi" then
		nChannel = PLAYER_TALK_CHANNEL.PARTY
		bOneTime = false
	elseif CAT[data] == "Team_Once" then
		nChannel = PLAYER_TALK_CHANNEL.TEAM
		bOneTime = true
	elseif CAT[data] == "Team_Multi" then
		nChannel = PLAYER_TALK_CHANNEL.TEAM
		bOneTime = false
	elseif CAT[data] == "Whisper_Once" then
		nChannel = PLAYER_TALK_CHANNEL.WHISPER
		bOneTime = true
	elseif CAT[data] == "Whisper_Multi" then
		nChannel = PLAYER_TALK_CHANNEL.WHISPER
		bOneTime = false
	end
	szChannel = CAT[data]
	frame:Lookup("", "Text_Channel"):SetText(CAT[data])
end