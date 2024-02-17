local monitor = peripheral.wrap("monitor_2")
local gui = require("GuiH")
local reactor = peripheral.wrap("fissionReactorLogicAdapter_1")
local canvas = gui.new(monitor)

monitor.setTextScale(0.5)

local progressBar = canvas.new.progressbar({
    direction = "down-top",
    value = 50,
    bg = colors.gray,
    fg = colors.lime,
    y = 10,
    x = 6.5,
    height = 14,
    width = 4
})

canvas.new.text({
    text = canvas.text{
        text = "Fissile Fuel",
        x = 3.5,
        y = 2
    }
})

local percentage = canvas.new.text({
    text = canvas.text{
        text = "--%",
        x = 6.5,
        y = 5
    }
})

local function loop()
    while true do
        progressBar.value = reactor.getFuelFilledPercentage() * 100
        percentage.text.text = reactor.getFuelFilledPercentage() * 100 .. "%"
        sleep(0.5)
    end
end

local function run()
    local e = canvas.execute(loop)
    print(e)
end

return run
