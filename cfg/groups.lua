local cfg = {}

-- define each group with a set of permissions
-- _config property:
--- gtype (optional): used to have only one group with the same gtype per player (example: a job gtype to only have one job)
--- onspawn (optional): function(player) (called when the player spawn with the group)
--- onjoin (optional): function(player) (called when the player join the group)
--- onleave (optional): function(player) (called when the player leave the group)
--- (you have direct access to vRP and vRPclient, the tunnel to client, in the config callbacks)

cfg.groups = {
  ["superadmin"] = {
    _config = {onspawn = function(player) vRPclient.notify(player,{"You are superadmin."}) end},
    "player.group.add",
    "player.group.remove",
    "player.givemoney",
    "player.giveitem",
    "self_storage.bctp",
    "self_storage.pbsf",
    "self_storage.bhsl",
    "self_storage.tsu",
    "self_storage.dpss",
    "self_storage.gohq",
    "self_storage.fthq",
    "self_storage.bats",
    "self_storage.lc2",
    "self_storage.fyrecay",
    "self_storage.test",
    "self_storage.biz_ltweld",
    "self_storage.biz_lsia",
    "self_storage.biz_murrietta_oil",
    "self_storage.biz_yellowjack",
    "self_storage.biz_stripclub",
    "self_storage.biz_granny",
    "self_storage.biz_hookies",
    "self_storage.biz_playboi",
    "self_storage.biz_vineyard",
    "self_storage.biz_walker",
    "self_storage.biz_train_paleto",
    "self_storage.biz_train_grapeseed",
    "self_storage.biz_train_davis",
    "self_storage.biz_train_docks",
    "self_storage.biz_train_terminal",
    "self_storage.biz_train_sandy",
    "self_storage.biz_train_lm",
    "self_storage.biz_train_mp",
    "self_storage.biz_train_lc",
    "self_storage.biz_fyrecay",
    "self_storage.biz_refinery"
  },
  ["admin"] = {
    "admin.tickets",
    "admin.announce",
    "player.list",
    "player.whitelist",
    "player.unwhitelist",
    "player.kick",
    "player.ban",
    "player.unban",
    "player.noclip",
    "player.custom_emote",
    "player.custom_sound",
    "player.display_custom",
    "player.coords",
    "player.tptome",
    "player.tpto"
  },
  ["god"] = {
    "admin.god" -- reset survivals/health periodically
  },
  -- the group user is auto added to all logged players
  ["user"] = {
    "player.phone",
    "player.calladmin",
    "police.askid",
    "police.store_weapons",
    "police.seizable" -- can be seized
  },
  ["police"] = {
    _config = { 
      gtype = "job",
      onjoin = function(player) vRPclient.setCop(player,{true}) end,
      onspawn = function(player) vRPclient.setCop(player,{true}) end,
      onleave = function(player) vRPclient.setCop(player,{false}) end
    },
    "police.menu",
    "police.cloakroom",
    "police.pc",
    "police.handcuff",
    "police.putinveh",
    "police.getoutveh",
    "police.check",
    "police.service",
    "police.wanted",
    "police.seize.weapons",
    "police.seize.items",
    "police.jail",
    "police.fine",
    "police.announce",
    "-police.store_weapons",
    "-police.seizable" -- negative permission, police can't seize itself, even if another group add the permission
  },
  ["emergency"] = {
    _config = { gtype = "job" },
    "emergency.revive",
    "emergency.shop",
    "emergency.service"
  },
  ["repair"] = {
    _config = { gtype = "job"},
    "vehicle.repair",
    "vehicle.replace",
    "repair.service"
  },
  ["taxi"] = {
    _config = { gtype = "job" },
    "taxi.service"
  },
  ["citizen"] = {
    _config = { gtype = "job" }
  },
  ["premium"] = {
    "premium.storage_features",
    "transfer.self_storage"
  }
}

-- groups are added dynamically using the API or the menu, but you can add group when an user join here
cfg.users = {
  [1] = { -- give superadmin, admin, and premium group to the first created user on the database
    "superadmin",
    "admin",
    "premium"
  }
}

-- group selectors
-- _config
--- x,y,z, blipid, blipcolor, permissions (optional)

cfg.selectors = {
  ["Job Selector"] = {
    _config = {x = -268.363739013672, y = -957.255126953125, z = 31.22313880920410, blipid = 351, blipcolor = 47},
    "police",
    "taxi",
    "repair",
    "citizen"
  }
}

return cfg