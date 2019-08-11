FROM debian:buster as build
WORKDIR /file-server
RUN apt-get update && apt-get install -y \
  curl \
  git \
  && \
  curl https://get.haskellstack.org/ | sh
RUN git clone https://github.com/neallred/file-server.git
WORKDIR file-server
RUN git pull
# build backend before static assets. They are less likely to change
RUN stack build --copy-bins --local-bin-path /static-file-server/

# frontend build 
RUN ls static/index.html || mkdir static && echo '<html>\n<head>\n</head>\n<body>\n<h1>Index file for static file server. Replace with your own content.</h1>\n</body></html>' > static/index.html

FROM debian:buster
COPY --from=build /static-file-server/file-server .
COPY --from=build /static-file-server/static .
EXPOSE 3000
CMD ["./file-server"]
