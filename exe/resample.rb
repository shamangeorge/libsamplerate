#!/usr/bin/env ruby

require "libsamplerate"

out_dir = "/home/pikos/Dropbox/Public"
file_name = "vagelis.wav"
file_path = "#{out_dir}/#{file_name}"
resampler = Libsamplerate::StaticResampler.new file_path
puts resampler
