# Quest Warden

This is a rough, self-hosted app designed to make tracking game-related things fun.
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

## Database Seeds
The projecct includes a rake task that will import a small collection of game information from IGDB and dump it into your database.  Run `bundle exec rake data:import_games` once you've completed the "getting started" section above.

## Features
Feature set is currently very limited as this is an early, WIP build.  See: https://github.com/kmagameguy/igdb_client for IGDB Client usage.

To run the app just use bin/rails server.  Go to 127.0.0.1:3000/games to view the games index.  You can also view individual games by id, for example: /games/1204

Trying to view a game that doesn't yet exist in the application database will automatically try to import the relevant data from the IGDB (if a matching ID can be found).