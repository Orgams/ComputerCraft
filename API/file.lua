os.loadAPI("API/api")
api.initisalisation("chaine")

local function ouvrirEn(chemin, mode)

  --si le fichier est un repertoire
  if fs.isDir(chemin) then 
    return false
  else    
    --si le fichier n'est quand lecture et qu'il n'est pas utilisé en lecture
    if mode ~= "r" and fs.isReadOnly(chemin) then
      return false
    end
  end

  --Creer le fichier s'il n'existe pas encore
  if mode == "a" or mode == "r" then
    if not fs.exists(chemin) then
      local fichierTmp = fs.open(chemin, "w")
      fichierTmp.close()
    end
  end

  --ouvrir le fichier
  return fs.open(chemin, mode)
end

local function ouvrirEnLecture(chemin)
  return ouvrirEn(chemin, "r")
end

local function ouvrirEnEcriture(chemin)
  return ouvrirEn(chemin, "w")
end

local function ouvrirEnAjout(chemin)
  return ouvrirEn(chemin, "a")
end

function lire(chemin)
  if chemin == nil then
    chemin = ""
  end
  fichier = ouvrirEnLecture(chemin)
  if not fichier then
    return false
  end
  local res
  local lu = fichier.readAll(chemin)
  local nombre = tonumber(lu)
  if nombre ~= nil then
    res = nombre
  else
    res = lu
  end
  fichier.close()
  return res
end

function ecrire(chemin, texte)
  creerDossier(getParent(chemin))
  fichier = ouvrirEnEcriture(chemin)
  if not fichier then
    return false
  end
  fichier.writeLine(tostring(texte))
  fichier.flush()
  fichier.close()
end

function ajouter(chemin, texte)
  creerDossier(getParent(chemin))
  fichier = ouvrirEnAjout(chemin)
  if not fichier then
    return false
  end
  fichier.writeLine(tostring(texte))
  fichier.flush()
  fichier.close()
end

function creerDossier(chemin)
  if fs.exists(chemin) then
    return
  end
  local parent = getParent(chemin)
  creerDossier(parent)
  fs.makeDir(chemin)
end

function listeFichier(chemin)
  local res = {}
  if fs.exists(chemin) then
    for _,elem in ipairs(fs.list(chemin)) do
       if not fs.isDir(chemin.."/"..elem) then
        table.insert(res, elem)
       end
     end 
  end
  return res
end

function supFichier(chemin)
  if fs.exists(chemin) then
    fs.delete(chemin)
  end
end

function getParent(chemin)
  local splits = chaine.split(chemin,"/")
  table.remove (splits)
  return chaine.join(splits,"/")
end