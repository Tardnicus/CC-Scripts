local class = require('pl.class')

local Config = class()

function Config:_init(filename)

    -- TODO: validate filename

    self._filename = filename

end

function Config:__tostring()
    return "Configuration: " .. self._filename
end

function Config:read()
    -- TODO: read, unserialize, validate
    error("stub!")
end

function Config:write(...)
    -- TODO: validate, serialize, write
    error("stub!")
end

return {
    Config = Config
}