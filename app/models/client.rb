class Client < ActiveRecord::Base
  belongs_to :user
  has_many :messages

  validates :name, uniqueness: { scope: :user_id }
  validates_format_of :name, with: /\A[A-Za-z\d_-]+\z/

  before_create :generate_access_token

  def generate_access_token
    candidate_token = nil

    while candidate_token.nil?
      candidate_token = SecureRandom.urlsafe_base64
      candidate_token = nil unless Client.find_by(access_token: candidate_token).nil?
    end

    self.access_token = candidate_token
  end

  def send_message(message, device)
    Message.send_message(message, self.access_token, device.name)
  end
end
