----------������----------
wzCareTag = {}

----------ϵͳ����----------
function wzCareTag.OnFrameCreate()
	local frame = Station.Lookup("Normal/wzCareTag")
	if not frame then
		frame = Wnd.OpenWindow("interface\\wzAddons\\wzCareTag\\wzCareTag.ini", "wzCareTag")
	end
	frame:Show()
	OutputMessage("MSG_SYS", "��ȱ����سɹ���\n")
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

	local szInfo = "��ս������"..wzCareTag:GetSingleDurabilityString(player, EQUIPMENT_INVENTORY.MELEE_WEAPON).."\n"..
		"Զ��������"..wzCareTag:GetSingleDurabilityString(player, EQUIPMENT_INVENTORY.RANGE_WEAPON).."\n"..
		"ñ�ӣ�"..wzCareTag:GetSingleDurabilityString(player, EQUIPMENT_INVENTORY.HELM).."\n"..
		"���£�"..wzCareTag:GetSingleDurabilityString(player, EQUIPMENT_INVENTORY.CHEST).."\n"..
		"����"..wzCareTag:GetSingleDurabilityString(player, EQUIPMENT_INVENTORY.BANGLE).."\n"..
		"������"..wzCareTag:GetSingleDurabilityString(player, EQUIPMENT_INVENTORY.WAIST).."\n"..
		"��װ��"..wzCareTag:GetSingleDurabilityString(player, EQUIPMENT_INVENTORY.PANTS).."\n"..
		"Ь�ӣ�"..wzCareTag:GetSingleDurabilityString(player, EQUIPMENT_INVENTORY.BOOTS)

	OutputTip("<Text>text="..EncodeComponentsString(szInfo).." font=100 </text>", 1000, {nMouseX, nMouseY, 82, 27})
end

function wzCareTag.OnItemMouseLeave()
	HideTip()
end

----------�Զ��庯��----------
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
			szDura = "��װ��"
		end
		return szDura
	end
	return "nil"
end

---[[ ���Ժ���
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

	local szInfo = "�ܰٷֱȣ�"..nPercent.."%\n"..
		"��ս������"..wzCareTag:GetSingleDurabilityString(player, EQUIPMENT_INVENTORY.MELEE_WEAPON).."\n"..
		"Զ��������"..wzCareTag:GetSingleDurabilityString(player, EQUIPMENT_INVENTORY.RANGE_WEAPON).."\n"..
		"ñ�ӣ�"..wzCareTag:GetSingleDurabilityString(player, EQUIPMENT_INVENTORY.HELM).."\n"..
		"���£�"..wzCareTag:GetSingleDurabilityString(player, EQUIPMENT_INVENTORY.CHEST).."\n"..
		"����"..wzCareTag:GetSingleDurabilityString(player, EQUIPMENT_INVENTORY.BANGLE).."\n"..
		"������"..wzCareTag:GetSingleDurabilityString(player, EQUIPMENT_INVENTORY.WAIST).."\n"..
		"��װ��"..wzCareTag:GetSingleDurabilityString(player, EQUIPMENT_INVENTORY.PANTS).."\n"..
		"Ь�ӣ�"..wzCareTag:GetSingleDurabilityString(player, EQUIPMENT_INVENTORY.BOOTS).."\n"

	OutputMessage("MSG_SYS", szInfo)
end

Hotkey.AddBinding("FreshDebug", "��ʾ�;���Ϣ", "��ʾ�;�", FreshDebug, nil)
--]]

Wnd.OpenWindow("interface\\wzAddons\\wzCareTag\\wzCareTag.ini", "wzCareTag")