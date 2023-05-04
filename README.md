# Prism Web

[![Rails](https://github.com/Prism-Hosting/web/actions/workflows/rails.yml/badge.svg)](https://github.com/Prism-Hosting/web/actions/workflows/rails.yml)

This is the web-application part of prism hosting.

It includes:
- Logging in with Steam
- Creating CS:GO servers
- Managing CS:GO servers
- Configuring CS:GO servers

Designed using [bootstrap](https://getbootstrap.com/) and the [Purpose Website UI Kit](https://themes.getbootstrap.com/product/purpose-website-ui-kit/).


## Prerequisites

- Ruby 3.2
- Bundler
- Foreman (development only)
- Redis
- Node.js
- PostgreSQL 15
- OpenShift 4.12
- Chrome

## Development

To start developing, first clone this repository:

```bash
$ git clone git@github.com:Prism-Hosting/web.git prism-web
$ cd prism-web
```

Then run the `bin/setup`. This will:

- Install all ruby dependencies
- Install all javascript dependencies
- Setup the database for development and testing
- Remove old logs and temp files

```
$ bin/setup
== Installing dependencies ==
The following gems are missing
 * rails (7.0.4.3)
 ...
```

After successful setup to run the application use:

```bash
$ bin/dev
```

This will start the necessary processes and the app will be available under http://localhost:3000

## Testing

To start the tests run:

```bash
$ bin/rails test
$ bin/rails test:system
```
