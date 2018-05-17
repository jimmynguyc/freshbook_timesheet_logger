require 'date'
require 'capybara'
require 'capybara/dsl'
require 'dotenv/load'
require 'selenium/webdriver'
require './config'

Capybara.default_driver = :selenium_chrome_headless # :selenium_chrome

class TimesheetLogger
  include Capybara::DSL

  def call
    visit ENV['FRESHBOOK_URL']
    fill_in 'Username', with: ENV['USERNAME']
    fill_in 'Password', with: ENV['PASSWORD']
    click_on 'Log in'
    click_on 'Time Tracking'

    today = Date.today.strftime
    start_date = Date.parse(ENV['FROM'] || ENV['DATE'] || today)
    end_date = Date.parse(ENV['TO'] || ENV['DATE'] || today)

    (start_date..end_date).each do |date|
      enter_for(date)
    end
  end

  def enter_for(date)
    if CONFIG['holidays'].include?(date.strftime)
      puts "#{date.strftime} is a holiday ~!!"
      return
    end

    items = CONFIG[date.strftime('%a')]
    return unless items

    puts "Logging for #{date.strftime}"
    puts "============================"
    visit "#{ENV['FRESHBOOK_URL']}timesheet#date/#{date.strftime}"

    unless page.find('.timesheet-entry-table').has_content?('No hours logged on')
      puts "Already Logged on #{date.strftime}!!"
      return
    end

    items.each do |item|
      project, task, hours, notes = item
      printf 'Project: %s, Task: %s, Hours: %s, Notes: %s ...', project, task, hours, notes

      select project, from: 'Project'
      select task, from: 'Task'
      fill_in 'Hours', with: hours
      fill_in 'Notes', with: notes

      click_on 'Log Hours'

      loop until page.find('.timesheet-entry-table').has_content?(notes)
      puts "Done"
    end
  end
end

TimesheetLogger.new.call
