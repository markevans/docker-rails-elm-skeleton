FROM ruby:2.4.1

# apt-get packages
RUN apt-get update -qq \
    && apt-get install -y build-essential libpq-dev

# Node.js
RUN curl -sL https://deb.nodesource.com/setup_7.x | bash - \
    && apt-get install -y nodejs

# Yarn
RUN apt-get install -y apt-transport-https \
    && curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
    && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
    && apt-get update -qq \
    && apt-get install -y yarn

ENV APP_DIR /app
RUN mkdir $APP_DIR
WORKDIR $APP_DIR

# Bundler
COPY Gemfile Gemfile
COPY Gemfile.lock Gemfile.lock
RUN bundle install

# Yarn
ADD package.json package.json
ADD yarn.lock yarn.lock
RUN yarn install --modules-folder /tmp/node_modules

# Code
COPY . .

ARG PRECOMPILE_ASSETS
RUN if [ "$PRECOMPILE_ASSETS" ]; then bundle exec rake assets:precompile; fi

EXPOSE 3000

CMD ["bundle", "exec", "rails", "s", "-p", "3000", "-b", "0.0.0.0"]
