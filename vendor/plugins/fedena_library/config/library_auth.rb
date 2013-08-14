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
authorization do

  #custom - privileges
  role :students_control do
    has_permission_on [:library],
      :to => [:student_library_details]
    
  end


  #library module
  role :librarian do
    has_permission_on [:book_movement],
      :to => [
      :issue_book,
      :user_search,
      :update_user,
      :return_book,
      :return_book_detail,
      :update_return,
      :reserve_book,
      :direct_issue_book,
      :renewal,
      :update_renewal
    ]
    has_permission_on [:books],
      :to => [
      :index,
      :new,
      :create,
      :edit,
      :update,
      :show,
      :destroy,
      :sort_by
    ]
    has_permission_on [:library],
      :to => [
      :index,
      :search_book,
      :search_result,
      :detail_search,
      :availabilty,
      :card_setting,
      :show_setting,
      :add_new_setting,
      :create_setting,
      :edit_card_setting,
      :update_card_setting,
      :delete_card_setting,
      :movement_log,
      :library_report,
      :library_report_pdf,
      :batch_library_report,
      :batch_library_report_pdf,
      :student_library_details,
      :employee_library_details
    ]
  end
  #end library

  # admin privileges
  role :admin do

    includes :librarian
  end


  #employee - privileges
  role :employee do
    has_permission_on [:book_movement],
      :to => [
      :user_search,
      :update_user,
      :reserve_book
    ]
    has_permission_on [:books],
      :to => [
      :index,
      :show,
      :sort_by

    ]
    has_permission_on [:library],
      :to => [
      :index,
      :search_book,
      :search_result,
      :detail_search,
      :availabilty ,
      :employee_library_details]
  end
  # student- privileges
  role :student do

    has_permission_on [:book_movement],
      :to => [

      :user_search,
      :update_user,
      :reserve_book
    ]
    has_permission_on [:books],
      :to => [
      :index,
      :show,
      :sort_by

    ]
    has_permission_on [:library],
      :to => [
      :index,
      :search_book,
      :search_result,
      :detail_search,
      :availabilty ,
      :student_library_details]
    #end library------

  end
end