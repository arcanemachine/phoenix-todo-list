# Unit Tests - Vitest

This project uses [`Vitest`](https://vitest.dev/) to manage its Javascript unit tests.

## Initial Setup

NOTE: The commands in this section should be run from the project root directory.

Before you can run the tests, you must ensure that the npm dependencies have been installed:

- Ensure npm is installed. (I recommend using `asdf` to install `npm` if necessary.)
- Navigate to the Javascript root directory for this projects: `cd assets`
- Install the dependencies: `npm install --save-dev`

## Running the Tests

To run this project's Javascript unit tests:

- Run once:
  - `just test-unit`
  - Or, use one of the alternative methods:
    - Navigate to the directory that contains the Javascript-based testing projects and run the tests:
      - `cd assets && npm run test-unit`
    - Or, `support/scripts/test-unit`
- Run in watch mode:
  - `just test-unit-watch`
  - Or, use one of the alternative methods:
    - `support/scripts/test-unit-watch`
    - Or, navigate to the directory that contains the Javascript-based testing projects and run the tests:
      - `cd assets && npm run test-unit-watch`
      - Or, `support/scripts/test-unit-watch`
