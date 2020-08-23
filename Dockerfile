FROM ruby:2.6.5-alpine

LABEL "org.gusrub.vendor"="Gustavo Adolfo Rubio Casillas"
LABEL "com.gusrub.maintainer"="Gustavo Rubio <mail@gustavorub.io>"
LABEL "com.gusrub.product"="Wallet API"
LABEL "version"="1.0"
LABEL "description"="This is a sample application written in ruby on rails to showcase a demo of an e-wallet REST API where customers can transfer money between wallets or deposit/withdraw to a credit or debit card."

ARG RAILS_ENV="development"
ENV RAILS_ENV=$RAILS_ENV
ENV RACK_ENV=$RAILS_ENV

RUN apk update && apk add --no-cache build-base libxml2-dev libxslt-dev wget bash tzdata postgresql-dev libpq openssh git tar file php7 php7-xml php7-simplexml
RUN mkdir /app
WORKDIR /app

COPY Gemfile ./Gemfile
COPY Gemfile.lock ./Gemfile.lock

RUN gem install bundler
RUN bundle install -j 4
RUN bundle exec rails db:drop db:create db:migrate
COPY . .

EXPOSE 3000 8080

HEALTHCHECK --interval=1m --timeout=5s CMD wget -S --spider -q localhost:3000 || exit 1

COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh

CMD ["bundle", "exec", "puma", "-C", "/app/config/puma.rb"]
ENTRYPOINT ["entrypoint.sh"]
