# Freshbook Timesheet Logger
Timesheet logger for lazy people

## Why use this
Allows you to timelog in bulk. When you're the king of procrasti-nation, there's really a lot of other / better things to do.

## Requirements
1. Ruby (duh)

## How to use this

1. `bundle install`

2. Copy `.env.sample` to `.env` and set the `NGROK_URL`, `CLIENT_ID` and `CLIENT_SECRET` from your [Freshbook App](#creating--updating-your-freshbook-app).

3. Copy `config.sample.rb` to `config.rb` and edit its content.
```ruby
CONFIG = {}

CONFIG['holidays'] = []
# CONFIG['holidays'] << 'YYYY-MM-DD'

CONFIG['Mon'] = []
# CONFIG['Mon'] << ['Project',  'Task', 'Hours', 'Notes']

CONFIG['Tue'] = []
# CONFIG['Tue'] << ['Project',  'Task', 'Hours', 'Notes']

CONFIG['Wed'] = []
# CONFIG['Wed'] << ['Project',  'Task', 'Hours', 'Notes']

CONFIG['Thu'] = []
# CONFIG['Thu'] << ['Project',  'Task', 'Hours', 'Notes']

CONFIG['Fri'] = []
# CONFIG['Fri'] << ['Project',  'Task', 'Hours', 'Notes']
```

4. Run the script

```bash
bundle exec ruby app.rb # Log today
DATE=2018-05-15 bundle exec ruby app.rb # Log specific date
FROM=2018-05-01 TO=2018-05-31 bundle exec ruby app.rb  # When you procrastinate until the last minute
```

## Creating / Updating your Freshbook App

You'll need to do this step when you fetch your oauth token for the first time / it expires. Otherwise the app should automatically use your existing token.

1. Start `ngrok http 8080`

2. Go to https://my.freshbooks.com/#/developer and create / updateyour app

3. Set the `Website URL` and `Redirect URL` to whatever ngrok domain (e.g. https://dab4c1546ef4.ngrok.io)

4. Save and get the Client ID & Secret

## Notes / Known Issues

1. The Capybara method no longer works bcoz we updated to the new UI. 
1. Contributions are welcomed.

## API is boring .. is there a better way of doing this?
Why yes of course .. check out the `master` branch that uses Capybara :D

## License

This project is Licensed under [GLWTPL](https://github.com/me-shaon/GLWTPL)