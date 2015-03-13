-- ProbablyEngine Rotation Packager
-- Svs Mistweaver Monk Rotation

ProbablyEngine.library.register('coreHealing', {
  needsHealing = function(percent, count)
    return ProbablyEngine.raid.needsHealing(tonumber(percent)) >= count
  end,
  needsDispelled = function(spell)
    for unit,_ in pairs(ProbablyEngine.raid.roster) do
      if UnitDebuff(unit, spell) then
        ProbablyEngine.dsl.parsedTarget = unit
        return true
      end
    end
  end,
})

ProbablyEngine.listener.register('LFG_PROPOSAL_SHOW', AcceptProposal)

local onLoad = function()
  ProbablyEngine.toggle.create('AutoStance', 'Interface\\Icons\\monk_stance_redcrane', 'Auto Stance Swap', 'Auto Stance Swap when in melee')
  ProbablyEngine.toggle.create('AutoTarget', 'Interface\\Icons\\Ability_spy', 'Auto Target', 'Automatically target the nearest enemy when target dies or does not exist')
end

local buffs = {
  { "115921", "!player.buffs.stats" }, -- Legacy of the Emperor
  { "115070", { "player.stance = 2", "lowest.health <= 60" }}, -- Stance of the Wise Serpent
  { "154436", { "player.stance = 1", "toggle.AutoStance", "lowest.health >= 80", "target.enemy", "target.range <= 5" }}, -- Stance of the Spirited Crane  
}

local ooc = {
  { buffs },
  { "115072", "player.health < 100" }, -- Expel Harm
  { "115313", "modifier.lcontrol", "mouseover.ground" }, -- Summon Jade Serpent Statue
  { "115450", "modifier.lshift", "mouseover" }, -- Detox
  { "123761", { "player.mana < 80", "player.buff(115867).count >= 2" }}, -- Mana Tea  
  { "115151", { "!player.spell(116670).casting", "talent(7,3)", "player.spell(115151).charges = 3", "player.chi < 4" }, "lowest" }, -- ReM
  { "115151", { "!player.spell(116670).casting", "talent(7,2)", "player.chi < 5" }, "lowest" }, -- ReM 
  { "116670", { "@coreHealing.needsHealing(85, 4)","!player.moving", "!player.spell(116670).casting", "player.chi >= 2" }, "player" }, -- Uplift  
  { "115175", { "lowest.health <= 80", "!player.moving", "!player.spell(116670).casting"}, "lowest" }, -- Soothing Mist
  { "116694", { "player.casting", "lowest.health <= 70" }, "lowest" }, -- Surging Mist
  { "124682", { "player.casting", "lowest.health <= 60", "player.chi > 2" }, "lowest" }, -- EnM
}

local aoe = {
  { "!116680", { "raid.health <= 80", "!player.spell(116670).casting" }}, -- TfT
  { "!116670", { "raid.health <= 80", "!player.moving", "!player.spell(116670).casting", "player.chi >= 2" }}, -- Uplift
  { "!115151", { "lowest.buff(119611).duration <= 2", "!player.spell(116670).casting", "player.spell(115151).charges > 1", "player.chi < 4" }, "lowest" }, --ReM 
  { "!115151", { "focus.buff(119611).duration <= 2", "!player.spell(116670).casting", "player.spell(115151).charges > 1", "player.chi < 4" }, "focus" }, --ReM 
  { "!115151", { "@coreHealing.needsHealing(80, 5)", "!player.spell(116670).casting", "player.spell(115151).charges > 1", "player.chi <= 2" }, "lowest" }, --ReM 
  { "!115151", { "!player.spell(116670).casting", "player.chi < 2", "@coreHealing.needsHealing(80, 5)" }, "focus" }, --ReM Need Chi
  { "!115151", { "!player.spell(116670).casting", "player.chi < 2", "@coreHealing.needsHealing(80, 5)" }, "tank" }, --ReM Need Chi
  { "116694", { "player.mana >=20", "@coreHealing.needsHealing(85, 5)", "player.casting", "lowest.health <= 90", "player.chi < 2"}, "lowest" }, -- Surging Mist
  { "115175", { "lowest.health <= 100", "!lastcast(115175)", "!player.spell(116670).casting", "!player.moving", "lowest.buff(115175).duration <= 1" }, "lowest" }, -- Soothing Mist
}

local serpent = {
  { "!116849", {"focus.health <= 30" }, "focus" }, -- Life Cocoon
  --{ "116680", "focus.health <= 30", "player" }, -- TfT
  { "115072" }, -- Expel Harm
  --{ "/stopcasting", { "lowest.health = 100", function() local s,_ = UnitChannelInfo("player"); return s and s == GetSpellInfo(115175) end }}, -- Soothing Mist cancel
  { "!115175", { "focus.health <= 100", "!player.moving", "!player.spell(116670).casting", "!lastcast(115175)", "focus.buff(115175).duration <= 1" }, "focus" }, -- Soothing Mist
  { "124682", { "player.casting", "focus.health <= 60", "player.chi >= 3" }, "focus" }, -- EnM
  { "116694", { "player.casting", "focus.health <= 50", "!lastcast(116694)" }, "focus" }, -- Surging Mist

  { "!116849", "tank.health <= 30", "tank" }, -- Life Cocoon
  { "!115175", { "tank.health <= 15", "!player.moving", "!player.spell(116670).casting", "!lastcast(115175)", "tank.buff(115175).duration <= 1" }, "tank" }, -- Soothing Mist
  --{ "116680", { "tank.health <= 15" }}, -- TfT
  { "124682", { "player.casting", "tank.health <= 50", "player.chi >= 3" }, "tank" }, -- EnM
  { "116694", { "player.casting", "tank.health <= 40" }, "tank" }, -- Surging Mist

  { "!115175", { "lowest.health <= 10", "!player.moving", "!player.spell(116670).casting", "!lastcast(115175)", "lowest.buff(115175).duration <= 1" }, "lowest" }, -- Soothing Mist
  --{ "116680", "lowest.health <= 10" , "player" }, -- TfT
  { "124682", { "player.casting", "lowest.health <= 10", "player.chi >= 3" }, "lowest" }, -- EnM
  { "116694", { "player.casting", "lowest.health <= 10" }, "lowest" }, -- Surging Mist  

  {{
  { "!115151", { "lowest.buff(119611).duration <= 2", "!player.spell(116670).casting", "player.spell(115151).charges = 3" }, "lowest" }, -- ReM , "player.chi < 4"
  { "!115151", { "tank.buff(119611).duration <= 2", "!player.spell(116670).casting", "player.spell(115151).charges = 3" }, "tank" }, 
  { "!115151", { "focus.buff(119611).duration <= 2","!player.spell(116670).casting", "player.spell(115151).charges = 3" }, "focus" },
  { "115151", { "!player.spell(116670).casting", "player.mana > 30", "player.chi < 5", "!lastcast(115151)" }, "lowest" },
  }, "talent(7,3)" },
  { "115151", { "!player.spell(116670).casting", "talent(7,2)", "lowest.health <= 90" }, "lowest" }, -- ReM 
  { "115151", { "!player.spell(116670).casting", "talent(7,2)", "player.chi < 5" }, "lowest" }, -- ReM 

  { aoe, "modifier.multitarget" },

  { "116680", "@coreHealing.needsHealing(80, 5)", "player" }, -- TfT
  --{ "115460", { "@coreHealing.needsHealing(70, 4)", "!player.spell(116670).casting", "player.mana >= 10" }}, -- Detonate Chi
  { "#trinket1", "@coreHealing.needsHealing(87, 4)" },
  { "115399", {"@coreHealing.needsHealing(87, 4)", "player.spell(115399).charges >= 1", "player.chi < 1", "!lastcast(115399)" }}, -- Chi Brew
  { "!116670", { "@coreHealing.needsHealing(90, 4)", "!player.moving", "!player.spell(116670).casting", "player.chi >= 2" }, "player" }, -- Uplift
  
  --{ "157675", { "talent(7,2)", "player.casting", "player.chi >= 4", "lowest.health <= 70" }, "lowest" }, -- Chi Explosion
  --{ "157675", { "talent(7,2)", "player.casting", "player.chi >= 4", "tank.health <= 70" }, "tank" }, -- Chi Explosion
  
  { "!115175", { "lowest.health <= 80", "!player.moving", "!lastcast(115175)", "lowest.buff(115175).duration <= 1" }, "lowest" }, -- Soothing Mist
  { "124682", { "!talent(7,2)", "player.casting", "lowest.health <= 70", "player.chi > 2" }, "lowest" }, -- EnM
  { "116694", { "player.casting", "lowest.health <= 40", "!lastcast(116694)" }, "lowest" }, -- Surging Mist
  { "115175", { "tank.health < 100", "!player.moving", "!lastcast(115175)", "player.tier17 > 2", "player.chi > 4" }, "tank" }, -- Soothing Mist
  { "115175", { "tank.health <= 80", "!player.moving", "!lastcast(115175)"}, "tank" }, -- Soothing Mist
  { "124682", { "player.casting", "tank.health <= 60", "player.chi > 2" }, "tank" }, -- EnM
  { "116694", { "player.casting", "tank.health <= 70", "!lastcast(116694)" }, "tank" }, -- Surging Mist
  { "115175", { "focus.health <= 90", "!player.moving"}, "focus" }, -- Soothing Mist
  
}

local crane = {
  { "115078", { -- Paralysis when SHS, and Quaking Palm are all on CD
    "!target.debuff(116705)", -- Spear Hand Strike
    "player.spell(116705).cooldown > 0", -- Spear Hand Strike
    "player.spell(107079).cooldown > 0", -- Quaking Palm
    "!lastcast(116705)", -- Spear Hand Strike
    "target.interruptAt(50)" }},
  { "116844", { -- Ring of Peace when SHS is on CD
    "!target.debuff(116705)", -- Spear Hand Strike
    "player.spell(116705).cooldown > 0", -- Spear Hand Strike
    "!lastcast(116705)", -- Spear Hand Strike
    "target.interruptAt(50)" }},
  { "119381", { -- Leg Sweep when SHS is on CD
    "player.spell(116705).cooldown > 0",
    "target.range <= 5",
    "!lastcast(116705)",
    "target.interruptAt(50)" }},
  { "119392", { -- Charging Ox Wave when SHS is on CD
    "player.spell(116705).cooldown > 0",
    "target.range <= 30",
    "!lastcast(116705)",
    "target.interruptAt(50)" }},
  { "107079", { -- Quaking Palm when SHS is on CD
    "!target.debuff(116705)", -- Spear Hand Strike
    "player.spell(116705).cooldown > 0", -- Spear Hand Strike
    "!lastcast(116705)", -- Spear Hand Strike
    "target.interruptAt(50)" }},
  { "116705", "target.interruptAt(50)" }, -- Spear Hand Strike
  { "115080", {"player.buff(121125)" }}, -- Touch of Death
  { "115072", "player.health < 80" }, -- Expel Harm
  { "116694", { "lowest.health < 90", "player.buff(118674).count = 5"}, "lowest" }, -- Surging Mist
  { "115460", { "lowest.health < 80", "player.mana >= 10" }}, -- Detonate Chi
  { "107428", { "target.debuff(130320).duration < 5", "player.chi > 1", "target.range <= 5" }}, -- Rising Sun Kick
  { "100784", { "player.buff(127722).duration < 5", "player.chi > 1", "!talent(7,2)" }}, -- Blackout Kick
  { "100787", { "player.buff(125359).duration < 5", "player.chi > 0" }}, -- Tiger Palm
  { "100784", "player.chi >= 4", "!talent(7,2)" }, -- Blackout Kick
  { "152174", { "talent(7,2)", "player.chi >= 4" }}, -- Chi Explosion
  { "108557" }, -- Jab
}

local combat = {
  { "pause", "modifier.lalt" },
  { "!115310", "modifier.ralt" },  -- Revival
  { "124081", { "!tank.buff(124081)", "talent(2,2)" }, "tank" }, -- Zen Sphere  
  { "!115450", "modifier.lshift", "mouseover" }, -- Detox
  --{ "115313", "!player.totem(115313)", "tank.ground" }, -- Summon Jade Serpent Statue
  { "115313", "modifier.lcontrol", "mouseover.ground" }, -- Summon Jade Serpent Statue
  {{
    { "/targetenemy [noexists]", "!target.exists" }, -- Auto Target & Focus
    { "/targetenemy [dead]", { "target.exists", "target.dead"}},
  }, "toggle.AutoTarget" },
  { buffs, },
  { "115450", { "lowest.dispellable(115450)" }, "lowest" }, -- Detox
  { "!115203", "player.health <= 40" }, -- Fortifying Brew
  { "#5512", "player.health <= 30" }, -- Healthstone
  --{ "#109223", "player.health < 20" }, -- Health Potion
  { "123761", { "player.mana < 80", "player.buff(115867).count >= 2" }}, -- Mana Tea
  { "#trinket2", "player.mana < 80" },
  { "115098", { "lowest.health <= 90" }, "lowest" }, -- Chi Wave
  { serpent, "player.stance = 1" },
  { crane, "player.stance = 2" },
}

ProbablyEngine.rotation.register_custom(270, "|cFF32ff84Svs Mistweaver|r", combat, ooc, onLoad)
