os.loadAPI("API/api")
api.initisalisation("log","move","bloc","inventaire", "comm")

log.setNomFichierLog("mineur.csv")
log.supFichier()

inventaire.blocAGarder = {constante.bloc["coal"]}

comm.connecter("right")

local _blocNonMine = {
  constante.bloc["grass"],
  constante.bloc["stone"],
  constante.bloc["dirt"],
  constante.bloc["gravel"]
}

local positionNextPuit = {["x"]=0,["z"]=0}

-- fonction qui compare et mine
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

function NextPuit()
  log.entreMethode()
  log.debug("NextPuit()")
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

function main()
  log.entreMethode("main()")
  print("tortue en attente")
  read()

  move.rechargerCharbon()
  local puit = NextPuit()
  while puit do
    local mess = "puit : "..puit[1].." - "..puit[2]
    log.info(mess)
    comm.envoie(mess)
    move.remplirFuel() -- on refait le plein si besoin
    move.aller(puit) -- puis on se déplace sur le puit a forer

    while move.decendre() do

      compare_mine()
      for i=1,3 do
        --tourne a droite
        move.tourneDroite()
        --compare et mine
        compare_mine()
        
      end
    end

    -- ici je remonte a la surface
    move.allerSurface()

    puit = NextPuit()
  end

  move.aller(move.getPositionDepart()) -- retour au point de départ

  inventaire.viderInventaire()
  log.sortieMethode()
end