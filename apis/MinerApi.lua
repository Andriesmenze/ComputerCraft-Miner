settings.load("Miner.settings")
fuelThreshold = settings.get("fuelThreshold")
mineSide = settings.get("mineSide")
fuelSlot = settings.get("fuelSlot")
chestSlot = settings.get("chestSlot")
endpointBlock = settings.get("endpointBlock")
dumpList = settings.get("dumpList")
alternateNameList = settings.get("alternateNameList")
fuelList = settings.get("fuelList")
active = settings.get("active")
function turn(option)
    if (option == 1 and mineSide == "Left") then
        turtle.turnLeft()
    elseif (option == 1 and mineSide == "Right") then
        turtle.turnRight()
    elseif (option == 2 and mineSide == "Left") then
        turtle.turnRight()
    elseif (option == 2 and mineSide == "Right") then
        turtle.turnLeft()
    else
        print("Invalid turn option or MineSide")
    end
end
function changeSwapBit(swapBit)
    if (swapBit == true) then
        return false
    elseif (swapBit == false) then
        return true
    end
end
function swapTurn(swapBit)
    if (swapBit == true) then
        turtle.turnLeft()
        MinerApi.redundantForward()
        turtle.turnLeft()
    elseif (swapBit == false) then
        turtle.turnRight()
        MinerApi.redundantForward()
        turtle.turnRight()
    end
end
function checkANL(name)
    if (alternateNameList[name] ~= nil) then
        name = alternateNameList[name]
    end
    return name
end
function fuelCheck()
    if (turtle.getFuelLevel() < fuelThreshold) then
        selected = turtle.getSelectedSlot()
        turtle.select(fuelSlot)
        fuelSlotContent = turtle.getItemDetail()
        fuelSlotContentName = fuelSlotContent["name"]
        if (turtle.getItemDetail() == nil or fuelList[fuelSlotContentName] ~= true) then
            print("There is no fuel in slot "..fuelSlot)
            term.write("Press Enter when there is fuel in slot "..fuelSlot)
            read("")
        end
        turtle.refuel()
        turtle.select(selected)
    end
end
function dumpGarbage()
    dumpStatus = false
    for step=1,14 do
        slot = step + 2
        turtle.select(slot)
        slotItem = turtle.getItemDetail()
        if (dumpList[slotItem["name"]] ~= nil) then
            turtle.drop()
            dumpStatus = true
        end
    end
    return dumpStatus
end
function checkSpace()
    selected = turtle.getSelectedSlot()
    a, b = turtle.inspect()
    if (b["name"] == endpointBlock) then
        print("Endpoint has been reached")
        print("Stopping Miner Program")
        print("Press Enter to Continue")
        print("Hold CTRL + T to stop")
        active = false
        settings.set("active", active)
        settings.save("Miner.settings")
        read("")
    else
        if (a ~= false) then
            c = checkANL(b["name"])
            for step=1,14 do
                slot = step + 2
                turtle.select(slot)
                slotItem = turtle.getItemDetail()
                space = false
                if (slotItem ~= nil) then
                    if (c == slotItem["name"]) then
                        if (slotItem["count"] ~= 64) then
                            selected = slot
                            space = true
                            break
                        end
                    end
                else
                    selected = slot
                    space = true
                    break
                end
            end
            if (space ~= true) then
                if (dumpGarbage() == false) then
                    turtle.select(chestSlot)
                    if (turtle.getItemDetail()["name"] ~= "minecraft:chest") then
                        print("No more space for the item infront")
                        print("Press Enter when there is space")
                        print("or a chest in slot "..chestSlot)
                        read("")
                    else
                        turtle.turnLeft()
                        turtle.turnLeft()
                        turtle.place()
                        for step=1,14 do
                            slot = step + 2
                            turtle.select(slot)
                            turtle.drop()
                        end    
                        turtle.turnLeft()
                        turtle.turnLeft()
                    end
                    selected = 3
                end
            end
            turtle.select(selected)
        end
    end
    return space
end
function redundantForward()
    notMovedYet = true
    while notMovedYet do
        if (turtle.inspect()) then
            checkSpace()
            turtle.dig()
        end
        if (turtle.forward()) then
            notMovedYet = false
        end
    end
end