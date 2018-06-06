class Project
  include ActiveModel::Validtations
  extend ActiveModel::Naming

  attr_accessor :id, :title, :description, :last_activity_at, :commit_count

  def initialize(attributes = {})
    attributes.each do |name, value|
      send("#{name}=", value)
    end
  end

  def persisted?
    false
  end
end
