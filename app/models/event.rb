class Event < ApplicationRecord
  has_and_belongs_to_many :event_types

  def self.search_by_json(json)
    where("lower(title) like lower(?)", "%#{json[:keyword]}%")
  end

  def make_query_from_json(json)

  end

  def add_event_type(name)
    # find or create
    event_type = EventType.find_or_create_by(name: name)
    # check uniqueness
    unless self.event_types.include? event_type
      self.event_types << event_type
      true
    else
      false
    end
  end

end
