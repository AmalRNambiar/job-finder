FROM ruby:2.7.0
ENV BUNDLER_VERSION=2.1.4
RUN apt-get install \
      binutils-gold \
      build-base \
      curl \
      file \
      g++ \
      gcc \
      git \
      libstdc++ \
      libffi-dev \
      libc-dev \
      linux-headers \
      libxml2-dev \
      libxslt-dev \
      libgcrypt-dev \
      make \
      netcat-openbsd \
      openssl \
      pkgconfig \
      postgresql-dev \
      tzdata \

RUN gem install bundler -v 2.1.4
WORKDIR /app
COPY Gemfile Gemfile.lock ./
RUN bundle check || bundle install
RUN rails webpacker:install
RUN rails webpacker:install:react
COPY . ./
RUN chmod +x ./entrypoints/docker-entrypoint.sh && chmod +x ./init.sql && chmod +x ./entrypoints/sneaker-entrypoint.sh

ENTRYPOINT ["./entrypoints/docker-entrypoint.sh"]


