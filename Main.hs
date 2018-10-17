{-# LANGUAGE OverloadedStrings #-}

module Main where

import System.IO
-- import Text.Read

import GoogleAPI
import Logo

-- import JsonParser

main = do
 hSetBuffering stdout NoBuffering
 putStrLn logo
 -- getDirection "UBC" "Granville"
 getOriginFromUser 
 getDestFromUser



{-
-- main :: IO String
main = do
 putStrLn "Would you like to search a route?"
 ans <- getLineFixed
 if (ans `elem` ["y","yes"]) then 
  getOriginFromUser getDestFromUser
 else if (ans `elem` ["n", "no"]) then 
  putStrLn "Goodbye!"
 else
  putStrLn "Invalid input, please answer y/n"
-}


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
