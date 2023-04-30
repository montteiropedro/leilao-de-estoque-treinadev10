class Batch < ApplicationRecord
  belongs_to :creator, class_name: 'User'
  belongs_to :approver, class_name: 'User'
end
