module Main where

-- import Network.HTTP.Conduit
-- import qualified Data.ByteString.Lazy as L
import System.IO

apiUrl = "http://api.translink.ca/rttiapi/v1/"
apiKey = "apikey="

-- getStopsNearBusLoop = do
--     let query = apiUrl ++ "stops?" ++ apiKey ++ "&lat=49.268342&long=-123.250015"
--     simpleHttp query >>= L.putStr

-- main = getStopsNearBusLoop

main = do
 getOriginFromUser
 getDestFromUser

getOriginFromUser :: IO String 
getOriginFromUser = do
 putStrLn "Where are you leaving from?"
 origin <- getLineFixed
 return origin

getDestFromUser :: IO String
getDestFromUser = do
 putStrLn "Where would you like to go?"
 dest <- getLineFixed
 return dest

getLineFixed =
   do
     line <- getLine
     return (fixdel line)

fixdel st
   | '\DEL' `elem` st = fixdel (remdel st)
   | otherwise = st
remdel ('\DEL':r) = r
remdel (a:'\DEL':r) = r
remdel (a:r) = a: remdel r