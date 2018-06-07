class Commit
  include ActiveModel::Validtations
  extend ActiveModel::Naming

  attr_accessor :id, :title, :message, :commited_at

  def initialize(attributes = {})
    attributes.each do |name, value|
      send("#{name}=", value)
    end
  end

  def persisted?
    false
  end
end
