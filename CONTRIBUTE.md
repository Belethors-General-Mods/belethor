# Contributing
TODO see https://github.com/Belethors-General-Mods/belethor/issues/33

## Basics
The git master branch is protected, do your changes a branch called 'feature/<feature-name>'.
We have automatic checks on your pull request, make them green if you want PR to be merged.

## Frontend
We have two apps, that need designing. There are design mockups, logos from Zaki, here: TODO
That whole design thing is very much in an concept phase, join our [Discord Server](https://discord.gg/4ezeRgn) to discuss design improvement / concept.
Also we lack github checks to do quality assurance on HTML, CSS and JS (feel free to recommend us some).

## Server Side Logic

We target the following versions of Elixir and OTP: 
 - [Elixir](https://elixir-lang.org/): `1.7`, `1.8`.
 - [OTP](https://github.com/erlang/otp): `21.1`, `21.2`.
 
The checks on elixir code are:
 - Compile without warnings
 - keep at least 80% of your code covered with tests
 - the new unit tests and the old tests should still pass.
 - dialyzer should not complain
 - code needs to have consistent formatted (`mix format` does that for you)
See `.travis.yml` how these tests are run, you can run them easily on your on machine, before committing.

## something unclear?
If you don't get something here, join our [Discord Server](https://discord.gg/4ezeRgn) and ask in '#support'.
