# file-server
Static file server, in Haskell.

It is deliberately left totally open ended on how to produce the static assets.
As long as they end up in a folder named "static" in the root of the repo, they will be served.
If an index.html file is present at the root, it will be served by default.
