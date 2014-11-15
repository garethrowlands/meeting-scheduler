module Types where

import           Data.Time.LocalTime
import           Data.Time.Clock
import Data.Text

type OpeningHours = (TimeOfDay, TimeOfDay)

data Input = Input {
    iOpeningHours     :: OpeningHours,
    iBookingRequests :: [BookingRequest]
}

data BookingRequest = BookingRequest {
    rSubmissionTime :: UTCTime,
    rEmployeeId :: EmployeeId
}

type EmployeeId = Text
