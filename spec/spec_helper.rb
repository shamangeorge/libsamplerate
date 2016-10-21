require 'libsamplerate'
require "open3"

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end
  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end
end

#puts "================================="
#puts "Version:"
#puts Libsamplerate::FFI.src_get_version
#puts "================================="
#puts "Available Converters"
#(0..4).each do |i|
#puts "=-=-=-=-=-=-=-="
#puts Libsamplerate::FFI.src_get_name(i)
#puts Libsamplerate::FFI.src_get_description(i)
#end
#puts "================================="

# A helper (extract to custom rspec test)
def audio_stat output_file_name
  result = nil
  Open3.popen3("sox #{output_file_name} -n stat") do |stdin, stdout, stderr, thread|
    result = stderr.read.chomp
  end
  result
end

def stat_values file
  audio_stat(file).split("\n").map do |line|
    line.split(":")[1].strip.to_f
  end
end

def compare_audio_by_stat file1, file2
  stat1 = stat_values(file1)
  stat2 = stat_values(file2)

  stat1.each_with_index.map do |elm, i|
    puts "#{elm}, #{stat2[i]}"
    (elm - stat2[i]).abs
  end
end
