module ActionKid.Core where
import ActionKid.Types
import ActionKid.Utils
import Control.Applicative
import Control.Monad
import Data.List
import Data.Maybe
import Text.Printf
import Graphics.Gloss hiding (display)
import Data.Monoid ((<>), mconcat)
import Graphics.Gloss.Interface.IO.Game
import Data.Ord
import ActionKid.Globals
import Data.StateVar
import Control.Lens
import qualified Debug.Trace as D
import ActionKid.Internal

-- | hittest. Check if one MovieClip is hitting another.
hits :: MovieClip a => a -> a -> Bool
hits a b = f a `intersects` f b
    where f = boundingBox . display

-- | Call this to run your game. Takes:
--
-- 1. Window title
-- 2. (width, height)
-- 3. Game state (a MovieClip)
-- 4. a key handler function (exactly the same as Gloss)
-- 5. a step function (onEnterFrame)
run :: MovieClip a => String -> (Int, Int) -> a -> (Event -> a -> IO a) -> (Float -> a -> IO a) -> IO ()
run title (w,h) state keyHandler stepFunc = do
  boardWidth $= w
  boardHeight $= h
  playIO
    (InWindow title (w,h) (1, 1))
    white
    30
    state
    -- this could be done through a pre-defined function too...
    -- just need to make the gamestate be a global var that is always
    -- a list of elements to display
    draw
    keyHandler
    (onEnterFrame stepFunc)

-- | Convenience function. Given a list of movie clips,
-- displays all of them.
displayAll :: MovieClip a => [a] -> Picture
displayAll mcs = Pictures $ map display mcs
