-- bless this library, my god
local class = require('pl.class')

local MAX_FLOORS = 16

---- "Abstract" Elevator ----

local Elevator = class()

function Elevator:_init(numFloors)

    if not numFloors or numFloors < 1 or numFloors > MAX_FLOORS then
        error("numFloors must be defined and between 1 and 16!")
    end

    self.numFloors = numFloors
    self.currentFloor = 0

end

function Elevator:__tostring()
    return string.format("Elevator -- %d/%d", self.currentFloor, self.numFloors)
end

-- Moves the elevator up by the specified number of blocks
function Elevator:moveUp(blocks)
    error("method moveUp() must be overriden!")
end

-- Moves the elevator down by the specified number of blocks
function Elevator:moveDown(blocks)
    error("method moveDown() must be overriden!")
end

-- Stops the elevator in its current position and holds it
function Elevator:halt()
    error("method halt() must be overriden!")
end

-- Allows the elevator to move towards its natural positon (usually downward)
function Elevator:release()
    error("method release() must be overriden!")
end

---- GantryElevator ----

local GantryElevator = class(Elevator)

function GantryElevator:_init(numFloors, maxRPM)

    self:super(numFloors)

    if not maxRPM or maxRPM < -256 or maxRPM > 256 then
        error("maxRPM must be defined and between -256 and 256!")
    end

    self.maxRPM = maxRPM

end

function GantryElevator:__tostring()
    return string.format("GantryElevator -- %d/%d @%dRPM", self.currentFloor, self.numFloors, self.maxRPM)
end

---- Module ----

return {
    Elevator = Elevator,
    GantryElevator = GantryElevator
}