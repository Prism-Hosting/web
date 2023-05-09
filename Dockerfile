FROM ruby:alpine AS rb
RUN apk update && apk add --no-cache postgresql-dev build-base libffi-dev nodejs tzdata sassc vips-dev
COPY Gemfile* ./
RUN gem update --system && gem install bundler
RUN bundle config frozen true \
    && bundle config jobs 4 \
    && bundle config deployment true \
    && bundle config without 'development test' \
    && bundle install
ENV RAILS_ENV=production \
    SECRET_KEY_BASE=buildingassets
ADD . .
RUN bundle exec rails assets:clobber && bundle exec rails assets:precompile


FROM ruby:alpine

RUN apk update && apk add --no-cache postgresql-client tzdata vips-dev

WORKDIR /prism

RUN gem update --system && gem install bundler

RUN bundle config --local frozen true \
    && bundle config --local jobs 4 \
    && bundle config --local deployment true \
    && bundle config --local without 'development test'

ADD . .

COPY --from=rb vendor/bundle vendor/bundle
COPY --from=rb public/assets public/assets
COPY docker-entrypoint.sh /bin/

RUN chgrp -R 0 /prism && \
    chmod -R g=u /prism

ENV RAILS_ENV=production \
    RAILS_SERVE_STATIC_FILES=true \
    RAILS_LOG_TO_STDOUT=true

VOLUME /prism/storage

ENTRYPOINT ["docker-entrypoint.sh"]
EXPOSE 3000
CMD ["bundle" "exec", "rails", "server", "--binding", "0.0.0.0"]
