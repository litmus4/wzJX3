----------面板对象----------
wzCareTag = {}

----------系统函数----------
function wzCareTag.OnFrameCreate()
	local frame = Station.Lookup("Normal/wzCareTag")
	if not frame then
		frame = Wnd.OpenWindow("interface\\wzAddons\\wzCareTag\\wzCareTag.ini", "wzCareTag")
	end
	frame:Show()
	OutputMessage("MSG_SYS", "守缺笺加载成功！\n")
end

function wzCareTag.OnFrameBreathe()
	local player = GetClientPlayer()
	if not player then
		return
	end

	local nTCurr = wzCareTag:CalTotalCurrentDurability(player)
	local nTMax = wzCareTag:CalTotalMaxDurability(player)
	if nTCurr == -1 or nTMax == -1 then
		return
	end

	local frame = Station.Lookup("Normal/wzCareTag")
	if not frame then
		return
	end

	local nPercent = math.floor(nTCurr / nTMax * 100)
	local szText = frame:Lookup("", "Text_CareTag")
	szText:SetText(nPercent.."%")
end

function wzCareTag.OnRButtonClick()
	local nMouseX, nMouseY = Cursor.GetPos()
	local player = GetClientPlayer()
	if not player then
		return
	end

	local szInfo = "近战武器："..wzCareTag:GetSingleDurabilityString(player, EQUIPMENT_INVENTORY.MELEE_WEAPON).."\n"..
		"远程武器："..wzCareTag:GetSingleDurabilityString(player, EQUIPMENT_INVENTORY.RANGE_WEAPON).."\n"..
		"帽子："..wzCareTag:GetSingleDurabilityString(player, EQUIPMENT_INVENTORY.HELM).."\n"..
		"上衣："..wzCareTag:GetSingleDurabilityString(player, EQUIPMENT_INVENTORY.CHEST).."\n"..
		"护腕："..wzCareTag:GetSingleDurabilityString(player, EQUIPMENT_INVENTORY.BANGLE).."\n"..
		"腰带："..wzCareTag:GetSingleDurabilityString(player, EQUIPMENT_INVENTORY.WAIST).."\n"..
		"下装："..wzCareTag:GetSingleDurabilityString(player, EQUIPMENT_INVENTORY.PANTS).."\n"..
		"鞋子："..wzCareTag:GetSingleDurabilityString(player, EQUIPMENT_INVENTORY.BOOTS)

	OutputTip("<Text>text="..EncodeComponentsString(szInfo).." font=100 </text>", 1000, {nMouseX, nMouseY, 82, 27})
end

function wzCareTag.OnItemMouseLeave()
	HideTip()
end

----------自定义函数----------
function wzCareTag:CalTotalCurrentDurability(player)
	local nVal = 0
	local item
	if player then
		item = player.GetItem(INVENTORY_INDEX.EQUIP, EQUIPMENT_INVENTORY.MELEE_WEAPON)
		if item then nVal = nVal + item.nCurrentDurability end
		item = player.GetItem(INVENTORY_INDEX.EQUIP, EQUIPMENT_INVENTORY.RANGE_WEAPON)
		if item then nVal = nVal + item.nCurrentDurability end
		item = player.GetItem(INVENTORY_INDEX.EQUIP, EQUIPMENT_INVENTORY.HELM)
		if item then nVal = nVal + item.nCurrentDurability end
		item = player.GetItem(INVENTORY_INDEX.EQUIP, EQUIPMENT_INVENTORY.CHEST)
		if item then nVal = nVal + item.nCurrentDurability end
		item = player.GetItem(INVENTORY_INDEX.EQUIP, EQUIPMENT_INVENTORY.BANGLE)
		if item then nVal = nVal + item.nCurrentDurability end
		item = player.GetItem(INVENTORY_INDEX.EQUIP, EQUIPMENT_INVENTORY.WAIST)
		if item then nVal = nVal + item.nCurrentDurability end
		item = player.GetItem(INVENTORY_INDEX.EQUIP, EQUIPMENT_INVENTORY.PANTS)
		if item then nVal = nVal + item.nCurrentDurability end
		item = player.GetItem(INVENTORY_INDEX.EQUIP, EQUIPMENT_INVENTORY.BOOTS)
		if item then nVal = nVal + item.nCurrentDurability end
		return nVal
	end
	return -1
end

function wzCareTag:CalTotalMaxDurability(player)
	local nVal = 0
	local item
	if player then
		item = player.GetItem(INVENTORY_INDEX.EQUIP, EQUIPMENT_INVENTORY.MELEE_WEAPON)
		if item then nVal = nVal + item.nMaxDurability end
		item = player.GetItem(INVENTORY_INDEX.EQUIP, EQUIPMENT_INVENTORY.RANGE_WEAPON)
		if item then nVal = nVal + item.nMaxDurability end
		item = player.GetItem(INVENTORY_INDEX.EQUIP, EQUIPMENT_INVENTORY.HELM)
		if item then nVal = nVal + item.nMaxDurability end
		item = player.GetItem(INVENTORY_INDEX.EQUIP, EQUIPMENT_INVENTORY.CHEST)
		if item then nVal = nVal + item.nMaxDurability end
		item = player.GetItem(INVENTORY_INDEX.EQUIP, EQUIPMENT_INVENTORY.BANGLE)
		if item then nVal = nVal + item.nMaxDurability end
		item = player.GetItem(INVENTORY_INDEX.EQUIP, EQUIPMENT_INVENTORY.WAIST)
		if item then nVal = nVal + item.nMaxDurability end
		item = player.GetItem(INVENTORY_INDEX.EQUIP, EQUIPMENT_INVENTORY.PANTS)
		if item then nVal = nVal + item.nMaxDurability end
		item = player.GetItem(INVENTORY_INDEX.EQUIP, EQUIPMENT_INVENTORY.BOOTS)
		if item then nVal = nVal + item.nMaxDurability end
		return nVal
	end
	return -1
end

function wzCareTag:GetSingleDurabilityString(player, type)
	local szDura
	local item
	if player then
		item = player.GetItem(INVENTORY_INDEX.EQUIP, type)
		if item then
			szDura = item.nCurrentDurability.."/"..item.nMaxDurability..""
		else
			szDura = "无装备"
		end
		return szDura
	end
	return "nil"
end

---[[ 调试函数
function FreshDebug()
	local player = GetClientPlayer()
	if not player then
		return
	end

	local nTCurr = wzCareTag:CalTotalCurrentDurability(player)
	local nTMax = wzCareTag:CalTotalMaxDurability(player)
	if nTCurr == -1 or nTMax == -1 then
		return
	end
	local nPercent = math.floor(nTCurr / nTMax * 100)

	local szInfo = "总百分比："..nPercent.."%\n"..
		"近战武器："..wzCareTag:GetSingleDurabilityString(player, EQUIPMENT_INVENTORY.MELEE_WEAPON).."\n"..
		"远程武器："..wzCareTag:GetSingleDurabilityString(player, EQUIPMENT_INVENTORY.RANGE_WEAPON).."\n"..
		"帽子："..wzCareTag:GetSingleDurabilityString(player, EQUIPMENT_INVENTORY.HELM).."\n"..
		"上衣："..wzCareTag:GetSingleDurabilityString(player, EQUIPMENT_INVENTORY.CHEST).."\n"..
		"护腕："..wzCareTag:GetSingleDurabilityString(player, EQUIPMENT_INVENTORY.BANGLE).."\n"..
		"腰带："..wzCareTag:GetSingleDurabilityString(player, EQUIPMENT_INVENTORY.WAIST).."\n"..
		"下装："..wzCareTag:GetSingleDurabilityString(player, EQUIPMENT_INVENTORY.PANTS).."\n"..
		"鞋子："..wzCareTag:GetSingleDurabilityString(player, EQUIPMENT_INVENTORY.BOOTS).."\n"

	OutputMessage("MSG_SYS", szInfo)
end

Hotkey.AddBinding("FreshDebug", "显示耐久信息", "显示耐久", FreshDebug, nil)
--]]

Wnd.OpenWindow("interface\\wzAddons\\wzCareTag\\wzCareTag.ini", "wzCareTag")