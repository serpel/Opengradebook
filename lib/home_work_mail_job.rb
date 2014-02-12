
class HomeWorkMailJob < Struct.new(:sender,:to,:subject,:body)
  def perform
    UserNotifier.deliver_homework_event(sender,to,subject,body)
  end
end