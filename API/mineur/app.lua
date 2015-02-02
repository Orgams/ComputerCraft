os.loadAPI("API/api")
api.initisalisation("log","move","bloc","inventaire", "comm","mineur/mineur")

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

function main()
  log.entreMethode("main()")
  print("Mineur en attente")
  read()

  move.rechargerCharbon()
  local puit = recupNextPuit()
  while puit do
    eMessage("puit = "..puit[1].." - "..puit[2])
    move.remplirFuel()
    move.aller(puit)

    while move.decendre() do

      compare_mine()
      for i=1,3 do
        move.tourneDroite()
        compare_mine()
        
      end
    end

    move.allerSurface()
    inventaire.viderInventaire()
    puit = recupNextPuit()
  end
  log.sortieMethode()
end