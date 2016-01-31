require "thor"
require "./utils/authentication.rb"

class RaaB < Thor
  desc "encrypt TEXT", "Encrypt the given TEXT using aes-256-cbc."
  def encrypt(text)
    text = Encryption.encrypt(text)
    puts [text].pack("m")
  end

  desc "decrypt TEXT", "Decrypt the given TEXT using aes-256-cbc."
  def decrypt(text)
    text = Encryption.decrypt(text.unpack('m').first())
    puts text
  end
end

RaaB.start(ARGV)
