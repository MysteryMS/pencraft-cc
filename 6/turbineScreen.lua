local guih = require("GuiH")
local m = "monitor_6"
local monitor = peripheral.wrap(m)
local turbine = peripheral.wrap("turbineValve_0")

local canvas = guih.new(monitor)

canvas.clear()

monitor.setTextScale(0.5)

canvas.new.text({
    text = canvas.text({
        text = "Turbine Stats",
        centered = true,
        offset_y = -5
    })
})

local steamFilledPercentage = turbine.getSteamFilledPercentage() * 100
local energyFilledPercentage = turbine.getEnergyFilledPercentage() * 100

local steamFilled = canvas.new.text({
    text = canvas.text({
        text = "Steam: " .. turbine.getSteam().amount .. " mB (" .. math.floor(steamFilledPercentage) .. "%)" ,
        transparent = true,
        centered = true,
    })
})

local energyFilled = canvas.new.text({
    text = canvas.text({
        text = "Energy: " .. turbine.getEnergy() .. " kFE (" .. math.floor(energyFilledPercentage) .. "%)" ,
        transparent = true,
        centered = true,
        offset_y = 6
    })
})

local energyProduced = canvas.new.text({
    text = canvas.text({
        text = turbine.getProductionRate() .. " kFE/t",
        transparent = true,
        centered = true,
        offset_y = 2,
        fg = colors.lime
    })
})

-- max water output text
canvas.new.text({
    text = canvas.text({
        text = "Max Water Output: " .. turbine.getMaxWaterOutput() .. " mB/t",
        transparent = true,
        centered = true,
        offset_y = 4,
        fg = colors.blue
    })
})

local function main()
    while true do
        local _p = turbine.getSteamFilledPercentage() * 100
        local _e = turbine.getEnergyFilledPercentage() * 100

        local kfe = mekanismEnergyHelper.joulesToFE(turbine.getProductionRate())
        local storedKfe = mekanismEnergyHelper.joulesToFE(turbine.getEnergy())

        if (_p >= 50) then
            steamFilled.text.fg = colors.orange
        elseif (_p >= 80) then
            steamFilled.text.fg = colors.red
        else
            steamFilled.text.fg = colors.white
        end

        steamFilled.text.text = "Steam: " .. turbine.getSteam().amount .. " mB (" .. math.floor(_p) .. "%)"
        
        local formattedEnergyFilled = string.format("%.2f", storedKfe / 1000)
        energyFilled.text.text = "Energy: " .. formattedEnergyFilled .. " kFE (" .. math.floor(_e) .. "%)"

        local formattedProd = string.format("%.2f", kfe / 1000)
        
        energyProduced.text.text = "Production: " .. formattedProd .. " kFE/t"
        sleep(0.5)

    end
end

local function run() 
    local e = canvas.execute(main)
    print(e)
end

return run
