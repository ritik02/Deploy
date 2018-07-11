class User < ApplicationRecord
  devise :cas_authenticatable
  validates :username , presence: true

  def cas_extra_attributes=(extra_attributes)
    extra_attributes.each do |name, value|
    	puts name +  " " + value.to_s
      case name.to_sym
      when :name
        self.name = value
      when :email
        self.email = value
      end
    end
  end
end
