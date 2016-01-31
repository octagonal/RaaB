require 'openssl'
require 'digest/sha1'
require 'yaml'

class Encryption
  def Encryption.encrypt(text)
    api_data = YAML::load_stream(File.open("./api_data.yaml")).first["api"];
    # create the cipher for encrypting
    cipher = OpenSSL::Cipher::Cipher.new("aes-256-cbc")
    cipher.encrypt

    # you will need to store these for later, in order to decrypt your data
    key = Digest::SHA1.hexdigest("yourpass")
    iv = cipher.random_iv

    # load them into the cipher
    cipher.key = key
    cipher.iv = iv

    # encrypt the message
    encrypted = cipher.update('This is a secure message, meet at the clock-tower at dawn.')
    encrypted << cipher.final
    puts "encrypted: #{encrypted}\n"
  end

  def Encryption.decrypt(text)
    api_data = YAML::load_stream(File.open("./api_data.yaml")).first["api"];
  end
end
