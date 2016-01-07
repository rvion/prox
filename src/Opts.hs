module Opts where

import Options.Applicative

data Opts = Opts
  { port :: Int
  , redir_port :: Int
  , redir_url :: String
  , verbose :: Bool
  }

sample :: Parser Opts
sample = Opts
     <$> option auto
         ( long "port"
        <> short 'p'
        <> metavar "PORT"
        <> help "listening port" )
     <*> option auto
         ( long "redir-port"
        <> short 'x'
        <> help "port to redirect to" )
     <*> strOption
         ( long "redir-url"
        <> short 'y'
        <> help "url to redirect to" )
     <*> switch
         ( long "verbose"
        <> short 'v'
        <> help "add some blablablablabla" )