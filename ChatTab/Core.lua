local f = CreateFrame("Frame")
f:RegisterEvent("VARIABLES_LOADED")
f:SetScript("OnEvent", function(self, e, ...)
	if (e == "VARIABLES_LOADED") then
		-- Set Alpha of faded tabs to 0
		CHAT_FRAME_TAB_NORMAL_NOMOUSE_ALPHA = 0
		CHAT_FRAME_TAB_SELECTED_NOMOUSE_ALPHA = 0
		 
		for _, i in ipairs(CHAT_FRAMES) do
			FCFTab_UpdateAlpha(_G[i])
		end
		
		-- Hide Micro Button
		FriendsMicroButton:Hide()
		
		-- Move B.NET Alert frame down due to Friend button being hidden
		BN_TOAST_TOP_OFFSET = 10
	end
end)