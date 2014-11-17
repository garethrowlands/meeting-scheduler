module Tests where

import Parser
import Types
import Booking
import Text.Parsec


pt s = let Right t1 = parse (pTime "%F %H:%M:%S") "" s in t1
r1 = BookingRequest {rSubmissionTime = pt "2011-03-16 09:28:23", rEmployeeId = "EMP003", rStartTime = pt "2011-03-22 14:00:00", rDurationHours = 2}
r2 = BookingRequest {rSubmissionTime = pt "2011-03-17 10:17:06", rEmployeeId = "EMP004", rStartTime = pt "2011-03-22 16:00:00", rDurationHours = 1}

testOverlaps = bookingsOverlap (requestToBooking r1) (requestToBooking r2)

