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

## Notes

1. Will only log on a day where there's no existing time logs. Comment out these lines if you wish to ignore :-
```ruby
# app.rb
unless page.find('.timesheet-entry-table').has_content?('No hours logged on')
  puts "Already Logged on #{date.strftime}!!"
  return
end
```
