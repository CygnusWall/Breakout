--allows us to use classes in lua
Class = require 'lib/class'

--for virtual resolution
push = require 'lib/push'

--constants that do not change, stored in one file for easy access
require 'src/constants'

--state machine
require 'src/StateMachine'

--various states of the game
require 'src/states/BaseState'
require 'src/states/StartState'
require 'src/states/PlayState'
require 'src/states/ServeState'
require 'Paddle'
require 'Ball'
require 'Brick'
require 'LevelMaker'

--utility function used for splitting up the sprite sheet
require 'src/Util'