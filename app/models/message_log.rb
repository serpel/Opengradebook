class MessageLog < ActiveRecord::Base
  belongs_to :employee

  validates_presence_of :quantity, :employee, :subject, :body
end

