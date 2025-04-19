local cfg = {}
local custom = {}
local TYPE = {
    INT = "int",
    FLOAT = "float",
}
-- cfg[stat] = {type, desc, shown, name, format, divisor}
cfg["TOTAL_PLAYING_TIME"] = {TYPE.INT, "Total playing time in milliseconds"}
cfg["LONGEST_PLAYING_TIME"] = {TYPE.INT, "Longest playing time since last death"}
cfg["LONGEST_CAM_TIME_DRIVING"] = {TYPE.INT, "Longest time spent driving in cinematic camera in milliseconds"}
cfg["DIED_IN_DROWNING"] = {TYPE.INT, "Number of times player died by drowning"}
cfg["DIED_IN_DROWNINGINVEHICLE"] = {TYPE.INT, "Number of times player died by drowning in vehicle"}
cfg["DIED_IN_EXPLOSION"] = {TYPE.INT, "Number of times player died by explosion"}
cfg["DIED_IN_FALL"] = {TYPE.INT, "Number of times player died by fall"}
cfg["DIED_IN_FIRE"] = {TYPE.INT, "Number of times player died by fire"}
cfg["DIED_IN_ROAD"] = {TYPE.INT, "Number of times player died in a road accident"}
cfg["KILLS_PLAYERS"] = {TYPE.INT, "Number of players killed"}
cfg["KILLS_INNOCENTS"] = {TYPE.INT, "Number of innocent pedestrians killed"}
cfg["KILLS_ENEMY_GANG_MEMBERS"] = {TYPE.INT, "Enemy gang members killed"}
cfg["KILLS_FRIENDLY_GANG_MEMBERS"] = {TYPE.INT, "Friendly gang members killed"}
cfg["LARGE_ACCIDENTS"] = {TYPE.INT, "Number of large accidents"}
cfg["LONGEST_DRIVE_NOCRASH"] = {TYPE.FLOAT, "Longest drive without a crash"}
cfg["DIST_DRIVING_CAR"] = {TYPE.FLOAT, "Total distance driving a car", true, "Car Distance", "%.2fkm", 1000}
cfg["DIST_DRIVING_PLANE"] = {TYPE.FLOAT, "Total distance driving a plane", true, "Plane Distance", "%.2fkm", 1000}
cfg["DIST_DRIVING_HELI"] = {TYPE.FLOAT, "Total distance driving a heli", true, "Helicopter Distance", "%.2fkm", 1000}
cfg["DIST_DRIVING_BIKE"] = {TYPE.FLOAT, "Total distance driving a bike"}
cfg["DIST_DRIVING_BOAT"] = {TYPE.FLOAT, "Total distance driving a boat", true, "Boat Distance", "%.2fkm", 1000}
cfg["DIST_SWIMMING"] = {TYPE.FLOAT, "Total swimming distance", true, "Swimming Distance", "%.2fkm", 1000}
cfg["DIST_WALKING"] = {TYPE.FLOAT, "Total walking distance", true, "Walking Distance", "%.2fkm", 1000}
cfg["DIST_RUNNING"] = {TYPE.FLOAT, "Total running distance", true, "Running Distance", "%.2fkm", 1000}
cfg["TIME_UNDERWATER"] = {TYPE.INT, "Total time underwater"}
cfg["TIME_IN_WATER"] = {TYPE.INT, "Total time in water"}
cfg["AVERAGE_SPEED"] = {TYPE.FLOAT, "Average speed when driving a car or a bike"}
cfg["FLIGHT_TIME"] = {TYPE.FLOAT, "Total flight time"}
cfg["NUMBER_NEAR_MISS"] = {TYPE.INT, "Number of vehicles near misses.", true, "Near Misses"}
cfg["BAILED_FROM_VEHICLE"] = {TYPE.INT, "Number of times jumped out of a moving vehicle."}
cfg["TOTAL_DAMAGE_CARS"] = {TYPE.FLOAT, "Total damage done in Cars"}
cfg["NUMBER_CRASHES_CARS"] = {TYPE.INT, "Number of crashes done in Cars"}
cfg["CARS_EXPLODED"] = {TYPE.INT, "Number of cars exploded"}
cfg["BOATS_EXPLODED"] = {TYPE.INT, "Number of boats exploded"}
cfg["HELIS_EXPLODED"] = {TYPE.INT, "Number of helis exploded"}
cfg["PLANES_EXPLODED"] = {TYPE.INT, "Number of planes exploded"}
cfg["FASTEST_SPEED"] = {TYPE.FLOAT, "Fastest speed recorded in a vehicle", true, "Fastest Speed", "%.0f mph", 1.609344}
cfg["TOP_SPEED_CAR"] = {TYPE.INT, "Model Index of the fastest speed car"}
cfg["TOTAL_WHEELIE_TIME"] = {TYPE.INT, "Total wheelie time in a bike"}
cfg["LONGEST_SURVIVED_FREEFALL"] = {TYPE.FLOAT, "Longest Survived free fall in meters."}
cfg["HIGHEST_SKITTLES"] = {TYPE.INT, "Number of pedestrians run down"}
-- custom[stat] = {name, secret, flexString}
-- flex string format: {m} for money, {s} for text, {i} for integers
custom['drops_collected'] =             {'Treasure Chests Collected', false, "I've collected {i} Treasure Chests!"}
custom['eastereggs_pickup'] =           {'EXP Bonuses Collected', false, "I've collected {i} EXP Bonuses!"}
custom['firefighter_streak_record'] =   {'Highest Firefighter Streak', false, "My highest Firefighter streak is {i}!"}
custom['quarry_coop'] =                 {'Contributed Quarry Deliveries', false, "I've contributed to {i} Quarry Deliveries!"}
custom['quarry_deliver'] =              {'Total Quarry Drop-offs', false, "I've delivered {i} Quarry Drop-offs!"}
custom['toll_paid'] =                   {'Toll Fines', false, "I've paid {m} in Toll Fines!"}
custom['trap_paid'] =                   {'Speed Trap Fines', false, "I've paid {m} in Speed Trap Fines!"}
custom['omni_void_leaderboard'] =       {'Voided Money', false, "I've voided {m}!"}
custom['quarry_excavate'] =             {'Excavator Buckets Filled', false, "I've filled {i} Excavator Buckets!"}
custom['ems_deliveries'] =              {'Completed Paramedic Callouts', false, "I've completed {i} Paramedic Callouts!"}
custom['ems_streak_record'] =           {'Highest Paramedic Streak', false, "My highest Paramedic streak is {i}!"}
custom['quarry_solo'] =                 {'Independent Quarry Deliveries', false, "I've completed {i} Independent Quarry Deliveries!"}
custom['aerialfire_earnings'] =         {'Aerial Firefighter Earnings', false, "I've earned {m} as an Aerial Firefighter!"}
custom['aerialfire_finished'] =         {'Aerial Fires Extinguished', false, "I've extinguished {i} Aerial Fires!"}
custom['aerialfire_finished_cl415f'] =  {'Aerial Fires Extinguished (CL415F)'}
custom['aerialfire_finished_cg130h'] =  {'Aerial Fires Extinguished (CG130H)'}
custom['aerialfire_finished_tula'] =    {'Aerial Fires Extinguished (Tula)'}
custom['aerialfire_finished_747fire'] = {'Aerial Fires Extinguished (747)'}
custom['houses_crafted'] =              {'Trucking Completed Houses', false, "I've crafted {i} Houses!"}
custom['vehicles_crafted'] =            {'Crafted Vehicle Shipments', false, "I've crafted {i} Vehicle Shipments!"}
custom['maid_maxscans'] =               {'Highest SACP Scan Streak', false, "My highest SACP Scan streak is {i}!"}
custom['maid_tickets'] =                {'Total SACP Tickets', false, "I've issued {i} SACP Tickets!"}
custom['cg_missions'] =                 {'Completed Coast Guard Missions', false, "I've completed {i} Coast Guard Missions!"}
custom['cg_pickups'] =                  {'Coast Guard Rescues', false, "I've rescued {i} people as Coast Guard!"}
custom['cg_points'] =                   {'Coast Guard Score', false, "I've earned {i} Coast Guard Points!"}
custom['hunting_skin'] =                {'Animals Gutted', false, "I've gutted {i} Animals!"}
custom['hunting_skin_mission'] =        {'Mission Animals Gutted', false, "I've gutted {i} Mission Animals!"}
custom['hunting_zones'] =               {'Hunting Zones Cleared', false, "I've cleared {i} Hunting Zones!"}
custom['hunting_missions'] =            {'Hunting Missions Completed', false, "I've completed {i} Hunting Missions!"}
custom['concrete_sold'] =               {'Trucking Concrete Sold', false, "I've sold {i} Concrete!"}
custom['bus_route_completed'] =         {"Bus Driver Completed Route(s)", false, "I've completed {i} Bus Routes!"}
custom['bus_fares_earned'] =            {"Bus Driver Total Fares", false, "I've served {i} passengers as a Bus Driver!"}
custom['bus_money_earned'] =            {"Bus Driver Money Earned", false, "I've earned {m} as a Bus Driver!"}
custom['bus_behemoth_completed'] =      {"Bus Driver Behemoth Route(s) Completed", false, "I've completed {i} Behemoth Routes!"}
custom['surveying_steps'] =             {"Surveyed Areas", false, "I've surveyed {i} Areas!"}
custom['surveying_missions'] =          {"Surveying Missions Completed", false, "I've completed {i} Surveying Missions!"}
custom['fyrecay_activities'] =          {"Cayo Activities Completed", false, "I've completed {i} Cayo Activities!"}
custom['fyrecay_completion'] =          {"Cayo Perico Completions", false, "I've completed Cayo Perico {i} times!"}
custom['garbage_routes_finished'] =     {"Garbage Routes Finished", false, "I've finished {i} Garbage Routes!"}
custom['garbage_trash_collected'] =     {"Garbage Bags Collected", false, "I've collected {i} Garbage Bags!"}
custom['mechanic_flatbed_dropoffs'] =   {"Mechanic Flatbed Dropoffs", false, "I've completed {i} Flatbed Dropoffs!"}
custom['mechanic_semi_dropoffs'] =      {"Mechanic Semi Dropoffs", false, "I've completed {i} Semi Dropoffs!"}
custom['mechanic_skylift_dropoffs'] =   {"Mechanic Skylift Dropoffs", false, "I've completed {i} Skylift Dropoffs!"}
custom['xmplow_dist22'] =               {"Snowplowing Total Distance (m)", false, "I've plowed {i} meters of snow!"}
custom['xmplow_road22'] =               {"Snowplowing Roads Cleared (m²)", false, "I've cleared {i} m² of snow!"}
custom['xmplow_snow22'] =               {"Snowplowing Snow Removed (m³)", false, "I've removed {i} m³ of snow!"}
custom['xmplow_salt22'] =               {"Snowplowing Salted Roads (m²)", false, "I've salted {i} m² of roads!"}
custom['xmplow_tokens22'] =             {"Snowplowing Tokens Earned", false, "I've earned {i} Snowplowing Tokens!"}
custom['xmplow_pay22'] =                {"Snowplowing Pay Earned", false, "I've earned {m} from Snowplowing!"}
custom['xmplow_bonus22'] =              {"Highest Snowplowing Convoy Bonus", false, "My highest Snowplowing Convoy Bonus is {i}!"}
custom['xmpresent_collected'] =         {"Collected Xmas Presents", false, "I've collected {i} Xmas Presents!"}
custom['hw22_zombies_looted'] =         {"Zombies Looted", false, "I've looted {i} Zombies!"}
custom['cabbie_dropoffs'] =             {"Cabbie Dropoffs", false, "My highest Cabbie streak is {i}!"}
custom['cabbie_dropoffs_total'] =       {"Cabbie Total Dropoffs", false, "I've completed {i} Cabbie Dropoffs!"}
custom['rts_cars_delivered'] =          {"RTS Cars Delivered", false, "I've delivered {i} RTS Cars!"}
custom['rts_cars_perfect'] =            {"RTS Perfect Deliveries", false, "I've completed {i} perfect RTS Deliveires!"}
custom['rts_air_delivered'] =           {"RTS Aircraft Delivered", false, "I've delivered {i} RTS Aircraft!"}
custom['shipping_crates_crafted'] =     {"Shipping Containers Crafted", false, "I've crafted {i} Shipping Containers!"}
custom['logs_processed'] =              {"Logs Processed", false, "I've processed {i} Logs!"}
-- cfg["SUCCESSFUL_COUNTERS"] = {TYPE.INT, "Number of melee counter counter"}
-- cfg["FIRES_EXTINGUISHED"] = {TYPE.INT, "Number of fires extinguished"}
-- cfg["FIRES_STARTED"] = {TYPE.INT, "Number of fires started"}
-- cfg["TIMES_CHEATED"] = {TYPE.INT, "Number of times cheated"}
-- cfg["MISSION_NAME"] = {TYPE.FLOAT, "Current Mission name"}
-- cfg["MPPLY_LEAST_FAVORITE_STATION"] = {TYPE.INT, "Least favorite radio station"}
-- cfg["MPPLY_MOST_FAVORITE_STATION"] = {TYPE.INT, "Most favorite radio station"}
-- cfg["BUSTED"] = {TYPE.INT, "Number of times the player was arrested"}
-- cfg["MANUAL_SAVED"] = {TYPE.INT, "Number of times saved the game manuall"}
-- cfg["AUTO_SAVED"] = {TYPE.INT, "Number of times saved the game automaticall"}
-- cfg["PLAYER_KILLS_ON_SPREE"] = {TYPE.INT, "Number Players killed done on spree"}
-- cfg["COPS_KILLS_ON_SPREE"] = {TYPE.INT, "Number Cops killed done on spree"}
-- cfg["PEDS_KILLS_ON_SPREE"] = {TYPE.INT, "Number Peds killed done on spree"}
-- cfg["LONGEST_KILLING_SPREE"] = {TYPE.INT, "Longest killing count in spree"}
-- cfg["LONGEST_KILLING_SPREE_TIME"] = {TYPE.INT, "Longest killing time count in spree"}
-- cfg["KILLS_STEALTH"] = {TYPE.INT, "Number of stealth kills"}
-- cfg["KILLS_COP"] = {TYPE.INT, "Number of Cops killed"}
-- cfg["KILLS_SWAT"] = {TYPE.INT, "Number of Swat killed"}
-- cfg["KILLS_BY_OTHERS"] = {TYPE.INT, "Peds killed by other players"}

-- cfg["DIST_CAR"] = {TYPE.FLOAT, "Total Distance in a car"}
-- cfg["TIME_DRIVING_CAR"] = {TYPE.INT, "Total time driving a car"}

-- cfg["DIST_PLANE"] = {TYPE.FLOAT, "Total Distance driving a plane"}
-- cfg["TIME_DRIVING_PLANE"] = {TYPE.INT, "Total time driving a plane"}

-- cfg["DIST_QUADBIKE"] = {TYPE.FLOAT, "Total Distance driving a quadbike"}
-- cfg["DIST_DRIVING_QUADBIKE"] = {TYPE.FLOAT, "Total time driving a quadbike"}
-- cfg["TIME_DRIVING_QUADBIKE"] = {TYPE.INT, "Total time driving a quadbike"}

-- cfg["DIST_HELI"] = {TYPE.FLOAT, "Total Distance driving a heli"}
-- cfg["TIME_DRIVING_HELI"] = {TYPE.INT, "Total time driving a heli"}

-- cfg["DIST_BIKE"] = {TYPE.FLOAT, "Total Distance driving a bike"}
-- cfg["TIME_DRIVING_BIKE"] = {TYPE.INT, "Total time driving a bike"}

-- cfg["DIST_BICYCLE"] = {TYPE.FLOAT, "Total Distance driving a bicycle"}
-- cfg["DIST_DRIVING_BICYCLE"] = {TYPE.FLOAT, "Total time driving a bicycle"}
-- cfg["TIME_DRIVING_BICYCLE"] = {TYPE.INT, "Total time driving a bicycle"}

-- cfg["DIST_BOAT"] = {TYPE.FLOAT, "Total Distance driving a boat"}
-- cfg["TIME_DRIVING_BOAT"] = {TYPE.INT, "Total time driving a boat"}

-- cfg["DIST_SUBMARINE"] = {TYPE.FLOAT, "Total Distance driving a submarine"}
-- cfg["DIST_DRIVING_SUBMARINE"] = {TYPE.FLOAT, "Total time driving a submarine"}
-- cfg["TIME_DRIVING_SUBMARINE"] = {TYPE.INT, "Total time driving a submarine"}

-- cfg["TIME_SWIMMING"] = {TYPE.INT, "Total time driving a swimming"}

-- cfg["TIME_WALKING"] = {TYPE.INT, "Total time spent walking"}

-- cfg["DIST_WALK_ST"] = {TYPE.FLOAT, "Total Distance walking in Stealth mode"}
-- cfg["TIME_IN_COVER"] = {TYPE.INT, "Total time spent in cover"}

-- cfg["ENTERED_COVER"] = {TYPE.INT, "Number of times the player has entered cover"}
-- cfg["ENTERED_COVER_AND_SHOT"] = {TYPE.INT, "Number of times the player has entered cover and fired a shot or shots"}
-- cfg["LONGEST_CHASE_TIME"] = {TYPE.FLOAT, "Duration of the longest cop chase"}
-- cfg["TOTAL_CHASE_TIME"] = {TYPE.INT, "Total time spent losing cops"}
-- cfg["LAST_CHASE_TIME"] = {TYPE.FLOAT, "Duration of the last cop chase"}
-- cfg["TOTAL_TIME_MAX_STARS"] = {TYPE.FLOAT, "Total time under maximun wanted stars"}
-- cfg["STARS_ATTAINED"] = {TYPE.INT, "Total Number of wanted stars the player has been awarded"}
-- cfg["STARS_EVADED"] = {TYPE.INT, "Total Number of wanted stars the player has evaded"}
-- cfg["NO_TIMES_WANTED_LEVEL"] = {TYPE.INT, "The number of times character obtains a wanted level"}

-- cfg["COPCARS_ENTERED_AS_CROOK"] = {TYPE.INT, "Number of times entered a cop car as a crook."}
-- cfg["THROWNTHROUGH_WINDSCREEN"] = {TYPE.INT, "Number of times thrown through a windscreen"}
-- cfg["TOTAL_DAMAGE_BIKES"] = {TYPE.FLOAT, "Total damage done in Bikes"}
-- cfg["TOTAL_DAMAGE_QUADBIKES"] = {TYPE.FLOAT, "Total damage done in Quadbikes"}
-- cfg["NUMBER_CRASHES_BIKES"] = {TYPE.INT, "Number of crashes done in Bikes"}
-- cfg["NUMBER_CRASHES_QUADBIKES"] = {TYPE.INT, "Number of crashes done in Quadbikes"}
-- cfg["NUMBER_STOLEN_COP_VEHICLE"] = {TYPE.INT, "Number of police cars stolen"}
-- cfg["NUMBER_STOLEN_CARS"] = {TYPE.INT, "Number of cars stolen"}
-- cfg["NUMBER_STOLEN_BIKES"] = {TYPE.INT, "Number of bikes stolen"}
-- cfg["NUMBER_STOLEN_BOATS"] = {TYPE.INT, "Number of boats stolen"}
-- cfg["NUMBER_STOLEN_HELIS"] = {TYPE.INT, "Number of helis stolen"}
-- cfg["NUMBER_STOLEN_PLANES"] = {TYPE.INT, "Number of planes stolen"}
-- cfg["NUMBER_STOLEN_QUADBIKES"] = {TYPE.INT, "Number of quad bikes stolen"}
-- cfg["NUMBER_STOLEN_BICYCLES"] = {TYPE.INT, "Number of bicycles stolen"}
-- cfg["TIRES_POPPED_BY_GUNSHOT"] = {TYPE.INT, "Number of tires popped by gunshot"}
-- cfg["VEHICLES_DESTROYED_ON_SPREE"] = {TYPE.INT, "Number of vehicles destroyed on spree"}
-- cfg["COP_VEHI_DESTROYED_ON_SPREE"] = {TYPE.INT, "Number of COP vehicles destroyed on spree"}
-- cfg["TANKS_DESTROYED_ON_SPREE"] = {TYPE.INT, "Number of TANK vehicles destroyed on spree"}
-- cfg["CARS_COPS_EXPLODED"] = {TYPE.INT, "Number of cop cars exploded"}
-- cfg["BIKES_EXPLODED"] = {TYPE.INT, "Number of bikes exploded"}
-- cfg["QUADBIKE_EXPLODED"] = {TYPE.INT, "Number of quadbike exploded"}
-- cfg["BICYCLE_EXPLODED"] = {TYPE.INT, "Number of bicycle exploded"}
-- cfg["SUBMARINE_EXPLODED"] = {TYPE.INT, "Number of submarine exploded"}
-- cfg["TRAIN_EXPLODED"] = {TYPE.INT, "Number of train exploded"}
-- cfg["LONGEST_2WHEEL_DIST"] = {TYPE.FLOAT, "Longest 2 wheel distance in a vehicle"}
-- cfg["LONGEST_2WHEEL_TIME"] = {TYPE.INT, "Longest 2 wheel time in a vehicle"}
-- cfg["LONGEST_STOPPIE_DIST"] = {TYPE.FLOAT, "Longest stoppie distance in a bike"}
-- cfg["LONGEST_STOPPIE_TIME"] = {TYPE.INT, "Longest stoppie time in a bike"}
-- cfg["LONGEST_WHEELIE_DIST"] = {TYPE.FLOAT, "Longest wheelie time in a bike"}
-- cfg["LONGEST_WHEELIE_TIME"] = {TYPE.INT, "Longest wheelie time in a bike"}
-- cfg["MOST_FLIPS_IN_ONE_JUMP"] = {TYPE.INT, "Number of flips in one vehicle jump"}
-- cfg["MOST_SPINS_IN_ONE_JUMP"] = {TYPE.INT, "Number of spins in one vehicle jump"}

local real_config = { native = {}, custom = custom }
for STAT, STATDATA in next, cfg do
    real_config.native["MP0_" .. STAT] = STATDATA
end

return real_config
