class User < ApplicationRecord
  devise :cas_authenticatable
  validates :username , presence: true
end
