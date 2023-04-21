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
  - Set dynamic or secret environment variables in `.env.override` so that they will not be accidentally committed to source control
  - Use the example template in `support/.env.override.example` and fill in your desired values
- Run the Docker image:
  - `docker-compose up`
