wzUtil = {
	
	tEmotions = {"΢Ц", "����", "��", "����", "����", "����", "��", "�ֻ�", "����", "��",
		"����", "����", "��Ĭ", "����", "����", "�亹", "��Ц", "����", "�ѹ�", "����",
		"����", "����", "��ŭ", "��ϲ", "��ˮ", "��", "��", "��", "����", "����",
		"��", "�׶�", "��թ", "����", "����", "����", "Ʋ��", "��", "�ƻ�", "˯",
		"��ͷ", "ɫ", "����", "����", "��", "Ǯ", "����", "����", "�ʺ�", "���",
		"�̵�", "�Ƶ�", "����", "��", "����", "ϲ��", "��", "��", "����", "��̾��",
		"����", "����", "��", "õ��", "�绰", "����", "����", "����", "����", "����",
		"����", "�Ϻ�", "��", "˥", "��", "�㽶", "ѩ��", "ʤ��", "ƻ��", "����",
		"��ͷ", "����", "�̻�", "���", "��ͷ", "̫��", "����", "ǿ", "�", "ӣ��"
	},
	
}

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

table.sort(wzUtil.tEmotions)