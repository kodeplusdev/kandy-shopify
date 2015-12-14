# kandy-shopify
A Kandy plugin for shopify websites.
- Homepage: https://www.kandy.io/

## Features
- Live chat
- PSTN/voice/video call supported (coming soon)
- SMS notifications

## Install
#### 1. Create a [shopify app](https://developers.shopify.com/) with:
- Embedded settings: `Enabled`
- Application URL: `https://your-awesome-app.com/`
- Preferences URL: `https://your-awesome-app.com/preferences`
- Support URL: `https://your-awesome-app.com/help`
- Redirection URL: `https://your-awesome-app.com/auth/shopify/callback`

#### 2. Config kandy-shopify
- Create a `.env` file
```yml
    SHOPIFY_CLIENT_API_KEY=<your-app-api-key>
    SHOPIFY_CLIENT_API_SECRET=<your-app-api-secret-key>
    MAILER_SENDER=<email-of-sender>
    MAILER_USERNAME=<gmail-smtp-email>
    MAILER_PASSWORD=<gmail-smtp-password>
    DEVISE_SECRET_KEY=<secret-token>
    APP_SECRET_TOKEN=<secret-token>
    KANDY_SHOPIFY_HOST=https://your-awesome-app.com
    PG_USERNAME=<postgresql-username>
    PG_PASSWORD=<postgresql-password>
```

- Open ['config/database.yml'](config/database.yml) and put setup for database your application use.

- Run command to create and migrate new database
```shell
  bundle install
  rake db:create
  rake db:migrate
```

- Run kandy shopify app
```shell
  rails s
```

## Troubleshooting

## License