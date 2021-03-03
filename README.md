# Freshbook Timesheet Logger
Timesheet logger for lazy people

## Why use this
Allows you to timelog in bulk. When you're the king of procrasti-nation, there's really a lot of other / better things to do.

## Requirements
1. Ruby (duh)
2. Chrome

## How to use this

1. `bundle install`

2. Copy `.env.sample` to `.env` and edit its content.

```
USERNAME=fixme
PASSWORD='fixme'
FRESHBOOK_URL = "https://fixme.freshbooks.com/"
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

1. Will only log on a day where there's no existing time logs. Comment out these lines if you wish to ignore :-
```ruby
# app.rb
unless page.find('.timesheet-entry-table').has_content?('No hours logged on')
  puts "Already Logged on #{date.strftime}!!"
  return
end
```

2. This obviously only works if you have a pretty similar work schedule every day of week.

3. There's no UNDO button. Make sure you know what you're doing.

4. Things will break when the UI changes.

5. You'll get your login will temporarily blocked if you fire the script too many frequently.

6. Contributions are welcomed.

## Why are you not using the API?
Because why use a scalpel when you have a chainsaw >:)

## But seriously .. there's an official API
If you can't handle the action & excitement, check out the `oauth` branch. But seriously, you're missing all the fun.


## License

This project is Licensed under [GLWTPL](https://github.com/me-shaon/GLWTPL)
