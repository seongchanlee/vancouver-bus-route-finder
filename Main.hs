{-# LANGUAGE OverloadedStrings #-}

module Main where

import System.IO
import Logo
import qualified GoogleAPI as GAPI
import qualified JsonParser as JP
import qualified Data.Text as T

{- Function to grab origin input from user -}
getOriginFromUser :: IO String
getOriginFromUser = do
 putStrLn "Where are you leaving from?:"
 origin <- getLineFixed
 return origin

{- Function to grab destination input from user -}
getDestFromUser :: IO String
getDestFromUser = do
 putStrLn "Where would you like to go?:"
 dest <- getLineFixed
 return dest

{- Function to remove delete characters from user input -}
getLineFixed =
   do
     line <- getLine
     return (fixdel line)

{- Helper function for getLineFixed -}
fixdel st
   | '\DEL' `elem` st = fixdel (remdel st)
   | otherwise = st
remdel ('\DEL':r) = r
remdel (a:'\DEL':r) = r
remdel (a:r) = a: remdel r

{- Function to ask user if he/she wants to do another search -}
askRestart :: IO String
askRestart = do
 putStrLn "Would you like to do another search? (y/n):"
 response <- getLineFixed
 return response

{- Function to get the first Route from list of Routes -}
unshellRoute :: [JP.Route] -> JP.Route
unshellRoute (h:t) = h

{- Function to get the first Leg from list of Legs -}
unshellLeg :: [JP.Leg] -> JP.Leg
unshellLeg (h:t) = h

{- Function to print the arrival time from Leg -}
printArrivalTime :: JP.Leg -> IO ()
printArrivalTime leg = putStrLn("Arrival time: " ++ (T.unpack (JP.arrivalTime (leg))))

{- Function to print the departure time from Leg -}
printDepartureTime :: JP.Leg -> IO ()
printDepartureTime leg = putStrLn("Departure time: " ++ (T.unpack (JP.departureTime (leg))))

{- Function to print the duration from Leg -}
printDuration :: JP.Leg -> IO ()
printDuration leg = putStrLn("Duration: " ++ (T.unpack (JP.duration (leg))))

{- Function to print instructions from list of Steps -}
printSteps :: [JP.Step] -> IO ()
printSteps steps = putStrLn("Instruction: " ++ "\n" ++ (stepsToString 1 steps))

{- Helper function to pretty print instruction -}
stepsToString :: Int -> [JP.Step] -> [Char]
stepsToString _ [] = ""
stepsToString n (h:t) = (((show n) ++ ". "++ (T.unpack(JP.instruction (h)))) ++ "\n") ++ (stepsToString (n+1) t)

{- Function to print a new line -}
printNewLine :: IO ()
printNewLine = putStrLn("")

{- Function for inital menu -}
initMenu :: IO()
initMenu = do
  origin <- getOriginFromUser
  dest <- getDestFromUser
  if (origin /= "" && dest /= "") then do
    route <- GAPI.getDirectionFromFile origin dest
    let leg = unshellLeg ((JP.legs (unshellRoute route)))

    printNewLine
    printDuration leg
    printDepartureTime leg
    printArrivalTime leg
    printNewLine
    printSteps (JP.steps leg)

    response <- askRestart

    if response == "y" then (do
      printNewLine
      initMenu)
    else if response == "n" then (do
      printNewLine
      putStrLn("Exiting.")
      return ())
    else (do
      printNewLine
      putStrLn("Invalid input. Exiting."))

  else do
    putStrLn("Invalid input. Please try again.")
    printNewLine
    initMenu

{- Main function -}
main :: IO()
main = do
 hSetBuffering stdout NoBuffering
 putStrLn logo
 initMenu