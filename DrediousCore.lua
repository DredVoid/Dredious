local discordia = require("discordia")
local client = discordia.Client()
local prefix = ";"
local http = require('coro-http')
local json = require('json')
local dredtoken = 'NTY5ODYwMjYzMDg4NDg4NDQ4.XMFfDw.Ya16g-PDJhOT8msiHTjJGjRZT7s'

local commandlist = {
	{name = ";info"; desc = "Shows info about the Bot."};
	{name = ";cmds"; desc = "Shows the Bot Commands."};
	{name = ";dvinvite"; desc = "Gives you the Invite to DVStudio Discord."};
	{name = ";quotes"; desc = "Shows a random quote."};
	{name = ";dice"; desc = "Gives a random number from 1 to 6."};
	{name = ";meme"; desc = "Shows a random meme."};
	{name = ";8ball (question)"; desc = "Gives you answers about what you asked."};
	{name = ";changestatus (Message)"; desc = "Changes my Playing Status.(DredVoid only)"};
	{name = ";ship (mentions)"; desc = "Test how much you love your mentioned user, or someone with someone."};
	{name = ";profile (name)"; desc = "Shows the Roblox Profile from the given name."};
	{name = ";groupinfo (groupId)"; desc = "Shows the Group's Name, Description, and Shout."}
}

client:on('messageCreate', function(message) 
	if message.content == prefix..'cmds' then
		local cmdmsg = '<@!'..message.member.id..'>  \n**Keep in mind that I sometimes give slow response if no commands used for long time.** \n```'
		for i,v in pairs(commandlist) do
			cmdmsg = cmdmsg..""..v.name.." | "..v.desc..'\n'
		end
		cmdmsg = cmdmsg.."```"
		message.channel:send(cmdmsg)
	elseif message.content == prefix..'info' then
		message.channel:send('Hello! I am Dredious, Bot made by DredVoid. I only have a few commands here.\n I will also not be Online if DredVoid has not taken control of me.')
	elseif message.content == prefix..'dice' then
		message.channel:send('<@!'..message.member.id..'> You rolled '..math.random(1,6)..'!')
	elseif message.content == prefix..'dvinvite' then
		message.channel:send('<@!'..message.member.id..'> https://discord.gg/xb47man')
	elseif string.sub(message.content, 1, 13) == prefix..'changestatus' then
		if tostring(message.member.id) == '403891356268757004' then
			client:setGame(string.sub(message.content, 15))
			message.channel:send("<@!"..message.member.id.."> Successfully changed my Status!")
		else
			message.channel:send("<@!"..message.member.id.."> The command can only be operated by DredVoid.")
		end
	elseif message.content == prefix..'quotes' then
		local result, body = http.request("GET", 'https://quota.glitch.me/random')
		body = json.parse(body)
		message.channel:send(tostring('"*'..body['quoteText']..'*" -'..body['quoteAuthor']))
	elseif message.content == prefix..'meme' then
		local result, body = http.request("GET", 'https://meme-api.herokuapp.com/gimme')
		body = json.parse(body)
		message.channel:send(tostring(body['url']))
	elseif string.sub(message.content,1 ,6 ) == prefix..'8ball' then
		if string.sub(message.content, 8) == "" or not tostring(string.sub(message.content, 8)) then
			message.channel:send('<@!'..message.member.id..'> Please include the question!')
			return
		end
		local result, body = http.request("GET", 'https://8ball.delegator.com/magic/JSON/'..string.sub(message.content, 8))
		body = json.parse(body)
		message.channel:send(tostring(body['magic']['answer']))
	elseif string.sub(message.content,1 ,5) == prefix..'ship' then
		local mentions = message.mentionedUsers
		local value = math.random(0, 100)
		if #mentions == 1 then
			message.channel:send(':heart:**MATCHING**:heart:\n <@!'..message.member.id..'> **'..value..'**% :heart: <@!'..mentions[1][1]..'>')
		elseif #mentions == 2 then
			message.channel:send(':heart:**MATCHING**:heart:\n <@!'..mentions[1][1]..'> **'..value..'**% :heart: <@!'..mentions[1][2]..'>')
		elseif #mentions == 0 or #mentions >= 3 then
			message.channel:send('<@!'..message.member.id..'> Mention one person you like, or who with who.')
		end
	elseif string.sub(message.content, 1, 8) == prefix..'profile' and tostring(string.sub(message.content, 10)) then
		local username = string.sub(message.content, 10)
		if username == "" or not tostring(username) or #message.mentionedUsers >= 1 then
			message.channel:send('<@!'..message.member.id..'> Please include the name!')
			return
		end
		local result, body = http.request("GET", 'https://api.roblox.com/users/get-by-username?username='..username)
		body = json.parse(body)
		if body['Id'] then
			message.channel:send(tostring('<@!'..message.member.id..'> https://www.roblox.com/users/'..body['Id']..'/profile'))
		else
			message.channel:send('<@!'..message.member.id..'> Profile not found!')
		end
	elseif string.sub(message.content, 1, 10) == prefix..'groupinfo' then
		if tonumber(string.sub(message.content, 12)) and string.sub(message.content, 12) ~= "" then
			local result, body = http.request("GET", 'https://groups.roblox.com/v1/groups/'..string.sub(message.content, 12))
			body = json.parse(body)
			if body and body['name'] then
				if body['shout'] then
					message.channel:send(tostring('<@!'..message.member.id..'>\n **Name**:```'..body['name']..'```\n**Description**:```'..body['description']..'```\n**Shout**:```'..body['shout']['body']..'```'))
				else
					message.channel:send(tostring('<@!'..message.member.id..'>\n **Name**:```'..body['name']..'```\n**Description**:```'..body['description']..'```'))
				end
			else
				message.channel:send(tostring('<@!'..message.member.id..'> Group not found!'))
			end
		else
			message.channel:send(tostring('<@!'..message.member.id..'> Please include the Group Id!'))
		end
	end
end)
client:run('Bot '..dredtoken)
client:setGame(';cmds ;dvinvite')
client:on('memberUpdate')
