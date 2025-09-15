class Project < ApplicationRecord
  belongs_to :owner, class_name: 'User'
  has_many :tasks, dependent: :destroy
  
  validates :name, presence: true
  validates :description, presence: true
end
