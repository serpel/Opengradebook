#Copyright 2010 Foradian Technologies Private Limited
#This product includes software developed at
#Project Fedena - http://www.projectfedena.org/
#
#Licensed under the Apache License, Version 2.0 (the "License");
#you may not use this file except in compliance with the License.
#You may obtain a copy of the License at
#
#  http://www.apache.org/licenses/LICENSE-2.0
#
#Unless required by applicable law or agreed to in writing,
#software distributed under the License is distributed on an
#"AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
#KIND, either express or implied.  See the License for the
#specific language governing permissions and limitations
#under the License.
class BookReservation < ActiveRecord::Base
  belongs_to :user
  belongs_to :book
  before_destroy :update_book_status

  validates_uniqueness_of :book_id

  def update_book_status
    book = self.book
    if book.status == "Reserved"
      book.update_attributes(:book_movement_id =>nil,:status=>'Available')
    end
  end

end
