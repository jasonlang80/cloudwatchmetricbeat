FROM golang:1.7

# install glide
RUN go get -v github.com/Masterminds/glide \
    && cd $GOPATH/src/github.com/Masterminds/glide \
    && git checkout tags/0.10.2 \
    && go install \
    && cd -

COPY . $GOPATH/src/github.com/narmitech/cloudwatchmetricbeat
RUN cd $GOPATH/src/github.com/narmitech/cloudwatchmetricbeat && make collect && make

RUN mkdir -p /etc/cloudwatchmetricbeat/ \
    && cp $GOPATH/src/github.com/narmitech/cloudwatchmetricbeat/cloudwatchmetricbeat /usr/local/bin/cloudwatchmetricbeat \
    && cp $GOPATH/src/github.com/narmitech/cloudwatchmetricbeat/_meta/beat.yml /etc/cloudwatchmetricbeat/cloudwatchmetricbeat.yml

WORKDIR /etc/cloudwatchmetricbeat
ENTRYPOINT cloudwatchmetricbeat
