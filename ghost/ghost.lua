-- Create Bad v1
-- This is a simple program to work around the "ghost" power bug in Create. When loaded, it breaks and replaces shafts (assume above) at specific times. Currently I have it set to my server's on and off time.

-- for communicating to the main thread to stop what it's doing
SUSPEND = false

local function logEvent(message)

    -- Append time to message
    message = os.date("%Y/%m/%d  %H:%M:%S - ", os.epoch("local") / 1000) .. message

    -- Print to console
    print(message)

    -- Log to file as well
    local logFile = fs.open("ghost.log", "a")
    logFile.writeLine(message)
    logFile.close()

end

local function keyLoop()

    while true do
        local event, key, isHeld = os.pullEvent("key")

        if key == keys.q and isHeld then

            logEvent("Manual activation was triggered")

            -- Whitespace
            print()
            print("Key combination recognized, attempting to suspend...")

            -- Break shaft and wait 30 seconds, or log in the event of a failure
            if turtle.digUp() then
                -- Suspend main thread
                SUSPEND = true
                logEvent("Main thread suspended")

                print("Shaft broken, waiting 30 seconds...")
                sleep(30)

                -- Resume main thread
                SUSPEND = false
                logEvent("Main thread resumed")

            else
                print("Failed to break shaft! Was it already broken?")
                print("WARNING: nothing was changed!")
                print()

                logEvent("Manual activation failed!")

                -- avoid retriggering too fast because key is held down
                sleep(4)

            end

        end
    end

end

local function main()

    local thresholds = {
        -- [ 11:59 PM, 12:01 AM )
        {
            23 * 3600 + 59 * 60,
            24 * 3600 + 1 * 60
        },

        -- [ 08:14 AM, 08:16 AM )
        {
            8 * 3600 + 14 * 60,
            8 * 3600 + 16 * 60
        }
    }

    term.clear()
    term.setCursorPos(1,1)

    print("Remove Ghost Stress v1")
    print("Starting loop...")

    -- Assuming the shaft is in the turtle's inventory on system startup (i.e. server restart, wait a little bit before placing)
    if turtle.getItemCount() > 0 then
        logEvent("Shaft found in the item slot on startup! Waiting 30s...")
        sleep(30)
    end

    while true do

        if not SUSPEND then

            -- In seconds
            local currentTime = os.time("local") * 3600

            --print(textutils.formatTime(currentTime / 3600))

            -- flag, communicates if we found a match among the table
            local match = false

            for index, thValue in pairs(thresholds) do
                if currentTime >= thValue[1] and currentTime < thValue[2] then
                    match = true

                    -- If we don't have an item, we try to remove. If we do, we ignore this.
                    if turtle.getItemCount() == 0 then

                        logEvent(string.format("Fell into time bracket %d, removing...", index))

                        if turtle.digUp() then
                            logEvent("  ...removed shaft")
                        else
                            logEvent("  \19\19\19 NO SHAFT TO REMOVE!!")
                        end
                    end
                end
            end

            -- There was no match, so we're out of ALL time windows. Now we place the shaft back, if we have it.
            if not match then
                if turtle.getItemCount() > 0 then
                    logEvent("Placing shaft...")
                    if turtle.placeUp() then
                        logEvent("  ...placed.")
                    else
                        logEvent("  \19\19\19 COULD NOT PLACE!!")
                    end
                end
            end
        end

        sleep(5)

    end

end

-- these two threads will never finish but we need them to execute in parallel
parallel.waitForAll(main, keyLoop)
