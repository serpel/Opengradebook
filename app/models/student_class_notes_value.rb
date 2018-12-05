class StudentClassNotesValue < ActiveRecord::Base
  belongs_to :subjects
  belongs_to :periods
end
