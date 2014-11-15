-- | Main entry point to the application.
module Main where

import Types
import Parser
import Text.Parsec.String

-- | The main entry point.
main :: IO ()
main = do
    r <- parseFromFile pInput "input.txt"
    print r
