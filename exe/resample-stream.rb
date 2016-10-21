#!/usr/bin/env ruby

require "ruby-audio"
require "libsamplerate"

puts "================================="
puts "Version:"
puts Libsamplerate::FFI.src_get_version
puts "================================="
puts "Available Converters"
(0..4).each do |i|
  puts "=-=-=-=-=-=-=-="
  puts Libsamplerate::FFI.src_get_name(i)
  puts Libsamplerate::FFI.src_get_description(i)
end
puts "================================="

out_dir = "."
out_dir = "/home/pikos/Dropbox"
file_name = "vagelis.wav"
file_path = "#{out_dir}/#{file_name}"
buffer = []
RubyAudio::Sound.open(file_path) do |snd|
  snd.read(:float, snd.info.frames).each do |sample|
    buffer.push((sample[0] + sample[1]) / 2)
  end
end

error_ptr = FFI::MemoryPointer.new :int
converter = 0
channels = 1
src_state = Libsamplerate::FFI.src_new(
  converter,
  channels,
  error_ptr
)

slice = 4096
all_data = []
buffer.each_slice(slice) do |input|
  num_samples = input.size
  in_ptr = FFI::MemoryPointer.new :float, input.size
  in_ptr.write_array_of_float input
  outbuffer = FFI::MemoryPointer.new :float, num_samples

  src_data = Libsamplerate::FFI::SRCDATA.new
  src_data[:data_in] = in_ptr
  src_data[:input_frames] = num_samples
  src_data[:data_out] = outbuffer
  src_data[:output_frames] = num_samples / 2
  src_data[:src_ratio] = 16000.0 / 44100.0

  puts "State Error: #{Libsamplerate::FFI.src_strerror error_ptr.read_int}"
  resampled = Libsamplerate::FFI.src_process(src_state, src_data)
  #resampled = Libsamplerate::FFI.src_simple(src_data, converter, channels)
  puts "resampled: #{Libsamplerate::FFI.src_strerror resampled}"
  num_samples_out = src_data[:output_frames_gen]
  num_samples_in = src_data[:input_frames_used]
  puts "Number of used input frames: #{num_samples_in}"
  puts "Number of generated output frames: #{num_samples_out}"
  samples = src_data[:data_out].read_array_of_float(num_samples_out * channels)
  all_data.concat(samples)
  puts "done"
end
Libsamplerate::FFI.src_delete src_state
file_out = "#{out_dir}/vagelis-16k-out.mono.stream.wav"
channels = 1
samplerate = 16000
info = RubyAudio::SoundInfo.new(
  :channels => channels,
  :samplerate => samplerate,
  :format => RubyAudio::FORMAT_WAV|RubyAudio::FORMAT_PCM_16
)
sound = RubyAudio::Sound.open(file_out, 'w', info)
buffer = RubyAudio::Buffer.float(all_data.length, channels)
all_data.each_with_index { |sample, index|
  puts sample if index == 100
  buffer[index] = sample
}
sound.write(buffer)
sound.close
