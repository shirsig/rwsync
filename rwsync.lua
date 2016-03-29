local rwsync = CreateFrame('Frame', nil, UIParent)
rwsync:SetScript('OnEvent', function()
	this[event](this)
end)
rwsync:RegisterEvent('ADDON_LOADED')

rwsync_channel, rwsync_players = '', ''

function rwsync:ADDON_LOADED()
	if arg1 ~= 'rwsync' then
		return
	end

	self:RegisterEvent('CHAT_MSG_CHANNEL')

	self.orig_SendChatMessage = SendChatMessage
	SendChatMessage = function(...)
		local message, type = arg[1], arg[2]
		if type == 'RAID_WARNING' then
			self.orig_SendChatMessage(message, 'CHANNEL', nil, GetChannelName(rwsync_channel))
		end
		return self.orig_SendChatMessage(unpack(arg))
	end

	self.orig_ChatFrame_OnEvent = ChatFrame_OnEvent
	ChatFrame_OnEvent = function(...)
		local event, channel = arg[1], arg9
		if not (event == 'CHAT_MSG_CHANNEL' and strlower(channel) == rwsync_channel) then
			return self.orig_ChatFrame_OnEvent(unpack(arg))
		end
	end
end

function rwsync:CHAT_MSG_CHANNEL()
	local channel, message, sender = arg9, arg1, arg2
	if channel == rwsync_channel then
		for player in self:split(rwsync_players) do
			if strlower(sender) == player then
				self.orig_SendChatMessage(sender..': '..message, 'RAID_WARNING')
				return
			end
		end
	end
end

function rwsync:split(str)
	return string.gfind(str, '%s*(%a+)%s*,?')
end

function rwsync:log(msg)
    DEFAULT_CHAT_FRAME:AddMessage('[rwsync] '..msg, 1, 1, 0)
end

SLASH_RWSYNC1 = '/rwsync'
function SlashCmdList.RWSYNC(str)
	local _, _, command, arg = strfind(str, '%s*(%a*)%s*(%S*)')
	if command == '' then
		rwsync:log('Channel: '..rwsync_channel)
		rwsync:log('Players: '..rwsync_players)
	elseif command == 'channel' then
		rwsync_channel = strlower(arg)
		rwsync:log('Channel: '..rwsync_channel)
	elseif command == 'players' then
		rwsync_players = strlower(arg)
		rwsync:log('Players: '..rwsync_players)
	end
end

