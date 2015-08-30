local timer = require 'timer'

function love.load()
    a = timer.new( function()
        wait( 1 )
        print( 'a' )
        wait( 1 )
        print( 'b' )
        wait( 1 )
        print( 'c' )
        wait( 1 )
        signal( 'B' )
        waitSignal( 'e!!' )
        print( 'e' )
        wait( 1 )
        signal( 'fin' )
        io.write( 'ta' )
    end )
    b = timer.new( function()
        waitSignal( 'B' )
        print( 'd' )
        wait( 1 )
        signal( 'e!!' )
        waitSignal( 'fin' )
        io.write( '-da!' )
    end )
end

function love.update( dt )
    a:update( dt )
    b:update( dt )
end

function love.keypressed( key )
    if key == 'escape' then 
        love.event.quit()
    end
end
