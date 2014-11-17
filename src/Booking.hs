{-# LANGUAGE RecordWildCards #-}
module Booking where

import           Data.Time.Clock
import           Types

data Booking = Booking {
    bStartTime :: UTCTime,
    bEndTime :: UTCTime,
    bEmployeeId :: EmployeeId
} deriving (Eq,Show)

bookingsOverlap booking1 booking2 = overlaps (timePeriod booking1) (timePeriod booking2)

timePeriod (Booking start end _) = (start,end)

overlaps r1@(start1,end1) r2@(start2,end2) =
    start1 `insideExclusive` r2 || end1 `insideExclusive` r2 ||
    start2 `insideExclusive` r1 || end2 `insideExclusive` r1 ||
    r1 == r2

t `insideExclusive` (opening,closing) = t > opening && t < closing

requestEndTime (BookingRequest _ _ rStartTime rDurationHours) = addHours rStartTime rDurationHours

requestToBooking r@(BookingRequest {..}) = Booking rStartTime endTime rEmployeeId
    where
        endTime = requestEndTime r

addHours :: UTCTime -> Hours -> UTCTime
addHours time hours = addUTCTime (fromInteger $ hours * 3600) time

