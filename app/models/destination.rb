class Destination < ApplicationRecord
    belongs_to :creator, class_name: "User", foreign_key: "creator_id"

    has_many :comments
    has_many :plans
    has_many :trips, through: :plans

    validates :name, uniqueness:{case_sensitive: false}
    validates :name, :city, :country, :description, presence: true


end
