require 'open-uri'
require 'tempfile'

STREAM_URI = 'http://localhost:8080/?action=stream'
SNAPSHOT_URI = 'http://localhost:8080/?action=snapshot'

loop do
  begin
    image = open(SNAPSHOT_URI).read
  rescue => e
    puts("Error: #{e}")
    next
  end

  analyzed = ZBar::Image.from_jpeg(image).process.map do |code|
    code.data
  end

  analyzed.compact!

  if analyzed.size > 0
    puts "#{Time.now.strftime("%F%T")}#{analyzed.join}"
  end

  sleep(0.3)
end
