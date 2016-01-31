require 'openssl'
require 'digest/sha1'
require 'yaml'

class Encryption
  def Encryption.encrypt(text)
    api_data = YAML::load_stream(File.open("./api_data.yaml")).first["api"];

    # create the cipher for encrypting
    cipher = OpenSSL::Cipher::Cipher.new("aes-256-cbc")
    cipher.encrypt

    # load them into the cipher
    cipher.key = Digest::SHA1.hexdigest(api_data["secret"])
    cipher.iv = api_data["iv"]

    # encrypt the message
    encrypted = cipher.update(text)
    encrypted << cipher.final
    encrypted
  end

  def Encryption.decrypt(text)
    api_data = YAML::load_stream(File.open("./api_data.yaml")).first["api"];

    cipher = OpenSSL::Cipher::Cipher.new("aes-256-cbc")
    cipher.decrypt
    cipher.key = Digest::SHA1.hexdigest(api_data["secret"])
    cipher.iv = api_data["iv"]

    # and decrypt it
    decrypted = cipher.update(text)
    decrypted << cipher.final
    decrypted
  end
end
