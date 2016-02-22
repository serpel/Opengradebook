class Nota < ActiveRecord::Base
	belongs_to :student
	belongs_to :subject

  #attr_accessible :examen_1, :examen_2, :examen_3, :examen_4,
  #                :acumulado_1, :acumulado_2, :acumulado_3, :acumulado_4,
  #                :subject_id, :student_id

  validates_presence_of :examen_1, :examen_2, :examen_3, :examen_4,
                        :acumulado_1, :acumulado_2, :acumulado_3, :acumulado_4,
                        :subject_id, :student_id
  validates_numericality_of :examen_1, :examen_2, :examen_3, :examen_4,
                            :acumulado_1, :acumulado_2, :acumulado_3, :acumulado_4,
                            :greater_than_or_equal_to => 0

  def set_notes_to_zero(subject_id, student_id)
    self.examen_1 = 0
    self.examen_2 = 0
    self.examen_3 = 0
    self.examen_4 = 0
    self.acumulado_1 = 0
    self.acumulado_2 = 0
    self.acumulado_3 = 0
    self.acumulado_4 = 0
    self.recuperacion_1 = 0
    self.recuperacion_2 = 0
    self.recuperacion_3 = 0
    self.recuperacion_4 = 0
    self.student_id = student_id
    self.subject_id = subject_id
    #
  end

  def total_parcial(number)
    case number
    when 1
      self.examen_1.to_f + self.acumulado_1.to_f + self.recuperacion_1.to_f
    when 2
      self.examen_2.to_f + self.acumulado_2.to_f + self.recuperacion_2.to_f
    when 3
      self.examen_3.to_f + self.acumulado_3.to_f + self.recuperacion_3.to_f
    when 4
      self.examen_4.to_f + self.acumulado_4.to_f + self.recuperacion_4.to_f
    else
      0.0
    end
  end

  def partial(number)
    case number
      when 1
        self.examen_1.to_f + self.acumulado_1.to_f + self.recuperacion_1.to_f
      when 2
        self.examen_2.to_f + self.acumulado_2.to_f + self.recuperacion_2.to_f
      when 3
        self.examen_3.to_f + self.acumulado_3.to_f + self.recuperacion_3.to_f
      when 4
        self.examen_4.to_f + self.acumulado_4.to_f + self.recuperacion_4.to_f
      else
        0.0
    end
  end

  def average
    ((self.examen_1.to_f + self.acumulado_1.to_f +  self.recuperacion_1.to_f) +
        (self.examen_2.to_f + self.acumulado_2.to_f + self.recuperacion_2.to_f) +
        (self.examen_3.to_f + self.acumulado_3.to_f + self.recuperacion_3.to_f) +
        (self.examen_4.to_f + self.acumulado_4.to_f + self.recuperacion_4.to_f)) / 4
  end

  def total_average
    ((self.examen_1.to_f + self.acumulado_1.to_f +  self.recuperacion_1.to_f) +
    (self.examen_2.to_f + self.acumulado_2.to_f + self.recuperacion_2.to_f) +
    (self.examen_3.to_f + self.acumulado_3.to_f + self.recuperacion_3.to_f) +
    (self.examen_4.to_f + self.acumulado_4.to_f + self.recuperacion_4.to_f)) / 4
  end

  def total_average_special
    avg = 0

    p2 = total_parcial(2) > get_recovery(2) ? total_parcial(2) : get_recovery(2)
    p4 = total_parcial(4) > get_recovery(1) ? total_parcial(4) : get_recovery(1)
    total_p1 = (total_parcial(1) + p2)/2
    total_p2 = (total_parcial(3) + p4)/2

    if total_p1 > 0 and total_p2 > 0
      avg = (total_p1 + total_p2) / 2
    elsif total_p1 > 0 and total_p2 <= 0
      avg = total_p1
    elsif total_p2 > 0 and total_p1 <= 0
      avg = total_p2
    end

    avg
  end

  def get_recovery(number)
    case number
      when 1
        self.recovery.to_f
      when 2
        self.recovery2.to_f
      else
        0
    end
  end



  def examen(number)
    case number
    when 1
      self.examen_1.to_f
    when 2
      self.examen_2.to_f
    when 3
      self.examen_3.to_f
    when 4
      self.examen_4.to_f
    else
      0.0
    end
  end

  def acum(number)
    case number
    when 1
      self.acumulado_1.to_f
    when 2
      self.acumulado_2.to_f
    when 3
      self.acumulado_3.to_f
    when 4
      self.acumulado_4.to_f
    else
      0.0
    end
  end

  def acumulado(numero)
    case numero
      when 1
        self.acumulado_1.to_f
      when 2
        self.acumulado_2.to_f
      when 3
        self.acumulado_3.to_f
      when 4
        self.acumulado_4.to_f
      else
        0.0
    end
  end

  def recuperacion(numero)
    case numero
      when 1
        self.recuperacion_1.to_f
      when 2
        self.recuperacion_2.to_f
      when 3
        self.recuperacion_3.to_f
      when 4
        self.recuperacion_4.to_f
      else
        0.0
    end
  end

  def nivelacion(numero)
    case numero
      when 1
        self.recovery.to_f
      when 2
        self.recovery2.to_f
      else
        0.0
    end
  end

  def parcial(numero)
    case numero
      when 1
        self.examen_1.to_f + self.acumulado_1.to_f
      when 2
        self.examen_2.to_f + self.acumulado_2.to_f
      when 3
        self.examen_3.to_f + self.acumulado_3.to_f
      when 4
        self.examen_4.to_f + self.acumulado_4.to_f
      else
        0.0
    end
  end

  def promedio_semestre(numero)
    if numero == 1
      p1 = parcial(1) < nivelacion(1) ? nivelacion(1) : parcial(1)
      p1 = p1 > recuperacion(1) ? p1 : recuperacion(1)
      p2 = parcial(2) < recuperacion(2) ? recuperacion(2) : parcial(2)
    else
      p1 = parcial(3) < nivelacion(2) ? nivelacion(2) : parcial(3)
      p1 = p1 > recuperacion(3) ? p1 : recuperacion(3)
      p2 = parcial(4) < recuperacion(4) ? recuperacion(4) : parcial(4)
    end

    (p1 + p2)/2
  end

end
