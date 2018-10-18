{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE RecordWildCards #-}

module JsonParser where

import Data.Maybe
import Data.Aeson
import Data.Aeson.Types
import Data.Text
import qualified Data.ByteString.Lazy as B

{- Data definition for steps from JSON -}
data Step = Step
  { travelMode :: Text,
    instruction :: Text
  } deriving Show

{- Data definition for legs from JSON -}
data Leg = Leg
  { arrivalTime :: Text,
    departureTime :: Text,
    duration :: Text,
    endAddress :: Text,
    startAddress :: Text,
    steps :: [Step]
  } deriving Show

{- Data definition for routes from JSON -}
data Route = Route
  { legs :: [Leg]
  } deriving Show

{- Function to parse JSON to custom data Step -}
instance FromJSON Step where
  parseJSON = withObject "Step" $ \o -> do
    travelMode <- o .: "travel_mode"
    instruction <- o .: "html_instructions"
    return Step{..}

{- Function to parse JSON to custom data Leg -}
instance FromJSON Leg where
  parseJSON = withObject "Leg" $ \o -> do
    arrivalTimeO <- o .: "arrival_time"
    arrivalTime <- arrivalTimeO .: "text"

    departureTimeO <- o .: "departure_time"
    departureTime <- departureTimeO .: "text"

    durationO <- o .: "duration"
    duration <- durationO .: "text"

    endAddress <- o .: "end_address"
    startAddress <- o .: "start_address"
    steps <- o .: "steps"
    return Leg{..}

{- Function to parse JSON to custom data Route -}
instance FromJSON Route where
  parseJSON = withObject "Route" $ \o -> do
    legs <- o .: "legs"
    return Route{..}

{- Function to convert Maybe [Route] from parser to [Route] -}
checkRoutes :: Maybe [Route] -> [Route]
checkRoutes routes
    | isJust routes = fromJust routes
    | otherwise = []