{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE RecordWildCards #-}

module JsonParser where

import Data.Maybe
import Data.Aeson
import Data.Aeson.Types
import Data.Text
import qualified Data.ByteString.Lazy as B

data Step = Step
  { travelMode :: Text,
    instruction :: Text
  } deriving Show

data Leg = Leg
  { arrivalTime :: Text,
    departureTime :: Text,
    duration :: Text,
    endAddress :: Text,
    startAddress :: Text,
    steps :: [Step]
  } deriving Show

data Route = Route
  { legs :: [Leg]
  } deriving Show

instance FromJSON Step where
  parseJSON = withObject "Step" $ \o -> do
    travelMode <- o .: "travel_mode"
    instruction <- o .: "html_instructions"
    return Step{..}

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

instance FromJSON Route where
  parseJSON = withObject "Route" $ \o -> do
    legs <- o .: "legs"
    return Route{..}

routes :: Value -> Parser [Route]
routes = withObject "Routes" $ \o -> o .: "routes"

checkRoutes :: Maybe [Route] -> [Route]
checkRoutes routes
    | isJust routes = fromJust routes
    | otherwise = []
