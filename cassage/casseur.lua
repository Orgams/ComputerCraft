while true do
    while turtle.getItemCount(16) == 0 do
      turtle.dig()
    end
    sleep(60)
end