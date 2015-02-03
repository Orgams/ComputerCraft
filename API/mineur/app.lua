os.loadAPI("API/api")
api.initisalisation("log","move","bloc","inventaire", "comm","bdd","mineur/mineur")

log.setNomFichierLog("mineur.csv")
log.supFichier()

move.setBlocPasCasse({constante.bloc["chest"]})
move.init()

inventaire.setBlocAGarder({constante.bloc["coal"]})

comm.connecter()

local _blocNonMine = {
  constante.bloc["grass"],
  constante.bloc["stone"],
  constante.bloc["dirt"],
  constante.bloc["gravel"]
}

local puit

local departAuto = true

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

function main()
  log.entreMethode("main()")
  move.retoure(move.getPositionDepart())
  print("Mineur en attente")
  bdd.sauver({["action"]="preparation"}, os.getComputerID())
  if not departAuto then
    read()
  end

  move.rechargerCharbon()
  puit = recupNextPuit()
  while puit do
    creuserPuit()
  end
  log.sortieMethode()
end