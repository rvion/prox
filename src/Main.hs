{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE RecordWildCards #-}

module Main where

import qualified Data.ByteString.Char8 as BS
import Network.HTTP.ReverseProxy
import Data.Conduit.Network

import Options.Applicative
import Opts

main :: IO ()
main = execParser opts >>= app
  where
    opts = info (helper <*> sample)
      ( fullDesc
     <> progDesc "Print a greeting for TARGET"
     <> header "hello - a test for optparse-applicative" )

app :: Opts -> IO ()
app (Opts{..}) = runTCPServer (serverSettings port "*") $ \appData ->
    rawProxyTo
        (\_headers -> return $ Right $ ProxyDest (BS.pack redir_url) redir_port)
        appData