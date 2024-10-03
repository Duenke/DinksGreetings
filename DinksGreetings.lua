-- AceAddon makes creating an addon easy. All addons are frames, btw.
DinksGreetings = LibStub("AceAddon-3.0"):NewAddon("DinksGreetings", "AceConsole-3.0", "AceEvent-3.0")

------------------------------------------
-- #region: locals
------------------------------------------

local DEBUG = true

-- WoW's globals that are exposed for addons.
local _G = _G
local IsInRaid = IsInRaid
local random = random
local SendChatMessage = SendChatMessage
local UnitRace = UnitRace

local greetingsTable = {
	["Human"] = {
		"Hello there.",
		"Greetings.",
		"Light be with you.",
		"What can I do for you?",
		"Well met.",
		"Need help?",
		"King's honor, friend.",
		"You need somethin'?",
		"Can I help you?",
		"How are you?",
		"Hey there.",
		"Hello.",
		"Good day to you.",
	},
	["Orc"] = {},
	["Dwarf"] = {},
	["NightElf"] = {},
	["Scourge"] = {},
	["Tauren"] = {},
	["Gnome"] = {},
	["Troll"] = {},
	["Goblin"] = {},
	["BloodElf"] = {
		"Anaria shola.",
		"Bal'a dash, malanore.",
		"We will persevere!",
		"Our enemies will fall!",
		"Victory lies ahead!",
		"Anu belore dela'na.",
		"What business have you?",
		"Glory to the sin'dorei.",
		"Yes?",
		"State your business.",
		"The eternal sun guides us.",
		"The dark times will pass.",
	},
	["Draenei"] = {},
	["FelOrc"] = {},
	["Naga_"] = {},
	["Broken"] = {},
	["Skeleton"] = {},
	["Vrykul"] = {},
	["Tuskarr"] = {},
	["ForestTroll"] = {},
	["Taunka"] = {},
	["NorthrendSkeleton"] = {},
	["IceTroll"] = {},
	["Worgen"] = {},
	["Neutral"] = {},
	["Pandaren"] = {},
	["Nightborne"] = {},
	["HighmountainTauren"] = {},
	["VoidElf"] = {},
	["LightforgedDraenei"] = {},
	["ZandalariTroll"] = {},
	["KulTiran"] = {},
	["ThinHuman"] = {},
	["DarkIronDwarf"] = {},
	["Vulpera"] = {},
	["MagharOrc"] = {},
	["Mechagnome"] = {},
	["Dracthyr"] = {},
}

local leaveMessagesTable = {
	["Human"] = {
		"Farewell.",
		"Be careful.",
		"Go with honor, friend.",
		"Safe travels!",
		"For the Alliance.",
		"See you around.",
		"Light bless you.",
		"Have a good one.",
	},
	["Orc"] = {},
	["Dwarf"] = {},
	["NightElf"] = {},
	["Scourge"] = {},
	["Tauren"] = {},
	["Gnome"] = {},
	["Troll"] = {},
	["Goblin"] = {},
	["BloodElf"] = {
		"Farewell.",
		"We will have justice!",
		"Death to all who oppose us!",
		"The reckoning is at hand!",
		"Selama ashal'anore!",
		"Remember the Sunwell.",
		"Stay the course.",
		"Time is of the essence.",
		"Shorel'aran.",
		"Keep your wits about you.",
		"Hold your head high.",
	},
	["Draenei"] = {},
	["FelOrc"] = {},
	["Naga_"] = {},
	["Broken"] = {},
	["Skeleton"] = {},
	["Vrykul"] = {},
	["Tuskarr"] = {},
	["ForestTroll"] = {},
	["Taunka"] = {},
	["NorthrendSkeleton"] = {},
	["IceTroll"] = {},
	["Worgen"] = {},
	["Neutral"] = {},
	["Pandaren"] = {},
	["Nightborne"] = {},
	["HighmountainTauren"] = {},
	["VoidElf"] = {},
	["LightforgedDraenei"] = {},
	["ZandalariTroll"] = {},
	["KulTiran"] = {},
	["ThinHuman"] = {},
	["DarkIronDwarf"] = {},
	["Vulpera"] = {},
	["MagharOrc"] = {},
	["Mechagnome"] = {},
	["Dracthyr"] = {},
}

------------------------------------------
-- #endregion: locals
------------------------------------------

------------------------------------------
-- #region: AceAddon lifecycle functions
------------------------------------------

function DinksGreetings:OnInitialize()
	self:Debug("OnInitialize")

	-- Seed the random number generator (optional but recommended)
	-- math.randomseed(GetTime() * 1000)
end

function DinksGreetings:OnEnable()
	self:Debug("OnEnable")

	self:RegisterEvent("PLAYER_ENTERING_WORLD", "HandleEnteringWorld")
	self:RegisterEvent("GROUP_JOINED", "Greet")
	self:RegisterEvent("GROUP_ROSTER_UPDATE", "Greet")
	self:RegisterEvent("GROUP_LEFT", "Leave")
	self:RegisterEvent("PLAYER_LEAVING_WORLD", "HandleLeavingWorld")
end

function DinksGreetings:OnDisable()
	self:Debug("OnDisable")

	self:HandleLeavingWorld()
end

------------------------------------------
-- #endregion: AceAddon lifecycle functions
------------------------------------------

------------------------------------------
-- #region: local functions
------------------------------------------

function DinksGreetings:HandleEnteringWorld()
	self:Debug("HandleEnteringWorld")

	self:Greet()
end

function DinksGreetings:HandleLeavingWorld()
	self:Debug("HandleLeavingWorld")

	-- self:Leave()
end

function DinksGreetings:Greet()
	self:Debug("Greet")

	if not IsInRaid() then
		local greeting = self:GetRandomGreeting()
		SendChatMessage(greeting, "EMOTE")
	end
end

function DinksGreetings:Leave()
	self:Debug("Leave")

	local leaveMessage = self:GetRandomLeaveMessage()
	SendChatMessage(leaveMessage, "EMOTE")
end

function DinksGreetings:GetRandomGreeting()
	self:Debug("GetRandomGreeting")

	local playerRace = UnitRace("player")
	local greetings = greetingsTable[playerRace]
	local randomIndex = random(1, #greetings)
	return greetings[randomIndex]
end

function DinksGreetings:GetRandomLeaveMessage()
	self:Debug("GetRandomLeaveMessage")

	local playerRace = UnitRace("player")
	local leaveMessages = leaveMessagesTable[playerRace]
	local randomIndex = random(1, #leaveMessages)
	return leaveMessages[randomIndex]
end

function DinksGreetings:Debug(message)
	if DEBUG then
		self:Print(_G["ChatFrame6"], message .. "\n ")
	end
end

------------------------------------------
-- #endregion: local functions
------------------------------------------
