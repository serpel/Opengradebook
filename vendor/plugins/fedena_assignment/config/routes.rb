ActionController::Routing::Routes.draw do |map|
  
 #assignment
  map.resources :assignments,:has_many => :assignment_answers
  map.resources :attendance_reports
end