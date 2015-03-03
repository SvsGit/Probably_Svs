-- SPEC ID 258
-- v2.1 - Updated by thefrobel  1/26/15

ProbablyEngine.rotation.register_custom(258, "Frobes Shadow", {

--       SURVIVAL        --
{"586", "target.threat >= 80"}, -- Fade
{"#5512", "player.health < 30"}, -- Healthstone
{"#109223", "player.health < 20" }, -- Health Potion
{"19236", "player.health <= 20", "player" }, -- Desperate Prayer
{"17", { "!player.buff(17).any", "!player.debuff(6788)", "player.health <= 30" }, "player" }, -- PW:S
{"47585", "player.health <= 20", "player" }, -- Dispersion



--------------------
-- Start Rotation --
--------------------
{"15473", "!player.buff(15473)" }, -- Shadow Form

-- Cooldowns
{"132603", "toggle.cooldowns"}, -- Shadowfiend

-- Keybinds
{"48045", "modifier.shift" }, -- Mind Sear

  -- AutoTarget
  { "/targetenemy [noexists]", { "toggle.autotarget", "!target.exists" } },
  { "/targetenemy [dead]", { "toggle.autotarget", "target.exists", "target.dead" } },
    
-- If Moving
{{
{ "17", { "!player.buff(17).any", "!player.debuff(6788)" }}, -- Power Word: Shield
{"589", {"mouseover.exists", "mouseover.enemy", "!mouseover.debuff(589)"}, "mouseover"}, -- SWP Mouseover
{"32379"}, -- Shadow Word: Death
{"8092"}, -- Mind Blast
{"2944"}, -- DP
{"120644", "target.range <= 30"} -- Halo
}, "player.moving" },

-- Mouseover Dotting
{"589", {"mouseover.exists", "mouseover.enemy", "!mouseover.debuff(589)"}, "mouseover"}, -- SWP Mouseover
{"34914", {"mouseover.exists", "mouseover.enemy", "!mouseover.debuff(34914)"}, "mouseover"},  -- VT Mouseover
    
-- Priority
-- Focus DOT target for 2 target fight   --

{"139139", {"player.buff(132573)", "target.health > 20"}}, -- Insanity
{"8092"},  -- Mind Blast every time off CD
{"32379", "target.health < 20"}, -- SW:Death if target < 20% health
{"2944", "target.health < 20"}, -- 2944
{"73510", "player.buff(87160)", "target"}, -- Mind Spike/Surge of Darkness
--{"Halo", {"target.range <= 30", "target.debuff(589).duration < 3", "player.shadoworbs = 4"}}, --"player.spell(Mind Blast).cooldown > 2",
{"120644", {"target.range <= 30", "toggle.TwoTargets"}}, -- Halo
{"73510",{"target.debuff(589).duration < 3", "player.shadoworbs = 4", "!lastcast(73510)", "!lastcast(120644)"}}, -- Mind Spike
{"589", {"toggle.TwoTargets", "!focus.debuff(589)"}, "focus"}, -- Multi target SWP
{"34914", {"toggle.TwoTargets", "!focus.debuff(34914)"}, "focus"},  -- Multi target VT
{"589", {"target.health > 20", "player.shadoworbs >= 4", "!target.debuff(589)"}},  --  Weave SWP
{"34914", {"target.health > 20","player.shadoworbs >= 4", "!target.debuff(34914)"}}, --  Weave VT
{"2944", "player.shadoworbs = 5"},  -- DP
{"2944", {"target.debuff(34914).duration > 1", "player.shadoworbs = 3" }}, -- Weave DP
{"2944", {"target.health < 20", "player.shadoworbs = 3"}},
{"139139", {"target.health < 20", "player.buff(132573).duration > 1", "player.spell(32379).cooldown > 1.25", "player.spell(8092).cooldown > 1.25"}},
{"73510", "target.debuff(34914).duration < 4"},
{"15407", "target.health > 20"},
------------------
-- End Rotation --
------------------
  
}, {
  
---------------
-- OOC Begin --
---------------
  
-- Power Word: Fortitude
{ "21562", {
"!player.buff(21562).any", -- Power Word: Fortitude
"!player.buff(166928).any", -- Blood Pact (Warlock)
"!player.buff(469).any", -- Commanding Shout
"!player.buff(50256).any", -- Hunter: Bear Pet Species Type - Invigorating Roar
"!player.buff(160014).any", -- Hunter: Goat Pet Species Type - Sturdiness
"!player.buff(160003).any", -- Hunter: Rylak Pet Species Type - Savage Vigor
"!player.buff(90364).any", -- Hunter: Silithid Pet Species Type - Qiraji Fortitude
}},
{"15473", "!player.buff(15473)"}, -- Shadow Form
{ "17", { "!player.buff(17).any", "!player.debuff(6788)", "player.moving" }}, -- Power Word: Shield
  
-------------
-- OOC End --
-------------
}, function()
ProbablyEngine.toggle.create('TwoTargets', 'Interface\\Icons\\ability_hunter_snipershot', 'Target/Focus','Set Boss as Focus and DPS target(s). Toggle off for single target boss dps.')
ProbablyEngine.toggle.create('autotarget', 'Interface\\Icons\\ability_spy', 'Auto Target', 'Automatically target the nearest enemy when target dies or does not exist')
  end)