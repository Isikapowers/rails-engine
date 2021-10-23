# rails-engine

## Table of contents
* [Description](#description)
* [Learning Goals](#learning-goals)
* [Requirements](#requirements)
* [Database Schema](#database-schema)
* [Setup](#setup)
* [Live App](#live-app)
* [Tools Used](#tools-used)
* [Contributors](#contributors)

## Description

"Rails Engine" is a Rails-based API which mimics an e-commerce platform reporting tool as an API. Users can query and store merchants and items, and retrieve information about an item's merchant, or a list of a merchant's items. Users can also run one of several "business intelligence" endpoints to do rich reporting using ActiveRecord queries.

## Learning Goals
- Practice building API endpoints for both RESTFUL and non-RESTFUL.
- Utilize Postman
- Utilize advanced ActiveRecord techniques to perform complex database queries.

## Requirements
- Rails 5.2.5
- Ruby 2.7.2
- PostgreSQL
- Test all feature and model code
- JSONAPI
- Postman

## Database Schema
<img width="599" alt="Screen Shot 2021-10-20 at 3 11 09 PM" src="https://user-images.githubusercontent.com/72399033/138172813-e892a835-7389-4e37-a70d-247b65ddc249.png">

## Setup
* Fork this repository
* Clone your fork
* [API Key from the movie database](https://developers.themoviedb.org/4/auth/user-authorization-1) is required
* From the command line, install gems and set up your DB:
    * `bundle install`
    * `rails db:{create,migrate}`
* Run the test suite with `bundle exec rspec`.
* Run your development server with `rails s` to see the app in action.

## Live App
[Link to Heroku deployment](https://viewing-party-denver.herokuapp.com)

## Tools Used

| Development    |  Testing             |
| :-------------:| :-------------------:|
| Ruby 2.7.2     | SimpleCov            |
| Rails 5.2.6    | Pry                  |
| Atom           | Launchy              |
| Git            | Orderly              |
| Github         | Factorybot/Faker     |
| Github Project | Postman              |
| Postico        | RSpec                |


## Contributors

- [Isika Powers](https://github.com/Isikapowers/)
