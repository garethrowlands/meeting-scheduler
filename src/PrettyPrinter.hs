module PrettyPrinter where

import Data.List (intersperse)

import Booking
import Data.Time.Format
import System.Locale (defaultTimeLocale)

-- | Formats a booking thus: 09:00 11:00 EMP002
formatBooking (Booking startTime endTime employeeId) =
    formatHours startTime ++ " " ++ formatHours endTime ++ " " ++ employeeId
    where
        formatHours time = formatTime defaultTimeLocale  "%H:%M" time

formatBookingsByDay (day,bookings) = formattedDay ++ "\n" ++ formattedBookings
    where
        formattedDay = formatTime defaultTimeLocale "%F" day
        formattedBookings = concat $ intersperse "\n" (map formatBooking bookings)