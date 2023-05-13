# Deployment

---

**Unless otherwise specified, all commands in this document should be run from the `support/deployment/` directory.**

---

Additional information on deployment.

## Deploying A Native Phoenix Server

- Ensure that your environment is configured properly.
  - Use the `support/scripts/dotenv-generate` script to create a `.env` file if one doesn't already exist.
  - Ensure that the `.env` file contains the desired values.
- Ensure the required steps have been completed before continuing:
  - Setup Postgres:
    - Using a container:
      - See the "Running a Standalone Postgres Container" in `support/containers/README.md`.
    - Manually:
      - Install the required packages (instructions will work for Debian/Ubuntu environments):
        - `sudo apt update`
        - `sudo apt install postgresql postgresql-contrib`
      - Use a Postgres terminal to create a new database and user:
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
  - Use the `support/scripts/elixir-release-create` script to create a release with Elixir/Mix.
- Ensure that your `PHX_HOST` environment variable matches the domain entered in your browser's address bar.
  - You will probably need to set up Caddy using the instructions below.
    - If you don't set up Caddy, your websockets (e.g. LiveView) probably won't work.
    - Also, Caddy will automatically set up TLS (HTTPS) which is essential for the modern web
      - e.g. Modern browsers will complain when entering passwords if plain HTTP is used.
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

### How To Start The Server Automatically When The System Boots

1. Ensure that your environment is configured properly using the instructions in the previous section.

2. Ensure that lingering is enabled for your user account so that services can run on startup:

- `sudo loginctl enable-linger $USER`

3. Run the `systemd` service file generator in `support/scripts/native-systemd-service-file-generate`.

- This script will place a `systemd` service file called `phoenix-todo-list.service` in the `$USER/.config/systemd/user/phoenix`
- To view the `systemd` service file template in the console instead of writing the file, set the `DRY_RUN=1` environment variable before running the script.

4. The `systemd` service file should now be available in the `$USER/.config/systemd/user/phoenix` directory.

5. Reload the `systemd` daemons: `systemctl --user daemon-reload`

6. Start the service: `systemctl --user start phoenix-todo-list.service`

- Stop the service: `systemctl --user stop phoenix-todo-list.service`

7. To enable the service on startup: `systemctl --user enable phoenix-todo-list.service`

- To disable the service from running on startup: `systemctl --user disable phoenix-todo-list.service`

8. To view the logs for the service (useful for troubleshooting): `journalctl --user -xe --unit phoenix-todo-list`

## Deploying With Containers

To deploy with Docker/Podman containers, see `support/containers/README.md`.

Any non-Traefik deployment strategy can be used with Caddy. To set up Caddy, see the [section below](#deploying-with-caddy)

## Deploying With Caddy

To deploy with Caddy, complete the following steps:

1. Ensure that Caddy is installed on your machine.

2. Backup the existing Caddyfile just in case:

- `sudo cp /etc/caddy/Caddyfile /etc/caddy/Caddyfile.bak`

3. There are several example Caddyfiles:

   - `Caddyfile.local`: Uses 'localhost' subdomain
   - `Caddyfile.vagrant`: Like local, but sets a manual path for the TLS certificates.
     - This allows a self-signed certificate to be made on the host (e.g. using 'mkcert'), and used in the VM.
     - Designed for use with [Vagrant](https://github.com/hashicorp/vagrant)
   - `Caddyfile.staging`: Uses a live domain name, but not the production one.
     - e.g. staging.your-project.com
   - `Caddyfile.prod`: Uses a live domain name

4. Copy the desired project's Caddyfile to the Caddy configuration directory:

- local: `sudo cp Caddyfile.local /etc/caddy/Caddyfile`
- vagrant: `sudo cp Caddyfile.vagrant /etc/caddy/Caddyfile`
- staging: `sudo cp Caddyfile.staging /etc/caddy/Caddyfile`
- prod: `sudo cp Caddyfile.prod /etc/caddy/Caddyfile`

5. Navigate to the Caddy configuration directory.

- `cd /etc/caddy`

6. Validate the new Caddyfile:

- `sudo caddy validate`

7. Reload the Caddyfile:

- `sudo caddy reload`

8. Caddy should now be working with the new configuration.

- Caddy will automatically enable TLS (HTTPS) for your domain. See the Caddy docs for more info.

### Modifying the Caddyfile

Caddyfiles are quite simple and mostly self-explanatory. Example:

```
phoenix-todo-list.nicholasmoen.com

reverse_proxy localhost:4000
```

After you change the Caddyfile, follow steps 5-7 to load the new configuration.

## Creating `systemd` Services For This Project

### Natively

You can use the `support/scripts/systemd-native-service-file-generate` to easily create a `systemd` service file for this project using a native Phoenix release (i.e. no containers).

When this script is run, it will generate `systemd` service file called `~/.config/systemd/user/phoenix-todo-list.service`

### Using Containers

You can use the `support/scripts/systemd-container-service-file-generate` to easily create a `systemd` service file for this project:

- This script is configured for Podman by default.
  - To generate a Docker container, pass the `--docker` flag when running this script.
- When this script is run, it will generate `systemd` service file called `~/.config/systemd/user/phoenix-todo-list.service` (unless the `--dry-run` flag is set)
- Other flags:
  - `--docker` - Configures the service for use with Docker instead of Podman.
    - If this flag is not set, the service will be configured for use with Podman.
  - `--dry-run` - Display the service file in the terminal instead of writing to a file.
    - No permanent changes are made when this flag is used.
    - The output of a `--dry-run` is identical to the real service file, and can be piped as needed.
  - `--postgres` - Run a Postgres container as part of the service.
  - `--traefik-client` - Configures the service to be used as Traefik.
    - Does not start a Traefik server.
  - `--traefik-host` - Configures the service to be used as Traefik.
    - Runs a Traefik container as part of the service.
  - `--remote` - Configures Traefik to work in a remote environment.
    - Supports HTTPS certificates via Let's Encrypt.
    - If the machine will be accessible from the Internet, you will probably want to use this option.

### Starting The Service Automatically On Boot

See [this section](#how-to-start-the-server-automatically-when-the-system-boots).
