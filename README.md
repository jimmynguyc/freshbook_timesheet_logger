# Freshbook Timesheet Logger
Timesheet logger for lazy people

## Why use this
Allows you to timelog in bulk. When you're the king of procrasti-nation, there's really a lot of other / better things to do.

## Requirements
1. Ruby (duh)

## How to use this

1. `bundle install`

2. Copy `.env.sample` to `.env` and edit its content.

```
API_URL="https://fixme.freshbooks.com/api/2.1/xml-in"
AUTHENTICATION_TOKEN="fixme"
```

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

## Notes / Known Issues

1. Contributions are welcomed.

## API is boring .. is there a better way of doing this?
Why yes of course .. check out the `master` branch that uses Capybara :D

## License

This project is Licensed under [GLWTPL](https://github.com/me-shaon/GLWTPL)