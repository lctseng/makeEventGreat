require 'open3'
namespace :event do
  desc "Update events via crawlers"
  task :update => :environment do
    def log(raw_msg)
      msg = "[Event Updater] #{raw_msg}"
      Rails.logger.info msg
      puts msg
    end
    log "Start updating events"
    event_raw_data = []
    classifier_path = "#{Rails.root}/#{ExternalProgram.classifier.path}"
    ExternalProgram.crawler.each do |name, info|
      path = info["path"]
      log "Running crawler: #{name}"
      crawler = IO.popen("#{Rails.root}/#{path}")
      un_typed = crawler.read
      log "Running classifier"
      Open3.popen2(classifier_path) do |stdin, stdout|
        stdin.write un_typed
        stdin.close
        typed = stdout.read
        event_raw_data += JSON.parse(typed.gsub(/[\t]+/,' '))
      end
    end
    log "Storing to database"
    Event.delete_all
    EventTypesEvent.delete_all
    Event.create_from_raw_data(event_raw_data)
  end
end
