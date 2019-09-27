# Contributing

## Basics
The git master branch is protected; do your changes a branch called 'feature/<feature-name>', or in a fork if you don't have commit permissions.
We have automatic checks on all pull requests. Please make an effort to get them to pass.
If you want to do large changes, you should discuss them with us in an issue or on discord first.

## Frontend Design
We have two apps that need designing. There are design [mockups](https://belethors-general-mods.github.io/belethor/website_mockups.html) from Zaki. The whole design things are [here](https://github.com/Belethors-General-Mods/belethor/tree/feature/design/apps/website/assets/design)
That whole design thing is very much in the concept phase; please join our [Discord Server](https://discord.gg/4ezeRgn) to discuss design improvement & concepts.
Also, we currently lack github checks to do quality assurance on HTML, CSS, and JS (feel free to recommend some).

## Travis
We target the following versions of Elixir and OTP when building on Travis CI:
 - [Elixir](https://elixir-lang.org/): `1.7`, `1.8`
 - [OTP](https://github.com/erlang/otp): `21.2`, `21.3`, `22.0`

Travis checks that:
 - code compiles without warnings
 - at least 80% of the code is covered with tests
 - all tests are passing
 - dialyzer does not complain
 - code has been formatted by `mix format`
See `.travis.yml` to see how these tests are run.
You can run them easily on your on machine before committing.

## Get in Touch
We're always looking for new contributors. If you want to help out in any way
(or you just have questions), please join our [Discord Server](https://discord.gg/4ezeRgn)!
