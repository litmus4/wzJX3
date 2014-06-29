wzCompass = {
	bOpen = true,
	bCanDrag = true,
	nX = 800,
	nY = 30,
	nMarkHeight = 4,
	
	bArrow = false,
	nState = -1,
}

RegisterCustomData("wzCompass.bOpen")
RegisterCustomData("wzCompass.bCanDrag")
RegisterCustomData("wzCompass.nX")
RegisterCustomData("wzCompass.nY")
RegisterCustomData("wzCompass.nMarkHeight")

function wzCompass.OnFrameCreate()
	this:RegisterEvent("CUSTOM_DATA_LOADED")
end

function wzCompass.OnFrameBreathe()
	local player = GetClientPlayer()
	if not player then
		return
	end
	
	local TargetType, dwTargetID = player.GetTarget()
	local target = GetTargetHandle(TargetType, dwTargetID)
	
	local nFrame = wzCompass:GetRelativeDirectionFrame(player, target)
	if nFrame > 0 then
		wzCompass:SetShowFrame(nFrame)
		if not wzCompass.bArrow then
			wzCompass.bArrow = true
		end
	elseif wzCompass.bArrow then
		wzCompass:SetShowFrame(0)
		wzCompass.bArrow = false
	end
	wzCompass:SetDistanceText(player, target)
end

function wzCompass.OnEvent(event)
	if event == "CUSTOM_DATA_LOADED" then
		local frame = Station.Lookup("Normal/wzCompass")
		if not frame then
			return
		end
		if not wzCompass.bOpen then
			frame:Hide()
		end
		frame:SetMousePenetrable(not wzCompass.bCanDrag)
		frame:SetAbsPos(wzCompass.nX, wzCompass.nY)
	end
end

function wzCompass.OnFrameDragEnd()
	local frame = Station.Lookup("Normal/wzCompass")
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
	if nX > w - 70 then
		nX = w - 70
	end
	if nY > h - 70 then
		nY = h - 70
	end
	wzCompass.nX, wzCompass.nY = nX, nY
	frame:SetAbsPos(nX, nY)
end

function wzCompass:SetShowFrame(nFrame)
	local frame = Station.Lookup("Normal/wzCompass")
	if not frame then
		return
	end
	local image_compass = frame:Lookup("", "Image_Compass")
	image_compass:FromUITex("interface\\wzAddons\\wzCompass\\Arrow.UITex", nFrame)
end

function wzCompass:SetDistanceText(player, target)
	if not target then
		if wzCompass.nState == 0 then
			return
		end
		
		wzCompass:SetShowText("无目标")
		wzCompass.nState = 0
	elseif player.dwID == target.dwID then
		if wzCompass.nState == 1 then
			return
		end
		
		wzCompass:SetShowText("自己")
		wzCompass.nState = 1
	else
		local szDis = ("%.2f"):format(GetCharacterDistance(player.dwID, target.dwID) / 64)
		local szUpDown = ""
		if target.nZ - player.nZ >= wzCompass.nMarkHeight * 512 then
			szUpDown = "上"
		elseif player.nZ - target.nZ >= wzCompass.nMarkHeight * 512 then
			szUpDown = "下"
		end
		wzCompass:SetShowText(szDis..szUpDown)
		
		if wzCompass.nState ~= 2 then
			wzCompass.nState = 2
		end
	end
end

function wzCompass:SetShowText(szText)
	local frame = Station.Lookup("Normal/wzCompass")
	if not frame then
		return
	end
	local text_distance = frame:Lookup("", "Text_Distance")
	text_distance:SetText(szText)
end

function wzCompass:GetRelativeDirectionFrame(player, target)
	if not target then
		return 0
	end
	
	--[[
	local scene = player.GetScene()
	if not scene then
		return -1
	end
	local scene3D = KG3DEngine.GetScene(scene.dwID)
	if not scene3D then
		return -1
	end
	local camera = scene3D:GetCamera()
	if not camera then
		return -1
	end
	local nGfxCamX, nGfxCamY, nGfxCamZ = camera:GetPosition()
	local nGfxAtX, nGfxAtY, nGfxAtZ = camera:GetLookAtPosition()
	local nLogCamX, nLogCamY, nLogCamZ = Scene_ScenePositionToGameWorldPosition(nGfxCamX, nGfxCamY, nGfxCamZ)
	local nLogAtX, nLogAtY, nLogAtZ = Scene_ScenePositionToGameWorldPosition(nGfxAtX, nGfxAtY, nGfxAtZ)
	local nPlayerDirX = nLogAtX - nLogCamX
	local nPlayerDirY = nLogAtY - nLogCamY
	local nPlayerAngle = wzCompass:CalAngleFromDirVec(nPlayerDirX, nPlayerDirY)
	--]]
	local fCameraToObjectEyeScale, fYaw, fPitch = Camera_GetRTParams()
	local nYawAngle = 360 - math.ceil(fYaw / math.pi * 180)
	local nPlayerAngle = nYawAngle + 90 --player.nFaceDirection / 255 * 360
	if nPlayerAngle >= 360 then
		nPlayerAngle = nPlayerAngle - 360
	end
	
	local nTargetDirX = target.nX - player.nX
	local nTargetDirY = target.nY - player.nY
	local nTargetAngle = wzCompass:CalAngleFromDirVec(nTargetDirX, nTargetDirY)
	if nTargetAngle < 0 then
		return 0
	end
	
	local nRelativeAngle = math.abs(nPlayerAngle - nTargetAngle)
	if nPlayerAngle >= nTargetAngle then
		nRelativeAngle = 360 - nRelativeAngle
	end
	
	if nRelativeAngle >= 355 then
		return 1
	end
	return math.ceil((nRelativeAngle + 5) / 10)
end

function wzCompass:CalAngleFromDirVec(nDirX, nDirY)
	local nDirK = math.sqrt(nDirX ^ 2 + nDirY ^ 2)
	if nDirK == 0 then
		return -1
	end
	local nAngle = math.deg(math.asin(math.abs(nDirY) / math.abs(nDirK)))
	if nDirX >= 0 and nDirY >= 0 then
		nAngle = nAngle + 0
	elseif nDirX < 0 and nDirY >= 0 then
		nAngle = 180 - nAngle
	elseif nDirX < 0 and nDirY < 0 then
		nAngle = nAngle + 180
	elseif nDirX >= 0 and nDirY < 0 then
		nAngle = 360 - nAngle
	end
	return nAngle
end

function wzCompass:WndSwitch(bShow)
	local frame = Station.Lookup("Normal/wzCompass")
	if not frame then
		return
	end
	if bShow then
		frame:Show()
	else
		frame:Hide()
	end
	wzCompass.bOpen = bShow
end

function wzCompass:SetCanDrag(bCan)
	local frame = Station.Lookup("Normal/wzCompass")
	if not frame then
		return
	end
	frame:SetMousePenetrable(not bCan)
	wzCompass.bCanDrag = bCan
end

function wzCompass:InputMarkHeight()
	local Recall = function(nHeight)
		if not nHeight then
			return
		end
		wzCompass.nMarkHeight = nHeight
	end
	GetUserInputNumber(wzCompass.nMarkHeight, 20000, nil, Recall, nil, function() end)
end

function wzCompass.GetMenu()
	local menu = {
		szOption = "目标指南针",
		{
			szOption = "开启目标指南针",
			bCheck = true,
			bChecked = wzCompass.bOpen,
			fnAction = function() wzCompass:WndSwitch(not wzCompass.bOpen) end,
			fnAutoClose = function() return true end,
		},
		{bDevide = true},
		{
			szOption = "界面可拖动",
			bCheck = true,
			bChecked = wzCompass.bCanDrag,
			fnAction = function() wzCompass:SetCanDrag(not wzCompass.bCanDrag) end,
			fnAutoClose = function() return true end,
		},
		{
			szOption = "设置提示高度差",
			fnAction = function() wzCompass:InputMarkHeight() end,
		},
	}
	return menu
end

RegisterEvent("LOGIN_GAME", function()
	local tMenu = {
		function()
			return {wzCompass.GetMenu()}
		end,
	}
	Player_AppendAddonMenu(tMenu)
end)

Wnd.OpenWindow("interface\\wzAddons\\wzCompass\\wzCompass.ini", "wzCompass")
OutputMessage("MSG_SYS", "目标指南针加载成功！\n")