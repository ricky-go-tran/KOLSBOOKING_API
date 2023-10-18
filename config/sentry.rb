Sentry.init do |config|
  config.dsn = 'https://dcfea9691434aebe2d55787be5fce328@o4506054373146624.ingest.sentry.io/4506055331414016'
  config.breadcrumbs_logger = [:active_support_logger, :http_logger]
  config.traces_sample_rate = 1.0
end
