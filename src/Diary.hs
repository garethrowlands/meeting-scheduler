{-# LANGUAGE RecordWildCards #-}
module Diary where

import Types
import Data.Time.Clock
import Data.Time.Calendar

type Diary = [Booking]

data Booking = Booking UTCTime UTCTime EmployeeId

bookMeetings :: OpeningHours -> [BookingRequest] -> Diary

--    rSubmissionTime :: UTCTime,
--    rEmployeeId :: EmployeeId,
--    rStartTime :: UTCTime,
--    rDurationHours :: Integer

-- bookMeeting :: OpeningHours -> Diary -> BookingRequest
bookMeeting openingHours diary r@(BookingRequest {..}) = do
    failUnless openingHoursErr $ (rStartTime `inside` openingHours) && (endTime `inside` openingHours)
    failUnless overlappingErr $ undefined
    where
        t `inside` (opening,closing) = t >= opening && t <= closing
        endTime = addHours rStartTime rDurationHours
        openingHoursErr = "Outside opening hours: " ++ r
        overlappingErr = "Time already taken: " ++ r

    
bookingsByDay :: Diary -> [(Day,[Booking])]

