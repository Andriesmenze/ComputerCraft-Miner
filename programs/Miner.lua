-- Settings --
-- Mode can be : ZigZag, Regular, 3D
Mode = "3D"
-- Distance before the turtle turns around in zigzag mode
zigzagDistance = 25
-- Turtle will refuel when the fuelLevel gets belowe this value
fuelThreshold = 1
-- side on which the turtle will mine in zigzag mode
mineSide = "Left"
-- 3D mode settings
targetX = 25
targetY = 1
targetZ = 25
-- inventory slot that contains the fuel
fuelSlot = 1
-- inventory slot that contains chests
chestSlot = 2
-- block where the turtle will stop
endpointBlock = "minecraft:oak_fence"
-- list of blocks that can be dump when the inventory is full
dumpList = {
    ["minecraft:cobblestone"] = true,
    ["minecraft:stone"] = true,
    ["minecraft:dirt"] = true,
    ["minecraft:gravel"] = true,
    ["minecraft:diorite"] = true,
    ["minecraft:andesite"] = true,
    ["minecraft:granite"] = true
}
-- list of blocks that result in an item with a diffrent name when mined
alternateNameList = {
    ["minecraft:stone"] = "minecraft:cobblestone",
    ["minecraft:diamond_ore"] = "minecraft:diamond",
    ["minecraft:coal_ore"] = "minecraft:coal",
    ["minecraft:emerald_ore"] = "minecraft:emerald",
    ["minecraft:redstone_ore"] = "minecraft:redstone",
    ["minecraft:lapis_ore"] = "minecraft:lapis_lazuli",
    ["minecraft:grass_block"] = "minecraft:dirt"
}
-- list of possible fuel types
fuelList = {
    ["minecraft:coal"] = true,
    ["minecraft:coal_block"] = true,
    ["minecraft:lava_bucket"] = true,
    ["minecraft:charcoal"] = true
}
-- Settings --
if (settings.load("Miner.settings")) then
    active = settings.get("active")
else
    active = false
end
if (active == false) then
    while true do
        term.clear()
        term.setCursorPos(1, 1)
        print("Miner Setup")
        print("Mode can be : ZigZag, Regular, 3D")
        term.write("Mode : ")
        modeRead = read()
        if (modeRead == "ZigZag" or modeRead == "Regular" or modeRead == "3D") then
            Mode = modeRead
            settings.set("Mode", Mode)
            settings.set("zigzagDistance", zigzagDistance)
            settings.set("fuelThreshold", fuelThreshold)
            settings.set("mineSide", mineSide)
            settings.set("targetX", targetX)
            settings.set("targetY", targetY)
            settings.set("targetZ", targetZ)
            settings.set("fuelSlot", fuelSlot)
            settings.set("chestSlot", chestSlot)
            settings.set("endpointBlock", endpointBlock)
            settings.set("dumpList", dumpList)
            settings.set("alternateNameList", alternateNameList)
            settings.set("fuelList", fuelList)
            settings.save("Miner.settings")
            break
        else
            print("Invalid input")
            os.sleep(2)
        end
    end
else
    settings.load("Miner.settings")
    Mode = settings.get("Mode")
    fuelThreshold = settings.get("fuelThreshold")
    mineSide = settings.get("mineSide")
    fuelSlot = settings.get("fuelSlot")
    chestSlot = settings.get("chestSlot")
    fuel = settings.get("fuel")
    endpointBlock = settings.get("endpointBlock")
    dumpList = settings.get("dumpList")
    alternateNameList = settings.get("alternateNameList")
    active = settings.get("active")
end
os.loadAPI("apis/MinerApi.lua")
if (Mode == "Regular") then
    term.clear()
    term.setCursorPos(1, 1)
    print("Miner")
    print("Mode : Regular")
    print(turtle.getFuelLevel().." Fuel Left")
    if (active ~= true) then
        print("Press Enter to Start")
        read("")
        active = true
        settings.set("active", active)
        settings.save("Miner.settings")
    end
    while true do
        term.clear()
        term.setCursorPos(1, 1)
        print("Miner")
        print("Mode : Regular")
        print(turtle.getFuelLevel().." Fuel Left")
        MinerApi.fuelCheck()
        MinerApi.checkSpace()
        turtle.dig()
        turtle.forward()
    end
elseif (Mode == "ZigZag") then
    term.clear()
    term.setCursorPos(1, 1)
    print("Miner")
    print("Mode : ZigZag")
    print(turtle.getFuelLevel().." Fuel Left")
    if (active ~= true) then
        while true do
            term.clear()
            term.setCursorPos(1, 1)
            print("Miner Setup")
            print("ZigZag Mode Settings")
            term.write("zigzagDistance : ")
            zigzagDistanceRead = tonumber(read())
            if (type(zigzagDistanceRead) == "number") then
                zigzagDistance = zigzagDistanceRead - 1
                settings.set("zigzagDistance", zigzagDistance)
                settings.save("Miner.settings")
                break
            else
                print("Invalid input")
                os.sleep(2)
            end
        end
        while true do
            term.write("MineSide (Can be Left or Right): ")
            mineSideRead = read()
            if (mineSideRead == "Left") then
                swapBit = true
                settings.set("swapBit", swapBit)
                settings.save("Miner.settings")
                break
            elseif (mineSideRead == "Right") then
                swapBit = false
                settings.set("swapBit", swapBit)
                settings.save("Miner.settings")
                break
            else
                print("Invalid input")
                os.sleep(2)
            end
        end
        print("Press Enter to Start")
        read("")
        active = true
        settings.set("active", active)
        continue = false
        settings.save("Miner.settings")
    else
        print("press enter to continue previous job")
        read("")
        zigzagDistance = settings.get("zigzagDistance")
        continue = true
    end
    if (continue ~= true) then
        Distance = 0
        notMovedYet = false
        settings.set("Distance", Distance)
        settings.save("Miner.settings")
    else
        Distance = settings.get("Distance")
        zigzagDistance = settings.get("zigzagDistance")
        swapBit = settings.get("swapBit")
        notMovedYet = settings.get("notMovedYet")
        if (notMovedYet == true) then
            if (turtle.forward()) then
                notMovedYet = false
                settings.set("notMovedYet", notMovedYet)
                Distance = Distance + 1
                settings.set("Distance", Distance)
                settings.save("Miner.settings")
            end
        end
        continue = false
    end
    while true do
        term.clear()
        term.setCursorPos(1, 1)
        print("Miner")
        print("Mode : ZigZag")
        print(turtle.getFuelLevel().." Fuel Left")
        print("Distance : "..Distance + 1)
        MinerApi.fuelCheck()
        MinerApi.checkSpace()
        while Distance < zigzagDistance do
            if (turtle.dig()) then
                notMovedYet = true
                settings.set("notMovedYet", notMovedYet)
                settings.save("Miner.settings")
            end
            if (turtle.forward()) then
                notMovedYet = false
                settings.set("notMovedYet", notMovedYet)
                Distance = Distance + 1
                settings.set("Distance", Distance)
                settings.save("Miner.settings")
            end
            term.clear()
            term.setCursorPos(1, 1)
            print("Miner")
            print("Mode : ZigZag")
            print(turtle.getFuelLevel().." Fuel Left")
            print("Distance : "..Distance + 1)
        end
        MinerApi.swapTurn(swapBit)
        swapBit = MinerApi.changeSwapBit(swapBit)
        Distance = 0
        settings.set("swapBit", swapBit)
        settings.set("Distance", Distance)
        settings.save("Miner.settings")
    end
elseif (Mode == "3D") then
    term.clear()
    term.setCursorPos(1, 1)
    print("Miner")
    print("Mode : 3D")
    print(turtle.getFuelLevel().." Fuel Left")
    if (active ~= true) then
        while true do
            term.clear()
            term.setCursorPos(1, 1)
            print("Miner Setup")
            print("3D Mode Settings")
            print("How far to go")
            term.write("X (Forward): ")
            targetXRead = tonumber(read())
            term.write("Y (Down): ")
            targetYRead = tonumber(read())
            term.write("Z (Left): ")
            targetZRead = tonumber(read())
            if (type(targetXRead) == "number" and type(targetYRead) == "number" and type(targetZRead) == "number") then
                targetX = targetXRead
                targetY = targetYRead
                targetZ = targetZRead
                turnLimit = targetZ - 1
                swapBit = true
                settings.set("targetX", targetX)
                settings.set("targetY", targetY)
                settings.set("targetZ", targetZ)
                settings.set("turnLimit", turnLimit)
                settings.set("swapBit", swapBit)
                settings.save("Miner.settings")
                break
            else
                print("Invalid input")
                os.sleep(2)
            end
        end
        print("Press Enter to Start")
        read("")
        active = true
        settings.set("active", active)
        continue = false
        currentY = 0
        settings.set("currentY", currentY)
        settings.save("Miner.settings")
    else
        print("press enter to continue previous job")
        read("")
        targetX = settings.get("targetX")
        targetY = settings.get("targetY")
        targetZ = settings.get("targetZ")
        continue = true
        currentY = settings.get("currentY")
    end
    while currentY < targetY do
        if (continue ~= true) then
            currentX = 1
            currentZ = 0
            turnCount = 0
            notMovedYet = false
            settings.set("currentX", currentX)
            settings.set("currentZ", currentZ)
            settings.set("turnCount", turnCount)
            settings.save("Miner.settings")
        else
            currentX = settings.get("currentX")
            currentZ = settings.get("currentZ")
            turnCount = settings.get("turnCount")
            turnLimit = settings.get("turnLimit")
            swapBit = settings.get("swapBit")
            notMovedYet = settings.get("notMovedYet")
            if (notMovedYet == true) then
                if (turtle.forward()) then
                    notMovedYet = false
                    settings.set("notMovedYet", notMovedYet)
                    currentX = currentX + 1
                    settings.set("currentX", currentX)
                    settings.save("Miner.settings")
                end
            end
            continue = false
        end
        while currentZ < targetZ do
            while currentX < targetX do
                term.clear()
                term.setCursorPos(1, 1)
                print("Miner")
                print("Mode : 3D")
                print(turtle.getFuelLevel().." Fuel Left")
                print("x : "..currentX)
                print("y : "..currentY)
                print("z : "..currentZ)
                MinerApi.fuelCheck()
                MinerApi.checkSpace()
                if (turtle.dig()) then
                    notMovedYet = true
                    settings.set("notMovedYet", notMovedYet)
                    settings.save("Miner.settings")
                end
                if (turtle.forward()) then
                    notMovedYet = false
                    settings.set("notMovedYet", notMovedYet)
                    currentX = currentX + 1
                    settings.set("currentX", currentX)
                    settings.save("Miner.settings")
                end
            end
            if (turnCount < turnLimit) then
                MinerApi.swapTurn(swapBit)
                swapBit = MinerApi.changeSwapBit(swapBit)
                turnCount = turnCount + 1
                settings.set("swapBit", swapBit)
                settings.set("turnCount", turnCount)
                settings.save("Miner.settings")
            end
            currentZ = currentZ + 1
            settings.set("currentZ", currentZ)
            settings.save("Miner.settings")
            currentX = 1
        end
        if (currentY < targetY - 1) then
            turtle.digDown()
            turtle.down()
            turtle.turnLeft()
            turtle.turnLeft()
        end
        currentY = currentY + 1
        settings.set("currentY", currentY)
        settings.save("Miner.settings")
    end
    term.clear()
    term.setCursorPos(1, 1)
    print("Miner")
    print("Mode : 3D")
    print(turtle.getFuelLevel().." Fuel Left")
    print("x : "..currentX)
    print("y : "..currentY)
    print("z : "..currentZ)
    print("job Done")
    print("Stopping Miner Program")
    active = false
    settings.set("active", active)
    settings.save("Miner.settings")
else
    print(Mode.." Is an invalid mode")
    print("quiting Program")
end