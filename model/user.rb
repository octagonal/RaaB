DataMapper.setup(:default, "sqlite3://#{Dir.pwd}/test.db")

class User
  include DataMapper::Resource
  include BCrypt

  has n, :comments

  property :id, Serial, :key => true
  property :username, String, :length => 3..50
  property :password, BCryptHash

  def authenticate(attempted_password)
    if self.password == attempted_password
      true
    else
      false
    end
  end
end

class Comment
  include DataMapper::Resource

  belongs_to :user
  property :id,         Serial
  property :post_id, Text, :required => true
  property :body,       Text
  property :created_at, DateTime  # A DateTime, for any date you might like.
end

DataMapper.finalize
DataMapper.auto_upgrade!
