expected_output="Samples read:             28235
Length (seconds):      1.764687
Scaled by:         2147483647.0
Maximum amplitude:     0.394348
Minimum amplitude:    -0.379791
Midline amplitude:     0.007278
Mean    norm:          0.036612
Mean    amplitude:    -0.000038
RMS     amplitude:     0.068360
Maximum delta:         0.609009
Minimum delta:         0.000000
Mean    delta:         0.019705
RMS     delta:         0.048197
Rough   frequency:         1795
Volume adjustment:        2.536"

describe Libsamplerate::StaticResampler do
  context "when I resample" do
    it "I get the correct expected output" do
      out_dir = "./wavfiles"
      file_name = "vagelis.wav"
      file_path = "#{out_dir}/#{file_name}"
      out = {
        path: "#{out_dir}/vagelis-16k-mono.ruby-libresample.wav",
        info: RubyAudio::SoundInfo.new(
                :channels => 1,
                :format => RubyAudio::FORMAT_WAV|RubyAudio::FORMAT_PCM_16,
                :samplerate => 16000
              )
      }
      resampler = described_class.new(file_path, out).resample
      out = resampler.out[:path]
      expect(audio_stat(out)).to eql expected_output
    end
  end
end
