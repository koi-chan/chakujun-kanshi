require 'open-uri'
require 'tempfile'

STREAM_URI = 'http://localhost:8080/?action=stream'
SNAPSHOT_URI = 'http://localhost:8080/?action=snapshot'

latest = []
loop do
  begin
    tf = Tempfile.open('chakujun-kanshi') do |file|
      open(SNAPSHOT_URI) do |image|
        file.write(image.read)
      end
      file
    end
  rescue => e
    puts("Error: #{e}")
    next
  end

  code_datas = `zbarimg -q #{tf.path}`.lines(chomp: true)
  tf.close

  result = latest - code_datas
  latest = code_datas

  puts("result: #{result}, now: #{code_datas}")
  sleep(0.35)
end
