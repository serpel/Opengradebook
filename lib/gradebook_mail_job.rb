
class GradebookMailJob < Struct.new(:sender,:to,:subject,:body)
  def perform
    UserNotifier.deliver_gradebook(sender,to,subject,body)
  end
end