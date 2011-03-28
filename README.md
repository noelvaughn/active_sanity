# Active Sanity

Perform a sanity check on your database through active record
validation.

## Install

Add the following line to your Gemfile

    gem 'active_sanity'

If you wish to store invalid records in your database run:

    $ rails generate active_sanity
    $ rake db:migrate

## Usage

Just run:

    rake db:sanity_check

ActiveSanity will iterate over every records of all your models to check
weither they're valid or not. It will save invalid records in the table
invalid_records if it exists and output all invalid records.

The output might look like the following:

    model       | id  | errors
    User        |   1 | { "email" => ["is invalid"] }
    Flight      | 123 | { "arrival_time" => ["can't be nil"], "departure_time" => ["is invalid"] }
    Flight      | 323 | { "arrival_time" => ["can't be nil"] }
