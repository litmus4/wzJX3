wzUtil = {

	tRegionPlayerList = {},

	tRegionNpcList = {},
	
	tTeamMarkStrs = {"[ÔÆ]", "[½£]", "[¸«]", "[¹³]", "[¹Ä]", "[¼ôµ¶]", "[°ôé³]", "[ÈçÒâ]", "[ïÚ]", "[ÉÈ×Ó]"},
	
	tEmotions = {},
	
}

wzUtil.Scene_GetPlayerList = function()
	return wzUtil.tRegionPlayerList
end

wzUtil.Scene_GetPlayerByName = function(szName)
	for i, dwID in ipairs(wzUtil.tRegionPlayerList) do
		local tPlayer = GetPlayer(dwID)
		if tPlayer.szName == szName then
			return tPlayer
		end
	end
	return nil
end

wzUtil.Scene_GetNpcList = function()
	return wzUtil.tRegionNpcList
end

wzUtil.Scene_GetNpcByName = function(szName)
	for i, dwID in ipairs(wzUtil.tRegionNpcList) do
		local tNpc = GetNpc(dwID)
		if tNpc.szName == szName then
			return tNpc
		end
	end
	return nil
end

wzUtil.Talk_InitEmotions = function()
	wzUtil.tEmotions = {}
	for i = 1, g_tTable.FaceIcon:GetRowCount() do
		local tRow = g_tTable.FaceIcon:GetRow(i)
		if tRow.szCommand and tRow.szCommand ~= "" then
			local tEmotion = {
				szEmo = tRow.szCommand,
				dwID = tRow.dwID,
			}
			table.insert(wzUtil.tEmotions, tEmotion)
		end
	end
	local fnSort = function(tEmotion1, tEmotion2)
		return (tEmotion1.szEmo < tEmotion2.szEmo)
	end
	table.sort(wzUtil.tEmotions, fnSort)
end

wzUtil.Talk_EmotionTableFromString = function(szContent)
	local tSay = {}
	local nPos = string.find(szContent, "#")
	local i = 1
	while nPos do
		if nPos > 1 then
			local nForeEnd = nPos - 1
			local szFore = string.sub(szContent, 1, nForeEnd)
			tSay[i] = {type = "text", text = szFore}
			szContent = string.sub(szContent, nPos)
			i = i + 1
		end
		
		local szEmotion = ""
		local dwEmoID = 0
		local nEmoLen = 3
		local nLen = string.len(szContent)
		local bFind = false
		while nEmoLen <= 7 do
			if nEmoLen > nLen then
				break
			end
			
			szEmotion = string.sub(szContent, 1, nEmoLen)
			local nFind = wzUtil.BinaryFind(wzUtil.tEmotions, "szEmo", szEmotion)
			if nFind > 0 then
				dwEmoID = wzUtil.tEmotions[nFind].dwID
				bFind = true
				break
			end
			
			nEmoLen = nEmoLen + 1
		end
		
		if bFind then
			tSay[i] = {type = "emotion", text = szEmotion, id = dwEmoID}
			if nEmoLen < nLen then
				szContent = string.sub(szContent, nEmoLen + 1)
				nPos = string.find(szContent, "#")
			else
				szContent = nil
				nPos = nil
			end
			i = i + 1
		else
			if nLen > 1 then
				szContent = string.sub(szContent, 2)
				nPos = string.find(szContent, "#")
			else
				szContent = nil
				nPos = nil
			end
		end
	end
	if szContent then
		tSay[i] = {type = "text", text = szContent}
	end
	
	return tSay
end

wzUtil.BinaryFind = function(tList, szKey, value)
	local nLow, nHigh, nMid = 1, table.getn(tList), 0
	while nLow <= nHigh do
		nMid = math.ceil((nLow + nHigh) / 2)
		local midValue = tList[nMid]
		if szKey then
			midValue = midValue[szKey]
		end
		if midValue == value then
			return nMid
		end
		if midValue > value then
			nHigh = nMid - 1
		else
			nLow = nMid + 1
		end
	end
	return 0
end

------------------------------------------------------------

wzUtil.Private_OnPlayerEnterScene = function()
	table.insert(wzUtil.tRegionPlayerList, arg0)
end

wzUtil.Private_OnPlayerLeaveScene = function()
	for i, dwID in ipairs(wzUtil.tRegionPlayerList) do
		if dwID == arg0 then
			table.remove(wzUtil.tRegionPlayerList, i)
			break
		end
	end
end

wzUtil.Private_OnNpcEnterScene = function()
	table.insert(wzUtil.tRegionNpcList, arg0)
end

wzUtil.Private_OnNpcLeaveScene = function()
	for i, dwID in ipairs(wzUtil.tRegionNpcList) do
		if dwID == arg0 then
			table.remove(wzUtil.tRegionNpcList, i)
			break
		end
	end
end

RegisterEvent("PLAYER_ENTER_SCENE", wzUtil.Private_OnPlayerEnterScene)
RegisterEvent("PLAYER_LEAVE_SCENE", wzUtil.Private_OnPlayerLeaveScene)
RegisterEvent("NPC_ENTER_SCENE", wzUtil.Private_OnNpcEnterScene)
RegisterEvent("NPC_LEAVE_SCENE", wzUtil.Private_OnNpcLeaveScene)

wzUtil.Talk_InitEmotions()