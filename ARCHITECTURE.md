# Architecture
This document describes belethor's software architecture at a high level.
We use [OTP](https://github.com/erlang/otp) apps, written in Elixir.
[Distillery](https://github.com/bitwalker/distillery) will be used to create releases.

## Database
This app is the database client, and is located at `apps/database`.
It is meant to manage the mod list information.


## Website
A Phoenix app which acts as the main public frontend.
Reads mod info from Database, and serves it nicely rendered for human consumption.
We have some design mockups, but currently that is about it.
You can find the mockups in `guides/website/website_mockups.md`.

## Crawler
Crawler isn't really a crawler :|.
We found no better name last time we talked about it. Feel free to make suggestions.
It acts more API client to access information from providers.
Planned providers are:
 * [Steam Workshop](https://steamcommunity.com/workshop/browse/?appid=72850)
 * [bethesda.net](https://bethesda.net/en/mods/skyrim)
 * [Nexus Mods](https://www.nexusmods.com/)

## Tag Editor
Another Phoenix app, meant to be used by mod list curators.
It will be basically a set of webforms used to enter mods and mod lists into the database.
Crawler helps streamline this by searching for metadata on all configured providers.

## Common
Unlike the others, Common is not an OTP app, but rather a way to share code between the apps.
Shared code includes data structures used by multiple apps or useful macros.
