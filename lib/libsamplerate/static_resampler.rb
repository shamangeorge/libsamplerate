require 'ruby-audio'
module Libsamplerate
  class StaticResampler
    attr_reader :in, :out, :src_data
    def initialize in_file, out
      @in = {
        path: in_file,
        info: get_info(in_file)
      }
      @out = out
    end

    def in_info
      @in[:info]
    end

    def out_info
      @out[:info]
    end

    def get_info file
      Libsamplerate.get_sound_file_info file
    end

    def setup_src_data in_ptr, num_samples_in, out_ptr, num_samples_out, src_ratio
      src_data[:data_in] = in_ptr
      src_data[:input_frames] = num_samples_in
      src_data[:data_out] = out_ptr
      src_data[:output_frames] = num_samples_out
      src_data[:src_ratio] = src_ratio
    end

    def src_data
      @src_data ||= Libsamplerate::FFI::SRCDATA.new
    end

    def write_out_file
      num_samples_out = src_data[:output_frames_gen]
      samples = src_data[:data_out].read_array_of_float(num_samples_out * out_info.channels)
      sound = RubyAudio::Sound.open(@out[:path], 'w', out_info)
      buffer = RubyAudio::Buffer.float(samples.length, out_info.channels)
      samples.each_with_index { |sample, index|
        buffer[index] = sample
      }
      sound.write(buffer)
      sound.close
    end

    def prepare_buffer
      if in_info.channels != 1
        Libsamplerate.stereo_to_mono @in[:path]
      else
        Libsamplerate.get_float_buffer_from_mono_file @in[:path]
      end
    end

    def resample
      input = prepare_buffer
      num_samples = input.size
      in_ptr = create_audio_pointer_buffer_float input
      tRate = out_info.samplerate.to_f
      iRate = in_info.samplerate.to_f
      outbuffer = allocate_audio_pointer_buffer_float num_samples
      outsamples = num_samples / 2
      src_ratio = tRate / iRate
      converter = Libsamplerate::CONVERTERS[:src_sinc_best_quality]
      setup_src_data(in_ptr, num_samples, outbuffer, outsamples, src_ratio)
      resampled = Libsamplerate::FFI.src_simple(src_data, converter, out_info.channels)
      error = Libsamplerate::FFI.src_strerror resampled
      error.eql? "No Error." || raise(error)
      write_out_file
      self
    end

    def allocate_audio_pointer_buffer_float num_samples
       ::FFI::MemoryPointer.new :float, num_samples
    end

    def create_audio_pointer_buffer_float samples
      ptr = ::FFI::MemoryPointer.new :float, samples.size
      ptr.write_array_of_float samples
      ptr
    end
  end
end
