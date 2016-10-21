module Libsamplerate
  def self.stereo_to_mono file_path
    buffer = []
    RubyAudio::Sound.open(file_path) do |snd|
      snd.read(:float, snd.info.frames).each do |sample|
        buffer.push(sample[0])
      end
    end
    buffer
  end

  def self.get_float_buffer_from_mono_file file
    raise "This is not a mono file" if get_sound_file_info(file).channels == 1
    buffer = []
    RubyAudio::Sound.open(file) do |snd|
      snd.read(:float, snd.info.frames).each do |sample|
        buffer.push(sample)
      end
    end
    buffer
  end

  def self.get_sound_file_info file_path
    info = nil
    RubyAudio::Sound.open(file_path) do |snd|
      info = snd.info
    end
    info
  end

  CONVERTERS =
    {
      src_sinc_best_quality: 0,
      src_sinc_medium_quality: 1,
      src_sinc_fastest: 2,
      src_zero_order_hold: 3,
      src_linear: 4
  }
end
