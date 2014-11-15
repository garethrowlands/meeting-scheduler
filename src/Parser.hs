module Parser where

import Data.Time.LocalTime
import Control.Applicative
import Text.Parsec
import Types

pTimeOfDay = do
    hours <- count 2 digit 
    minutes <- count 2 digit
    return $ TimeOfDay (read hours) (read minutes)

pOpeningHours = (,) <$> pTimeOfDay <* spaces <*> pTimeOfDay
