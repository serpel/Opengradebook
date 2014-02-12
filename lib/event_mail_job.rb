
class EventMailJob < Struct.new(:sender,:to,:subject,:body)
  def perform
    UserNotifier.deliver_create_event(sender,to,subject,body)
  end
end