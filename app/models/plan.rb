class Plan < ActiveRecord::Base
	belongs_to :subject

  validates_presence_of :examen_1, :examen_2, :examen_3, :examen_4,
                        :acumulado_1, :acumulado_2, :acumulado_3, :acumulado_4,
                        :subject_id
  validates_numericality_of :examen_1, :examen_2, :examen_3, :examen_4,
                            :acumulado_1, :acumulado_2, :acumulado_3, :acumulado_4,
                            :greater_than_or_equal_to => 0

end
