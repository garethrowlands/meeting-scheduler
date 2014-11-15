{-# LANGUAGE RecordWildCards #-}
module Diary where

import Types
import Control.Monad (unless)
import Data.Time.Clock
import Data.Time.Calendar

type Diary = [Booking]

data Booking = Booking UTCTime UTCTime EmployeeId

bookMeetings :: OpeningHours -> [BookingRequest] -> Diary

--    rSubmissionTime :: UTCTime,
--    rEmployeeId :: EmployeeId,
--    rStartTime :: UTCTime,
--    rDurationHours :: Integer

failUnless msg b = unless b $ fail msg

-- bookMeeting :: OpeningHours -> Diary -> BookingRequest
bookMeeting openingHours diary r@(BookingRequest {..}) = do
    failUnless openingHoursErr $ (rStartTime `inside` openingHours) && (endTime `inside` openingHours)
    failUnless overlappingErr $ undefined
    where
        t `inside` (opening,closing) = t >= opening && t <= closing
        endTime = addUTCTime rStartTime (fromInteger $ rDurationHours * 3600)
        openingHoursErr = "Outside opening hours: " ++ r
        overlappingErr = "Time already taken: " ++ r

    
bookingsByDay :: Diary -> [(Day,[Booking])]

