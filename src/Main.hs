{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE ScopedTypeVariables #-}
{-# LANGUAGE RecordWildCards #-}

module Main where

import qualified Data.ByteString.Char8 as BS
import Network.HTTP.ReverseProxy
import Network.HTTP.Types.Status (statusCode)
import Network.HTTP.Client
import Network.Wai.Handler.Warp (run)
import Data.Conduit.Network (runTCPServer, serverSettings)
import Control.Exception (catch, SomeException)
import Control.Monad (when)
import Control.Concurrent (threadDelay)
import System.IO
import Text.Show.Pretty
import Text.PrettyPrint hiding ((<>))

import Options.Applicative
import Opts

main :: IO ()
main = do
  hSetBuffering stdout NoBuffering
  execParser opts >>= app
  where
    opts = info (helper <*> sample)
      ( fullDesc
     <> progDesc "mini reverse proxy server. support websocket with --fast. Not yet https but should be trivial to implement"
     <> header "prox - command line simple reverse proxy" )

app :: Opts -> IO ()
app opts = if fast opts
  then rawForward opts
  else do
    m <- mkManager
    waiForward opts m


rawForward :: Opts -> IO ()
rawForward (Opts{..}) = runTCPServer (serverSettings port "*") $ \appData ->
    rawProxyTo
        (\_headers -> do
          when verbose (print _headers >> putStrLn "--")
          return $ Right $ ProxyDest (BS.pack redir_url) redir_port)
        appData

waiForward :: Opts -> Manager -> IO ()
waiForward (Opts{..}) m = run port $
  waiProxyTo action defaultOnExc m
  where
    action r = do
      putStrLn "=========="
      waitUntil $ testS m (concat ["http://", redir_url, ":", (show redir_port)])
      putStrLn "--"
      putStrLn $ renderStyle style (ppDoc r)
      return $ WPRProxyDest $ ProxyDest (BS.pack redir_url) redir_port

waitUntil :: IO Bool -> IO ()
waitUntil action = go 10000
  where
    go t = do
      serverIsUp <- action
      if serverIsUp
        then return ()
        else do
          putStrLn $ "it's not yet up, waiting " ++ show (2*t)
          threadDelay (2*t)
          go (2*t)

testS :: Manager -> String -> IO Bool
testS manager url = catch
  (do
    request <- parseUrl url
    response <- httpLbs request manager
    putStrLn $ "The status code was: " ++ (show $ statusCode $ responseStatus response)
    return True)
  (\(_ :: SomeException)-> return False)

mkManager :: IO Manager
mkManager = newManager defaultManagerSettings
