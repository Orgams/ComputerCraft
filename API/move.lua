os.loadAPI("API/api")
api.initisalisation("log","inventaire", "constante")

_direction ={
  [0]="devant",["devant"]=0,
  [1]="droite",["droite"]=1,
  [2]="derriere",["derriere"]=2,
  [3]="gauche",["gauche"]=3
}

local _blocUtilise = {
    ["Fuel"] = constante.bloc["coal"]
}
local position = {
  ["direction"] = 0,
  ["y"] = 0,
  ["x"] = 0,
  ["z"] = 0
}
local positionDepart = position

local niveauFuelMini = 5
local niveauCharbonMini = 5

function getPositionDepart()
   return table.clone(positionDepart)
end 
function getPosition()
   return table.clone(position)
end 

function allerSurface()
  log.entreMethode("allerSurface()")
  deplacementY(0)
  log.sortieMethode()
end

function aller(tab)
  log.entreMethode("aller(",tab,")")
  if tab[1] ~= nil then
    tab["x"] = tab[1]
  end
  if tab[2] ~= nil then
    tab["z"] = tab[2]
  end
  if tab[3] ~= nil then
    tab["y"] = tab[3]
  end
  if tab[4] ~= nil then
    tab["direction"] = tab[4]
  end
  if tab["x"] ~= nil and tab["z"] ~= nil then
    deplacementXZ(tab["x"], tab["z"])
  end
  if tab["y"] ~= nil then
    deplacementY(tab["y"])
  end
  if tab["direction"] ~= nil then
    direction(tab["direction"])
  end
  log.sortieMethode()
end

function retoure(tab)
  log.entreMethode("retoure(",tab,")")
  if tab["y"] ~= nil then
    deplacementY(tab["y"])
  end
    if tab["x"] ~= nil and tab["z"] ~= nil then
    deplacementXZ(tab["x"], tab["z"])
  end
  if tab["direction"] ~= nil then
    direction(tab["direction"])
  end
  log.sortieMethode()
end

function deplacementY(y)
  log.entreMethode("deplacementY()")
  while position["y"] > y do
    monter()
  end
  while position["y"] < y do
    decendre()
  end
  log.sortieMethode()
end


-- pour aller a des coordonnées précises
function deplacementXZ(x,z)
  log.entreMethode("deplacementXZ("..x..","..z..")")

  --nombre de déplacement en X et Z
  local nbX = math.abs(x - position["x"])
  local nbZ = math.abs(z - position["z"])

  -- On commence par se déplacer en x
  if nbX ~= 0 then
    if x > position["x"] then
      directionDevant()
    elseif x < position["x"] then
      directionDeriere()
    end
    while nbX > 0 do
      avancer()
      nbX = nbX - 1
    end
  end

  -- Ensuite on fait le déplacement en z
  if nbZ ~= 0 then
    if z > position["z"] then
      directionDroite()
    elseif z < position["z"] then
      directionGauche()
    end
    while nbZ > 0 do
      avancer()
      nbZ = nbZ - 1
    end
  end

  log.sortieMethode()
end

function direction(direction)
  log.entreMethode("direction(",direction,")")
  while position["direction"] ~= direction do
    tourneDroite()
  end
  log.sortieMethode()
end

function directionDevant()
  log.entreMethode("directionDevant()")
  direction(_direction["devant"])
  log.sortieMethode()
end

function directionDroite()
  log.entreMethode("directionDroite()")
  direction(_direction["droite"])
  log.sortieMethode()
end

function directionDeriere()
  log.entreMethode("directionDeriere()")
  direction(_direction["derriere"])
  log.sortieMethode()
end

function directionGauche()
  log.entreMethode("directionGauche()")
  direction(_direction["gauche"])
  log.sortieMethode()
end

function tourneDroite()
  log.entreMethode("tourneDroite()")
  turtle.turnRight()
  position["direction"]=position["direction"]+1
  if position["direction"] == 4 then
    position["direction"]=0
  end
  log.sortieMethode()
end

function avancer()
  log.entreMethode("avancer()")

  if turtle.detect() then
    turtle.dig()
  end

  while not turtle.forward() do
    sleep(0.1)
  end

  if position["direction"] == 0 then 
    position["x"] = position["x"] + 1 
  end
  if position["direction"] == 1 then 
    position["z"] = position["z"] + 1 
  end
  if(position["direction"] == 2) then
    position["x"] = position["x"] - 1 
  end
  if position["direction"] == 3 then 
    position["z"] = position["z"] - 1 
  end
  remplirFuel()
  log.sortieMethode()
end

function decendre()
  log.entreMethode("decendre()")

  if turtle.detectDown() then
    turtle.digDown()
  end
  
  local res = true
  local tentative = 0;
  while res and not turtle.down() do
    tentative = tentative + 1
    if tentative >=10 then
      log.warn("plus de carburant?")
      res = false
    end
    sleep(0.3)
  end

  if(res)then
    position["y"] = position["y"]+1
    remplirFuel()
  end
  log.sortieMethode(res)
  return res
end

function monter()
  log.entreMethode("monter()")
  -- on vérifie si il y a un bloc en dessus
  if turtle.detectUp() then
    turtle.digUp()
  end

  while not turtle.up() do
    sleep(0.1)
  end
  position["y"] = position["y"]-1
  remplirFuel()
  log.sortieMethode()
end

function descrPosition()
  return position["x"]..";"..position["z"]..";"..position["y"]..";".._direction[position["direction"]]
end

-- vérifie si on a assez de fuel (déplacements) en réserve.
function remplirFuel()
  log.entreMethode("remplirFuel()")
  -- 1 charbon = 96 move.deplacements
  -- On vérifie le niveau de fuel
  local niveauFuel = turtle.getFuelLevel()

  if (niveauFuel ~= "unlimited") then
    if (niveauFuel < niveauFuelMini) then
      -- On a besoin de faire le plein
      inventaire.selectFirstSlot(_blocUtilise["Fuel"])
      turtle.refuel(1) -- on recharge pour 96 move.deplacements
      -- et on vérifie si il nous reste assez de charbon
      rechargerCharbon()
    end
  end
  log.sortieMethode()
end

function rechargerCharbon()
  log.entreMethode("rechargerCharbon()")
  if turtle.getItemCount(charbonSlot) < niveauCharbonMini then
    positionTmp = position


    retoure(positionDepart)

    inventaire.selectFirstSlot(_blocUtilise["Fuel"])
    turtle.suckUp()

    aller(positionTmp)

  end
  log.sortieMethode()
end
