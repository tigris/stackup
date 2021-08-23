FROM ruby:2.6-alpine@sha256:eb71c962ac76ca7ec94a3ec2a1afacae1916962813a480efcf7490af756db79c as build

WORKDIR /app
COPY bin /app/bin
COPY lib /app/lib
COPY spec /app/spec
COPY README.md /app/
COPY CHANGES.md /app/
COPY LICENSE.md /app/
COPY stackup.gemspec /app/
RUN gem build stackup.gemspec

FROM ruby:2.6-alpine@sha256:eb71c962ac76ca7ec94a3ec2a1afacae1916962813a480efcf7490af756db79c

MAINTAINER https://github.com/realestate-com-au/stackup

COPY --from=build /app/stackup-*.gem /tmp/

RUN apk --no-cache add diffutils \
 && gem install /tmp/stackup-*.gem \
 && rm -f /tmp/stackup-*.gem \
 && rm -rf /usr/local/bundle/gems/stackup-*/{spec,*.md}

WORKDIR /cwd
ENTRYPOINT ["stackup"]
