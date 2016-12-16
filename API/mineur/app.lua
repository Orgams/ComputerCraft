os.loadAPI("API/api")
api.initisalisation("log","move","bloc","inventaire", "comm","bdd","mineur/mineur")

log.setNomFichierLog("mineur.csv")
log.supFichier()

move.setBlocPasCasse({constante.bloc["chest"], constante.bloc["enderchest"]})
move.init()

inventaire.setBlocAGarder({constante.bloc["coal"]})

comm.connecter()

local _blocNonMine = {
  constante.bloc["grass"],
  constante.bloc["stone"],
  constante.bloc["cobblestone"],
  constante.bloc["dirt"],
  constante.bloc["gravel"],
}

local puit

local autostat = false

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
  puit = res
  bdd.sauver(puit, os.getComputerID().."/puit")
  log.sortieMethode()
end

function creuserPuit()
  log.entreMethode("creuserPuit()")
  eMessage("puit = "..puit["x"].." - "..puit["z"])

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
  move.aller(move.getPositionDepart())
  inventaire.viderInventaire()
  recupNextPuit()
  log.sortieMethode()
end

function init()
  local tab = bdd.charger(os.getComputerID().."/puit")
  if next(tab) ~= nil then
    mineur.setPositionNextPuit(tab)
  end
end

function main()
  log.entreMethode("main()")
  log.display(puit)
  init()
  log.display(puit)
  move.retoure(move.getPositionDepart())
  print("Mineur en attente")
  bdd.sauver({["action"]="preparation"}, os.getComputerID())
  if not autostat then
    read()
  end
  log.display(puit)
  move.rechargerCharbon()
  recupNextPuit()
  log.display(puit)
  while puit do
    creuserPuit()
  end
  log.sortieMethode()
end