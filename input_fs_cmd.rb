require 'open-uri'
require 'listen'
require 'zbar'

IMAGE_DIR = '/tmp/chakujun'

listener = Listen.to(IMAGE_DIR) do |modified, added, removed|
  puts("m:#{modified.size}, a:#{added.size}, r:#{removed.size}")
  next if added.empty?

  added.each do |f|
#    code_datas = `zbarimg -q #{f}`.lines(chomp: true)
    i = ZBar::Image.from_jpeg(File.binread(f))
    c = i.process
    pp c
#    code_datas = c.map do |code|
#      "#{code.symbology}:#{code.data}"
#    end
#    puts(code_datas)

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
