os.loadAPI("API/api")
api.initisalisation("log")

local positionNextPuit = {["x"]=0,["z"]=0}

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
  log.sortieMethode({x,z})
  return {x,z}
end