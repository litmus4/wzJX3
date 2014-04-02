----------�������----------
wzYgRemind = {
	bOpen = false,
	bActive = false,
	nDelay = 0,
	nTime = 0,
	bActivez = false,
	bOpenz2 = false,
	bStatez2 = false,
	bFilter = false,
	bQ = false
}

z2_tFiltList = {
	"��̫��",
}

tManual = {
	szContent = "JQJQJQJQJQ",
	szWTarget = "",
	szChannel = "Nearby_Once",
	nChannel = PLAYER_TALK_CHANNEL.NEARBY,
	bOneTime = true,
}

RegisterCustomData("wzYgRemind.bOpen")
RegisterCustomData("wzYgRemind.bActive")
RegisterCustomData("wzYgRemind.nDelay")
RegisterCustomData("wzYgRemind.nTime")

----------ϵͳ����----------
function wzYgRemind.OnFrameBreathe()
	zzz2()
	if wzYgRemind.bOpen then
		local player = GetClientPlayer()
		if not player then
			return
		end

		local TargetType, dwTargetID = player.GetTarget()
		local target = GetTargetHandle(TargetType, dwTargetID)
		if not target then
			wzYgRemind.nTime = 0
			return
		end

		--local bPrepare, dwID, dwLevel, fP = target.GetSkillPrepareState()
		local bPrepare = wzYgRemind:GetPrepare()
		if bPrepare then
			if not tManual.bOneTime then
				wzYgRemind.bActive = true
			else
				wzYgRemind.nTime = wzYgRemind.nTime + 1
			end
		else
			wzYgRemind.nTime = 0
		end

		local wTarget = ""
		if tManual.nChannel == PLAYER_TALK_CHANNEL.WHISPER then
			wTarget = tManual.szWTarget
		end

		if wzYgRemind.bActive then
			if wzYgRemind.nDelay == 0 then
				player.Talk(tManual.nChannel,wTarget,{{type="text",text=tManual.szContent}})
				OutputMessage("MSG_SYS", "JQJQJQJQJQ\n")
			end
			wzYgRemind.nDelay = wzYgRemind.nDelay + 1
		end

		if wzYgRemind.nTime == 1 then
			player.Talk(tManual.nChannel,wTarget,{{type="text",text=tManual.szContent}})
			OutputMessage("MSG_SYS", "JQJQJQJQJQ\n")
		end

		if wzYgRemind.nDelay >= 10 then
			wzYgRemind.nDelay = 0
			wzYgRemind.bActive = false
		end
	end
end

----------�Զ��庯��----------
function Open()
	local frame = Wnd.OpenWindow("interface\\wzYgRemind\\wzYgRemind.ini", "wzYgRemind")
	frame:Hide()
	OutputMessage("MSG_SYS", "Ŀ���˹�����ģ����سɹ���\n")
end

function SwitchYgBreak()
	if not wzYgRemind.bOpen then
		wzYgRemind.bOpen = true
		OutputMessage("MSG_SYS", "���ѹ��ܿ���\n")
	else
		wzYgRemind.bOpen = false
		OutputMessage("MSG_SYS", "���ѹ��ܹر�\n")
	end
end

function ChangeTimes()
	if not tManual.bOneTime then
		tManual.bOneTime = true
		OutputMessage("MSG_SYS", "һ��\n")
	else
		tManual.bOneTime = false
		OutputMessage("MSG_SYS", "���\n")
	end
end

function SwitchOptions()
	local frame = Station.Lookup("Normal/YgRemindOptions")
	if frame then
		if frame:IsVisible() then
			frame:Hide()
		else
			frame:Show()
		end
	else
		frame = Wnd.OpenWindow("interface\\wzYgRemind\\YgRemindOptions.ini", "YgRemindOptions")
		frame:Show()
	end
end

function Switchzzz2()
	local frame = Station.Lookup("Normal/wzYgRemind")
	if not frame then
		return
	end
	if not wzYgRemind.bOpenz2 then
		wzYgRemind.bOpenz2 = true
		frame:Show()
		OutputMessage("MSG_SYS", "zzz2����\n")
	else
		wzYgRemind.bOpenz2 = false
		frame:Hide()
		OutputMessage("MSG_SYS", "zzz2�ر�\n")
	end
end

function ChangeFilter()
	if not wzYgRemind.bFilter then
		wzYgRemind.bFilter = true
		OutputMessage("MSG_SYS", "ȫ��\n")
	else
		wzYgRemind.bFilter = false
		OutputMessage("MSG_SYS", "����\n")
	end
end

function zzz()
	local player = GetClientPlayer()
	if not player then
		return
	end

	local TargetType, dwTargetID = player.GetTarget()
	local target = GetTargetHandle(TargetType, dwTargetID)
	if not target then
		return
	end

	local bPrepare, dwID, dwLevel, fP = target.GetSkillPrepareState()
	local bCool, nLeft, nTotal = player.GetSkillCDProgress(310, player.GetSkillLevel(310))
	local bTempFilt = (dwID == 358) or (dwID == 363) or (dwID == 187) or wzYgRemind.bFilter
	--OutputMessage("MSG_SYS", nLeft.."\n")
	if bPrepare and nLeft == 0 and bTempFilt then
		wzYgRemind.bActivez = true
	else
		wzYgRemind.bActivez = false
	end

	if wzYgRemind.bActivez == true then
		player.StopCurrentAction()
		OnRemoteCall("DoClientScript", "OnUseSkill(310,5)")
	end
end

function zzz2()
	if not wzYgRemind.bOpenz2 then
		return
	end
	local player = GetClientPlayer()
	if not player then
		return
	end
	local bCool, nLeft, nTotal = player.GetSkillCDProgress(310, player.GetSkillLevel(310))
	local szPrepare = wzYgRemind:GetPrepare()
	if szPrepare and nLeft == 0 and wzYgRemind:IsInFiltList(szPrepare) then
		if not wzYgRemind.bStatez2 then
			wzYgRemind.bStatez2 = true
			wzYgRemind:SetState(true)
		end
	else
		if wzYgRemind.bStatez2 then
			wzYgRemind.bStatez2 = false
			wzYgRemind:SetState(false)
		end
	end
end

function wzYgRemind:GetPrepare()
	local frame = Station.Lookup("Normal/Target")
	local handle = frame:Lookup("", "")
	local actionBar = handle:Lookup("Handle_Bar")
	local textName = actionBar:Lookup("Text_Name")
	if textName and frame:IsVisible() and actionBar:IsVisible() then
		return textName:GetText()
	end
	return nil
end

function wzYgRemind:IsInFiltList(szPrepare)
	if wzYgRemind.bFilter then
		return true
	end
	for i, szSkill in ipairs(z2_tFiltList) do
		if szSkill == szPrepare then
			return true
		end
	end
	return false
end

function wzYgRemind:SetState(bFlag)
	local frame = Station.Lookup("Normal/wzYgRemind")
	if not frame then
		return
	end
	local imageState = frame:Lookup("", "Image_State")
	if bFlag then
		imageState:FromUITex("interface\\wzYgRemind\\States.UITex", 1)
	else
		imageState:FromUITex("interface\\wzYgRemind\\States.UITex", 0)
	end
end

function Deceive()
	if wzYgRemind.bQ then
		local player = GetClientPlayer()
		if not player then
			return
		end
		
		player.StopCurrentAction()
		wzYgRemind.bQ = false
	else
		OnRemoteCall("DoClientScript", "OnUseSkill(358,1)")
		wzYgRemind.bQ = true
	end
end

Hotkey.AddBinding("SwitchYgBreak", "���ѿ���", "Ŀ���˹�����", SwitchYgBreak, nil)
Hotkey.AddBinding("ChangeTimes", "��������", "", ChangeTimes, nil)
Hotkey.AddBinding("SwitchOptions", "���ÿ���", "", SwitchOptions, nil)
Hotkey.AddBinding("zzz", "zzz����", "", zzz, nil)
Hotkey.AddBinding("zzz2", "zzz2����", "", Switchzzz2, nil)
Hotkey.AddBinding("ChangeFilter", "������", "", ChangeFilter, nil)
Hotkey.AddBinding("Deceive", "��ƭ", "", Deceive, nil)
Open()