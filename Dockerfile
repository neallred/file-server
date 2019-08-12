# BUILD STATIC FILE SERVER
FROM debian:buster as build
WORKDIR /server-mount
RUN apt-get update && apt-get install -y \
  curl \
  git \
  && \
  curl https://get.haskellstack.org/ | sh && \
  apt-get remove -y curl && \
  rm -rf /var/lib/apt/lists/*
RUN git clone https://github.com/neallred/file-server.git
WORKDIR file-server
RUN git pull && apt-get remove -y git
# build backend before static assets. They are less likely to change
RUN stack build --copy-bins --local-bin-path ./ && rm -rf ~/.stack && rm -rf .stack-work

# STATIC FILE BUILD
RUN ls static/index.html || mkdir static && echo '<html>\n<head>\n</head>\n<body>\n<h1>Index file for static file server. Replace with your own content.</h1>\n</body></html>' > static/index.html

# ASSEMBLE FINAL IMAGE
FROM debian:buster
RUN mkdir /server-mount
COPY --from=build /server-mount/file-server/file-server /server-mount/server
COPY --from=build /server-mount/file-server/static /server-mount/static
WORKDIR server-mount/

# RUN STATIC SERVER
CMD ["./server"]
