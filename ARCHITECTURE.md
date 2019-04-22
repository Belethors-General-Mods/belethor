# Architecture
This file should give you a idea, how belethors software architecture looks like.
We run [OTP](https://github.com/erlang/otp) apps, written in Elixir.
[Distillery](https://github.com/bitwalker/distillery) will be used to create releases.

## Database
This app is database client.
It is meant to hold the mod list information.
We plan to publish this databases full backups, to allow reviving this project like we did to G.E.M.S.
The question where to publish the backups has not be answered yet, maybe at archive.org?
This also means there can be no confidential data in here.

## Website
A phoenix app, which acts as public frontend.
Reads mod info from Database, and serves nicely rendered.
We have some design mockups, but that is about it.

## Crawler
Is not really a crawler :|.
We found no better name, last time we talked about it. Feel free to make suggestions.
More API client to access providers, if an API is not there we scrap.
Planned providers are:
 * [Steam Workshop](https://steamcommunity.com/workshop/browse/?appid=72850)
 * [bethesda.net](https://bethesda.net/en/mods/skyrim)
 * [Nexus Mods](https://www.nexusmods.com/)

## Tag Editor
Another phoenix app.
It is meant to be used by mod list curators.
It will be basically a set of webforms, to write mod lists into Database.
Crawler helps searching on all configured providers.

## Common
Is not OTP app, but rather a way to share code between the apps.
Like data structures used by multiple apps or useful macros.

