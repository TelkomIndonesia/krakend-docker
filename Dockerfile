FROM golang:1.24.2 AS krakend 

WORKDIR /src
RUN git clone https://github.com/krakend/krakend-ce 
RUN cd krakend-ce && make build


FROM kcllang/kcl:v0.11.2 AS kcl 

COPY --from=krakend /src/krakend-ce/krakend /usr/local/bin/krakend

WORKDIR /etc/krakend
RUN echo '{ "version": 3 }' > krakend.json

EXPOSE 8000 8090
ENTRYPOINT ["/usr/local/bin/krakend"]
CMD [ "run", "-c", "/etc/krakend/krakend.json" ]