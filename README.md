# ComputerCraft

Ce projet est fait pour controler des turtles dans le mod pour minecraft nommée ComputeurCraft.

la philosophie est de mettre tous le code dans des librairie pour n'avoir qu'a lancer un main dans le fichier "startup" (qui ce lance automatiquement au démarrage de la tortue)

## Lib

### api
Load des autre libreries.
Les fichiers .lua sont renommé puis charger car le chargement échoue avec l'extantion

utilise 
  * File


### bdd
Sauvgarde rapide d'information dans le file systeme

utilise 
  * log
  * File

### bloc
Interaction avec les autres blocs

utilise 
  * log

### chaine
Manipulation de chaine de caractére

utilise 
  * log
  * tableau

### coffre
Interaction avec les inventaires

### comm
Comunication entre les ordinateurs

utilise 
  * log
  * constante

### constante
Constante partager entre les librairies

### ecran
Affichage sur les moniteurs

### file
Interaction avec le file système

utilise 
  * chaine

### init
Initialisation automatique de peripheriques

utilise 
  * log
  * ecran
  * comm

### inventaire
Gestion de l'inventaire de la tortue

utilise 
  * tableau
  * coffre
  * move

### log
Systeme de logging

utilise 
  * file
  * tableau
  * move

### move
déplacement de la turtle (avec un referanciel relatif)

utilise 
  * log
  * inventaire
  * constante
  * bloc
  * bdd

### tableau
Manipulation de tableau

## Application

### bucheron

### central

### mineur
