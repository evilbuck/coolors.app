Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  # Palette generator.
  #   GET /                       -> random palette (HTML)
  #   GET /<hex>-<hex>-...        -> that palette (HTML, 3+ hexes)
  #   GET /<hex>-<hex>-....json   -> that palette (JSON, agent-friendly)
  #   GET /saved                  -> localStorage-backed list (HTML shell)
  root to: "palettes#index"
  get "/saved", to: "saved#index", as: :saved
  # JSON variant for the palette path. Constraint on the request path keeps
  # hexes matching only when no format extension is appended; .json requests
  # fall through to this route. Named so views/agents can call palette_url.
  match "/:hexes(.:format)", to: "palettes#show", via: :get,
        as: :palette,
        constraints: { hexes: /(?:[0-9a-f]{6}-){2,}[0-9a-f]{6}/i }
end
