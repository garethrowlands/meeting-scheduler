module Types where

import           Data.Time.LocalTime
import           Data.Time.Clock

type OpeningHours = (TimeOfDay, TimeOfDay)

data Input = Input {
    iOpeningHours     :: OpeningHours,
    iBookingRequests :: [BookingRequest]
} deriving (Show, Eq)

data BookingRequest = BookingRequest {
    rSubmissionTime :: UTCTime,
    rEmployeeId :: EmployeeId,
    rStartTime :: UTCTime,
    rDurationHours :: Integer
} deriving (Show, Eq)

type EmployeeId = String
