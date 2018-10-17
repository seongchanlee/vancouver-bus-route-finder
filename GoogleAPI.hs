{-# LANGUAGE OverloadedStrings #-}

module GoogleAPI where

import Network.Stream
import Network.URI
import Network.HTTP.Conduit
import Network.HTTP.Base
import Network.HTTP.Headers
import Data.Maybe
import qualified Data.ByteString.Lazy as B

import JsonParser

directionsUrl = "https://maps.googleapis.com/maps/api/directions/json?"

{- DO NOT PUSH API KEY -}
apiKey = ""

getDirection origin destination = do
  {- From busloop to Granville station as a sample for now -}
  initReq <- parseUrlThrow (directionsUrl)
  let r = initReq {method = "GET"}
  let request = setQueryString [("origin", Just origin)
                                ,("destination", Just destination)
                                ,("mode", Just "transit")
                                ,("key", Just apiKey)] r

  manager <- newManager tlsManagerSettings
  res <- httpLbs request manager
  return . responseBody $ res

getDirectionInExternalJson origin destination = do
  routeInJson <- getDirection origin destination
  B.writeFile "route.json" routeInJson
