local signals = {}

local function resumeCoroutine( co, ... )
    local passed, err = coroutine.resume( co, ... )
    assert( passed, 'Timer error: ' .. tostring( err ) )
    return passed
end

local function wait( process, seconds )
    local co = coroutine.running()
    local wakeUpTime = process.time + seconds
    process.times[co] = wakeUpTime
    return coroutine.yield( co )
end

local function checkThreads( process )
    for co, wakeUpTime in pairs( process.times ) do
        if process.time > wakeUpTime then
            process.times[co] = nil
            resumeCoroutine( co )
        end
    end
end

local function waitSignal( name )
    local co = coroutine.running()
    if signals[name] then
        table.insert( signals[name], co )
    else
        signals[name] = { co }
    end
    return coroutine.yield( co )
end

local toResume = {} -- Prevent bugs caused by coroutines starting then pausing wrong thread
local function signal( name )
    for i, co in ipairs( signals[name] ) do
        if coroutine.status( co ) == 'suspended' then
            table.insert( toResume, co )
        end
    end
    signals[name] = nil
end

-- Wrapper function
local function newProcess( func )
    local process = {
        time = 0,
        times = {},
        update = function( self, dt )
            self.time = self.time + dt
            checkThreads( self )
            for _, co in ipairs( toResume ) do
                resumeCoroutine( co )
            end
            toResume = {}
        end,
    }

    setfenv( func,
        setmetatable( {
            waitSignal = waitSignal, 
            signal = signal, 
            wait = function( seconds )
                process.time = 0
                return wait( process, seconds )
            end,
        }, {
            __index = getfenv( 0 ),
        } )
    )
    local co = coroutine.create( func )
    resumeCoroutine( co )

    return process
end

return {
    new = newProcess,
    wait = wait,
}
