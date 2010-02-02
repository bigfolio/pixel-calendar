# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_RAFBC-PixelCal_session',
  :secret      => '08456542719f84164b79a5dda0a59f6a6359ffef0826990b30c8e66997a354c99ef889a01c686dae9d933a8c67bfbfee21d552f1022f9b0ec007d38b31641d2f'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
