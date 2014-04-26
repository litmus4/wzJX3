bActive = false
PrevState = 0
CurrState = 0
nCount = 0

function zJumpback()
--[[
	if bActive then
		OutputMessage("MSG_SYS", "true ")
	else
		OutputMessage("MSG_SYS", "false ")
	end
	OutputMessage("MSG_SYS", PrevState.." "..CurrState.." "..nCount.."\n")
--]]
	PrevState = CurrState
	CurrState = 0

	local player = GetClientPlayer()
	if not player then
		return
	end

	local TargetType, dwTargetID = player.GetTarget()
	local target = GetTargetHandle(TargetType, dwTargetID)
	if not target then
		return
	end

	local BuffTable = target.GetBuffList()
	if BuffTable then
		for k, buff in pairs(BuffTable) do
			if buff.dwID == 554 then
				CurrState = 1
			end
			if buff.dwID == 1229 then
				CurrState = 1
			end
		end
	end

	if PrevState == 1 and CurrState == 0 then
		bActive = true
	end
	if bActive then
		nCount = nCount + 1
		if nCount >= 5 then
			bActive = false
			nCount = 0
		end
		player.StopCurrentAction()
		OnRemoteCall("DoClientScript", "OnUseSkill(9007, 1)")
	end
end

zJSel = {
	tEnemies = {},
	nPointer = 0,
}

function zJDoCollect()
	zJSel.tEnemies = {}
	zJSel.nPointer = 0
	local player = GetClientPlayer()
	local tPlayers = wzUtil.Scene_GetPlayerList()
	for i, dwID in ipairs(tPlayers) do
		if IsEnemy(player.dwID, dwID) then
			table.insert(zJSel.tEnemies, dwID)
		end
	end
	local nCount = #zJSel.tEnemies
	OutputMessage("MSG_SYS", tostring(nCount).."\n")
	
	zJSelPanel:Collect()
end

function zJDoSelect()
	local nCount = #zJSel.tEnemies
	if zJSel.nPointer < 1 or zJSel.nPointer >= nCount then
		zJSel.nPointer = 1
	else
		zJSel.nPointer = zJSel.nPointer + 1
	end
	SetTarget(TARGET.PLAYER, zJSel.tEnemies[zJSel.nPointer])
end

zJSelPanel = {
	bOpen = true,
	nX = 800,
	nY = 30,
	
	tDatas = {},
}

RegisterCustomData("zJSelPanel.bOpen")
RegisterCustomData("zJSelPanel.nX")
RegisterCustomData("zJSelPanel.nY")

function zJSelPanel.OnFrameCreate()
	this:RegisterEvent("CUSTOM_DATA_LOADED")
end

function zJSelPanel.OnFrameBreathe()
	local frame = Station.Lookup("Normal/zJSelPanel")
	if not frame then
		return
	end
	
	local tTeam = GetClientTeam()
	local tTeamMarks = nil
	if tTeam then
		tTeamMarks = tTeam.GetTeamMark()
	end
	
	for i = 1, 5 do
		if zJSel.tEnemies[i] then
			local button = frame:Lookup("Button_Enemy"..tostring(i))
			local text = button:Lookup("", "Text_Enemy"..tostring(i))
			local enemy = GetPlayer(zJSel.tEnemies[i])
			if enemy then
				local szShow = zJSelPanel.tDatas[i].szFront
				local bChange = false
				
				local nLife = math.floor(enemy.nCurrentLife / enemy.nMaxLife * 100)
				szShow = szShow..tostring(nLife)
				if nLife ~= zJSelPanel.tDatas[i].nLife then
					zJSelPanel.tDatas[i].nLife = nLife
					bChange = true
				end
				
				local nMark = zJSelPanel:CheckMark(tTeamMarks, enemy.dwID)
				if nMark > 0 then
					szShow = szShow.."  "..wzUtil.tTeamMarkStrs[nMark]
				end
				if nMark ~= zJSelPanel.tDatas[i].nMark then
					zJSelPanel.tDatas[i].nMark = nMark
					bChange = true
				end
				
				if bChange then
					text:SetText(szShow)
				end
				
				if enemy.nCurrentLife == 0 then
					text:SetFontColor(100, 100, 100)
				else
					text:SetFontColor(255, 255, 255)
				end
			else
				text:SetFontColor(255, 0, 0)
			end
		end
	end
end

function zJSelPanel.OnEvent(event)
	if event == "CUSTOM_DATA_LOADED" then
		local frame = Station.Lookup("Normal/zJSelPanel")
		if not frame then
			return
		end
		if not zJSelPanel.bOpen then
			frame:Hide()
		end
		frame:SetAbsPos(zJSelPanel.nX, zJSelPanel.nY)
	end
end

function zJSelPanel.OnFrameDragEnd()
	local frame = Station.Lookup("Normal/zJSelPanel")
	if not frame then
		return
	end
	local nX, nY = frame:GetAbsPos()
	local w, h = Station.GetClientSize()
	if nX < 0 then
		nX = 0
	end
	if nY < 0 then
		nY = 0
	end
	if nX > w - 300 then
		nX = w - 300
	end
	if nY > h - 220 then
		nY = h - 220
	end
	zJSelPanel.nX, zJSelPanel.nY = nX, nY
	frame:SetAbsPos(nX, nY)
end

function zJSelPanel.OnLButtonClick()
	local name = this:GetName()
	for i = 1, 5 do
		if name == "Button_Enemy"..tostring(i) and zJSel.tEnemies[i] then
			SetTarget(TARGET.PLAYER, zJSel.tEnemies[i])
			break
		end
	end
end

function zJSelPanel:Collect()
	local frame = Station.Lookup("Normal/zJSelPanel")
	if not frame then
		return
	end
	zJSelPanel.tDatas = {}
	
	local tTeam = GetClientTeam()
	local tTeamMarks = nil
	if tTeam then
		tTeamMarks = tTeam.GetTeamMark()
	end
	
	for i = 1, 5 do
		local button = frame:Lookup("Button_Enemy"..tostring(i))
		local text = button:Lookup("", "Text_Enemy"..tostring(i))
		if zJSel.tEnemies[i] then
			local enemy = GetPlayer(zJSel.tEnemies[i])
			if enemy then
				local szName = enemy.szName
				if string.len(szName) > 12 then
					szName = string.sub(szName, 1, 12).."..."
				end
				local szMenpai = GetForceTitle(enemy.dwForceID)
				local nLife = math.floor(enemy.nCurrentLife / enemy.nMaxLife * 100)
				local nMark = zJSelPanel:CheckMark(tTeamMarks, enemy.dwID)
				
				local tData = {}
				tData["szFront"] = "  "..szName.."·"..szMenpai.."  "
				tData["nLife"] = nLife
				tData["nMark"] = nMark
				table.insert(zJSelPanel.tDatas, tData)
				
				local szShow = tData.szFront..tostring(nLife)
				if nMark > 0 then
					szShow = szShow.."  "..wzUtil.tTeamMarkStrs[nMark]
				end
				text:SetText(szShow)
			else
				text:SetText("")
			end
		else
			text:SetText("")
		end
	end
end

function zJSelPanel:CheckMark(tTeamMarks, dwID)
	if not tTeamMarks then
		return 0
	end
	for dwCurID, nMark in pairs(tTeamMarks) do
		if dwCurID == dwID then
			return nMark
		end
	end
	return 0
end

function zJSelPanel:WndSwitch(bShow)
	local frame = Station.Lookup("Normal/zJSelPanel")
	if not frame then
		return
	end
	if bShow then
		frame:Show()
	else
		frame:Hide()
	end
	zJSelPanel.bOpen = bShow
end

function zJSelPanel.GetMenu()
	local menu = {
		szOption = "zJSelPanel",
		{
			szOption = "开启zJSelPanel",
			bCheck = true,
			bChecked = zJSelPanel.bOpen,
			fnAction = function() zJSelPanel:WndSwitch(not zJSelPanel.bOpen) end,
			fnAutoClose = function() return true end,
		},
	}
	return menu
end

RegisterEvent("LOGIN_GAME", function()
	local tMenu = {
		function()
			return {zJSelPanel.GetMenu()}
		end,
	}
	Player_AppendAddonMenu(tMenu)
end)

Hotkey.AddBinding("zJumpback", "自动后跳", "自动后跳", zJumpback, nil)
Hotkey.AddBinding("zJDoCollect", "zJSel收集", "", zJDoCollect, nil)
Hotkey.AddBinding("zJDoSelect", "zJSel选择", "", zJDoSelect, nil)
Wnd.OpenWindow("interface\\wzJumpback\\zJSelPanel.ini", "zJSelPanel")
OutputMessage("MSG_SYS", "自动后跳启动\n")