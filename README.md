# rails-engine ![Travis CI](https://app.travis-ci.com/Isikapowers/rails-engine.svg?branch=main)

## Table of contents
* [Description](#description)
* [Learning Goals](#learning-goals)
* [Requirements](#requirements)
* [Database Schema](#database-schema)
* [API Endpoints](#api-endpoints)
* [Setup](#setup)
* [Live App](#live-app)
* [Tools Used](#tools-used)
* [Contributors](#contributors)

## Description

"Rails Engine" is a Rails-based API which mimics an e-commerce platform (based on [Little Esty Shop Repo](https://github.com/Isikapowers/little-esty-shop.git) reporting tool as an API. Users can query and store merchants and items, and retrieve information about an item's merchant, or a list of a merchant's items. Users can also run one of several "business intelligence" endpoints to do rich reporting using ActiveRecord queries.

## Learning Goals
- Practice building API endpoints for both RESTFUL and non-RESTFUL.
- Practice using serializer.
- Utilize Postman
- Utilize advanced ActiveRecord techniques to perform complex database queries.

## Requirements
- Rails 5.2.5
- Ruby 2.7.2
- PostgreSQL
- JSONAPI::Serializer
- Postman

## Database Schema
![Schema](https://user-images.githubusercontent.com/72399033/134418403-99e1a24c-11fb-442c-a682-01e86095ba7d.png)

## API Endpoints

|   HTTP   |                        Route                            |                     Description                      |
| :-------:| :-----------------------------------------------------: | :--------------------------------------------------: |
| GET      | /api/v1/merchants	                                    | Get all merchants (default 20 per page)              |
| GET      | /api/v1/merchants?per_page=number&page=number           | Get all merchants using pagination                   |
| GET      | /api/v1/merchants/id	                                 | Get one merchant by id                               |   
| GET      | /api/v1/merchants/id/items                              | Get all items for one merchant by id                 |
| GET      | /api/v1/merchants/find?name=text                        | Get merchant by name                                 |
| GET      | /api/v1/merchants/find_all?name=text                    | Get all merchants by name                            |
| GET      | /api/v1/items                                           | Get all items (default 20 per page)                  |
| GET      | /api/v1/items?per_page=number&page=number               | Get all items using pagination                       |
| GET      | /api/v1/items/id                                        | Get one item by id                                   |
| POST     | /api/v1/items                                           | Create an item                                       |
| PATCH    | /api/v1/items/id                                        | Update an item                                       |
| DELETE   | /api/v1/items/id                                        | Delete an item                                       |
| GET      | /api/v1/items/id/merchant                               | Get an item's merchant                               |
| GET      | /api/v1/items/find?name=text                            | Get item by name                                     |
| GET      | /api/v1/items/find?min_price=number                     | Get item by minumum price                            |
| GET      | /api/v1/items/find?max_price=number                     | Get item by maximum price                            |
| GET      | /api/v1/items/find?min_price=number&max_price=number    | Get item by price range                              |
| GET      | /api/v1/items/find_all?name=text.                       | Get all items by name                                |
| GET      | /api/v1/revenue/merchants?quantity=number               | Get x amount of merchants by most revenue            |
| GET      | /api/v1/merchants/most_items?quantity=number            | Get x amount of merchants by most items              |
| GET      | /api/v1/revenue/merchants/id                            | Get revenue for a merchant by id                     |
| GET      | /api/v1/revenue/items                                   | Get top ten items by revenue                         |
| GET      | /api/v1/revenue/items?quantity=number                   | Get x amount of items by most revenue                |
| GET      | /api/v1/revenue/unshipped                               | Get top ten invoices for unshipped revenue           |
| GET      | /api/v1/revenue/unshipped?quantity=number               | Get x amount of invoices for unshipped revenue       |
| GET      | /api/v1/revenue/weekly                                  | Get revenue by week                                  |

## Setup
* Fork this repository
* Clone your fork
* From the command line, install gems and set up your DB:
    * `bundle install`
    * `rails db:{drop,create,migrate, seed}`
    * `rails db:schema:dump`
* Run the test suite with `bundle exec rspec`.
* Run your development server with `rails s` to see the API app in action.

## Live App
[Link to Heroku deployment](https://rails-engine-denver.herokuapp.com/api/v1)

## Tools Used

| Development    |  Testing             |
| :-------------:| :-------------------:|
| Ruby 2.7.2     | SimpleCov            |
| Rails 5.2.6    | Pry                  |
| Atom           | Launchy              |
| Git            | Travis CI            |
| Github         | Factorybot/Faker     |
| Github Project | Postman              |
| Postico        | RSpec                |


## Contributors

- [Isika Powers](https://github.com/Isikapowers/)
