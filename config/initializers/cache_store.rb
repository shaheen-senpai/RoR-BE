Rails.application.config.cache_store = :redis_cache_store, {
  url: ENV.fetch('REDIS_URL', 'redis://localhost:6379/0'),
  namespace: "RoR-BE:cache",
  expires_in: 1.day
}
