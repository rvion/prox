module Opts where

import Options.Applicative

data Opts = Opts
  { port :: Int
  , redir_url :: String
  , redir_port :: Int
  , verbose :: Bool
  , fast :: Bool
  }

sample :: Parser Opts
sample = Opts
     <$> option auto
         ( long "port"
        <> short 'p'
        <> metavar "PORT"
        <> help "listening port" )
     <*> strOption
         ( long "redir-url"
        <> short 'x'
        <> help "url to redirect to" )
     <*> option auto
         ( long "redir-port"
        <> short 'y'
        <> help "port to redirect to" )
     <*> switch
         ( long "verbose"
        <> short 'v'
        <> help "add some loging" )
     <*> switch
         ( long "fast"
        <> short 'f'
        <> help "" )
