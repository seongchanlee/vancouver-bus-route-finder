{-# LANGUAGE OverloadedStrings #-}

module Main where

import System.IO
import qualified GoogleAPI as GAPI
import qualified JsonParser as JP
import qualified Data.Text as T

getOriginFromUser :: IO String
getOriginFromUser = do
 putStrLn "Where are you leaving from?:"
 origin <- getLineFixed
 return origin

getDestFromUser :: IO String
getDestFromUser = do
 putStrLn "Where would you like to go?:"
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

askRestart :: IO String
askRestart = do
 putStrLn "Would you like to do another search? (y/n):"
 response <- getLineFixed
 return response

unshellRoute :: [JP.Route] -> JP.Route
unshellRoute (h:t) = h

unshellLeg :: [JP.Leg] -> JP.Leg
unshellLeg (h:t) = h

printArrivalTime :: JP.Leg -> IO ()
printArrivalTime leg = putStrLn("Arrival time: " ++ (T.unpack (JP.arrivalTime (leg))))

printDepartureTime :: JP.Leg -> IO ()
printDepartureTime leg = putStrLn("Departure time: " ++ (T.unpack (JP.departureTime (leg))))

printDuration :: JP.Leg -> IO ()
printDuration leg = putStrLn("Duration: " ++ (T.unpack (JP.duration (leg))))

printSteps :: [JP.Step] -> IO ()
printSteps steps = putStrLn("Instruction: " ++ "\n" ++ (stepsToString 1 steps))

stepsToString :: Int -> [JP.Step] -> [Char]
stepsToString _ [] = ""
stepsToString n (h:t) = (((show n) ++ ". "++ (T.unpack(JP.instruction (h)))) ++ "\n") ++ (stepsToString (n+1) t)

printNewLine :: IO ()
printNewLine = putStrLn("")

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

main :: IO()
main = do
 initMenu