json.extract! token, :token, :token_type, :expires_at
json.url token_url(token, format: :json)
