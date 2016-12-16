os.loadAPI("API/api")
api.initisalisation("log","move","bloc","inventaire", "comm","bdd")

log.setNomFichierLog("transport.csv")
log.supFichier()

move.setBlocPasCasse({constante.bloc["any"]})
move.init()

inventaire.setBlocAGarder({constante.bloc["coal"]})

local autostart = false

local _arrets = {
  {
    ["direction"] = move._direction["droite"],
    ["y"] = 0,
    ["x"] = 9,
    ["z"] = 15
  }
}

function faireUnArret( tab )
  move.rechargerCharbon()
  move.remplirFuel()
  move.aller(tab)
  inventaire.getMaxItem()
end

function faireLaTourne()
  for k, v in pairs(_arrets) do
    faireUnArret(v)
  end
  move.aller(move.getPositionDepart())
  inventaire.viderInventaire()
end

function main()
  log.entreMethode("main()")
  move.aller(move.getPositionDepart())
  inventaire.viderInventaire()
  print("transporteur en attente")
  if not autostart then
    read()
  end
  --while true do
    faireLaTourne()
  --end

  log.sortieMethode()
end

function test()
  -- for arret in _arrets do
  --   print(arret)
  -- end
  for k, v in pairs(_arrets) do
    print(v)
  end
end