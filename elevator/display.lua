local class = require('pl.class')

---- Abstract Display ----

local Display = class()

function Display:_init()
    -- TODO
end

function Display:draw()
    error("method draw() must be implemented!")
end

function Display:__tostring()
    return "Display[]"
end

---- TwoSegmentDisplay ----

-- Identified by 2 vertical 1x2 display segments
local TwoSegmentDisplay = class(Display)

function TwoSegmentDisplay:_init()
    -- TODO
end

function TwoSegmentDisplay:draw()
    -- TODO
end

return {
    Display = Display,
    TwoSegmentDisplay = TwoSegmentDisplay
}