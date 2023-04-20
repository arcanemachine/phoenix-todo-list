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

Run the following commands **from the project root directory**:

- Set required environment variables:

  - `export SECRET_KEY_BASE="$(mix phx.gen.secret)"`
  - `export DATABASE_URL="ecto://postgres:postgres@localhost/todo_list"`

- Create a release using the helper script:
  - `./support/scripts/release`
- Build a Docker image:
  - `docker build -t arcanemachine/phoenix-todo-list .`
- Configure your environment:
  - Set environment variables in `.env.override`
  - Use the example template in `support/.env.override.example` and fill in your desired values
- Run the Docker image:
  - `docker run --name phoenix-todo-list --network='host' --env-file=.env.override -e SECRET_KEY_BASE=$SECRET_KEY_BASE -e DATABASE_URL=$DATABASE_URL arcanemachine/phoenix-todo-list`
