class Source < Settingslogic
  source "#{Rails.root}/config/event_source.yml"
  def find(id)
   self["source"][id] 
  end

  def get_source_to_id_map
    map = {}
    self["source"].each do |id, name|
      map[name] = id.to_i
    end
    map
  end
end
