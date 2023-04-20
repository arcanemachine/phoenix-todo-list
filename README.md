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

# Releases

Run the following commands from the project root directory:

- Set required environment variables:

  - `export SECRET_KEY_BASE="$(mix phx.gen.secret)"`
  - `export DATABASE_URL="ecto://postgres:postgres@localhost/todo_list"`

- Create a release using the helper script:
  - `./support/scripts/release`
- Build a Docker image:
  - `docker build -t arcanemachine/phoenix-todo-list .`
- Run the Docker image:
  - `docker run -p $PORT:$PORT -e SECRET_KEY_BASE=$SECRET_KEY_BASE -e DATABASE_URL=$DATABASE_URL arcanemachine/phoenix-todo-list`
