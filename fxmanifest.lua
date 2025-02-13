fx_version 'adamant'

name "vRP Framework"
author "ImagicTheCat"
contact "https://forum.fivem.net/u/imagic/"
version "0.5 (Modified by Tycoon)"

game 'gta5'

description "RP module/framework"
usage [[

]]

dependency "vrp_mysql"

ui_page "gui/index.html"

-- server scripts
server_scripts{
  "lib/utils.lua",
  "lib/rev_veh.lua",
  "base.lua",
  "modules/gui.lua",
  "modules/group.lua",
  "modules/admin.lua",
  "modules/survival.lua",
  "modules/player_state.lua",
  "modules/map.lua",
  "modules/money.lua",
  "modules/inventory.lua",
  "modules/identity.lua",
  "modules/business.lua",
  "modules/item_transformer.lua",
  "modules/emotes.lua",
  "modules/police.lua",
  "modules/home.lua",
  "modules/home_components.lua",
  "modules/mission.lua",
  "modules/aptitude.lua",
  "modules/licenses.lua",
  "modules/ironman.lua",
  "modules/stats.lua",
  "modules/loans.lua",
  "modules/factions.lua",

  -- basic implementations
  "modules/basic_phone.lua",
  "modules/basic_atm.lua",
  "modules/basic_market.lua",
  "modules/basic_gunshop.lua",
  "modules/basic_garage.lua",
  "modules/basic_items.lua",
  "modules/basic_skinshop.lua",
  "modules/cloakroom.lua",
  "modules/paycheck.lua",
  "modules/player_options.lua",
  "modules/spawnpoint.lua",
  "modules/commerce.lua",
  "modules/codes.lua",
  "modules/secrets.lua",
}

-- client scripts
client_scripts{
  "lib/utils.lua",
  "lib/rev_veh.lua",
  "client/Tunnel.lua",
  "client/Proxy.lua",
  "client/base.lua",
  "client/iplloader.lua",
  "client/gui.lua",
  "client/player_state.lua",
  "client/survival.lua",
  "client/map.lua",
  "client/money.lua",
  "client/identity.lua",
  "client/basic_garage.lua",
  "client/police.lua",
  "client/admin.lua",
  "client/paycheck.lua",
  "client/stats.lua",
}

-- client files
files{
  "cfg/client.lua",
  "cfg/stats.lua",
  "cfg/weapons.lua",
  "cfg/decorators.lua",
  "gui/index.html",
  "gui/design.css",
  "gui/main.js",
  "gui/Menu.js",
  "gui/ProgressBar.js",
  "gui/WPrompt.js",
  "gui/RequestManager.js",
  "gui/AnnounceManager.js",
  "gui/Div.js",
  "gui/dynamic_classes.js",
  "gui/fonts/Pdown.woff",
  "gui/fonts/Pricedown.woff",
  "gui/fonts/PRICEDOWNGTAVINT.TTF",
  -- FA Stuff
  "gui/css/all.min.css",
  "gui/webfonts/fa-brands-400.eot",
  "gui/webfonts/fa-brands-400.svg",
  "gui/webfonts/fa-brands-400.ttf",
  "gui/webfonts/fa-brands-400.woff",
  "gui/webfonts/fa-brands-400.woff2",
  "gui/webfonts/fa-regular-400.eot",
  "gui/webfonts/fa-regular-400.svg",
  "gui/webfonts/fa-regular-400.ttf",
  "gui/webfonts/fa-regular-400.woff",
  "gui/webfonts/fa-regular-400.woff2",
  "gui/webfonts/fa-solid-900.eot",
  "gui/webfonts/fa-solid-900.svg",
  "gui/webfonts/fa-solid-900.ttf",
  "gui/webfonts/fa-solid-900.woff",
  "gui/webfonts/fa-solid-900.woff2",
}

config_file 'cfg/homes.lua'
