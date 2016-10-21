# Generated by ffi_gen. Please do not change this file by hand.

require 'ffi'

module Libsamplerate::FFI
  extend FFI::Library
  ffi_lib "libsamplerate"

  def self.attach_function(name, *_)
    begin; super; rescue FFI::NotFoundError => e
      (class << self; self; end).class_eval { define_method(name) { |*_| raise e } }
    end
  end

  # Opaque data type SRC_STATE.
  class SRCSTATETag < FFI::Struct
    layout :dummy, :char
  end

  # SRC_DATA is used to pass data to src_simple() and src_process().
  #
  # = Fields:
  # :data_in ::
  #   (FFI::Pointer(*Float))
  # :data_out ::
  #   (FFI::Pointer(*Float))
  # :input_frames ::
  #   (Integer)
  # :output_frames ::
  #   (Integer)
  # :input_frames_used ::
  #   (Integer)
  # :output_frames_gen ::
  #   (Integer)
  # :end_of_input ::
  #   (Integer)
  # :src_ratio ::
  #   (Float)
  class SRCDATA < FFI::Struct
    layout :data_in, :pointer,
           :data_out, :pointer,
           :input_frames, :long,
           :output_frames, :long,
           :input_frames_used, :long,
           :output_frames_gen, :long,
           :end_of_input, :int,
           :src_ratio, :double
  end

  # SRC_CB_DATA is used with callback based API.
  #
  # = Fields:
  # :frames ::
  #   (Integer)
  # :data_in ::
  #   (FFI::Pointer(*Float))
  class SRCCBDATA < FFI::Struct
    layout :frames, :long,
           :data_in, :pointer
  end

  # User supplied callback function type for use with src_callback_new()
  # and src_callback_read(). First parameter is the same pointer that was
  # passed into src_callback_new(). Second parameter is pointer to a
  # pointer. The user supplied callback function must modify *data to
  # point to the start of the user supplied float array. The user supplied
  # function must return the number of frames that **data points to.
  #
  # <em>This entry is only for documentation and no real method.</em>
  #
  # @method _callback_src_callback_t_(cb_data, data)
  # @param [FFI::Pointer(*Void)] cb_data
  # @param [FFI::Pointer(**Float)] data
  # @return [FFI::Pointer(*Void)]
  # @scope class
  callback :src_callback_t, [:pointer, :pointer], :pointer

  # Standard initialisation function : return an anonymous pointer to the
  # internal state of the converter. Choose a converter from the enums below.
  # Error returned in *error.
  #
  # @method src_new(converter_type, channels, error)
  # @param [Integer] converter_type
  # @param [Integer] channels
  # @param [FFI::Pointer(*Int)] error
  # @return [SRCSTATETag]
  # @scope class
  attach_function :src_new, :src_new, [:int, :int, :pointer], SRCSTATETag

  # Initilisation for callback based API : return an anonymous pointer to the
  # internal state of the converter. Choose a converter from the enums below.
  # The cb_data pointer can point to any data or be set to NULL. Whatever the
  # value, when processing, user supplied function "func" gets called with
  # cb_data as first parameter.
  #
  # @method src_callback_new(func, converter_type, channels, error, cb_data)
  # @param [Proc(_callback_src_callback_t_)] func
  # @param [Integer] converter_type
  # @param [Integer] channels
  # @param [FFI::Pointer(*Int)] error
  # @param [FFI::Pointer(*Void)] cb_data
  # @return [SRCSTATETag]
  # @scope class
  attach_function :src_callback_new, :src_callback_new, [:src_callback_t, :int, :int, :pointer, :pointer], SRCSTATETag

  # Cleanup all internal allocations.
  # Always returns NULL.
  #
  # @method src_delete(state)
  # @param [SRCSTATETag] state
  # @return [SRCSTATETag]
  # @scope class
  attach_function :src_delete, :src_delete, [SRCSTATETag], SRCSTATETag

  # Standard processing function.
  # Returns non zero on error.
  #
  # @method src_process(state, data)
  # @param [SRCSTATETag] state
  # @param [SRCDATA] data
  # @return [Integer]
  # @scope class
  attach_function :src_process, :src_process, [SRCSTATETag, SRCDATA], :int

  # Callback based processing function. Read up to frames worth of data from
  # the converter int *data and return frames read or -1 on error.
  #
  # @method src_callback_read(state, src_ratio, frames, data)
  # @param [SRCSTATETag] state
  # @param [Float] src_ratio
  # @param [Integer] frames
  # @param [FFI::Pointer(*Float)] data
  # @return [Integer]
  # @scope class
  attach_function :src_callback_read, :src_callback_read, [SRCSTATETag, :double, :long, :pointer], :long

  # Simple interface for performing a single conversion from input buffer to
  # output buffer at a fixed conversion ratio.
  # Simple interface does not require initialisation as it can only operate on
  # a single buffer worth of audio.
  #
  # @method src_simple(data, converter_type, channels)
  # @param [SRCDATA] data
  # @param [Integer] converter_type
  # @param [Integer] channels
  # @return [Integer]
  # @scope class
  attach_function :src_simple, :src_simple, [SRCDATA, :int, :int], :int

  # This library contains a number of different sample rate converters,
  # numbered 0 through N.
  #
  # Return a string giving either a name or a more full description of each
  # sample rate converter or NULL if no sample rate converter exists for
  # the given value. The converters are sequentially numbered from 0 to N.
  #
  # @method src_get_name(converter_type)
  # @param [Integer] converter_type
  # @return [String]
  # @scope class
  attach_function :src_get_name, :src_get_name, [:int], :string

  # (Not documented)
  #
  # @method src_get_description(converter_type)
  # @param [Integer] converter_type
  # @return [String]
  # @scope class
  attach_function :src_get_description, :src_get_description, [:int], :string

  # (Not documented)
  #
  # @method src_get_version()
  # @return [String]
  # @scope class
  attach_function :src_get_version, :src_get_version, [], :string

  # Set a new SRC ratio. This allows step responses
  # in the conversion ratio.
  # Returns non zero on error.
  #
  # @method src_set_ratio(state, new_ratio)
  # @param [SRCSTATETag] state
  # @param [Float] new_ratio
  # @return [Integer]
  # @scope class
  attach_function :src_set_ratio, :src_set_ratio, [SRCSTATETag, :double], :int

  # Reset the internal SRC state.
  # Does not modify the quality settings.
  # Does not free any memory allocations.
  # Returns non zero on error.
  #
  # @method src_reset(state)
  # @param [SRCSTATETag] state
  # @return [Integer]
  # @scope class
  attach_function :src_reset, :src_reset, [SRCSTATETag], :int

  # Return TRUE if ratio is a valid conversion ratio, FALSE
  # otherwise.
  #
  # @method src_is_valid_ratio(ratio)
  # @param [Float] ratio
  # @return [Integer]
  # @scope class
  attach_function :src_is_valid_ratio, :src_is_valid_ratio, [:double], :int

  # Return an error number.
  #
  # @method src_error(state)
  # @param [SRCSTATETag] state
  # @return [Integer]
  # @scope class
  attach_function :src_error, :src_error, [SRCSTATETag], :int

  # Convert the error number into a string.
  #
  # @method src_strerror(error)
  # @param [Integer] error
  # @return [String]
  # @scope class
  attach_function :src_strerror, :src_strerror, [:int], :string

  # Extra helper functions for converting from short to float and
  # back again.
  #
  # @method src_short_to_float_array(in_, out, len)
  # @param [FFI::Pointer(*Short)] in_
  # @param [FFI::Pointer(*Float)] out
  # @param [Integer] len
  # @return [nil]
  # @scope class
  attach_function :src_short_to_float_array, :src_short_to_float_array, [:pointer, :pointer, :int], :void

  # (Not documented)
  #
  # @method src_float_to_short_array(in_, out, len)
  # @param [FFI::Pointer(*Float)] in_
  # @param [FFI::Pointer(*Short)] out
  # @param [Integer] len
  # @return [nil]
  # @scope class
  attach_function :src_float_to_short_array, :src_float_to_short_array, [:pointer, :pointer, :int], :void

  # (Not documented)
  #
  # @method src_int_to_float_array(in_, out, len)
  # @param [FFI::Pointer(*Int)] in_
  # @param [FFI::Pointer(*Float)] out
  # @param [Integer] len
  # @return [nil]
  # @scope class
  attach_function :src_int_to_float_array, :src_int_to_float_array, [:pointer, :pointer, :int], :void

  # (Not documented)
  #
  # @method src_float_to_int_array(in_, out, len)
  # @param [FFI::Pointer(*Float)] in_
  # @param [FFI::Pointer(*Int)] out
  # @param [Integer] len
  # @return [nil]
  # @scope class
  attach_function :src_float_to_int_array, :src_float_to_int_array, [:pointer, :pointer, :int], :void

end
