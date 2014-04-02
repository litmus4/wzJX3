wzUtil = {

	tRegionPlayerList = {},

	tRegionNpcList = {},
	
	tTeamMarkStrs = {"[ÔÆ]", "[½£]", "[¸«]", "[¹³]", "[¹Ä]", "[¼ôµ¶]", "[°ôé³]", "[ÈçÒâ]", "[ïÚ]", "[ÉÈ×Ó]"},
	
	tEmotions = {"Î¢Ð¦", "¿ÉÁ¯", "ÍÂ", "ÃÄÑÛ", "º¦Ðß", "ÞÏÞÎ", "¿ñº¹", "¿Ö»Å", "ÉúÆø", "»è",
		"Á÷Àá", "Ç×Ç×", "³ÁÄ¬", "ÎÞÄÎ", "°ÁÂý", "Àäº¹", "´óÐ¦", "ÒõÏÕ", "ÄÑ¹ý", "ÌÖÑá",
		"°ÍÕÆ", "Á÷º¹", "·¢Å­", "ÐÀÏ²", "¿ÚË®", "ÏÅ", "´ô", "àÞ", "ßÚÑÀ", "¶ñÐÄ",
		"À§", "Ð×¶ñ", "½ÆÕ©", "µÃÒâ", "¹íÁ³", "±â×ì", "Æ²×ì", "ÔÎ", "½Æ»«", "Ë¯",
		"ÉàÍ·", "É«", "ÑÈÒì", "±ÉÊÓ", "¿á", "Ç®", "´¸×Ó", "´òÀ×", "ÎÊºÅ", "ºìµÆ",
		"ÂÌµÆ", "»ÆµÆ", "ÏÂÓê", "µ¶", "¿§·È", "Ï²»¶", "×ì", "´½", "ÐÄËé", "¸ÐÌ¾ºÅ",
		"ÅÄÊÖ", "ÎÕÊÖ", "Öí", "Ãµ¹å", "µç»°", "µÆÅÝ", "±¿Öí", "ÔÂÁÁ", "²¤ÂÜ", "÷¼÷Ã",
		"ÀñÎï", "ÑÏº®", "º®", "Ë¥", "»¨", "Ïã½¶", "Ñ©¸â", "Ê¤Àû", "Æ»¹û", "ÒûÁÏ",
		"ÂøÍ·", "Î÷¹Ï", "ÑÌ»¨", "±ê¼Ç", "ËâÍ·", "Ì«Ñô", "°®ÐÄ", "Ç¿", "²î¾¢", "Ó£ÌÒ"
	},
	
}

function wzUtil.Scene_GetPlayerList()
	return wzUtil.tRegionPlayerList
end

function wzUtil.Scene_GetPlayerByName(szName)
	for i, dwID in ipairs(wzUtil.tRegionPlayerList) do
		local tPlayer = GetPlayer(dwID)
		if tPlayer.szName == szName then
			return tPlayer
		end
	end
	return nil
end

function wzUtil.Scene_GetNpcList()
	return wzUtil.tRegionNpcList
end

function wzUtil.Scene_GetNpcByName(szName)
	for i, dwID in ipairs(wzUtil.tRegionNpcList) do
		local tNpc = GetNpc(dwID)
		if tNpc.szName == szName then
			return tNpc
		end
	end
	return nil
end

function wzUtil.Talk_EmotionTableFromString(szContent)
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
		local nEmoLen = 3
		local nLen = string.len(szContent)
		local bFind = false
		while nEmoLen <= 7 do
			if nEmoLen > nLen then
				break
			end
			
			szEmotion = string.sub(szContent, 1, nEmoLen)
			local szEmo = string.sub(szEmotion, 2)
			local nFind = wzUtil.BinaryFind(wzUtil.tEmotions, szEmo)
			if nFind > 0 then
				bFind = true
				break
			end
			
			nEmoLen = nEmoLen + 2
		end
		
		if bFind then
			tSay[i] = {type = "text", text = szEmotion}
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

function wzUtil.BinaryFind(tList, value)
	local nLow, nHigh, nMid = 1, table.getn(tList), 0
	while nLow <= nHigh do
		nMid = math.ceil((nLow + nHigh) / 2)
		if tList[nMid] == value then
			return nMid
		end
		if tList[nMid] > value then
			nHigh = nMid - 1
		else
			nLow = nMid + 1
		end
	end
	return 0
end

------------------------------------------------------------

function wzUtil.Private_OnPlayerEnterScene()
	table.insert(wzUtil.tRegionPlayerList, arg0)
end

function wzUtil.Private_OnPlayerLeaveScene()
	for i, dwID in ipairs(wzUtil.tRegionPlayerList) do
		if dwID == arg0 then
			table.remove(wzUtil.tRegionPlayerList, i)
			break
		end
	end
end

function wzUtil.Private_OnNpcEnterScene()
	table.insert(wzUtil.tRegionNpcList, arg0)
end

function wzUtil.Private_OnNpcLeaveScene()
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

table.sort(wzUtil.tEmotions)