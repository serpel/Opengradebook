
class ImboxMailJob < Struct.new(:sender,:to,:subject,:body)
  def perform
    UserNotifier.deliver_imbox(sender,to,subject,body)
  end
end