-- SPEC ID 70

ProbablyEngine.listener.register('LFG_PROPOSAL_SHOW', AcceptProposal)

local seals = {
  {{
    { "31801", { -- Seal of Truth
      "player.seal != 1",
      "player.buff(156990).duration < 3", -- Maraad's Truth
      "player.spell(20271).cooldown < 1.2" -- Judgment
    }},
    { "20154", { -- Seal of Righteousness
      "player.seal != 2",
      "player.buff(156989).duration < 3", -- Liadrin's Righteousness
      "player.buff(156990)",
      "player.spell(20271).cooldown < 1.2"
    }},
    { "20271", {
      "player.buff(156990).duration < 3"
    }},
    { "20271", {
      "player.buff(156989).duration < 3"
    }},
    {{
      { "31801", {
        "player.seal != 1",
        "!modifier.multitarget"
      }},
      { "31801", {
        "player.seal != 1",
        "modifier.multitarget",
        "player.area(10).enemies < 4" 
      }},
      { "20154", {
        "player.seal != 2",
        "modifier.multitarget",
        "player.area(10).enemies >= 4"
      }}
    }, {
      "player.buff(156990).duration > 3",
      "player.buff(156989).duration > 3"
    }}
  }, "talent(7, 1)" },
  {{
    { "31801", {
      "player.seal != 1",
      "!modifier.multitarget"
    }},
    { "31801", {
      "player.seal != 1",
      "player.area(10).enemies < 4" 
    }},
    { "20154", {
      "player.seal != 2",
      "modifier.multitarget",
      "player.area(10).enemies >= 4"
    }}
  }, "!talent(7, 1)" }
}

local singleTarget = {
  { "31884", "modifier.cooldowns" }, -- Avenging Wrath
  { "105809", "modifier.cooldowns" }, -- Holy Avenger
  { "114157", "target.health.actual > 50000" }, -- Execution Sentence 100000
  { "85256", "player.buff(86172)" }, -- Templar's Verdict/
  { "157048", "player.buff(86172)" }, -- Final Verdict
  { "85256", "player.holypower = 5" },
  { "157048", "player.holypower = 5" },
  { "53385", { -- Divine Storm
    --"player.buff(157048)",
    "player.buff(174718)" -- Empowered Divine Storm
  }},
  { "24275" }, -- Hammer of Wrath
  { "35395" }, -- Crusader Strike
  { "20271" },
  { "879" }, -- Exorcism
  { "85256", "player.holypower >= 3" },
  { "157048", "player.holypower >= 3" },
}

local cleaveTarget = {
  { "31884", "modifier.cooldowns" },
  { "105809", "modifier.cooldowns" },
  { "114157", "target.health.actual > 100000" },
  { "53385", {
    --"player.buff(157048)",
    "player.buff(174718)" -- Empowered Divine Storm
  }},
  { "53385", "player.buff(86172)" },
  { "85256", "player.holypower = 5" },
  { "157048", "player.holypower = 5" },
  { "24275" },
  { "35395" },
  { "20271" },
  { "879" },
  { "85256", "player.holypower >= 3" },
  { "157048", "player.holypower >= 3" },
}

local multiTarget = {
  { "31884", "modifier.cooldowns" },
  { "105809", "modifier.cooldowns" },
  { "114157", "target.health.actual > 100000" },
  { "53385", {
    --"player.buff(157048)",
    "player.buff(174718)" -- Empowered Divine Storm
  }},
  { "53385", "player.buff(86172)" },
  { "53385", "player.buff(157048)" },
  { "53385", "player.holypower = 5" },
  { "53595" }, -- Hammer of the Righteous
  { "879" },
  { "24275" },
  { "20271" },
  { "53385", "player.holypower >= 3" },
}

ProbablyEngine.rotation.register_custom(70, "Hackinret", {
  -- Survive
  { "633", "player.health < 20" }, -- LoH
    -- AutoTarget
  { "/targetenemy [noexists]", { "toggle.autotarget", "!target.exists" }},
  { "/targetenemy [dead]", { "toggle.autotarget", "target.exists", "target.dead" }},
  { "96231", "target.interruptAt(50)" }, -- Rebuke "modifier.interrupts",
  { "4987", "player.dispellable(4987)" }, -- Cleanse
  { "1044", { "!player.buff", "player.state.root" }, "player" }, -- Hand of Freedom
  { "19750", { "player.buff(85804).count = 3", "focus.exists", "focus.health <= 80" }, "focus" }, -- Flash of Light/Selfless Healer
  { "19750", { "player.buff(85804).count = 3", "!focus.exists", "player.health <= 70" }, "player" },
  { "20925", "!player.buff" }, -- Sacred Shield
  { "20217", { "!player.buff", "!player.party" }}, -- Blessing of Kings
  { "#trinket1", "modifier.cooldowns" },
  { "#trinket2", "modifier.cooldowns" },
  -- Rotation
  { seals },
  { singleTarget, "player.area(10).enemies < 2" },
  { cleaveTarget, "player.area(10).enemies >= 2" },
  { multiTarget, { "player.area(10).enemies >= 4", "modifier.multitarget" }},
  { singleTarget }, -- fallback
},{ -- ooc
  
  { "85673", "player.holypower >= 1", "player.health < 90" },

}, function()
    ProbablyEngine.toggle.create('autotarget', 'Interface\\Icons\\ability_spy', 'Auto Target', 'Automatically target the nearest enemy when target dies or does not exist')
end)
     
