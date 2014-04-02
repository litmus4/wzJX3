wzExactEye = {
	tManagedList = {},
	bOpen = true,
}

RegisterCustomData("wzExactEye.tManagedList")
RegisterCustomData("wzExactEye.bOpen")

ITEMTRIGGER_TYPE = {
	ENTER_SCENE = 1,
	BUFF_APPEAR = 2,
	BUFF_DISAPPEAR = 3,
}

function wzExactEye.OnFrameCreate()
	this:RegisterEvent("CUSTOM_DATA_LOADED")
	this:RegisterEvent("PLAYER_ENTER_SCENE")
	this:RegisterEvent("NPC_ENTER_SCENE")
end

function wzExactEye.OnFrameBreathe()
	--TODO
end

function wzExactEye.OnEvent(event)
	if event == "CUSTOM_DATA_LOADED" then
		--输出此时是CUSTOM_DATA_LOADED
		return
	elseif event == "PLAYER_ENTER_SCENE" then
		for i, tGroup in ipairs(wzExactEye.tManagedList) do
			if tGroup.bActive then
				for j, tItem in ipairs(tGroup.tContents) do
					if tItem.nTriggerType == ITEMTRIGGER_TYPE.ENTER_SCENE then
						wzExactEye:TryToSelect(true, tItem.szTargetName, arg0)
					end
				end
			end
		end
	else if event == "NPC_ENTER_SCENE" then
		for i, tGroup in ipairs(wzExactEye.tManagedList) do
			if tGroup.bActive then
				for j, tItem in ipairs(tGroup.tContents) do
					if tItem.nTriggerType == ITEMTRIGGER_TYPE.ENTER_SCENE then
						wzExactEye:TryToSelect(false, tItem.szTargetName, arg0)
					end
				end
			end
		end
	end
end

function wzExactEye:CheckAllItems(nTriggerType)
end

function wzExactEye:TryToSelect(bPlayer, szTargetName, dwFixID)
	if bPlayer then
		local tPlayer = nil
		if dwFixID then
			tPlayer = GetPlayer(dwFixID)
			if tPlayer then
				if tPlayer.szName ~= szTargetName then
					tPlayer = nil
				end
			end
		else
			tPlayer = wzUtil.Scene_GetPlayerByName(szTargetName)
		end
		
		if tPlayer then
			SetTarget(TARGET.PLAYER, tPlayer.dwID)
			return true
		end
		return wzExactEye:TryToSelectMark(bPlayer, szTargetName)
	else
		local tNpc = nil
		if dwFixID then
			tNpc = GetNpc(dwFixID)
			if tNpc then
				if tNpc.szName ~= szTargetName then
					tNpc = nil
				end
			end
		else
			tNpc = wzUtil.Scene_GetNpcByName(szTargetName)
		end
		
		if tNpc then
			SetTarget(TARGET.NPC, tNpc.dwID)
			return true
		end
		return wzExactEye:TryToSelectMark(bPlayer, szTargetName)
	end
end

function wzExactEye:TryToSelectMark(bPlayer, szTargetName)
	local tTeam = GetClientTeam()
	if not tTeam then
		return false
	end
	local tMarks = tTeam.GetTeamMark()
	if not tMarks then
		return false
	end
	
	for dwID, nIndex in ipairs(tMarks) do
		if wzUtil.tTeamMarkStrs[nIndex] == szTargetName then
			if bPlayer then
				--[[
				local tPlayer = GetPlayer(dwID)
				if tPlayer then
					SetTarget(TARGET.PLAYER, tPlayer.dwID)
					return true
				end
				--]]
				SetTarget(TARGET.PLAYER, dwID)
				return true
			else
				--[[
				local tNpc = GetNpc(dwID)
				if tNpc then
					SetTarget(TARGET.NPC, tNpc.dwID)
					return true
				end
				--]]
				SetTarget(TARGET.NPC, dwID)
				return true
			end
		end
	end
	return false
end

--返回项ID，0则未找到分组
function wzExactEye:AddItem(nType, xArg1, xArg2, targetName, szGroupName)
	local item = {
		nTriggerType = nType,
		xTriggerArg1 = xArg1,
		xTriggerArg2 = xArg2,
		szTargetName = targetName,
		
		bActive = true,
		bCanManual = false,
	}
	
	for i, tGroup in ipairs(wzExactEye.tManagedList) do
		if tGroup.szName == szGroupName then
			local nSize = #tGroup.tContents
			table.insert(wzExactEye.tManagedList[i].tContents, item)
			return nSize + 1
		end
	end
	return 0
end

--返回是否成功(存在同名分组则失败)
function wzExactEye:AddGroup(name)
	local group = {
		szName = name,
		tContents = {},
		bActive = true,
	}
	
	local bNoSame = true
	for i, tGroup in ipairs(wzExactEye.tManagedList) do
		if tGroup.szName == name then
			bNoSame = false
			break
		end
	end
	if bNoSame then
		table.insert(wzExactEye.tManagedList, group)
	end 
	
	return bNoSame
end

--返回是否成功(未找到分组或ID越界则失败)
function wzExactEye:RemoveItem(dwID, szGroupName)
	for i, tGroup in ipairs(wzExactEye.tManagedList) do
		if tGroup.szName == szGroupName and dwID > 0 and dwID <= #tGroup.tContents then
			table.remove(wzExactEye.tManagedList[i].tContents, dwID)
			return true
		end
	end
	return false
end

--返回是否成功(未找到分组则失败)
function wzExactEye:RemoveGroup(name)
	for i, tGroup in ipairs(wzExactEye.tManagedList) do
		if tGroup.szName == name then
			table.remove(wzExactEye.tManagedList, i)
			return true
		end
	end
	return false
end

--返回是否成功(未找到分组则失败)
function wzExactEye:ChangeGroupName(szOld, szNew)
	for i, tGroup in ipairs(wzExactEye.tManagedList) do
		if tGroup.szName == szOld then
			wzExactEye.tManagedList[i].szName = szNew
			return true
		end
	end
	return false
end

--返回是否成功(未找到分组则失败)
function wzExactEye:SwitchGroupActive(name)
	for i, tGroup in ipairs(wzExactEye.tManagedList) do
		if tGroup.szName == name then
			local bOldActive = wzExactEye.tManagedList[i].bActive
			wzExactEye.tManagedList[i].bActive = not bOldActive
			return true
		end
	end
	return false
end

--返回是否成功(未找到分组或ID越界则失败)
function wzExactEye:SwitchItemActive(dwID, szGroupName)
	for i, tGroup in ipairs(wzExactEye.tManagedList) do
		if tGroup.szName == szGroupName and dwID > 0 and dwID <= #tGroup.tContents then
			local bOldActive = wzExactEye.tManagedList[i].tContents[dwID].bActive
			wzExactEye.tManagedList[i].tContents[dwID].bActive = not bOldActive
			return true
		end
	end
	return false
end

--返回是否成功(未找到分组或ID越界则失败)
function wzExactEye:SwitchItemManual(dwID, szGroupName)
	for i, tGroup in ipairs(wzExactEye.tManagedList) do
		if tGroup.szName == szGroupName and dwID > 0 and dwID <= #tGroup.tContents then
			local bOldCanManual = wzExactEye.tManagedList[i].tContents[dwID].bCanManual
			wzExactEye.tManagedList[i].tContents[dwID].bCanManual = not bOldCanManual
			return true
		end
	end
	return false
end