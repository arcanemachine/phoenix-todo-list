# /support/deployment/

---

**Unless otherwise specified, all commands in this document should be run from the `support/deployment/` directory.**

---

Additional information on deployment.

## Deploying A Native Phoenix Server

- Ensure that your environment is configured properly.
  - Use the `support/scripts/dotenv-generate` script to create a `.env` file if one doesn't already exist.
  - Ensure that the `.env` file contains the desired values.
- Ensure the required steps have been completed before continuing:
  - Setup PostgreSQL:
    - Using a container:
      - See the "Running a Standalone Postgres Container" in `support/containers/README.md`.
    - Manually:
      - Install the required packages (instructions will work for Debian/Ubuntu environments):
        - `sudo apt update`
        - `sudo apt install postgresql postgresql-contrib`
      - Use a PostgreSQL terminal to create a new database and user:
        - `sudo su - postgres`
        - `psql`
          - `CREATE USER todo_list_user WITH PASSWORD 'todo_list_password';`
          - `CREATE DATABASE todo_list;`
          - `GRANT ALL PRIVILEGES ON DATABASE todo_list TO todo_list_user;`
        - Exit `psql` by pressing `Ctrl+D` or typing `\q` + `Enter`
  - Setup Caddy using the instructions in the _[Deploying With Caddy](#deploying-with-caddy)_ section.
    - Alternatively, you can set up a different server as you like.
    - Ensure that the domain matches the `PHX_HOST` environment variable, or else Phoenix will complain and websockets (e.g. LiveView) won't work.
- Build a release:
  - Use the `support/scripts/release-build` script to build a release.
- To run the server:
  - Using a script:
    - Run migrations and start the server with `supports/scripts/server-prod-start`
  - Manually:
    - Navigate to the directory `_build/prod/rel/todo_list/bin/`.
    - Run migrations: `./migrate`
    - Start the prod server: `./server`
- To stop the server:
  - Using a script: `supports/scripts/server-prod-start`
  - Manually:
    - Navigate to the directory `_build/prod/rel/todo_list/bin/`.
    - Stop the prod server: `./todo_list stop`

### How To Start the Server Automatically When the System Boots

- Ensure that your environment is configured properly using the instructions in the previous section.
- Ensure that lingering is enabled for your user account so that services can run on startup:
  - `sudo loginctl enable-linger $USER`
- Run the `systemd` service file generator in `support/scripts/native-systemd-service-file-generate`.
  - This script will place a `systemd` service file called `phoenix-todo-list.service` in the `$USER/.config/systemd/user/phoenix`
  - To view the `systemd` service file template in the console instead of writing the file, set the `DRY_RUN=1` environment variable before running the script.
- The `systemd` service file should now be available in the `$USER/.config/systemd/user/phoenix` directory.
- Reload the `systemd` daemons: `systemctl --user daemon-reload`
- Start the service: `systemctl --user start phoenix-todo-list.service`
  - Stop the service: `systemctl --user stop phoenix-todo-list.service`
- To enable the service on startup: `systemctl --user enable phoenix-todo-list.service`
  - To disable the service from running on startup: `systemctl --user disable phoenix-todo-list.service`

## Deploying With Containers

To deploy with Docker/Podman containers, see `support/containers/README.md`.

Any non-Traefik deployment strategy can be used with Caddy. To set up Caddy, continue reading.

## Deploying With Caddy

To deploy with Caddy, complete the following steps:

1. Ensure that Caddy is installed on your machine.

2. Backup the existing Caddyfile just in case:

- `sudo cp /etc/caddy/Caddyfile /etc/caddy/Caddyfile.bak`

3. There are 2 example Caddyfiles:

- A `Caddyfile.local` to ensure the configuration works locally
- A `Caddyfile.remote` Caddyfile for use in a production environment

4. Copy the desired project's Caddyfile to the Caddy configuration directory:

- local: `sudo cp Caddyfile.local /etc/caddy/Caddyfile`
- remote: `sudo cp Caddyfile.remote /etc/caddy/Caddyfile`

5. Navigate to the Caddy configuration directory.

- `cd /etc/caddy`

6. Validate the new Caddyfile:

- `sudo caddy validate`

7. Reload the Caddyfile:

- `sudo caddy reload`

8. Caddy should now be working with the new configuration.

- Caddy will automatically enable TLS (HTTPS) for your domain. See the Caddy docs for more info.

### Modifying the Caddyfile

The base Caddyfile is self-explanatory:

```
phoenix-todo-list.nicholasmoen.com

reverse_proxy localhost:4000
```

After you change the Caddyfile, follow steps 5-7 to load the new configuration.
