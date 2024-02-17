local guih = require("GuiH")
local m = "monitor_1"
local monitor = peripheral.wrap(m)
local reactor = peripheral.wrap("fissionReactorLogicAdapter_1")

local canvas = guih.new(monitor)

local w, h = canvas.getSize()

local titleText = canvas.new.text({
    text = canvas.text({
        text = "Reator Offline",
        centered = true,
        offset_y = -8
    })
})

local function updateReactorState()
    if (reactor.getStatus()) then
        reactor.scram()
    else
        reactor.activate()
    end
end


local toggleButton = canvas.new.button({
    x = (w / 2) - 5,
    y = 4,
    text = canvas.text({
        text = "Activate",
        centered = true,
        transparent = true,
    }),
    width = 12,
    height = 3,
    background_color = colors.lime,
    on_click = updateReactorState
})

local burnRateTxt = canvas.new.text({
    text = canvas.text({
        text = "-- mB/t",
        transparent = true,
        centered = true,
    })
})

-- stored steam with % (heatedCoolant)
local heatedPercentage = reactor.getHeatedCoolantFilledPercentage() * 100
local heatedCoolantTxt = canvas.new.text({
    text = canvas.text({
        text = "Heated: " .. reactor.getHeatedCoolant().amount .. " mb (" .. heatedPercentage .. "%)" ,
        transparent = true,
        centered = true,
        offset_y = 2
    })
})

canvas.new.button({
    text = canvas.text({ text = "-", centered = true, transparent = true, width = 3}),
    background_color = colors.gray,
    width = 3,
    height = 2,
    y = (h / 2),
    x = 5,
    on_click = function ()
        reactor.setBurnRate(reactor.getBurnRate() - 1)
    end
})

canvas.new.button({
    text = canvas.text({ text = "+", centered = true, transparent = true, width = 3}),
    background_color = colors.gray,
    width = 3,
    height = 2,
    y = (h / 2),
    x = 23,
    on_click = function ()
        reactor.setBurnRate(reactor.getBurnRate() + 1)
    end
})

local function main()
    while true do
        local status = reactor.getStatus()
        burnRateTxt.text.text = reactor.getBurnRate() .. " mB/t"
        if (status) then
            titleText.text.text = "Reator Online"
            titleText.text.fg = colors.lime
            toggleButton.background_color = colors.red
            toggleButton.text.text = "SCRAM"
        else
            titleText.text.text = "Reator Offline"
            titleText.text.fg = colors.red
            toggleButton.background_color = colors.lime
            toggleButton.text.text = "Activate"
        end
        -- update heated coolant text
        local _p = reactor.getHeatedCoolantFilledPercentage() * 100
        local formattedP = string.format("%.2f", _p)
        if (_p >= 50) then
            heatedCoolantTxt.text.fg = colors.orange
        elseif (_p >= 80) then
            heatedCoolantTxt.text.fg = colors.red
        end
        heatedCoolantTxt.text.text = "Heated: " .. reactor.getHeatedCoolant().amount .. " mb (" .. formattedP .. "%)"
    end
end

local function run() 
    local e = canvas.execute(main)
    print(e)
end

return run
