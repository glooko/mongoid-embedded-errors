# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/), and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]
- TODO

## [v3.0.0] - 2020-09-29
### Added
- Started 🔎 tracking changes in a changelog!
- Mongoid 7 support
- Ruby 2.4 support by using `send` instead of `public_send` [#18]

### Removed
- Mongoid 3 support

### Fixed
- Updated style to fix Rubocop issues (as per included .rubocop.yml configuration file)
- Removed .lock files as these are not supposed to be included with gem source code

[Unreleased]: https://github.com/glooko/mongoid-embedded-errors/compare/v3.0.0...HEAD
[v3.0.0]: https://github.com/glooko/mongoid-embedded-errors/compare/f1ce0d8ed140de86c894b2fad7ad197504fefd5a...v3.0.0