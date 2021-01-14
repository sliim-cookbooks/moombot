# moombot CHANGELOG

This file is used to list changes made in each version of the moombot cookbook.

## 2.1.0
- Use `node[languages][ruby]` attributes for ruby/gem paths
- Don't install ruby in default recipe
- Add `moombot::ruby` recipe to install ruby if missing
- Update Ubuntu platforms
- Remove foodcritic

## 2.0.1
- Use absolute path in systemd service

## 2.0.0
- Removed recipes, keep only the default recipe
- Install ruby instead of using embedded ruby in Chef
- Install gems system-wide
- Updated moombot_plugin resource
- Improved configuration template

## 1.1.0
- CI Improvements
- Chef13 compatibility
- Improved Cinch SSL configuration
- Do not include moombot::configuration for plugins

## 1.0.0
- Initial public release of moombot

## 0.1.0
- PoC / Development of moombot
