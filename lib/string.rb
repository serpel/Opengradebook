require 'iconv'
class String
  def to_my_utf8
    ::Iconv.conv('UTF-8//IGNORE', 'UTF-8', self + ' ')[0..-2]
  end
end