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
# FedenaLibrary
require File.join(RAILS_ROOT, "app","models","student.rb")
require File.join(RAILS_ROOT, "app","models","hr","employee.rb")
require File.join(RAILS_ROOT, "app","models","user.rb")

User.send  :has_many,:book_movements, :dependent=>:destroy
User.send  :has_many,:book_reservations, :dependent=>:destroy
User.send  :before_destroy , :clear_book_movements
Student.send  :has_many,:book_movements, :through=>:user
Student.send  :has_many,:book_reservations, :through=>:user
Employee.send  :has_many,:book_movements, :through=>:user
Employee.send  :has_many,:book_reservations, :through=>:user

class FedenaLibrary
  unloadable
  def self.student_profile_hook
    "shared/student_profile"
  end

  def self.student_dependency_hook
    "shared/student_dependency"
  end

  def self.employee_dependency_hook
    "shared/employee_dependency"
  end

  def self.dependency_check(record,type)
    if record.class.to_s == "Student" or record.class.to_s == "Employee"
      return true if record.book_movements.all(:conditions=>"status = 'Issued'").present?
    end
    return false
  end
end

module FedenaLibraryBookMovement
  def issued_books
    self.book_movements.all(:conditions=>"status = 'Issued'")
  end
end

class Student
  unloadable
  include FedenaLibraryBookMovement
end

class Employee
  unloadable
  include FedenaLibraryBookMovement
end

class User
  unloadable
  def  clear_book_movements
    self.book_movements.destroy_all
    self.book_reservations.destroy_all
  end
end

