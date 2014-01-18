---------------------------------------------------------
-- KillingBlows
---------------------------------------------------------
KillDB = KillDB or { Enabled = true }
local KillTimer, KillCounter
local KB_FILTER_ENEMY = bit.bor(
	COMBATLOG_OBJECT_AFFILIATION_PARTY,
	COMBATLOG_OBJECT_AFFILIATION_RAID,
	COMBATLOG_OBJECT_AFFILIATION_OUTSIDER,
	COMBATLOG_OBJECT_REACTION_NEUTRAL,
	COMBATLOG_OBJECT_REACTION_HOSTILE,
	COMBATLOG_OBJECT_CONTROL_PLAYER,
	COMBATLOG_OBJECT_TYPE_PLAYER
)
---------------------------------------------------------
local OnLoad = function(self)
	self:UnregisterEvent("VARIABLES_LOADED")
	SLASH_KillingBlow1 = "/killblow"
	SlashCmdList["KillingBlow"] = function()
		KillDB.Enabled = not KillDB.Enabled
		DEFAULT_CHAT_FRAME:AddMessage("|cff00aa00Killing Blows|r: Enabled = "..tostring(KillDB.Enabled))
	end
end
---------------------------------------------------------
local OnEvent = function(self, event, ...)
	if (event == "VARIABLES_LOADED") then
		OnLoad(self)
	elseif (event == "COMBAT_LOG_EVENT_UNFILTERED") then
		local _, cmbEvent, _, sGUID, _, _, _, _, _, dFlag = select(1, ...)
		if (cmbEvent == "PARTY_KILL") then
			if (sGUID == UnitGUID("player") and CombatLog_Object_IsA(dFlag, KB_FILTER_ENEMY) and KillDB.Enabled) then
				if (not KillTimer or (GetTime() - KillTimer > 60)) then
					PlaySoundFile("Interface\\AddOns\\KillingBlows\\Sounds\\firstblood.mp3")
					KillCounter = 0
				elseif (GetTime() - KillTimer <= 60) then
					KillCounter = KillCounter + 1
					if (KillCounter == 1) then
						PlaySoundFile("Interface\\AddOns\\KillingBlows\\Sounds\\dominating.mp3")
					elseif (KillCounter == 2) then
						PlaySoundFile("Interface\\AddOns\\KillingBlows\\Sounds\\killingspree.mp3")
					elseif (KillCounter == 3) then
						PlaySoundFile("Interface\\AddOns\\KillingBlows\\Sounds\\unstoppable.mp3")
					elseif (KillCounter > 3) then
						PlaySoundFile("Interface\\AddOns\\KillingBlows\\Sounds\\godlike.mp3")
					end
				end
				KillTimer = GetTime()
			end
		end
	end
end
---------------------------------------------------------
local f = CreateFrame("Frame", nil, UIParent) --Frame, nil, UIParent
f:RegisterEvent("VARIABLES_LOADED")
f:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
f:SetScript("OnEvent", OnEvent)