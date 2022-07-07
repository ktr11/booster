FROM ruby:3.0.2
RUN apt-get update -qq && \
  apt-get install -y \
  nodejs \
  default-mysql-client \
  yarn \
  chromium-driver
RUN mkdir /booster
WORKDIR /booster
COPY Gemfile /booster/Gemfile
COPY Gemfile.lock /booster/Gemfile.lock
RUN gem install bundler
RUN bundle install
COPY . /booster
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000
CMD ["rails", "server", "-b", "0.0.0.0"]
