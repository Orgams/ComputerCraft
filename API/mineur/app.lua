os.loadAPI("API/api")
api.initisalisation("log","move","bloc","inventaire")

log.setNiveauLogFichier(log._niveau["debug"])
log.setNomFichierLog("mineur.log")
log.supFichier()

inventaire.blocAGarder = {constante.bloc["coal"]}

local _blocNonMine = {
  constante.bloc["stone"],
  constante.bloc["dirt"],
  constante.bloc["gravel"]
}

local drapeauBedrock = false

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
  log.entreMethode("mineur.main()")
  print("tortue en attente")
  read()

  move.rechargerCharbon()
  local puit = NextPuit()
  while puit do
    log.info("puit : ",puit[1]," - ",puit[2])
    drapeauBedrock = false --avant tout, on reset ce flag
    move.remplirFuel() -- on refait le plein si besoin
    move.aller(puit) -- puis on se déplace sur le puit a forer

    while move.decendre() do
      -- ici, direction = 0
      for i=1,4 do
        --compare et mine
        compare_mine()
        --tourne a droite
        move.tourneDroite()
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