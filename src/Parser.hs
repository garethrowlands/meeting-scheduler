module Parser where

import           Data.Time.LocalTime

import           Control.Applicative hiding (many)
import           Data.Maybe          (listToMaybe)
import           Data.Time.Clock     (UTCTime)
import           Data.Time.Format
import           System.Locale
import           Text.Parsec
import           Text.Parsec.String
import           Types

-- | converts a ReadS parser as used by Read into a Parsec Parser
liftReadS :: ReadS a -> String -> Parser a
liftReadS f s = maybe (fail $ "Cannot parse '" ++ s ++ "'") (return . fst) .
                listToMaybe . filter (null . snd) . f $ s

-- | parse an Integer by using the Integer Read instance
pInteger :: Parser Integer
pInteger = many1 digit >>= liftReadS reads

-- | hhmm
pTimeOfDay :: Parser TimeOfDay
pTimeOfDay = do
    hours <- count 2 digit
    minutes <- count 2 digit
    return $ TimeOfDay (read hours) (read minutes) 0

-- | hhmm hhmm
pOpeningHours :: Parser (TimeOfDay,TimeOfDay)
pOpeningHours = (,) <$> pTimeOfDay <* spaces <*> pTimeOfDay

pEmployeeId :: Parser String
pEmployeeId = many1 alphaNum

pTime :: String -> Parser UTCTime
pTime fmt = do
    sDate <- word
    spaces
    sTime <- word
    let s = sDate ++ " " ++ sTime
    let result = parseTime defaultTimeLocale fmt s
    maybe (fail $ "Cannot parse date '" ++ s ++ "'") return result
    where
        word = many1 (noneOf " \n")

pBookingRequest :: Parser BookingRequest
pBookingRequest = do
    BookingRequest <$> pTime "%F %H:%M:%S" <* spaces <*> pEmployeeId <* spaces <*> pTime "%F %H:%M" <* spaces <*> pInteger

pInput :: Parser Input
pInput = Input <$> pOpeningHours <* spaces <*> pBookingRequest `endBy` spaces

