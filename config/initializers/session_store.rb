Rails.application.config.session_store :cookie_store, 
  key: '_virusscanner_session',
  expire_after: 2.weeks,
  same_site: :lax