local guih = require("GuiH")

local matrixPort = "inductionPort_0"
local monitor = "monitor_0"

local monitorPeripheral = peripheral.wrap(monitor)
local inductionPeripheral = peripheral.wrap(matrixPort)

local canvas = guih.new(monitorPeripheral)

local lastOutRead = -1
local lastReadPercent = -1

print("Inicializando MAtriz...")

local w, h = canvas.getSize()

local energyProgress = canvas.new.progressbar({
    direction = "left-right",
    value = 0,
    width = 10,
    height = 1,
    fg = colors.lime,
    bg = colors.white,
    x = 5,
    y = h 
})

canvas.new.text({
    text = canvas.text({
        text = "Matriz Pencraft",
        centered = true,
        offset_y = -5
    })
})

local kfeText = canvas.new.text({
    text = canvas.text({
        text = "-- kFE/t",
        centered = true,
        fg = colors.white,
        offset_y = -2
    })
})

local outText = canvas.new.text({
    text = canvas.text({
        text = "-- kFE/t",
        centered = true
    })
})

monitorPeripheral.setTextScale(1)


local function liga()
    while true do
        local output = inductionPeripheral.getLastOutput()
        local input = inductionPeripheral.getLastInput()
        local energyPercentage = inductionPeripheral.getEnergyFilledPercentage() * 100

        if (output ~= lastOutRead) then
            local feOutput = mekanismEnergyHelper.joulesToFE(output)
            local feInput = mekanismEnergyHelper.joulesToFE(input)
            local energyProfit = (feInput - feOutput) / 1000
            local profitColor

            if (energyProfit < 0) then
                profitColor = colors.red
            else
                profitColor = colors.green
            end

            
            kfeText.text.text = tostring(energyProfit) .. "kFE/t"
            kfeText.text.fg = profitColor

            outText.text.text = "Out: " .. (feOutput / 1000) .. "kFE/t"

            lastOutRead = output
        end

        if (lastReadPercent ~= energyPercentage) then
            energyProgress.value = energyPercentage
            lastReadPercent = energyPercentage
        end

        sleep(0.3)
    end
end


local e = canvas.execute(liga)
print(e)
