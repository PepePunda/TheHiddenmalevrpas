local cfg = {}

-- exp notes:
-- levels are defined by the amount of xp
-- with a step of 5: 5|15|30|50|75 (by default)
-- total exp for a specific level, exp = step*lvl*(lvl+1)/2
-- level for a specific exp amount, lvl = (sqrt(1+8*exp/step)-1)/2

-- define groups of aptitudes (skills)
--- _title: title of the group
--- map of aptitude => {title,init_exp,max_exp}
---- max_exp: -1 for infinite exp
cfg.gaptitudes = {
  ["physical"] = {
    _title = "Physical",
    ["strength"] = {"Strength", 0, 9395}
  },
  ["science"] = {
    _title = "Science",
    ["chemicals"] = {"Study of chemicals", 0, -1},
    ["mathematics"] = {"Study of mathematics", 0, -1}
  },
  ["business"] = {
    _title = "Business Level",
    ["business"] = {"Business", 0, 110}
  },
  ["emergency"] = {
    _title = "Emergency Levels",
    ["ems"] = {"EMS", 0, 10},
    ["fire_fighter"] = {"Fire Fighter", 0, 10}
  },
  ["gathering"] = {
    _title = "Gathering Industries",
    ["farming"] = {"Farming", 0, 70},
    ["fishing"] = {"Fishing", 0, 20},
    ["mining"] = {"Mining", 0, 70}
  },
  ["hunting"] = {
    _title = "Hunting",
    ["hunting"] = {"Hunting", 0, 340}
  },
  ["piloting"] = {
    _title = "Piloting",
    ["cargo_pilot"] = {"Cargo Pilot", 0, 10},
    ["helicopter_pilot"] = {"Helicopter Pilot", 0, 10},
    ["airline_pilot"] = {"Airline Pilot", 0, 10}
  },
  ["player"] = {
    _title = "Player Level",
    ["player"] = {"Player", 0, 9518},
    ["racing"] = {"Racing", 0, 4002}
  },
  ["public_transportation"] = {
    _title = "Public Transportation",
    ["bus_driver"] = {"Bus Driver", 0, 10},
    ["conductor"] = {"Conductor", 0, 1111}
  },
  ["trucking"] = {
    _title = "Trucking",
    ["garbage_collections"] = {"Garbage Collections", 0, 10},
    ["mechanic"] = {"Mechanic", 0, 10},
    ["postop"] = {"PostOP", 0, 10},
    ["trucking"] = {"Trucking", 0, 10432}
  },
  ["combined"] = {
    _title = "Combined Level",
    ["combined"] = {"Combined Level", 0, 35160},
    ["combined_level"] = {"Combined Level", 0, 35160}
  },
  ["hypesPunda"] = {
    _title = "HypesPunda",
    ["PepePunda"] = {"Study of Hypes gyatt", 0, -1},
    ["pundaatics"] = {"Study of thiccness", 0, -1}
  },
  ["RodawgsPunda"] = {
    _title = "RodawgsPunda",
    ["PepePunda"] = {"Study of rodawgs gyatt", 0, -1},
    ["pundaatics"] = {"Study of thiccness", 0, -1}
  },
  ["PepePunda"] = {
    _title = "PepesPunda",
    ["PepePunda"] = {"Study of pepes gyatt", 0, -1},
    ["pundaatics"] = {"Study of thiccness", 0, -1}
  }
}

return cfg
