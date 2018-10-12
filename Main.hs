module Main where

import Network.HTTP.Conduit
import qualified Data.ByteString.Lazy as L

apiUrl = "http://api.translink.ca/rttiapi/v1/"
apiKey = "apikey="

getStopsNearBusLoop = do
    let query = apiUrl ++ "stops?" ++ apiKey ++ "&lat=49.268342&long=-123.250015"
    simpleHttp query >>= L.putStr

main = getStopsNearBusLoop