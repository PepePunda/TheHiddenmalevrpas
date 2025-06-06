
local cfg = {}

-- mission display css
cfg.display_css = [[
.div_mission{
  position: absolute;
  top: 125px;
  right: 5px;
  color: white;
  background-color: #161b33;
  border-radius: 8px;
  border-left: 5px solid #23B5D3;
  padding: 8px;
  max-width: 300px;
  font-family: 'Roboto', sans-serif;
}

.div_mission .name{
  color: rgb(255,226,0);
  font-weight: bold;
}

.div_mission .step{
  color: rgb(0,255,0);
  font-weight: bold;
}
]]

return cfg
