ARG KRAKEND_VERSION=2.11.0
ARG GO_VERSION=1.25.1
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

COPY ./entrypoint.sh /
ENV KRAKEND_KCL_FILE ""

EXPOSE 8000 8090
ENTRYPOINT ["/entrypoint.sh"]
CMD [ "run", "-c", "/etc/krakend/krakend.json" ]