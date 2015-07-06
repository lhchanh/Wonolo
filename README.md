    ,----,------------------------------,------.
    | ## |            WONOLO            |    - |
    | ## |                              |    - |
    |    |------------------------------|    - |
    |    ||............................||      |
    |    ||,-                        -.||      |
    |    ||___                      ___||    ##|
    |    ||---`--------------------'---||      |
    `----'|_|______________________==__|`------'

# Development

### Installation

1. `git clone git@github.com:lhchanh/Wonolo.git && cd Wonolo`
2. `cp config/database.example.yml config/database.yml` _(fill in your credentials)_
3. `bundle install`
4. `rake db:create db:migrate`

# Running tests

* `bundle exec rspec`

# Deploy to Heroku:

`git push heroku master`