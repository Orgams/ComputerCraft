os.loadAPI("API/api")
api.initisalisation("log","inventaire", "constante","bloc","bdd")

_direction ={
  [0]="devant",["devant"]=0,
  [1]="droite",["droite"]=1,
  [2]="derriere",["derriere"]=2,
  [3]="gauche",["gauche"]=3
}

local _blocUtilise = {
    ["Fuel"] = constante.bloc["coal"]
}
local _blocPasCasse = {}

local positionDepart = {
  ["direction"] = 0,
  ["y"] = 0,
  ["x"] = 0,
  ["z"] = 0
}

local position = positionDepart

local positionTmp

local niveauFuelMini = 75
local niveauCharbonMini = 10

function getPositionDepart()
  log.entreMethode("getPositionDepart()")
  log.sortieMethode(positionDepart)
  return tableau.clone(positionDepart)
end 
function getPosition()
  log.entreMethode("getPosition()")
  log.sortieMethode(position)
  return tableau.clone(position)
end 
function setBlocPasCasse(tab)
  log.entreMethode("setBlocPasCasse(",tab,")")
  _blocPasCasse = tableau.clone(tab)
  log.sortieMethode()
end

function setPositionTmp(tab)
  log.entreMethode("setPositionTmp(",tab,")")
  positionTmp = tableau.clone(tab)
  log.sortieMethode()
end

function getPositionTmp()
  log.entreMethode("getPositionTmp()")
  log.sortieMethode(positionTmp)
  return tableau.clone(positionTmp)
end 

function allerSurface()
  log.entreMethode("allerSurface()")
  deplacementY(0)
  log.sortieMethode()
end
function allerDepart()
  log.entreMethode("allerDepart()")
  deplacementY(0)
  deplacementZ(0)
  deplacementX(0)
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

  if tab["x"] ~= nil then
    deplacementX(tab["x"])
  end
  if tab["z"] ~= nil then
    deplacementZ(tab["z"])
  end
  if tab["y"] ~= nil then
    deplacementY(tab["y"])
  end
  if tab["direction"] ~= nil then
    direction(tab["direction"])
  end

  isOK = true;
  if tab["x"] ~= nil and tab["x"] ~= position["x"] then
    isOK = false
  end
  if tab["z"] ~= nil and tab["z"] ~= position["z"] then
    isOK = false
  end
  if tab["y"] ~= nil and tab["y"] ~= position["y"] then
    isOK = false
  end
  if tab["direction"] ~= nil and tab["direction"] ~= position["direction"] then
    isOK = false
  end

  if not isOK then
    log.warn("aller is not ok")
    aller(tab)
  end

  log.sortieMethode()
end
function retoure(tab)
  log.entreMethode("retoure(",tab,")")
  if tab["y"] ~= nil then
    deplacementY(tab["y"])
  end
  if tab["x"] ~= nil then
    deplacementX(tab["x"])
  end
  if tab["z"] ~= nil then
    deplacementZ(tab["z"])
  end
  if tab["direction"] ~= nil then
    direction(tab["direction"])
  end
  log.sortieMethode()
end

function deplacementY(y)
  log.entreMethode("deplacementY(",y,")")
  while position["y"] < y do
    monter()
  end
  while position["y"] > y do
    decendre()
  end
  log.sortieMethode()
end

function deplacementX(x)
  log.entreMethode("deplacementX(",x,")")
  while position["x"] < x do
    avancerDevant()
  end
  while position["x"] > x do
    avancerDerriere()
  end
  log.sortieMethode()
end

function deplacementZ(z)
  log.entreMethode("deplacementZ(",z,")")
  while position["z"] < z do
    avancerDroite()
  end
  while position["z"] > z do
    avancerGauche()
  end
  log.sortieMethode()
end

function direction(direction)
  log.entreMethode("direction(",direction,")")
  if position["direction"] == (direction+1)%4 then
    tourneGauche()
  end
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

function directionDerriere()
  log.entreMethode("directionDerriere()")
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
  modifierPosition("direction", (position["direction"]+1)%4)
  log.sortieMethode()
end
function tourneGauche()
  log.entreMethode("tourneGauche()")
  turtle.turnLeft()
  modifierPosition("direction", (position["direction"]-1)%4)
  log.sortieMethode()
end

function avancer()
  log.entreMethode("avancer()")
  if bloc.presance(_blocPasCasse) then
    eviterBlocDevant()
  else
    if turtle.detect() then
      turtle.dig()
    end

    while not turtle.forward() do
      sleep(0.1)
    end

    if position["direction"] == 0 then 
      modifierPosition("x", position["x"]+1)
    end
    if position["direction"] == 1 then 
      modifierPosition("z", position["z"]+1)
    end
    if(position["direction"] == 2) then
      modifierPosition("x", position["x"]-1)
    end
    if position["direction"] == 3 then 
      modifierPosition("z", position["z"]-1)
    end
    remplirFuel()
  end
  log.sortieMethode()
end

function avancerDevant()
  directionDevant()
  avancer()
end

function avancerDerriere()
  directionDerriere()
  avancer()
end

function avancerDroite()
  directionDroite()
  avancer()
end

function avancerGauche()
  directionGauche()
  avancer()
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
    modifierPosition("y", position["y"]-1)
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
  modifierPosition("y", position["y"]+1)
  remplirFuel()
  log.sortieMethode()
end

function modifierPosition(nomAttribut, valeurAttribut)
  position[nomAttribut] = valeurAttribut
  bdd.sauver({[nomAttribut] = valeurAttribut}, os.getComputerID().."/position")
end

function eviterBlocDevant()
  log.entreMethode("eviterBlocDevant()")
  monter()
  avancer()
  --avancer()
  --decendre()
  remplirFuel()
  log.sortieMethode()
end

function descrPosition()
  --print(_direction[position["direction"]])
  local desc = position["x"]..";"..position["z"]..";"..position["y"]..";".._direction[position["direction"]]
  return desc
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

    bdd.sauver(positionTmp, os.getComputerID().."/positionTmp")
    bdd.sauver({["action"]="recharger_charbon"}, os.getComputerID())

    retoure(positionDepart)

    inventaire.selectFirstSlot(_blocUtilise["Fuel"])
    directionGauche()
    turtle.suck()

    bdd.sauver({["action"]="retoure_depart"}, os.getComputerID())
    aller(positionTmp)

  end
  log.sortieMethode()
end

function init()
  log.entreMethode("init()")
  position = bdd.charger(os.getComputerID().."/position")
  if next(position) == nil then
    position = {["direction"] = 0,["y"] = 0,["x"] = 0,["z"] = 0}
    bdd.sauver(position, os.getComputerID().."/position")
  end
  log.sortieMethode()
end