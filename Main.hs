{-# LANGUAGE OverloadedStrings #-}

module Main where

import Network.Stream
import Network.URI
import Network.HTTP.Conduit
import Network.HTTP.Base
import Network.HTTP.Headers
import Data.Maybe
import qualified Data.ByteString.Lazy as B

directionsUrl = "https://maps.googleapis.com/maps/api/directions/json?"
placesUrl = "https://maps.googleapis.com/maps/api/place/textsearch/json?"
apiKey = ""

getDirection = do
  {- From busloop to Granville station as a sample for now -}
  initReq <- parseUrl (directionsUrl)
  let r = initReq {method = "GET"}
  let request = setQueryString [("origin", Just "49.2683386,-123.2500156")
                                ,("destination", Just "49.283416,-123.1169463")
                                ,("mode", Just "transit")
                                ,("key", Just apiKey)] r

  manager <- newManager tlsManagerSettings
  res <- httpLbs request manager
  return . responseBody $ res

storeRouteExternally = do
  routeInJson <- getDirection
  B.writeFile "route.json" routeInJson

getLatLonFromName = do
  {- Get Granville station for now -}
  initReq <- parseUrl (placesUrl)
  let r = initReq {method = "GET"}
  let request = setQueryString [("query", Just "Granville station")
                                ,("key", Just apiKey)] r
  manager <- newManager tlsManagerSettings
  res <- httpLbs request manager
  return . responseBody $ res

storePlaceLatLonExternally = do
  latLonInJson <- getLatLonFromName
  B.writeFile "placeLatLon.json" latLonInJson

main = do
  storePlaceLatLonExternally
