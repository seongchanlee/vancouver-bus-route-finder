{-# LANGUAGE CPP #-}
{-# LANGUAGE NoRebindableSyntax #-}
{-# OPTIONS_GHC -fno-warn-missing-import-lists #-}
module Paths_vancouver_bus_route_finder (
    version,
    getBinDir, getLibDir, getDynLibDir, getDataDir, getLibexecDir,
    getDataFileName, getSysconfDir
  ) where

import qualified Control.Exception as Exception
import Data.Version (Version(..))
import System.Environment (getEnv)
import Prelude

#if defined(VERSION_base)

#if MIN_VERSION_base(4,0,0)
catchIO :: IO a -> (Exception.IOException -> IO a) -> IO a
#else
catchIO :: IO a -> (Exception.Exception -> IO a) -> IO a
#endif

#else
catchIO :: IO a -> (Exception.IOException -> IO a) -> IO a
#endif
catchIO = Exception.catch

version :: Version
version = Version [0,1,0,0] []
bindir, libdir, dynlibdir, datadir, libexecdir, sysconfdir :: FilePath

bindir     = "/Users/seongchanlee/Library/Haskell/bin"
libdir     = "/Users/seongchanlee/Library/Haskell/ghc-8.4.3-x86_64/lib/vancouver-bus-route-finder-0.1.0.0"
dynlibdir  = "/Users/seongchanlee/Library/Haskell/ghc-8.4.3-x86_64/lib/x86_64-osx-ghc-8.4.3"
datadir    = "/Users/seongchanlee/Library/Haskell/share/ghc-8.4.3-x86_64/vancouver-bus-route-finder-0.1.0.0"
libexecdir = "/Users/seongchanlee/Library/Haskell/libexec/x86_64-osx-ghc-8.4.3/vancouver-bus-route-finder-0.1.0.0"
sysconfdir = "/Users/seongchanlee/Library/Haskell/etc"

getBinDir, getLibDir, getDynLibDir, getDataDir, getLibexecDir, getSysconfDir :: IO FilePath
getBinDir = catchIO (getEnv "vancouver_bus_route_finder_bindir") (\_ -> return bindir)
getLibDir = catchIO (getEnv "vancouver_bus_route_finder_libdir") (\_ -> return libdir)
getDynLibDir = catchIO (getEnv "vancouver_bus_route_finder_dynlibdir") (\_ -> return dynlibdir)
getDataDir = catchIO (getEnv "vancouver_bus_route_finder_datadir") (\_ -> return datadir)
getLibexecDir = catchIO (getEnv "vancouver_bus_route_finder_libexecdir") (\_ -> return libexecdir)
getSysconfDir = catchIO (getEnv "vancouver_bus_route_finder_sysconfdir") (\_ -> return sysconfdir)

getDataFileName :: FilePath -> IO FilePath
getDataFileName name = do
  dir <- getDataDir
  return (dir ++ "/" ++ name)
