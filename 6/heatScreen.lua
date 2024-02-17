local monitor = peripheral.wrap("monitor_4")
local gui = require("GuiH")
local reactor = peripheral.wrap("fissionReactorLogicAdapter_1")
local canvas = gui.new(monitor)

monitor.setTextScale(1)

canvas.new.text({
    text = canvas.text{
        text = "Heat",
        fg = colors.orange,
        centered = true,
        offset_y = -1
    }
})

local heatValue = canvas.new.text({
    text = canvas.text{
        text = "--",
        fg = colors.orange,
        centered = true,
        offset_y = 1
    }
})

local function loop()
    while true do
        local kTemp = reactor.getTemperature()
            heatValue.text.text = string.format("%.2f", (kTemp - 273.1)) .. " C"
        sleep(0.5)
    end
end

local function run()
    local e = canvas.execute(loop)
    print(e)
end

return run
