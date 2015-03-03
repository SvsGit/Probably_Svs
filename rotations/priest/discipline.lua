	
ProbablyEngine.library.register('coreHealing', {
  needsHealing = function(percent, count)
    return ProbablyEngine.raid.needsHealing(tonumber(percent)) >= count
  end,
  needsDispelled = function(spell)
    for unit,_ in pairs(ProbablyEngine.raid.roster) do
      if UnitDebuff(unit, tostring(GetSpellInfo(spell))) then
        ProbablyEngine.dsl.parsedTarget = unit
        return true
      end
    end
  end,
})

ProbablyEngine.listener.register('LFG_PROPOSAL_SHOW', AcceptProposal)

ProbablyEngine.rotation.register_custom(256, "Disco", {

 -- Buffs

-- Power Word: Fortitude
{ "21562", {
"!player.buff(21562).any", -- Power Word: Fortitude
"!player.buff(166928)", -- Blood Pact (Warlock)
"!player.buff(469)", -- Commanding Shout
"!player.buff(50256)", -- Hunter: Bear Pet Species Type - Invigorating Roar
"!player.buff(160014)", -- Hunter: Goat Pet Species Type - Sturdiness
"!player.buff(160003)", -- Hunter: Rylak Pet Species Type - Savage Vigor
"!player.buff(90364)", -- Hunter: Silithid Pet Species Type - Qiraji Fortitude
}},

-- Auto Target
	{ "/target [target=focustarget, harm, nodead]", "target.range > 40" },
	{ "/targetenemy [noexists]", { "toggle.autotarget", "!target.exists" }},
	{ "/targetenemy [dead]", { "toggle.autotarget", "target.exists", "target.dead" }},  	

--Power Word: Shield Moving
    { "17", { "!player.buff(17).any", "!player.debuff(6788)", "player.moving" }},
    
-- Dispel Magic
   	{ "528", { "target.dispellable(528)" }, "target" },

-- Purify
	{ "527", { "lowest.dispellable(527)" }, "lowest" },	   	

--POwer infusion
    { "10060", "!player.buff(10060)" }, 
      "player.spell(10060).cooldown < .001",

--Trinkets
   -- {{
   -- { "#trinket1" },
   -- { "#trinket2" },
    --}, "player.mana < 80" },
    
-- Healthstone
 	{ "#5512", "player.health < 30" }, -- Healthstone
  	{ "#109223", "player.health < 20" }, -- Health Potion

--Inner Focus
    { "89485", "!player.buff(89485)" }, 
      "player.spell(89485).cooldown < .001",

--Archangel
	{ "81700", { 
          "player.buff(81661).count = 5" }},

--Spirit Shell
	{"109964", "modifier.rcontrol" },
	{ "32375", "modifier.ralt", "mouseover" }, 	-- Mass Dispel
	{ "62618", "modifier.rshift", "mouseover" },	-- Power word Barrier // w/t CD's and on tank // PArty
	{ "527", "modifier.lshift", "mouseover" }, -- Purify 

--Prayer of Healing
	{ "596", "player.spell(109964).cooldown >= 50", "lowest" }, 

 --Tier 6
--Cascade
	{ "121135", {
          "@coreHealing.needsHealing(85, 4)"
--	  "modifier.lcontrol"
	}, "player" },

-- Misc

--Mindbender
	{ "123040", { 
	  "player.mana < 90",
	  "target.range < 41"
	}, "target" },

--Shadowfiend
	{ "34433", { 
          "player.mana < 70",	  
      "target.range < 41"
    }, "target" },	

--Desperate Prayer
	{ "19236", { 
	  "player.health <= 20" 
	}, "player" },

--Mass Dispell
        { "32375", "modifier.lalt", "ground" },
        
--Power Word: Barrier
    { "62618", "modifier.ralt", "ground" },          

-- Fade
	{ "586", "target.threat >= 80" },

--Pain Suppression
    { "33206", { "lowest.health <= 20" }, "lowest" },
	{ "33206", { "tank.health <= 30" }, "tank" },
	
 --Prochealing

-- Prayer of mending
       { "33076", {
        "!player.moving", 
	"player.buff(89485)",
	"@coreHealing.needsHealing(99, 1)", 
        }, "lowest" },

-- Prayer of healing
       { "596", {
        "!player.moving", 
	"player.buff(89485)",
	"@coreHealing.needsHealing(80, 2)", 
        }, "lowest" },

--Power Word: Shield LMG
        { "17", { 
          "!tank.debuff(6788).any",
          "!tank.buff(17).any",
          "player.buff(137323)",
	  "tank.health <= 100",
	}, "tank" },


--Power Word: Shield
        { "17", { 
          "!lowest.debuff(6788).any",
          "!lowest.buff(17).any",
          "lowest.health <= 80",
	}, "lowest" },	

--Cascade LMG
        { "121135", {
          "@coreHealing.needsHealing(99, 1)", 
	  "player.buff(137323)",
        }, "lowest" },

--Cascade LMG
        { "121135", {
          "@coreHealing.needsHealing(85, 2)", 
	    }, "lowest" },

--Halo LMG
	{ "120517", {
	"@coreHealing.needsHealing(95, 1)", 
	 "player.buff(137323)",
        }, "lowest" },

--Divine Star LMG
	{ "110744", { 
          "player.buff(137323)",
	  "@coreHealing.needsHealing(99, 1)" }},

-- Focus	

--Power Word: Shield
    { "17", { 
      "!focus.debuff(6788).any",
	  "!focus.buff(17).any",
	  "focus.health <= 100",
	  "focus.spell(17).range"
	}, "focus" },

-- Clarity of Will
 { "152118", { 
 	  "!focus.buff(152118).any",
	  "focus.health <= 100", 
	  "focus.spell(17).range"
	}, "focus" },  

 -- Tank
 
 { "17", { 
          "!tank.debuff(6788).any",
          "!tank.debuff(17).any",
	  "!tank.buff(17).any",
	  "tank.health <= 100", 
	  "tank.spell(17).range"
	}, "tank" },

-- Clarity of Will
 { "152118", { 
 	  "!tank.buff(152118).any",
	  "tank.health <= 100", 
	  "tank.spell(17).range"
	}, "tank" },	

--Penance
        { "47540", {
	  "tank.health <= 40", 
	  "tank.spell(47540).range"
	}, "tank" },

--Flash Heal
    { "2061", {
	  "!player.moving",
	  "tank.health <= 50",
	}, "tank" },	

--Raidhealing
 
--Penance
    { "47540", {
	  "lowest.health <= 70", 
	  "lowest.spell(47540).range"
	}, "lowest" }, 
	
-- Prayer of healing
       { "596", {
        "!player.moving", 
	"@coreHealing.needsHealing(80, 4)", 
        }, "lowest" },

--Flash Heal
    { "2061", {
	  "!player.moving",
	  "lowest.health <= 30",
	  "lowest.spell(2061).range"	  
	}, "lowest" },        	
 
 --Attonement healing

--Power word Solace
        { "129250", {
	  "player.spell(129250).cooldown < .001",
	}, "target" },

--Holy Fire
        { "14914", {
	  "player.spell(129250).cooldown < .001",
	}, "target" },

--Penance
	{ "47540", { 
	  "player.mana > 30",
	}, "target"},

--Smite
 	{ "585", { 
	  "player.mana > 60",
	  "!player.moving",
	}, "target" },

},{
 --Out of combat 

--Angelic feather - Hold Down Button
        { "121536", "modifier.alt", "ground" },
        
--Power Word: Shield Moving
        { "17", { "!player.buff(17).any", "!player.debuff(6788)", "player.moving" }},

-- Power Word: Fortitude
{ "21562", {
"!player.buff(21562).any", -- Power Word: Fortitude
"!player.buff(166928)", -- Blood Pact (Warlock)
"!player.buff(469)", -- Commanding Shout
"!player.buff(50256)", -- Hunter: Bear Pet Species Type - Invigorating Roar
"!player.buff(160014)", -- Hunter: Goat Pet Species Type - Sturdiness
"!player.buff(160003)", -- Hunter: Rylak Pet Species Type - Savage Vigor
"!player.buff(90364)", -- Hunter: Silithid Pet Species Type - Qiraji Fortitude
}},

--Penance
        { "47540", {
	  "lowest.health <= 80",
	  "lowest.spell(47540).range"
	}, "lowest" },

-- Focus	

--Power Word: Shield
        { "17", { 
          "!focus.debuff(6788).any",
	  "!focus.buff(17).any",
	  "focus.health <= 100",
	  "focus.spell(17).range"
	}, "focus" },

-- Prayer of healing
       { "596", {
        "!player.moving", 
		"@coreHealing.needsHealing(80, 4)",
		"lowest.spell(596).range" 
        }, "lowest" },

},function()

ProbablyEngine.toggle.create(
	'autotarget', 
	'Interface\\Icons\\Ability_spy.png', 
	'Auto Target', 
	'Automatically target the nearest enemy when target dies or does not exist')

end)