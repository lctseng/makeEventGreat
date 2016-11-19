class Source < Settingslogic
  source "#{Rails.root}/config/event_source.yml"
  def find(id)
   self["source"][id] 
  end
end
