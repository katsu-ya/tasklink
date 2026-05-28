FROM ruby:3.3.10

# 必要パッケージ

RUN apt-get update -qq && apt-get install -y \
build-essential \
libpq-dev \
nodejs \
postgresql-client

# 作業ディレクトリ

WORKDIR /app

# Gem install高速化

COPY Gemfile Gemfile.lock ./
RUN bundle install

# アプリコピー

COPY . .

# ポート

EXPOSE 3000

# Rails起動

CMD ["bin/rails", "server", "-b", "0.0.0.0"]
