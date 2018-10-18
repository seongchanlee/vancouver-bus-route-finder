{-# LANGUAGE OverloadedStrings #-}

module GoogleAPI where

import Network.Stream
import Network.URI
import Network.HTTP.Conduit
import Network.HTTP.Base
import Network.HTTP.Headers
import Data.Maybe
import Data.Aeson
import Data.Aeson.Types
import qualified Data.ByteString.Lazy as LBS
import qualified Data.ByteString.Char8 as BS
import qualified JsonParser as JP

import JsonParser

directionsUrl = "https://maps.googleapis.com/maps/api/directions/json?"

{- DO NOT PUSH API KEY -}
apiKey = ""

{- Function to do make HTTPS GET request to Google's Direction API -}
getDirectionFromApi :: String -> String -> IO(LBS.ByteString)
getDirectionFromApi origin destination = do
  initReq <- parseUrlThrow (directionsUrl)
  let r = initReq {method = "GET"}
  let request = setQueryString [("origin", Just (BS.pack origin))
                                ,("destination", Just (BS.pack destination))
                                ,("mode", Just "transit")
                                ,("key", Just apiKey)] r

  manager <- newManager tlsManagerSettings
  res <- httpLbs request manager
  return . responseBody $ res

{- Function to store JSON file externally -}
storeDirectionInExternalJson :: String -> String -> IO()
storeDirectionInExternalJson origin destination = do
  routeInJson <- getDirectionFromApi origin destination
  LBS.writeFile "route.json" routeInJson

{- Function to quickly grab list of Route from JSON -}
routes :: Value -> Parser [JP.Route]
routes = withObject "Routes" $ \o -> o .: "routes"

{- Function to get list of Route from loaded JSON -}
getDirectionFromFile :: String -> String -> IO ([JP.Route])
getDirectionFromFile origin destination = do
  storeDirectionInExternalJson origin destination
  bs <- LBS.readFile "route.json"
  let maybeRoutes = parseMaybe routes =<< decode bs
  let routeList = JP.checkRoutes maybeRoutes
  return routeList

