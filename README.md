# README

### How to Run

This is a single-page Rails 8 app using Hotwire (Turbo), TailwindCSS, and SQLite.

Requirements
- Ruby 3.x
- SQLite 3
- Node.js and Yarn (for Tailwind)

```bash
bundle install
bin/setup   # sets up DB and runs seeds
bin/dev     # runs Rails server + Tailwind watcher
```

#### Notes
- Seed data: The app seeds 100 projects with 25+ tasks each (some expired).
- CSS: Tailwind is used, `bin/dev` will watch and rebuild styles on change.
- Tasks expire automatically after 6 months. Expired tasks are excluded from the UI by default.
- No background scheduler included — see notes below for expiration job.

For speed of development and demonstration purposes, basic pagination styles were added directly to `app/assets/stylesheets/application.css`.
This was done to quickly make pagy pagination look decent.

### Task Expiration & Background Processing

Tasks automatically expire 6 months after creation using the expires_at timestamp.
A background job `Tasks::ExpireTasksJob` is defined to handle expired tasks. It can be used to archive or mark expired tasks, trigger cleanups, or fire off related side effects.
This job is not scheduled by default. You should configure a scheduler that periodically runs this job in your environment.
Options include:
- Cron (via rails runner)
- Sidekiq + sidekiq-cron
- Any external scheduler compatible with Rails or Active Job

Choose the option that best fits your deployment and infrastructure.
