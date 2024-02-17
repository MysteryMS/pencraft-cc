local mainScreen = require("mainScreen")
local fuelScreen = require("fuelScreen")
local coolantScreen = require("coolant")
local heatScreen = require("heatScreen")
local damageScreen = require("damageScreen")
local turbineScreen = require("turbineScreen")

parallel.waitForAll(
    function ()
        mainScreen()
    end,
    function ()
        fuelScreen()
    end,
    function ()
        coolantScreen()
    end,
    function ()
        heatScreen()
    end,
    function ()
        damageScreen()
    end,
    function ()
        turbineScreen()
    end
)