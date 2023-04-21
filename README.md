# phoenix-todo-list

Yet another todo list. Made using the Phoenix web framework.

Features:

- Basic CRUD
- LiveView CRUD
- REST API
- OpenAPI spec
- E2E tests (Playwright)
- GitHub Actions CI
- Releases (via Docker + fly.io)

## Releases

### Docker

Run the following commands from the project root directory:

- Set private environment variables in `./.env.override` so that they will not be accidentally committed to source control
  - Use the example template in `support/.env.override.example` and fill in your desired values
- Create a release using the helper script:
  - `./support/scripts/release`
    - You will need to set the `SECRET_KEY_BASE` and `DATABASE_URL` environment variables in your shell before you run the release builder script. If you have `direnv` installed, these values can be loaded automatically from `./.env.override`
- Build a Docker image:
  - `docker build -t phoenix-todo-list .`
- Run the Docker image with Docker Compose or just plain Docker:
  - `docker-compose up`, or
  - `docker run --name phoenix-todo-list --network='host' --env-file=.env.override -e SECRET_KEY_BASE=$SECRET_KEY_BASE -e DATABASE_URL=$DATABASE_URL arcanemachine/phoenix-todo-list`
