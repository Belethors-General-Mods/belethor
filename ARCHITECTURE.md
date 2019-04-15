# Architecture
This file should give you a idea, how belethors software architecture looks like.
We run [OTP](https://github.com/erlang/otp) apps(./apps), written in elixir.
[Distillery](https://github.com/bitwalker/distillery) will be used to create releases.

## Website
A phoenix app, which acts as public frontend.
We have some design mockups, but that is about it.

## Database
This app is database client.

## Tag Editor
Another phoenix app.

## Crawler
Is not a full crawler :|.
More API client to access providers.
Planned providers are:
 * [Steam Workshop](https://steamcommunity.com/workshop/browse/?appid=72850)
 * [bethesda.net](https://bethesda.net/en/mods/skyrim)
 * [Nexus Mods](https://www.nexusmods.com/)

## Common
Is not OTP app, but rather a way to share code between the apps.

## Website
[phoenix](https://phoenixframework.org/).
