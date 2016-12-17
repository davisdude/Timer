Timer
===

Timer aims to be a simple to use library to manage events that occur based on timings and events.

Usage
---

Load in using a `require` statement, then create a new timer calling [`timer.new`](#timer-new).

### timer.new

- **timer.new( func )**

Create a new timer object. `func` contains the instructions for the timer. Special functions are exposed only within the scope of `func`:

#### signal

- **signal( str )**

Signals an event, where `str` is the event, as specified by a `waitSignal` function. Like calling a function which activates the block of code following the signal.

#### wait

- **wait( time )**

Wait `time` time units, where time units are whatever time your chosen framework uses. After `time` time units has passed, the next block of code will be executed.

#### waitSignal

- **waitSignal( str )**

Suspend execution of the thread until the corresponding `signal` is called.
