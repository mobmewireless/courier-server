class Device < ActiveRecord::Base
  # validation checks
  validates :name, :presence => true, uniqueness: { scope: :user_id }
  validates :device_type, :presence => true

  has_many :messages
  belongs_to :user

  before_create :generate_registration_token

  # Checks if this device has a push_id associated with it.
  def registered?
    !push_id.nil?
  end

  # Generates a new unique registration token for device.
  def generate_registration_token
    candidate_token = nil

    while candidate_token.nil?
      candidate_token = SecureRandom.hex(3).upcase
      candidate_token = nil unless Device.find_by(registration_token: candidate_token).nil?
    end

    self.registration_token = candidate_token
  end

  # Adds push identifier to device based on supplied registration token.
  def self.register(registration_token, push_id)
    device = Device.find_by(registration_token: registration_token.upcase)

    raise Exceptions::DeviceNotFound unless device

    device.push_id = push_id
    device.registration_token = nil # Let's prevent repeated use of registration token.

    device.save
  end
end
