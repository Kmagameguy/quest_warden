# Game App

This is a rough app designed to make tracking game-related things fun.
Track your backlog, grow your wishlist, and rate/review your games.
WIP and unstable at the moment.

## Pre-requisites
You will need:
1. A Twitch account with 2FA enabled
1. A Twitch client_id and client_secret (see twitch developer account)

## Getting Started
1. Clone this repo
1. Install Visual Studio Code
1. Install the Dev Containers extension
1. Open the repo in Visual Studio Code
1. Build the new devcontainer when prompted
1. Make a copy of `.env` and rename it `.env.development.local`
1. Override the template values in `.env.development.local` with your client_id and client_secret

## Features
Feature set is currently very limited as this is an early, WIP build.  Examples:

```ruby
client = Igdb::ApiClient.new
client.get(:games)
=> # Returns an array of OpenStruct data sets for 10 games with all fields included

client.get(:games, { fields: "name"})
=> # Returns an array of OpenStruct data sets for 10 games with only the "name" field included

client.get(:games, { id: 131913 })
=> # Returns an OpenStruct data set for the specified game with all fields included

client.get(:games, { id: 131913, fields: "name" })
=> # Returns an OpenStruct data set for the specified game with only the "name" field included
```

Other endpoints work the same.  See `app/services/igdb/api_client.rb` for the list of available endpoints.  Requesting a non-existent endpoint will return an error.

