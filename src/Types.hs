module Types where

import           Data.Time.LocalTime

type OpeningHours = (TimeOfDay, TimeOfDay)

data Input = Input {
    iOpeningHours     :: OpeningHours,
    iBookingRequests :: [BookingRequest]
}

data BookingRequest = {
    rSubmissionTime :: U
}