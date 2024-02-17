local monitor = peripheral.wrap("monitor_5")
local gui = require("GuiH")
local reactor = peripheral.wrap("fissionReactorLogicAdapter_1")
local canvas = gui.new(monitor)
local playDamageSound = require("./safety/damageAlarm")

monitor.setTextScale(1)

canvas.new.text({
    text = canvas.text {
        text = "Damage",
        fg = colors.red,
        centered = true,
        offset_y = -1
    }
})

local damageValue = canvas.new.text({
    text = canvas.text {
        text = "--",
        fg = colors.red,
        centered = true,
        offset_y = 1
    }
})

local function loop()
    while true do
        local damage = reactor.getDamagePercent()
        damageValue.text.text = tostring(damage) .. "%"

        if (damage > 50 or damage > 30) then
            if (reactor.getStatus()) then
                reactor.scram()
            end
            playDamageSound()
        end

        sleep(0.3)
    end
end

local function run()
    local e = canvas.execute(loop)
    print(e)
end

return run
