os.loadAPI("API/api")
api.initisalisation("log","move")
local longueur = 3
local largeur = 3

function main()
    print("coucou tous")
    for i=1,longueur do
        for j=1,largeur do
            move.aller({i,j})
            turtle.placeDown()
        end
    end
end