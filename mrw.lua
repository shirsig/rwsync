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

	self.origSendChatMessage = SendChatMessage
	SendChatMessage = function(...)
		if arg[2] == 'RAID_WARNING' then
			for player in self:split(mrw_notify) do
				SendChatMessage('MRW:'..arg[1], 'WHISPER', nil, player)
			end
		end
		return self.origSendChatMessage(unpack(arg))
	end
end

function mrw:CHAT_MSG_WHISPER()
	local _, _, message = strfind(arg1, '^MRW:(.*)')
	if message then
		for player in self:split(mrw_listen) do
			if strupper(player) == strupper(arg2) then
				self.origSendChatMessage('['..arg2..']: '..message, 'RAID_WARNING')
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
	elseif command == 'notify' then
		mrw_notify = players
	end
end

