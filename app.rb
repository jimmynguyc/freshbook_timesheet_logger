require "byebug"
require "date"
require "dotenv/load"
require "./config"
require "./get_auth"

class TimesheetLogger
  include Oauth2Helper
  BUSINESS_ID = 7392819

  def initialize
    @token = get_oauth_token
  end

  def call
    today = Date.today.strftime
    start_date = Date.parse(ENV["FROM"] || ENV["DATE"] || today)
    end_date = Date.parse(ENV["TO"] || ENV["DATE"] || today)

    (start_date..end_date).each do |date|
      enter_for(date)
    end
  end

  def enter_for(date)
    printf "%s", "Logging for #{date.strftime} --- "

    if CONFIG["holidays"].include?(date.strftime)
      puts "is a holiday ~!!"
      return
    end

    items = CONFIG[date.strftime("%a")]
    unless items
      puts "Not a workday, skipping"
      return
    end

    puts "\n============================"

    items.each do |item|
      create_time_entry(item, date)
    end
  end

  private

  def create_time_entry(item, date)
    project_name, service_name, hours, notes = item
    printf "Project: %s, Task: %s, Hours: %s, Notes: %s ...", project_name, service_name, hours, notes

    response = api_request(:post, "timetracking/business/#{BUSINESS_ID}/time_entries", {
      headers: {
        'Content-Type': "application/vnd.api+json",
      },
      body: {
        time_entry: {
          is_logged: true,
          duration: (hours.to_f * 60 * 60).to_i,
          started_at: date.to_time.strftime("%Y-%m-%dT%H:%M:01.%LZ"),
          note: notes,
          project_id: project_id_by_name(project_name),
          service_id: service_id_by_name(service_name, project_name),
          task_id: task_id_by_name(service_name, project_name),
        },
      }.to_json,
    })
    puts "Done (#{response["time_entry"]["id"]})"
  end

  def projects
    return @projects if @projects

    @projects = api_request(:get, "projects/business/#{BUSINESS_ID}/projects")["projects"]
  end

  def project_id_by_name(project_name)
    project = projects.find { |p| p["title"] == project_name }
    project["id"] if project
  end

  def services_by_project(project_name)
    @services ||= {}
    project_id = project_id_by_name(project_name)
    return @services[project_id] if @services[project_id]

    @services[project_id] = api_request(:get, "comments/business/#{BUSINESS_ID}/services?include_task_id=true")["services"]
  end

  def service_id_by_name(service_name, project_name)
    service = services_by_project(project_name).find { |t| t["name"] == service_name }
    service["id"] if service
  end

  def task_id_by_name(service_name, project_name)
    service = services_by_project(project_name).find { |t| t["name"] == service_name }
    service["task_id"] if service
  end

  def api_request(method, path, params = {})
    JSON.parse(@token.send(method, path, params).body)
  end
end

TimesheetLogger.new.call
