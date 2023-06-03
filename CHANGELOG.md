# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.1.11]

### Changed

- Remove unnecessary E2E test fragment that broke when updating npm dependencies
- Upgrade npm dependencies:
  - @alpinejs/collapse: 3.12.1 -> 3.12.2
  - @alpinejs/focus: 3.12.1 -> 3.12.2
  - @playwright/test: 1.33.0 -> 1.34.3
  - alpinejs: 3.12.1 -> 3.12.2
  - daisyui: 2.52.0 -> 3.0.1
  - jsdom: 22.0.0 -> 22.1.0
  - typescript: 5.0.4 -> 5.1.3
  - vitest: 0.31.0 -> 0.31.4

## [0.1.10]

### Fixed

- Upgrade mix dependencies:
  - floki: 0.34.2 -> 0.34.3
  - flop_phoenix: 0.18.2 -> 0.19.0
  - heroicons: 0.5.2 -> 0.5.3
  - phoenix_live_view: 0.18.3 -> 0.19.0
  - phoenix_live_dashboard: 0.7.2 -> 0.8.0

## [0.1.9]

### Fixed

- In Todos index, do not show Todos that belong to another user.

## [0.1.8]

### Changed

- Use modified container deployment strategy

## [0.1.7]

### Changed

- New users no longer receive a confirmation email during registration.
- The description of this project in the 'Terms Of Use' section has been updated.

## [0.1.6]

### Changed

- Started keeping a changelog :)
- The maximum width of the page elements has been limited, allowing the UI to be read comfortably on larger screens.
