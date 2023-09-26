# Freddit - A small Reddit clone app built with Phoenix MVC

## Requirements

- [Erlang](https://www.erlang.org/downloads.html)
- [Elixir](https://elixir-lang.org/install.html)
- [Docker Desktop](https://www.docker.com/products/docker-desktop/)

## How to run the project locally

Clone the project

```bash
git clone https://github.com/alphazero-wd/freddit.git
cd freddit
```

Install all the dependencies and run Docker compose

```bash
mix deps.get
docker-compose up
```

Start the development server

```bash
mix phx.server
```

Run all tests

```bash
mix test
```
