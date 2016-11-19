class Event < ApplicationRecord
  has_and_belongs_to_many :event_types, dependent: :destroy

  def self.search_by_json(json)
    query_from_json(json)
  end

  def self.query_from_json(json)
    query = order(:start_date)
    filters = []
    json.each do |key, value|
      case key
      when "keyword"
	# ANDed
	q = "%#{json[key]}%"
	query = query.where("lower(title) like lower(?) or lower(description) like lower(?)", q, q)
      when "type"
        # ANDed
        value = [value] unless value.is_a? Array
        query = query.includes(:event_types)
	filters << Proc.new do |events|
	  events.select{|e| (value - e.event_types.map(&:name)).empty?}
	end
      when "location"
        # ORed
        value = [value] unless value.is_a? Array
        query_str = Array.new(value.size, "lower(#{key}) like lower(?)").join(" OR ")
        query = query.where(query_str, *(value.map{|s| "%#{s}%"}))
      when "host"
	query = query.where("lower(#{key}) like lower(?)", "%#{json[key]}%")
      when "fee", "number_of_people"
        if value["lower"]
          query = query.where("#{key} >= ?", value["lower"])
        end
        if value["upper"]
          query = query.where("#{key} <= ?", value["upper"])
        end
      when "date"
        if value["start"]
          query = query.where("start_date >= ?", value["start"])
        end
        if value["end"]
          query = query.where("end_date <= ?", value["end"])
        end
      end
    end
    # apply all filters
    accu_result = query
    filters.each do |filter|
      accu_result = filter.call(accu_result)
    end
    accu_result
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

  def as_json(options = { })
    super((options || { }).merge({
      :methods => [:type, :source],
      :except => [:start_date, :end_date, :source_id, :created_at, :updated_at, :id]
    })).merge({
      start_date: fmt_time(start_date),
      end_date: fmt_time(end_date),
    })
  end

  def type
    event_types.map(&:name)
  end

  def source
    Source.find(self.source_id)
  end

  def fmt_time(time)
    time.strftime("%Y-%m-%d %H:%M")
  end

end
