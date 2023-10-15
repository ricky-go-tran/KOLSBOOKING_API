require "active_support/core_ext/integer/time"

Rails.application.configure do
  config.cache_classes = false
  config.eager_load = false
  config.consider_all_requests_local = true
  config.server_timing = true
  if Rails.root.join("tmp/caching-dev.txt").exist?
    config.cache_store = :memory_store
    config.public_file_server.headers = {
      "Cache-Control" => "public, max-age=#{2.days.to_i}"
    }
  else
    config.action_controller.perform_caching = false

    config.cache_store = :null_store
  end

  # Store uploaded files on the local file system (see config/storage.yml for options).
  config.active_storage.service = :local

  # Don't care if the mailer can't send.
  config.action_mailer.raise_delivery_errors = false

  config.action_mailer.perform_caching = false

  # Print deprecation notices to the Rails logger.
  config.active_support.deprecation = :log

  # Raise exceptions for disallowed deprecations.
  config.active_support.disallowed_deprecation = :raise

  # Tell Active Support which deprecation messages to disallow.
  config.active_support.disallowed_deprecation_warnings = []

  # Raise an error on page load if there are pending migrations.
  config.active_record.migration_error = :page_load

  config.action_cable.mount_path = '/cable'
  config.action_cable.url = 'wss://localhost:3000/cable'
  config.action_cable.allowed_request_origins = [ /http:\/\/localhost:*/ ]

  # Highlight code that triggered database queries in logs.
  config.active_record.verbose_query_logs = true
  config.action_mailer.default_url_options = { host: 'localhost:3000' }
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.perform_deliveries = true
  config.action_mailer.raise_delivery_errors = false
  config.action_mailer.default charset: 'utf-8'
  config.action_mailer.smtp_settings = {
    address: 'smtp.gmail.com',
    domain: 'gmail.com',
    port: 587,
    user_name: 'developer.opendevzone@gmail.com',
    password: Rails.application.credentials.gmail_key,
    authentication: 'plain',
    enable_starttls_auto: true
  }
  # config.after_initialize do
  #     Bullet.enable = true
  #     Bullet.bullet_logger = true
  #     Bullet.raise = true # raise an error if n+1 query occurs
  #     Bullet.unused_eager_loading_enable = false
  #   end

end
