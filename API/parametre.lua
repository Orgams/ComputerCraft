os.loadAPI("API/api")
api.initisalisation("log","tableau")

function prepareParamPosition (tab) 
    tab = tableau.nommerEntre(tab, "x", "z", "y")
    tab = tableau.mettreA(tab, 0, "x", "z", "y")
end