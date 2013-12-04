class User < ActiveRecord::Base
  has_many :devices

  # TODO: Add user_id to messages table so that messages become directly related to user.
  has_many :messages, through: :devices

  has_many :clients

  acts_as_authentic

  after_create :generate_default_client!

  def generate_default_client!
    client = self.clients.new(name: 'default')
    client.save!
  end

  def default_client
    clients.find_by_name('default')
  end
end
