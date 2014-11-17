-- | Main entry point to the application.
module Main where

import Types
import Booking
import Parser
import Diary
import PrettyPrinter
import Text.Parsec.String
import Text.Parsec
import Data.Time.Calendar (Day)

-- | The main entry point.
main :: IO ()
main = do
    parseResult <- parseFromFile pInput "input.txt"
    case parseResult of
        Right (Input hours requests) -> do
            print requests
            print requests
            let (diary,failures) = bookMeetings hours requests
            mapM_ (putStrLn . show) diary
            print failures
            putStrLn "\n"
            print $ bookingsByDay diary
            mapM_ (putStrLn . formatBookingsByDay) (bookingsByDay diary)
        Left err -> print err


