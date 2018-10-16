{-# LANGUAGE OverloadedStrings #-}

module Main where

import System.IO

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
