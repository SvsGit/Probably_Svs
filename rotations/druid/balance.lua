-- SPEC ID 102 (Balance)

local ooc = {
  { "1126", "!player.buff(1126).any" },

}

local combat = {
{ "pause", "modifier.lalt" },
{ "22812", "player.health < 60" }, -- Barkskin
-- AutoTarget
{ "/targetenemy [noexists]", { "toggle.autotarget", "!target.exists" } },
{ "/targetenemy [dead]", { "toggle.autotarget", "target.exists", "target.dead" } },	

-- Walking
{ "93402", "player.moving" }, -- Sunfire
{ "8921", "player.moving" }, -- Moonfire
--Cooldowns
{ "112071",  "modifier.cooldowns" }, -- Celestial Alignment
{ "102560", "modifier.cooldowns" }, -- Incarnation: Chosen of Elune
{ "124974", { "modifier.cooldowns", "player.health < 80" }}, -- Nature's Vigil

{ "48505", { "modifier.multitarget", "!player.buff(48505)" }}, -- Starfall
   
-- Starsurge Check
{ "78674", {"player.buff(93400)", "player.enumber < 0", "player.balance.moon", "!modifier.multitarget" }}, -- Starsurge/Shooting Stars
{ "78674", {"!player.buff(164547)", "player.enumber < 1", "!modifier.multitarget" }}, -- Starsurge/Lunar Empowerment
{ "78674", {"!player.buff(164545)", "player.enumber > 0", "!modifier.multitarget" }}, -- Starsurge/Solar Empowerment
-- Check Peaks
{ "171743", "player.buff(171743)" }, -- Lunar Peak
{ "171744", "player.buff(171744)" }, -- Solar Peak
{ "8921", "player.buff(171743)" },  -- Moonfire/Lunar Peak
{ "93402", "player.buff(171744)" }, -- Sunfire/Solar Peak
-- Refreshing Sun and moon fire at peaks. It lasts all the way back to origination. This enables it during your pull phase.
{ "93402",  {"!target.debuff(164815)", "player.buff(112071)" }},  -- Sunfire/No target debuff/Celestial Alignment
{ "8921", {"!target.debuff(164812)", "player.buff(112071)" }}, -- Moonfire/No target debuff/Celestial Alignment
-- Main Rotation
{ "2912", "player.buff(112071)" }, -- Starfire/Celestial Alignment
{ "2912", {"player.enumber < 60", "player.balance.moon", "player.buff(164547)" }},
{ "2912", {"player.enumber < -60", "player.buff(164547)" }},
{ "5176", {"player.balance.sun", "player.enumber > 0", "player.buff(164545)" }}, -- Wrath/Solar Empowerment
{ "5176", { "player.balance.moon", "player.enumber > 60", "player.buff(164545)" }},
 
{ "2912", {"player.enumber < 60", "player.balance.moon" }},
{ "2912", "player.enumber < -60" },
{ "5176", {"player.balance.sun", "player.enumber > 0" }},
{ "5176", { "player.balance.moon", "player.enumber > 60" }},
{ "5176", {"player.balance.sun", "player.enumber > -30" }},

}

local onLoad = function()
	-- Buttons
ProbablyEngine.toggle.create('autotarget', 'Interface\\Icons\\ability_spy', 'Auto Target', 'Automatically target the nearest enemy when target dies or does not exist') 
end

ProbablyEngine.rotation.register_custom(102, "NessK Boomkin", combat, ooc, onLoad)