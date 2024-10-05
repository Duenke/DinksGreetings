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
local SAY, EMOTE, PARTY, INSTANCE_CHAT = "SAY", "EMOTE", "PARTY", "INSTANCE_CHAT"

local greetingTable = {
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
	["Orc"] = {
		"Speak.",
		"Speak, friend.",
		"Zug-zug.",
		"Blood and thunder!",
		"Strength and honor!",
		"Lok-tar!",
		"Thrall hall!",
		"Mok-rah!",
		"What do you need?",
		"Greetings.",
		"Glory to the Horde!",
		"What can I do for you?",
		"Yes?",
		"Hmmm?",
		"What you want?",
		"Something need doing?",
		"Whaaat?",
		"Me busy. Leave me alone!",
		"Me not that kind of orc!",
	},
	["Dwarf"] = {
		"Hey there!",
		"Ya got my attention.",
		"How are ya?",
		"Talk to me.",
		"'Lo!",
		"Well met.",
		"What's on your mind?",
		"Great tae meet ya.",
		"What can I do fer ya?",
		"Aye?",
		"Interest ya'n a pint?",
		"Welcome.",
		"Hello.",
	},
	["Night Elf"] = {
		"Elune be with you.",
		"Ishnu-alah.",
		"Elune light your path.",
		"I am listening.",
		"I am honored.",
		"Goddess bless you.",
		"What brings you here?",
		"Elune-adore.",
		"Greetings.",
		"Peace be with you.",
	},
	["Scourge"] = {
		"What do you require?",
		"This had better be good.",
		"I haven't got all day!",
		"What is it?",
		"Speak quickly.",
		"I'm listening.",
		"What would you ask of death?",
		"I am Forsaken.",
		"What now?!",
		"Hello.",
		"And you are...?",
	},
	["Tauren"] = {
		"Peace, friend.",
		"Hail.",
		"You wish to speak?",
		"How?",
		"How may I aid you?",
		"What brings you here?",
		"Ah, I've been expecting you.",
		"Well met.",
		"Greetings, traveler.",
		"Greetings.",
		"The winds guide you.",
		"I've been expecting you.",
	},
	["Gnome"] = {
		"Hey!",
		"Greetings!",
		"Salutations!",
		"Honored, I'm sure.",
		"Good day to you.",
		"My, you're a tall one!",
		"Hmmm, interesting.",
		"Pleased to meet you!",
		"Can I help you?",
		"Need assistance?",
	},
	["Troll"] = {
		"Talk to me.",
		"Eh there.",
		"Who you be?",
		"Hello mon.",
		"Greetings mon.",
		"What be on ya mind?",
		"How ya doing mon?",
		"Relax.",
		"Don't be shy.",
		"What'chu want?",
		"You come get da Voodoo.",
	},
	["Goblin"] = {
		"Hey, how ya doin'?",
		"Welcome, friend.",
		"Hmm, interesting.",
		"Time is money, friend.",
		"Yeah, what do ya want?",
		"Wazzup?",
		"Well? Spit it out!",
		"Yo.",
		"Heya.",
		"Talk to me!",
		"What's shakin'?",
		"What's the word on the street?",
		"Yeah, yeah.",
		"What's up?",
		"I seen you around here before?",
		"What?!",
		"Don't waste my time!",
		"Make sense!",
		"Oh, go!",
		"Quickly, quickly!",
		"G.T.L., friend: Gambling, Tinkering, Laundry!",
		"You lookin' at me?",
		"Big shot, huh?",
		"I ain't gettin' paid to chat.",
		"It's my way or the highway, pal!",
		"Yo, can I help you with somethin'?",
		"No loiterin'... whatever that means.",
		"Smartmouth, eh?",
		"I get no respect around here.",
	},
	["Blood Elf"] = {
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
	["Draenei"] = {
		"Blessings upon you.",
		"Archenon poros.",
		"Krona ki cristorr!",
		"May the light embrace you.",
		"The Naaru have not forgotten us.",
		"Each day is a blessing.",
		"Good fortune!",
		"Open your heart to the light.",
		"The Legion will fall.",
		"The Legion's end draws near.",
		"Warm wishes to you.",
	},
	["Worgen"] = {
		"Ain't you a chipper looking one?",
		"We've been walled up for far too long.",
		"Oi!",
		"Any friend of Greymane is a friend of mine.",
		"I've got a bad feeling.",
		"Get gabbing or get going.",
		"What can I do for you?",
		"What's your story?",
		"Yes?",
		"Greymane will lead us to victory.",
		"You have my attention.",
		"Our curse grants us strength.",
		"Hail traveler.",
		"Don't waste my time.",
		"I can smell your fear.",
		"No time for dallying.",
		"You have my undivided attention.",
		"Glory to Gilneas.",
		"Gilneas will be reborn from the blood of our enemies.",
	},
	["Pandaren"] = {
		"Speak up.",
		"Hmm?",
		"Slow down.",
		"What do you need?",
		"Hello.",
		"Greetings, wanderer.",
		"Tell me of your travels.",
		"Welcome.",
	},
	["Nightborne"] = {
		"Tanu'balah.",
		"Wisdom to Elisande.",
		"Greetings.",
		"Our destiny is at hand.",
		"We no longer hide.",
		"Nightwell nourish us.",
		"Ash'thoras danil.",
		"What is your wish?",
		"We see the stars once more.",
		"May I help you?",
		"Our destiny is upon us.",
		"We are the defenders of Suramar.",
		"Well met.",
		"The future is ours to forge.",
		"The shal'dorei stand strong.",
	},
	["Highmountain Tauren"] = {
		"Hmph.",
		"Greetings, traveler.",
		"Do you feel the change in the wind?",
		"It is a day for flying.",
		"What has the wind brought?",
		"The river provides.",
		"Highmountain stands.",
		"We defend this world together.",
		"Peace and patience, friend.",
		"We will not fear the darkness.",
		"We defend against the darkness.",
	},
	["Void Elf"] = {
		"I greet you.",
		"We fight for a new future.",
		"Bal'a dash, malanore.",
		"Walk your own path.",
		"Question everything.",
		"We embrace a new future.",
		"New doorways have opened to us.",
		"The universe is full of mystery.",
	},
	["Lightforged Draenei"] = {
		"Krona ki cristorr.",
		"I serve the Light.",
		"Greetings, traveler.",
		"In darkest night, we still shine with hope.",
		"Our cause is just, our purpose noble.",
	},
	["Zandalari Troll"] = {
		"Speak ya business.",
		"What do you ask of de Zandalari?",
		"What is ya business here?",
		"Zandalar will endure.",
		"Hello, mon.",
		"Mind ya step around me.",
		"What you doin' here?",
		"What you want, richmon?",
		"Who you be?",
		"Hm, and which loa do you bargain with?",
		"De spirits whisper ya name.",
		"I am listening.",
		"May de loa bless ya journey.",
		"Name ya loa, so I may name mine.",
		"Speak.",
		"Speak, and de loa listen.",
		"Which loa do you bargain with?",
		"Fly with Pa'ku.",
		"Give thanks to de loa of shapes.",
		"Praise de loa of kings.",
	},
	["Kul Tiran"] = {
		"Fancy a cuppa?",
		"Good day to ya!",
		"Lord Admiral's favor, friend.",
		"What can I do fer ya?",
		"Don't get many travelers here.",
		"Mainlander, eh?",
		"You mind your business, and I'll mind mine.",
		"Every hand helps.",
		"Not from around here, are ya?",
		"Times were simpler once.",
		"Keeping warm, I hope.",
		"Wind's howling today.",
		"Ahoy.",
		"Good day to ya.",
		"Lord Admiral's favor, friend.",
		"What can I do fer ya?",
	},
	["Dark Iron Dwarf"] = {
		"Are ye here to lend a hand?",
		"How can I help ye?",
		"I'd rather be hammerin' than talkin'.",
		"I'm not much for small talk.",
		"Speak yer piece, if ye must.",
		"Spit it out, I got smeltin' to do!",
		"Warm yerself by the forge.",
		"Here ta help? Grab a weapon and stand-to.",
		"I'd rather be fightin' than talkin'.",
		"I'm not much for small talk.",
		"Speak yer piece, if ye must.",
		"Spit it out! I'm on duty!",
		"We protect what is ours.",
		"What can I do fer ye?",
	},
	["Vulpera"] = {
		"Got anything for me?",
		"Have you come to trade?",
		"Hi there!",
		"Need something?",
		"What did you bring me?",
	},
	["Maghar Orc"] = {},
	["Mechagnome"] = {},
	["Dracthyr"] = {},
}

local farewellTable = {
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
	["Orc"] = {
		"Dabu.",
		"For the Horde!",
		"Go forth to victory.",
		"Strength.",
		"Go, with honor.",
		"Farewell.",
		"Victory!",
		"Fight well, friend.",
		"Be safe.",
		"May your blades never dull.",
		"No time for play.",
	},
	["Dwarf"] = {
		"Off with ye.",
		"Safe travels.",
		"Keep your feet on the ground.",
		"See ya soon.",
		"Watch yer back!",
		"Be good!",
	},
	["Night Elf"] = {
		"Be careful.",
		"Elune guide your path.",
		"Goddess watch over you.",
		"Till the next we meet.",
		"May the stars guide you.",
		"Del-nadres.",
		"Asha-fela.",
		"Farewell.",
		"Go in peace.",
		"Good luck, friend.",
		"Goodbye.",
	},
	["Scourge"] = {
		"Dark Lady watch over you.",
		"Victory for Sylvanas.",
		"Watch your back.",
		"Trust no one.",
		"Do not seek death.",
		"Goodbye.",
		"Our time will come.",
		"Beware, our enemies abound.",
		"Beware the living.",
		"Remember, patience... discipline.",
		"Embrace the shadow.",
	},
	["Tauren"] = {
		"Walk with the Earth Mother.",
		"Winds be at your back.",
		"Go in peace.",
		"May the eternal sun shine upon thee.",
		"Be careful.",
		"We shall meet again.",
		"Ancestors watch over you.",
		"Farewell.",
		"Goodbye.",
	},
	["Gnome"] = {
		"You have a great day now.",
		"Very good.",
		"Very well then.",
		"Off and away!",
		"Be seeing you.",
		"Daylight's burning.",
		"Right.",
		"Alrighty, then!",
	},
	["Troll"] = {
		"Layta.",
		"Okie dokie.",
		"See ya layta.",
		"Stay away from the Voodoo.",
		"You be careful mon.",
		"Be seeing ya.",
		"Spirits be with ya mon.",
	},
	["Goblin"] = {
		"Hurry back.",
		"Be good!",
		"Have a good one!",
		"Pleasure doin' business with ya.",
		"Glad I could help.",
		"If you ever need anything...",
		"Keep it real!",
		"Be careful out there!",
		"See you 'round, friend.",
		"Keep your ear to the ground.",
		"Catch you on the flipside.",
		"Go get 'em, champ!",
		"Don't be a stranger.",
		"Move it!",
		"On your way.",
		"Hit the road!",
		"Stay strong.",
		"Yeesh, talk my head off why don't ya?",
		"If you can make it here, you can make it anywhere.",
		"Don't try anything stupid.",
		"Hey, I got your back.",
		"Security, enforcement, extortion... We do it all!",
		"You ever need anything, you know where to find me.",
		"Do not get on Gallywix's bad side.",
		"Get lost, will ya?",
		"This gig ain't so bad.",
	},
	["Blood Elf"] = {
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
	["Draenei"] = {
		"May your days be long and your hardships few.",
		"Be well.",
		"Remember the lessons of the past.",
		"Do not lose faith.",
		"Dioniss aca.",
		"Be kind to those less fortunate.",
		"Favor the road traveled by few.",
		"Remain vigilant.",
		"Safe journey.",
		"Blessings upon your family.",
		"Good health, long life.",
	},
	["Worgen"] = {
		"Watch your back!",
		"Long live Greymane.",
		"Farewell.",
		"Good day.",
		"Keep your chin up, eh?",
		"That's enough gabbing from me today.",
		"Let the light of the new moon guide you.",
		"We are bound by a common enemy.",
		"You wouldn't want to see me when I'm angry.",
		"The past must not be repeated.",
		"We are not the monsters here.",
		"Keep your enemies in your sights.",
		"We must face our fears.",
		"Remember that the beasts in the shadows might be your salvation.",
	},
	["Pandaren"] = {
		"Goodbye.",
		"Enough of that.",
		"Until next time.",
		"White Tiger watch over you.",
		"Jade Serpent guide you.",
		"Next one is on me.",
		"May the mists protect you.",
		"There is no hurry.",
	},
	["Nightborne"] = {
		"Farewell.",
		"We shall endure.",
		"Elisande guide you.",
		"Walk in the moonlight.",
		"May you ever walk in moonlight.",
		"We will make our place in this world.",
		"Stars guide you.",
		"Stay strong for Suramar.",
		"The shal'dorei will never be oppressed again.",
		"Together we are stronger.",
	},
	["Highmountain Tauren"] = {
		"Ride the winds.",
		"Look to the skies.",
		"Beware the deep places of the earth.",
		"An'she guide you.",
		"Together, we are Highmountain.",
		"May your rivers be ever bountiful.",
		"Sun and moon light your way.",
		"Remember the Earth Mother's lessons.",
	},
	["Void Elf"] = {
		"Farewell.",
		"Shorel'aran.",
		"The whispers do not control me.",
		"The Void offers endless possibilities.",
		"Unchecked emotion leads to ruin.",
		"My fate is my own.",
		"Do not fear the shadows.",
		"Power is to be wielded, not feared.",
	},
	["Lightforged Draenei"] = {
		"Dioniss aca.",
		"Light be with you.",
		"We shall see the Legion's end.",
		"Have faith in the light.",
		"Fight well, traveler.",
	},
	["Zandalari Troll"] = {
		"Di chuka Zandalar!",
		"Go carefully.",
		"I am sworn to defend de royal family.",
		"I serve de Zandalari.",
		"Our kingdom will be defended.",
		"Watch yourself within our city.",
		"May Jani bring you fortune.",
		"Shadra be watchin'.",
		"So be it.",
		"Watch your back.",
		"Zandalar forever.",
		"De loa are always watchin'.",
		"De loa are strong here.",
		"Loa guide you.",
		"Loa keep you.",
		"Spirits be with you.",
		"Spirits' blessings.",
		"When de loa speak, be sure to listen.",
		"Gonk guide your path.",
		"Pa'ku watch over you.",
		"Rezan give you strength.",
	},
	["Kul Tiran"] = {
		"Keep the wind in your sails.",
		"Look always to the sea.",
		"Safe passage to ya.",
		"Smooth sailing.",
		"Even rotten crops regrow.",
		"May blight fall upon the coven!",
		"This land is cursed.",
		"Every path has a few puddles.",
		"Seas grant you favor.",
		"We will reclaim what's ours.",
		"Carry on strong.",
		"Steer clear of dark alleys.",
		"Stay warm.",
	},
	["Dark Iron Dwarf"] = {
		"Don't burn yourself on the way out.",
		"Honest work is good for the soul.",
		"I prefer to stay underground.",
		"May the Black Anvil bless ye.",
		"The Dark Iron clan will forge a new future.",
		"Watch yer head in the tunnels!",
		"Well, back to work.",
		"Be ready for whatever comes at ye.",
		"Don't strike till ye see the glow o' their eyes.",
		"No enemy's gettin' past me!",
		"The Dark Iron clan will forge a new future.",
		"The deep places can be dangerous.",
		"The might of the anvil be with ye!",
		"Watch yer step.",
	},
	["Vulpera"] = {
		"Be quick, be clever.",
		"Don't die out there.",
		"Remember, everything has its use.",
		"Survival means being resourceful.",
		"Take care of yourself. No one else will!",
		"The dunes have everything we need.",
	},
	["Maghar Orc"] = {},
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
end

function DinksGreetings:OnEnable()
	self:Debug("OnEnable")

	self:RegisterChatCommand("dgt", "HandleSlashCommand")
	self:RegisterChatCommand("dinksgreet", "HandleSlashCommand")
	self:RegisterEvent("PLAYER_ENTERING_WORLD", "HandleEnteringWorld")
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

	if IsInGroup() and not IsInRaid() then
		self:Greet(PARTY)
	else
		self:Greet(EMOTE)
	end
end

function DinksGreetings:HandleLeavingWorld()
	self:Debug("HandleLeavingWorld")

	if IsInGroup() and not IsInRaid() then
		self:Farewell(PARTY)
	else
		self:Farewell(EMOTE)
	end
end

function DinksGreetings:HandleSlashCommand(command)
	self:Debug("HandleSlashCommand: " .. command)

	local cmdParts = {}
	local COMMAND = command:trim():upper()
	for p in string.gmatch(COMMAND, "%S+") do
		table.insert(cmdParts, p)
	end

	local command = cmdParts[1]
	local channel = (
		cmdParts[2] == SAY or cmdParts[2] == EMOTE or cmdParts[2] == PARTY or cmdParts[2] == INSTANCE_CHAT
	) and cmdParts[2] or EMOTE

	if command == "H" or command == "HELP" then
		self:Print("DinksGreetings commands: SAY, EMOTE, PARTY, or INSTANCE_CHAT")
		return
	end

	if command == "G" or command == "GREET" then
		self:Greet(channel)
		return
	end

	if command == "F" or command == "FAREWELL" then
		self:Farewell(channel)
		return
	end

	self:Greet(EMOTE)
end

function DinksGreetings:Greet(channel)
	self:Debug("Greet")

	local playerRace = UnitRace("player")
	local greetings = greetingTable[playerRace]
	local randomIndex = random(1, #greetings)
	local greeting = greetings[randomIndex] or "UNKNOWN RACE"
	SendChatMessage(greeting, channel)
end

function DinksGreetings:Farewell(channel)
	self:Debug("Leave")

	local playerRace = UnitRace("player")
	local leaveMessages = farewellTable[playerRace]
	local randomIndex = random(1, #leaveMessages)
	local leaveMessage = leaveMessages[randomIndex] or "UNKNOWN RACE"
	SendChatMessage(leaveMessage, channel)
end

function DinksGreetings:Debug(message)
	if DEBUG then
		self:Print(_G["ChatFrame6"], message .. "\n ")
	end
end

------------------------------------------
-- #endregion: local functions
------------------------------------------
