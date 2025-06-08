ARG KRAKEND_VERSION=2.10.0
ARG GO_VERSION=1.24.2
ARG KCL_VERSION=0.11.2



FROM golang:${GO_VERSION} AS krakend 

ARG KRAKEND_VERSION

WORKDIR /src
RUN git clone https://github.com/krakend/krakend-ce \
    && cd krakend-ce \
    && git checkout v${KRAKEND_VERSION}
RUN cd krakend-ce && make build



FROM kcllang/kcl:v${KCL_VERSION} AS final 

COPY --from=krakend /src/krakend-ce/krakend /usr/local/bin/krakend

WORKDIR /etc/krakend
RUN echo '{ "version": 3 }' > krakend.json

EXPOSE 8000 8090
ENTRYPOINT ["/usr/local/bin/krakend"]
CMD [ "run", "-c", "/etc/krakend/krakend.json" ]