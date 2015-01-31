os.loadAPI("API/api")
api.initisalisation("log")

function presance(tabId)
    log.entreMethode("presance(",tabId,")")
    local success, data = turtle.inspect()
    local res = false
    if success then
        for k,name in pairs(tabId) do
            if data.name == name then
                res = true
            end
        end
    end
    log.sortieMethode(res)
    return res
end