# telemetry

This document describes the process of getting a rudimentary (read: hacky and insecure) telemetry frontend service working, powered by [PromEx](https://github.com/akoutmos/prom_ex/) + [Prometheus](https://github.com/prometheus/prometheus) + [Grafana](https://github.com/grafana/grafana).

**Disclaimer: This document is intended as a starting point to get a telemetry service up and running. However, the metrics endpoints are publicly available, and should be secured before deploying to the Internet.**

Note: Because of the insecurity of this setup, this document assumes you are working in a dev environment. For example, the `prometheus.yml` config uses the `http://localhost:4001` endpoint for scraping metrics data.

## Overview

- Elixir and Phoenix have powerful built-in telemetry, powered by the [`telemetry`](https://hexdocs.pm/telemetry/readme.html) Elixir library.
- PromEx exposes built-in and custom telemetry data via an HTTP endpoint that can be consumed by Prometheus, which is a "a monitoring system and time-series database".
- The data from Prometheus is displayed using Grafana, which is an "open and composable observability and data visualization platform".

## Setup Instructions

- These instructions should be run from the same directory as this README (`support/telemetry/`).
- Ensure that you have Docker installed before continuing.

## Setting up PromEx

Follow the instructions in the [PromEx GitHub repo](https://github.com/akoutmos/prom_ex).

Notes:

- When generating the `prom_ex.ex` module, use `prometheus` as the name of your datasource:
  - `mix prom_ex.gen.config --datasource prometheus`

## Setting up Prometheus

- Use the quick-start script `support/telemetry/prometheus` to start a Prometheus container.
  - The `prometheus.yml` file uses the default `http://localhost:4001` URL to access your Phoenix server's metrics
    - If you are using a different URL, modify the `prometheus.yml` file and restart the container after saving your changes.
      - The `prometheus` script stops and start the Prometheus container, so running it is an easy way to restart the container.
- After running this script, the Prometheus server should automatically start scraping your Phoenix server's metrics via PromEx.
  - To ensure that Prometheus is working, you can navigate to `http://localhost:9090/targets` in your browser.
    - The `State` of both targets (`prometheus` and `phoenix-todo-list`) should be `UP`
    - The `Last Scrape` for each target should be within the past 5 seconds

## Setting up Grafana

- Use the quick-start script `support/telemetry/grafana` to start a Grafana container.
- Navigate to `localhost:3000` and login to Grafana.
  - The default username is `admin` and the default password is `admin`.
- Set a new password when prompted.
- Add Prometheus as a new data source:
  - Click the "Add your first data source" item on the homepage
    - Or, `Hamburger Menu` -> Click `Connections` -> `Data Sources` -> `Add new data source`
  - Select `Prometheus`.
  - Name the data source `prometheus`.
    - Use lowercase letters so it matches the PromEx datasource we created in a previous section.
  - Enter the URL of our Prometheus server: `http://localhost:9090`
  - Click the `Save & test` button at the bottom of the page to save our changes.
- Create a dashboard so we can view the data that Prometheus scraped from our server.
  - `Hamburger Menu` -> Click `Dashboards` -> Click the `New` button -> `Import`
- Now we need to use PromEx to generate the dashboard:
  - PromEx has several built-in plugins (e.g. Application, BEAM), each of which comes with a dashboard interface.
    - For this example, we'll generate a dashboard for the Application plugin.
      - NOTE: The Application and BEAM plugins are enabled by default.
        - To enable other plugins/dashboards, you will need to uncomment their lines in the `plugins` and `dashboards` sections of the `lib/todo_list/prom_ex.ex` module.
    - Use Mix to generate the dashboard:
      - `mix prom_ex.dashboard.export --dashboard application.json --stdout`
    - Copy the JSON output to the clipboard.
- Back in Grafana, paste the JSON output into the `Import via panel json` section.
- Press the `Load` button at the bottom of the page.
- Press the `Import` button to finish creating the dashboard.
- Now, the dashboard should be visible. Cool!
