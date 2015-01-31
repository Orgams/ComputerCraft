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

local function ouvrirEnEcriture(chemin)
  return ouvrirEn(chemin, "w")
end

local function ouvrirEnAjout(chemin)
  return ouvrirEn(chemin, "a")
end

function ecrire(chemin, texte)
  fichier = ouvrirEnEcriture(chemin)
  if not fichier then
    return false
  end
  fichier.writeLine(texte)
  fichier.flush()
end

function ajouter(chemin, texte)
  fichier = ouvrirEnAjout(chemin)
  if not fichier then
    return false
  end
  fichier.writeLine(texte)
  fichier.flush()
end

function supFichier(chemin)
  if fs.exists(chemin) then
    fs.delete(chemin)
  end
end