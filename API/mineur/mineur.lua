os.loadAPI("API/api")
api.initisalisation("log")

local positionNextPuit = {["x"]=0,["z"]=0}

function setPositionNextPuit(tab)
  log.entreMethode("setPositionNextPuit(",tab,")")
  positionNextPuit = tableau.clone(tab)
  log.sortieMethode()
end

function nextPuit()
  log.entreMethode("nextPuit()")
  local x = positionNextPuit["x"]
  local z = positionNextPuit["z"]
  if x <= 0 and z >= 0 then
      positionNextPuit["x"] = x+1
      positionNextPuit["z"] = z+2
  end
  if x > 0 and z >= 0 then
      positionNextPuit["x"] = x+1
      positionNextPuit["z"] = z-3
  end
  if x > 0 and z < 0 then
      positionNextPuit["x"] = x-1
      positionNextPuit["z"] = z-2
  end
  if x <= 0 and z < 0 then
      positionNextPuit["x"] = x-1
      positionNextPuit["z"] = z+3
  end
  local puitTmp = {["x"]=x,["z"]=z}
  log.sortieMethode(puitTmp)
  return puitTmp
end