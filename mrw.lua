local mrw = CreateFrame('Frame', nil, UIParent)
mrw:SetScript('OnEvent', function()
	this[event](this)
end)
mrw:RegisterEvent('ADDON_LOADED')

mrw_listen, mrw_notify = '', ''

function mrw:ADDON_LOADED()
	if arg1 ~= 'mrw' then
		return
	end

	self:RegisterEvent('CHAT_MSG_WHISPER')

	self.orig_SendChatMessage = SendChatMessage
	SendChatMessage = function(...)
		if arg[2] == 'RAID_WARNING' then
			for player in self:split(mrw_notify) do
				self.orig_SendChatMessage('MRW:'..arg[1], 'WHISPER', nil, player)
			end
		end
		return self.orig_SendChatMessage(unpack(arg))
	end

	self.orig_ChatFrame_OnEvent = ChatFrame_OnEvent
	ChatFrame_OnEvent = function(...)
		if not ((arg[1] == 'CHAT_MSG_WHISPER' or arg[1] == 'CHAT_MSG_WHISPER_INFORM') and strfind(arg1, '^MRW:(.*)')) then
			return self.orig_ChatFrame_OnEvent(unpack(arg))
		end
	end
end

function mrw:CHAT_MSG_WHISPER()
	local _, _, message = strfind(arg1, '^MRW:(.*)')
	if message then
		for player in self:split(mrw_listen) do
			if strupper(player) == strupper(arg2) then
				self.orig_SendChatMessage(arg2..': '..message, 'RAID_WARNING')
				return
			end
		end
	end
end

function mrw:split(str)
	return string.gfind(str, '%s*(%a+)%s*,?')
end

function mrw:log(msg)
    DEFAULT_CHAT_FRAME:AddMessage('[mrw] '..msg, 1, 1, 0)
end

SLASH_MRW1 = '/mrw'
function SlashCmdList.MRW(str)
	local _, _, command, players = strfind(str, '%s*(%a*)%s*(.*)')
	if command == '' then
		mrw:log('Listen: '..mrw_listen)
		mrw:log('Notify: '..mrw_notify)
	elseif command == 'listen' then
		mrw_listen = players
		mrw:log('Listen: '..mrw_listen)
	elseif command == 'notify' then
		mrw_notify = players
		mrw:log('Notify: '..mrw_notify)
	end
end

