{-# LANGUAGE RecordWildCards #-}
module Diary where

import           Booking
import Control.Arrow ((&&&))
import           Data.Function       (on)
import           Data.List           (foldl', groupBy, partition, sortBy)
import           Data.Ord            (comparing)
import           Data.Time.Calendar
import           Data.Time.Clock
import           Data.Time.LocalTime
import           Types

type Diary = [Booking]
newDiary = []
addToDiary = (:)

data BookingFailure = OutOfHours | OverlapsExistingBooking
    deriving (Eq,Show)

bookMeetings :: OpeningHours -> [BookingRequest] -> (Diary, [(BookingFailure,BookingRequest)])
bookMeetings openingHours requests =
    let (inHoursRequests, outOfHoursRequests) = partition (requestIsInsideHours openingHours) requests
        requestsInSubmissionOrder = sortBy (comparing rSubmissionTime) inHoursRequests
        (diary,overlappingRequests) = foldl' bookMeeting (newDiary,[]) requestsInSubmissionOrder
        failures = zip (repeat OutOfHours) outOfHoursRequests ++ zip (repeat OverlapsExistingBooking) overlappingRequests
    in
        (diary, failures)

bookMeeting :: (Diary,[BookingRequest]) -> BookingRequest -> (Diary,[BookingRequest])
bookMeeting (diary,failedRequests) bookingRequest
    | not anyBookingsOverlap = (booking `addToDiary` diary, failedRequests)
    | otherwise              = (diary, bookingRequest : failedRequests)
    where
        booking = requestToBooking bookingRequest
        anyBookingsOverlap = any (bookingsOverlap booking) diary

t `insideInclusive` (opening,closing) = t >= opening && t <= closing

requestIsInsideHours :: (TimeOfDay,TimeOfDay) -> BookingRequest -> Bool
requestIsInsideHours openingHours request = (timeToTimeOfDay startTime `insideInclusive` openingHours) && (timeToTimeOfDay endTime `insideInclusive` openingHours)
    where
        UTCTime _ startTime = rStartTime request
        UTCTime _ endTime = requestEndTime request


bookingsByDay :: Diary -> [(Day,[Booking])]
bookingsByDay bookings = myGroupBy (utctDay . bStartTime) bookings

myGroupBy :: (Ord b) => (a -> b) -> [a] -> [(b, [a])]
myGroupBy f = map (f . head &&& id)
                   . groupBy ((==) `on` f)
                   . sortBy (compare `on` f)

