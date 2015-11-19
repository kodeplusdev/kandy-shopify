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
```

- Edit [`config/environments/<enviroment>`](config/environments)
```rb
  # Set an explicit asset host for each environment
  config.action_controller.asset_host = 'https://your-awesome-app.com'
  config.action_mailer.default_url_options = { host: 'https://your-awesome-app.com', port: 443 }
```

- Open ['config/database.yml'](config/database.yml) and put setup for database your application use.

- Run command to create and migrate new database
```shell
  rake db:create
  rake db:migrate
```

- Run kandy shopify app
```shell
  rails s
```

## Troubleshooting
## License