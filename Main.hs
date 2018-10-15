{-# LANGUAGE OverloadedStrings #-}

module Main where

import qualified GoogleAPI as GAPI

main = do
  GAPI.getDirectionInExternalJson "University of British Columbia" "Granville station"
  putStrLn ("Operation Successful")
