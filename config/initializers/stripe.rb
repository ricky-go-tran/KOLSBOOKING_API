Rails.configuration.stripe = {
  :publishable_key => Rails.application.credentials.stripe_public_key,
  :secret_key      =>  Rails.application.credentials.stripe_private_key
}

Stripe.api_key = Rails.configuration.stripe[:secret_key]
