ESX               = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local cooldown = 0
local cooldowntime = 600 * 6000

function Timer()
	cooldown = 1
	Citizen.Wait(cooldowntime)
	cooldown = 0
end

RegisterServerEvent('hinode_yachtrobbery:robbery')
AddEventHandler('hinode_yachtrobbery:robbery', function(text)
	local _source  = source
	local xPlayer  = ESX.GetPlayerFromId(_source)
	local xPlayers = ESX.GetPlayers()
	local police = 0
	for i=1, #xPlayers, 1 do
		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
		if xPlayer.job.name == 'police' then
			police = police+1
		end
	end
		if police > Config.LSPD-1 and cooldown == 0 then
			TriggerClientEvent("hinode_yachtrobbery:start", source)
			TriggerClientEvent("hinode_yachtrobbery:true", source)
			TriggerClientEvent("hinode_yachtrobbery:notification", source, _U('robbery_started'))
			LSPD()
			Citizen.Wait(1000)
			Timer()
		end

		if cooldown == 1 then
			TriggerClientEvent("hinode_yachtrobbery:notification", source, _U('robbed_recent'))
		end

		if police < Config.LSPD then
			TriggerClientEvent("hinode_yachtrobbery:notification", source, _U('police'))
		end
end)

RegisterServerEvent('hinode_yachtrobbery:reward')
AddEventHandler('hinode_yachtrobbery:reward', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	
	xPlayer.addMoney(GetRandomIntInRange(Config.MinReward,Config.MaxReward))
end)

function LSPD()
	local _source = source
	local xPlayers = ESX.GetPlayers()

	for i=1, #xPlayers, 1 do
		xPlayer = ESX.GetPlayerFromId(xPlayers[i])

		if xPlayer.job.name == 'police' then
			TriggerClientEvent("hinode_yachtrobbery:notify", -1)
		end
	end
end