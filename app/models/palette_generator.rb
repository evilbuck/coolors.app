# frozen_string_literal: true

# Generates random hex palettes with light/legibility constraints.
# ponytail: single Random source, no warm-up, no caching. If palettes feel
#   too "pure random" we can add an HSL constraint (lock S/L bands) here.
module PaletteGenerator
  HEX = /\A[0-9a-f]{6}\z/i.freeze

  module_function

  # Returns an array of `count` random 6-char hex strings (no leading #).
  def random(count = 5)
    Array.new(count) { SecureRandom.hex(3) }
  end

  # Validates a hex string ("aabbcc" or "#aabbcc"); returns canonical 6-char
  # downcase or nil. Used by the show route to pull hexes from the URL path.
  def normalize(hex)
    return nil if hex.nil?
    cleaned = hex.delete_prefix("#").downcase
    HEX.match?(cleaned) ? cleaned : nil
  end

  # Returns true if the string is a valid 6-char hex (with or without #).
  def valid?(hex)
    !normalize(hex).nil?
  end
end
