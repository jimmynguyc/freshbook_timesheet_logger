require 'date'
require 'dotenv/load'
require './config'
require 'httparty'
require 'nokogiri'

class TimesheetLogger

  def initialize
    @api_url = ENV['API_URL']
    @authentication_token = ENV['AUTHENTICATION_TOKEN']
    @auth = {username: @authentication_token, password: 'X'}
    raise 'API URL & Authentication Token Required !!!' unless @api_url && @authentication_token
  end

  def call
    today = Date.today.strftime
    start_date = Date.parse(ENV['FROM'] || ENV['DATE'] || today)
    end_date = Date.parse(ENV['TO'] || ENV['DATE'] || today)

    (start_date..end_date).each do |date|
      enter_for(date)
    end
  end

  def enter_for(date)
    printf '%s', "Logging for #{date.strftime} --- "

    if CONFIG['holidays'].include?(date.strftime)
      puts 'is a holiday ~!!'
      return
    end

    items = CONFIG[date.strftime('%a')]
    unless items
      puts 'Not a workday, skipping'
      return
    end

    puts "\n============================"


    items.each do |item|
      create_time_entry(item, date)
    end
  end

  private
  def create_time_entry(item, date)
    project_name, task_name, hours, notes = item
    printf 'Project: %s, Task: %s, Hours: %s, Notes: %s ...', project_name, task_name, hours, notes

    builder = Nokogiri::XML::Builder.new do |xml|
      xml.request(method: 'time_entry.create') do
        xml.time_entry do
          xml.project_id project_id_by_name(project_name)
          xml.task_id task_id_by_name(task_name, project_name)
          xml.hours hours
          xml.notes notes
          xml.date date
        end
      end
    end

    response = api_request(builder.to_xml)['response']
    puts "Done (#{response['time_entry_id']})"
  end

  def projects
    return @projects if @projects
    builder = Nokogiri::XML::Builder.new do |xml|
      xml.request(method: 'project.list')
    end

    @projects = api_request(builder.to_xml)['response']['projects']['project']
  end

  def project_id_by_name(project_name)
    project = projects.find {|p| p['name'] == project_name }
    project['project_id'] if project
  end

  def tasks_by_project(project_name)
    @tasks ||= {}
    project_id = project_id_by_name(project_name)
    return @tasks[project_id] if @tasks[project_id]

    builder = Nokogiri::XML::Builder.new do |xml|
      xml.request(method: 'task.list') do
        xml.project_id project_id
      end
    end
    @tasks[project_id] = api_request(builder.to_xml)['response']['tasks']['task']
  end

  def task_id_by_name(task_name, project_name)
    task = tasks_by_project(project_name).find {|t| t['name'] == task_name }
    task['task_id'] if task
  end

  def api_request(xml)
    response = HTTParty.get(@api_url, body: xml, basic_auth: @auth)
    raise "#{response['response']['error']} (#{response['response']['code']})" if response['response']['status'] == 'fail'
    response.parsed_response
  end
end

TimesheetLogger.new.call
