authorization do

  role :student do
    has_permission_on [:assignment_answers],
      :to=>[
      :create,
      :download_attachment,
      :edit,
      :new,
      :show,
      :update]
    has_permission_on [:assignments],
      :to=>[
      :assignment_student_list,
      :download_attachment,
      :index,
      :new,
      :show,
      :subject_assignments,
      :subjects_students_list,
      :history
       ]
  end

  role :parent do
    has_permission_on [:assignment_answers],
      :to=>[
      :create,
      :download_attachment,
      :edit,
      :new,
      :show,
      :update]
    has_permission_on [:assignments],
      :to=>[
      :assignment_student_list,
      :download_attachment,
      :index,
      :new,
      :show,
      :subject_assignments,
      :subjects_students_list,
      :history
       ]
  end

  role :employee do
    has_permission_on [:assignments],
      :to=>[
      :assignment_student_list,
      :create,
      :destroy,
      :download_attachment,
      :edit,
      :index,
      :new,
      :show,
      :subject_assignments,
      :subjects_students_list,
      :update,
      :history]
    has_permission_on [:assignment_answers],
      :to=>[
      :create,
      :download_attachment,
      :edit,
      :evaluate_assignment,
      :new,
      :show,
      :update]
  end


end