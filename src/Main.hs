{-# LANGUAGE OverloadedStrings #-}

module Main where

import Network.Wai.Application.Static
import Network.Wai.Handler.Warp (run)

port = 3000

-- Front end build process can be anything,
-- as long as it ends up in static
-- with the entry point as index.html
staticPath = "./static"

main =
  run
    port
    (staticApp (defaultFileServerSettings staticPath) --
     )
