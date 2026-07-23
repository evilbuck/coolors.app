# frozen_string_literal: true

# Single controller for the generator surface.
#
# Routes:
#   GET /                -> index, generates a random palette
#   GET /<hex>-<hex>-... -> show, renders the palette from the URL
#
# Palette state lives in the URL so it can be shared without auth. The view
# is plain HTML + a tiny inline script for spacebar regen + lock + copy;
# no JS framework, no Tailwind UI kit — the page is just five colored
# columns.
class PalettesController < ApplicationController
  COUNT = 5
  HEX_PATH = /\A(?<hexes>(?:[0-9a-f]{6}-){2,}[0-9a-f]{6})\z/i.freeze

  def index
    @colors = PaletteGenerator.random(COUNT)
    render :show
  end

  def show
    raw = params[:hexes].to_s
    hexes = raw.split("-")
    if hexes.length < 3 || hexes.any? { |h| !PaletteGenerator.valid?(h) }
      return redirect_to root_path, status: :see_other
    end

    @colors = hexes.map { |h| PaletteGenerator.normalize(h) }
    render :show
  end
end
