require 'listen'
require 'zbar'
require 'rmagick'

IMAGE_DIR = '/tmp/chakujun'

# mjpg_streamer -o "output_http.so -w /usr/local/share/mjpg-streamer/www" -o "output_file.so -f /tmp/chakujun" -i "input_uvc.so -d /dev/video0 -f 2 -n -br 90 -ex 50 -co 100 -sh 0"

latest = []
listener = Listen.to(IMAGE_DIR) do |modified, added, removed|
  puts("m:#{modified.size}, a:#{added.size}, r:#{removed.size}")
  next if added.empty?

  added.each do |f|
    image = Magick::Image.read(f + '[0]').first.strip!.to_blob do
      self.format = 'PGM'
    end
    decoded = ZBar::Image.from_pgm(image).process
    decoded.map! do |code|
      "#{code.symbology}:#{code.data}"
    end

    result = latest - decoded
    latest = decoded
    puts("r:#{result}, now:#{decoded}")

    begin
      File.delete(f)
    rescue => e
      puts("Error: can't delete #{e}")
    end
  end
end

listener.start
puts("started")
sleep
