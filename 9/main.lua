local statusScreen = require("./status")

parallel.waitForAll(
    function ()
        statusScreen()
    end
)
