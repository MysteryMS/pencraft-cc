local monitor = peripheral.wrap("monitor_3")
local gui = require("GuiH")
local reactor = peripheral.wrap("fissionReactorLogicAdapter_1")
local canvas = gui.new(monitor)
local playLowCoolantSound = require("./safety/coolantAlarm")

monitor.setTextScale(0.5)

local progressBar = canvas.new.progressbar({
    direction = "down-top",
    value = 50,
    bg = colors.gray,
    fg = colors.blue,
    y = 10,
    x = 6.5,
    height = 14,
    width = 4
})

canvas.new.text({
    text = canvas.text {
        text = "Coolant",
        x = 5.5,
        y = 2
    }
})

local coolantType = canvas.new.text({
    text = canvas.text({
        text = "--",
        x = 5.5,
        y = 4
    })
})

local percentage = canvas.new.text({
    text = canvas.text {
        text = "--%",
        x = 6.5,
        y = 6
    }
})

local function loop()
    while true do
        local percent = reactor.getCoolantFilledPercentage()
        if reactor.getCoolant().name == "minecraft:water" then
            coolantType.text.text = "(Water)"
            progressBar.fg = colors.blue
        elseif reactor.getCoolant().name == "mekanism:sodium" then
            coolantType.text.text = "(Sodium)"
            progressBar.fg = colors.white
        else
            coolantType.text.text = "(None)"
        end

        percentage.text.text = math.floor(percent * 100) .. "%"
        progressBar.value = percent * 100

        if ((percent * 100) <= 15) then
            if (reactor.getStatus()) then
                reactor.scram()
            end
            playLowCoolantSound()
        end
        sleep(0.5)
    end
end

local function run()
    local e = canvas.execute(loop)
    print(e)
end

return run
