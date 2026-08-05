require 'jwt'

# 🔹 Set your private key file path
key_file = "/Users/intileotechnologies/Documents/Aman/opd_sure_app/ios/fastlane/AuthKey_R8DWU66GG9.p8"

# 🔹 Replace with your actual Key ID from Apple Developer
key_id = "R8DWU66GG9"

# 🔹 Replace with your actual Issuer ID from App Store Connect
issuer_id = "7a0bf4e3c-a1ed-4325-8f16-25317a6d2727"

begin
  # Load private key
  private_key = OpenSSL::PKey::EC.new(File.read(key_file))

  # Generate the JWT token
  payload = {
    iss: issuer_id,
    exp: Time.now.to_i + (365 * 24 * 60 * 60),  # Expiration time: 1 year (365 days)
    aud: "appstoreconnect-v1"
  }

  # 🔹 Define the header fields, including the Key ID
   header_fields = {
     kid: key_id  # Key ID from Apple Developer
   }


  # Generate the token
  token = JWT.encode(payload, private_key, 'ES256', { kid: key_id })

  # Print the token
  puts "✅ Generated Token: #{token}"

rescue Errno::ENOENT
  puts "❌ Error: Private key file not found. Check the file path."
rescue OpenSSL::PKey::ECError
  puts "❌ Error: Invalid private key format. Ensure it's a valid .p8 file."
rescue StandardError => e
  puts "❌ Error: #{e.message}"
end
