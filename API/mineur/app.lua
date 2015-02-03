os.loadAPI("API/api")
api.initisalisation("log","move","bloc","inventaire", "comm","bdd","mineur/mineur")

log.setNomFichierLog("mineur.csv")
log.supFichier()

move.setBlocPasCasse({constante.bloc["chest"]})

inventaire.setBlocAGarder({constante.bloc["coal"]})

comm.connecter()

local _blocNonMine = {
  constante.bloc["grass"],
  constante.bloc["stone"],
  constante.bloc["dirt"],
  constante.bloc["gravel"]
}

local puit

function compare_mine()
  log.entreMethode("compare_mine()")

  if not bloc.presance(_blocNonMine) then
    turtle.dig()
    if not inventaire.firstVide() then
      inventaire.viderInventaire()
    end
  end

  log.sortieMethode()
end

function eMessage( mess )
  log.debug("eMessage( ",mess," )")
  log.info(mess)
  comm.envoie("message:"..mess.."     ")
  log.sortieMethode()
end

function recupNextPuit()
  log.debug("recupNextPuit()")
  local res
  if comm.isConnecter() then
    comm.envoie("nextPuit")
    local info = comm.ecouter()
    res = info["message"]
  else
    res = mineur.nextPuit()
  end
  log.sortieMethode(res)
  return res
end

function creuserPuit()
  log.entreMethode("creuserPuit()")
  eMessage("puit = "..puit[1].." - "..puit[2])
  bdd.sauver({["puit"]=puit}, os.getComputerID())

  move.remplirFuel()
  move.aller(puit)

  while move.decendre() do
  bdd.sauver({["action"]="minage"}, os.getComputerID())
    compare_mine()
    for i=1,3 do
      move.tourneDroite()
      compare_mine()
    end
  end
  bdd.sauver({["action"]="remonter"}, os.getComputerID())
  move.allerSurface()
  inventaire.viderInventaire()
  puit = recupNextPuit()
  log.sortieMethode()
end

function reprise()
  log.entreMethode("reprise()")
  local res = false
  local action = bdd.charger({"action"}, os.getComputerID())
  position = bdd.charger({"x","z","y","direction"}, os.getComputerID())
  if action == "minage" then
    creuserPuit()
    res = true
  elseif action == "remonter" then
    move.allerSurface()
    res = true
  elseif action == "recharger charbon" then
    move.setPositionTmp(bdd.charger({"x","z","y","direction"}, os.getComputerID().."/tmp"))
    move.rechargerCharbon()
    res = true
  elseif action == "retourer au point de départ" then
    move.setPositionTmp(bdd.charger({"x","z","y","direction"}, os.getComputerID().."/tmp"))
    move.aller(move.getPositionTmp())
    creuserPuit()
    res = true
  end
  log.sortieMethode(res)
  return res
end

function main()
  log.entreMethode("main()")
  print("Mineur en attente")
  bdd.sauver({["action"]="préparation"}, os.getComputerID())
  --if not reprise() then
    read()
  --end

  move.rechargerCharbon()
  puit = recupNextPuit()
  while puit do
    creuserPuit()
  end
  log.sortieMethode()
end