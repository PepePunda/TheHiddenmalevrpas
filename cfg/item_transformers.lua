local cfg = {}

cfg.item_transformers = {
  {
    name = "Tool Buyer",
    r = 0, g = 125, b = 255,
    max_units = 1000,
    units_per_minute = 10,
    x = -3162.7288, y = 1129.4196, z = 20.9608,
    radius = 5, height = 1.5,
    recipes = {
      ["Sell Tools"] = {
        description = "Sell your tools.",
        in_money = 0,
        out_money = 200,
        reagents = {
          ["tools"] = 1
        },
        products = {},
        aptitudes = {
          ["player.player"] = 0.106,
          ["trucking.trucking"] = 0.106,
          ["physical.strength"] = 0.146
        }
      },
      ["Sell Tools x10"] = {
        description = "Sell 10 tools.",
        in_money = 0,
        out_money = 2000,
        reagents = {
          ["tools"] = 10
        },
        products = {},
        aptitudes = {
          ["player.player"] = 1.06,
          ["trucking.trucking"] = 1.06,
          ["physical.strength"] = 1.46
        }
      },
      ["Sell Tools x100"] = {
        description = "Sell 100 tools.",
        in_money = 0,
        out_money = 20000,
        reagents = {
          ["tools"] = 100
        },
        products = {},
        aptitudes = {
          ["player.player"] = 10.6,
          ["trucking.trucking"] = 10.6,
          ["physical.strength"] = 14.6
        }
      }
    }
  },
  {
    name = "Tool Seller",
    r = 255, g = 125, b = 0,
    max_units = 1000,
    units_per_minute = 10,
    x = 835.6380, y = -1989.8676, z = 29.3013,
    radius = 5, height = 1.5,
    recipes = {
      ["Buy Tools"] = {
        description = "Buy a tool.",
        in_money = 200,
        out_money = 0,
        reagents = {},
        products = {
          ["tools"] = 1
        }
      },
      ["Buy Tools x10"] = {
        description = "Buy 10 tools.",
        in_money = 2000,
        out_money = 0,
        reagents = {},
        products = {
          ["tools"] = 10
        },
        check = function(player)
          local user_id = vRP.getUserId(player)
          if user_id then
            local level = vRP.expToLevel(vRP.getExp(user_id, "trucking", "trucking"))
            if level >= 5 then
              return true
            else
              vRPclient.notify(player, {"~r~You need to be level 5 in Trucking to buy 10 tools."})
              return false
            end
          end
          return false
        end
      },
      ["Buy Tools x100"] = {
        description = "Buy 100 tools.",
        in_money = 20000,
        out_money = 0,
        reagents = {},
        products = {
          ["tools"] = 100
        },
        check = function(player)
          local user_id = vRP.getUserId(player)
          if user_id then
            local level = vRP.expToLevel(vRP.getExp(user_id, "trucking", "trucking"))
            if level >= 10 then
              return true
            else
              vRPclient.notify(player, {"~r~You need to be level 10 in Trucking to buy 100 tools."})
              return false
            end
          end
          return false
        end
      }
    }
  },
  {
    name = "Alta Construction Site",
    r = 0, g = 125, b = 255,
    max_units = 1000,
    units_per_minute = 10,
    x = 108.1893, y = -376.1188, z = 42.2259,
    radius = 5, height = 1.5,
    recipes = {
      ["Sell Concrete x1"] = {
        description = "Sell 1 Concrete.",
        in_money = 0,
        out_money = 800000,
        reagents = {
          ["concrete"] = 1
        },
        products = {},
        aptitudes = {
          ["player.player"] = 11.456,
          ["trucking.trucking"] = 11.456,
          ["physical.strength"] = 11.456
        }
      },
      ["Sell Concrete x2"] = {
        description = "Sell 2 Concrete.",
        in_money = 0,
        out_money = 1600000,
        reagents = {
          ["concrete"] = 2
        },
        products = {},
        aptitudes = {
          ["player.player"] = 22.912,
          ["trucking.trucking"] = 22.912,
          ["physical.strength"] = 22.912
        }
      },
      ["Sell Rebar x1"] = {
        description = "Sell 1 Rebar.",
        in_money = 0,
        out_money = 230000,
        reagents = {
          ["rebar"] = 1
        },
        products = {},
        aptitudes = {
          ["player.player"] = 2.132,
          ["trucking.trucking"] = 2.132,
          ["physical.strength"] = 2.132
        }
      },
      ["Sell Rebar x5"] = {
        description = "Sell 5 Rebar.",
        in_money = 0,
        out_money = 1150000,
        reagents = {
          ["rebar"] = 5
        },
        products = {},
        aptitudes = {
          ["player.player"] = 10.66,
          ["trucking.trucking"] = 10.66,
          ["physical.strength"] = 10.66
        }
      },
      ["Sell Asphalt Concrete x1"] = {
        description = "Sell 1 Asphalt Concrete.",
        in_money = 0,
        out_money = 125000,
        reagents = {
          ["asphalt_concrete"] = 1
        },
        products = {},
        aptitudes = {
          ["player.player"] = 7.6985,
          ["trucking.trucking"] = 7.6985,
          ["physical.strength"] = 7.6985
        }
      },
      ["Sell Asphalt Concrete x5"] = {
        description = "Sell 5 Asphalt Concrete.",
        in_money = 0,
        out_money = 625000,
        reagents = {
          ["asphalt_concrete"] = 5
        },
        products = {},
        aptitudes = {
          ["player.player"] = 38.4925,
          ["trucking.trucking"] = 38.4925,
          ["physical.strength"] = 38.4925
        }
      }
    }
  },
  {
    name = "Quarry",
    r = 255, g = 125, b = 0,
    max_units = 1000,
    units_per_minute = 10,
    x = 2681.3694, y = 2810.5940, z = 40.5229,
    radius = 5, height = 1.5,
    recipes = {
      ["Pick Up Quarry Rubble x1"] = {
        description = "Pick up 1 Quarry Rubble.",
        in_money = 0,
        out_money = 0,
        reagents = {},
        products = {
          ["quarry_rubble"] = 1
        },
        aptitudes = {}
      },
      ["Pick Up Quarry Rubble x2"] = {
        description = "Pick up 2 Quarry Rubble.",
        in_money = 0,
        out_money = 0,
        reagents = {},
        products = {
          ["quarry_rubble"] = 2
        },
        aptitudes = {}
      },
      ["Deliver Sand"] = {
        description = "Deliver Sand.",
        in_money = 0,
        out_money = 1500,
        reagents = {
          ["sand"] = 1
        },
        products = {},
        aptitudes = {
          ["player.player"] = 1.439,
          ["trucking.trucking"] = 1.439,
          ["physical.strength"] = 1.439
        }
      },
      ["Create Cement Mix x1"] = {
        description = "Create 1 Cement Mix.",
        in_money = 1500,
        out_money = 0,
        reagents = {
          ["sand"] = 5,
          ["sawdust"] = 2
        },
        products = {
          ["cement_mix"] = 1
        },
        aptitudes = {
          ["player.player"] = 0.746,
          ["trucking.trucking"] = 0.746,
          ["physical.strength"] = 0.746
        }
      },
      ["Create Cement Mix x10"] = {
        description = "Create 10 Cement Mix.",
        in_money = 15000,
        out_money = 0,
        reagents = {
          ["sand"] = 50,
          ["sawdust"] = 20
        },
        products = {
          ["cement_mix"] = 10
        },
        aptitudes = {
          ["player.player"] = 7.46,
          ["trucking.trucking"] = 7.46,
          ["physical.strength"] = 7.46
        }
      }
    }
  },
  {
    name = "Filtering Plant",
    r = 125, g = 125, b = 0,
    max_units = 1000,
    units_per_minute = 10,
    x = 262.3541, y = 2846.0415, z = 43.7422,
    radius = 5, height = 1.5,
    recipes = {
      ["Filter Gravel"] = {
        description = "Filter materials out of the gravel.",
        in_money = 90000,
        out_money = 0,
        reagents = {
          ["gravel"] = 60
        },
        products = {
          ["sand"] = 36,
          ["flint"] = 24
        },
        aptitudes = {
          ["player.player"] = 1.512,
          ["trucking.trucking"] = 1.512,
          ["physical.strength"] = 1.512
        }
      },
      ["Filter Gravel x6"] = {
        description = "Filter materials out of the gravel.",
        in_money = 540000,
        out_money = 0,
        reagents = {
          ["gravel"] = 360
        },
        products = {
          ["sand"] = 216,
          ["flint"] = 144
        },
        aptitudes = {
          ["player.player"] = 9.072,
          ["trucking.trucking"] = 9.072,
          ["physical.strength"] = 9.072
        }
      },
      ["Filter Quarry Rubble"] = {
        description = "Filter materials out of the rubble.",
        in_money = 15000,
        out_money = 0,
        reagents = {
          ["quarry_rubble"] = 1
        },
        products = {
          ["raw_ore_mix"] = 4,
          ["gravel"] = 12,
          ["raw_emeralds"] = 1
        },
        aptitudes = {
          ["player.player"] = 2.573,
          ["trucking.trucking"] = 2.573,
          ["physical.strength"] = 2.573
        }
      },
      ["Filter Quarry Rubble x2"] = {
        description = "Filter materials out of the rubble.",
        in_money = 30000,
        out_money = 0,
        reagents = {
          ["quarry_rubble"] = 2
        },
        products = {
          ["raw_ore_mix"] = 8,
          ["gravel"] = 24,
          ["raw_emeralds"] = 2
        },
        aptitudes = {
          ["player.player"] = 5.146,
          ["trucking.trucking"] = 5.146,
          ["physical.strength"] = 5.146
        }
      },
      ["Filter Toxic Waste"] = {
        description = "Filter materials out of the waste.",
        in_money = 0,
        out_money = 0,
        reagents = {
          ["toxic_waste"] = 1
        },
        products = {
          ["acid"] = 4,
          ["scrap_lead"] = 2,
          ["scrap_mercury"] = 2
        },
        aptitudes = {
          ["player.player"] = 6.174,
          ["trucking.trucking"] = 6.174,
          ["physical.strength"] = 6.174
        }
      },
      ["Filter Toxic Waste x3"] = {
        description = "Filter materials out of the waste.",
        in_money = 0,
        out_money = 0,
        reagents = {
          ["toxic_waste"] = 3
        },
        products = {
          ["acid"] = 12,
          ["scrap_lead"] = 6,
          ["scrap_mercury"] = 6
        },
        aptitudes = {
          ["player.player"] = 18.522,
          ["trucking.trucking"] = 18.522,
          ["physical.strength"] = 18.522
        }
      },
      ["Mix Concrete"] = {
        description = "Mix materials to create concrete.",
        in_money = 0,
        out_money = 0,
        reagents = {
          ["cement_mix"] = 1
        },
        products = {
          ["concrete"] = 1
        },
        aptitudes = {}
      },
      ["Mix Concrete x2"] = {
        description = "Mix materials to create concrete.",
        in_money = 0,
        out_money = 0,
        reagents = {
          ["cement_mix"] = 2
        },
        products = {
          ["concrete"] = 2
        },
        aptitudes = {}
      },
      ["Secret"] = {
        description = "Conveyor Filtering",
        in_money = 30000,
        out_money = 0,
        reagents = {
          ["copper_ore_voucher"] = 1,
          ["iron_ore_voucher"] = 1
        },
        products = {
          ["raw_emeralds"] = 1,
          ["gravel"] = 10,
          ["raw_ore_mix"] = 3
        },
        aptitudes = {}
      }
    }
  },
  {
    name = "Erasers Seller",
    r = 0, g = 125, b = 255,
    max_units = 1000,
    units_per_minute = 10,
    x = 823.9042, y = -1936.2496, z = 29.0860,
    radius = 5, height = 1.5,
    recipes = {
      ["Buy Erasers"] = {
        description = "Buy an Eraser.",
        in_money = 200,
        out_money = 0,
        reagents = {},
        products = {
          ["eraser"] = 1
        },
        check = function(player)
          local user_id = vRP.getUserId(player)
          if user_id then
            local level = vRP.expToLevel(vRP.getExp(user_id, "trucking", "trucking"))
            if level >= 2 then
              return true
            else
              vRPclient.notify(player, {"~r~You need to be level 2 in Trucking to buy an eraser."})
              return false
            end
          end
          return false
        end
      },
      ["Buy Erasers x10"] = {
        description = "Buy 10 Erasers.",
        in_money = 2000,
        out_money = 0,
        reagents = {},
        products = {
          ["eraser"] = 10
        },
        check = function(player)
          local user_id = vRP.getUserId(player)
          if user_id then
            local level = vRP.expToLevel(vRP.getExp(user_id, "trucking", "trucking"))
            if level >= 2 then
              return true
            else
              vRPclient.notify(player, {"~r~You need to be level 2 in Trucking to buy 10 erasers."})
              return false
            end
          end
          return false
        end
      },
      ["Buy Erasers x100"] = {
        description = "Buy 100 Erasers.",
        in_money = 20000,
        out_money = 0,
        reagents = {},
        products = {
          ["eraser"] = 100
        },
        check = function(player)
          local user_id = vRP.getUserId(player)
          if user_id then
            local level = vRP.expToLevel(vRP.getExp(user_id, "trucking", "trucking"))
            if level >= 2 then
              return true
            else
              vRPclient.notify(player, {"~r~You need to be level 2 in Trucking to buy 100 erasers."})
              return false
            end
          end
          return false
        end
      }
    }
  },
  {
    name = "Erasers Buyer",
    r = 255, g = 125, b = 0,
    max_units = 1000,
    units_per_minute = 10,
    x = -1134.3035, y = 2695.2085, z = 18.8004,
    radius = 5, height = 1.5,
    recipes = {
      ["Sell Erasers"] = {
        description = "Sell Erasers.",
        in_money = 0,
        out_money = 600,
        reagents = {
          ["eraser"] = 1
        },
        products = {},
        aptitudes = {
          ["player.player"] = 0.421,
          ["trucking.trucking"] = 0.421,
          ["physical.strength"] = 0.421
        }
      },
      ["Sell Erasers x10"] = {
        description = "Sell 10 Erasers.",
        in_money = 0,
        out_money = 6000,
        reagents = {
          ["eraser"] = 10
        },
        products = {},
        aptitudes = {
          ["player.player"] = 4.2,
          ["trucking.trucking"] = 4.2,
          ["physical.strength"] = 4.2
        }
      },
      ["Sell Erasers x100"] = {
        description = "Sell 100 Erasers.",
        in_money = 0,
        out_money = 60000,
        reagents = {
          ["eraser"] = 100
        },
        products = {},
        aptitudes = {
          ["player.player"] = 42.0,
          ["trucking.trucking"] = 42.0,
          ["physical.strength"] = 42.0
        }
      }
    }
  }
}

-- define transformers randomly placed on the map
cfg.hidden_transformers = {
  ["weed field"] = {
    def = {
      name = "Weed field",
      r = 0, g = 200, b = 0,
      max_units = 30,
      units_per_minute = 1,
      x = 0, y = 0, z = 0,
      radius = 5, height = 1.5,
      recipes = {
        ["Harvest"] = {
          description = "Harvest some weed.",
          in_money = 0,
          out_money = 0,
          reagents = {},
          products = {
            ["weed"] = 1
          }
        }
      }
    },
    positions = {
      {1873.36901855469, 3658.46215820313, 33.8029747009277},
      {1856.33776855469, 3635.12109375, 34.1897926330566},
      {1830.75390625, 3621.44140625, 33.8487205505371}
    }
  }
}

-- time in minutes before hidden transformers are relocated (min is 5 minutes)
cfg.hidden_transformer_duration = 5 * 24 * 60 -- 5 days

-- configure the information reseller (can sell hidden transformers positions)
cfg.informer = {
  infos = {
    ["weed field"] = 20000
  },
  positions = {
    {1821.12390136719, 3685.9736328125, 34.2769317626953},
    {1804.2958984375, 3684.12280273438, 34.217945098877}
  },
  interval = 60,
  duration = 10,
  blipid = 133,
  blipcolor = 2
}

return cfg
