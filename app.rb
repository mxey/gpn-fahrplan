require 'sinatra'
require 'open-uri'
require 'json'
require 'icalendar'
require 'date'

get '/' do
  uri = 'http://bl0rg.net/~andi/gpn13-fahrplan.json'

  fahrplan = JSON.parse(open(uri).read)
  cal = Icalendar::Calendar.new

  fahrplan.each do |fpe|
    ice = Icalendar::Event.new
    begin
      ice.dtstart = DateTime.strptime(fpe['start'], '%Y%m%d-%H%M')
    rescue ArgumentError
    end
  
    begin
      ice.dtend = DateTime.strptime(fpe['end'], '%Y%m%d-%H%M')
    rescue ArgumentError
    end
    ice.summary = fpe['title']
    ice.description = fpe['long_desc']
    ice.location = fpe['place']
    cal.add_event ice
  end

  headers 'Content-Type' => 'text/calendar'
  return cal.to_ical
end
