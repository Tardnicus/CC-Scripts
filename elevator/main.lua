local elevator = require("elevator")
local display = require("display")
local config = require("config")

local function main()

    print("Main!")

    local e = elevator.GantryElevator(12, 128)
    local d = display.TwoSegmentDisplay()
    local c = config.Config("filename")

    print(e)
    print(d)
    print(c)

end

main()