# frozen_string_literal: true

# Saved palettes live in localStorage for v1 — this controller only renders
# the shell. The list is hydrated client-side. When we add auth, this becomes
# a real index action backed by a SavedPalettes model.
class SavedController < ApplicationController
  def index
  end
end
