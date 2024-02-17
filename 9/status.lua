local guih = require("GuiH")
local m = "monitor_7"
local monitor = peripheral.wrap(m)
local environment = peripheral.wrap("environmentDetector_0")

local canvas = guih.new(monitor)

local w, h = canvas.getSize()
monitor.setTextScale(1.5)

canvas.new.text({
    text = canvas.text({
        text = "Floor Status",
        centered = true,
        offset_y = -3
    })
})

local radiationLevel = canvas.new.text({
    text = canvas.text({
        text = "--",
        centered = true,
    })
})

local suitRequired = canvas.new.text({
    text = canvas.text({
        text = "Clear",
        centered = true,
        offset_y = 2
    })
})


local function main()
    while true do
        local radiation = environment.getRadiation()
        local rawRad = environment.getRadiationRaw()
        radiationLevel.text.text = radiation.radiation .. " " .. radiation.unit
        if (rawRad > 60 * 10 ^ (-6)) then
            suitRequired.text.text = "Suit Required"
            suitRequired.text.fg = colors.red
            radiationLevel.text.fg = colors.orange
        else
            suitRequired.text.text = "Clear"
            suitRequired.text.fg = colors.lime
        end
    end
end

local function run()
    local e = canvas.execute(main)
    print(e)
end

return run
