FROM jrottenberg/ffmpeg:3.2

ENV RUBY_MAJOR 2.1
ENV RUBY_VERSION 2.1.10

# some of ruby's build scripts are written in ruby
# we purge this later to make sure our final image uses what we just built
RUN apt-get update && apt-get install -y \
      autoconf \
      build-essential \
      imagemagick \
      libbz2-dev \
      libcurl4-openssl-dev \
      libevent-dev \
      libffi-dev \
      libglib2.0-dev \
      libjpeg-dev \
      liblzma-dev \
      libmagickcore-dev \
      libmagickwand-dev \
      libmysqlclient-dev \
      libncurses-dev \
      libpq-dev \
      libreadline-dev \
      libsqlite3-dev \
      libssl-dev \
      libxml2-dev \
      libxslt-dev \
      libyaml-dev \
      zlib1g-dev \
      bison \
      libgdbm-dev \
      curl \
      && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /usr/src/ruby \
      && curl -fSL -o ruby.tar.gz "http://cache.ruby-lang.org/pub/ruby/$RUBY_MAJOR/ruby-$RUBY_VERSION.tar.gz" \
      && tar -xzf ruby.tar.gz -C /usr/src/ruby --strip-components=1 \
      && rm ruby.tar.gz \
      && cd /usr/src/ruby \
      && autoconf \
      && ./configure --disable-install-doc \
      && make -j"$(nproc)" \
      && make install \
      && apt-get purge -y --auto-remove bison libgdbm-dev \
      && rm -r /usr/src/ruby

# skip installing gem documentation
RUN echo 'gem: --no-rdoc --no-ri' >> "$HOME/.gemrc"

ENV BUNDLER_VERSION 1.10.3

RUN gem install bundler --version "$BUNDLER_VERSION"

ENTRYPOINT []
