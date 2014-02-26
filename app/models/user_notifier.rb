

class UserNotifier < ActionMailer::Base

  def forgot_password(user,current_url)
    setup_email(user,current_url)
    @subject    += 'Reset Password'
    @body[:url]  =  current_url+"/user/reset_password/#{user.reset_password_code}"
  end

  def imbox(sender,recipients,subject,body)
  
    if sender == "" or sender == nil
      sender = User.find_by_username('admin').email
    end
    
    @recipients = recipients
    @from       = sender
    @subject    = subject
    @sent_on    = Time.now
    @template   = '/user_notifier/create_event'
    @body[:description] = body
    @content_type = "text/html"
  end

  def gradebook(sender,recipients,subject,body)

    if sender == "" or sender == nil
      sender = User.find_by_username('admin').email
      sender ||= "noreply@#{get_domain(current_url)}"
    end

    @recipients = recipients
    @from       = sender
    @subject    = subject
    @sent_on    = Time.now
    @template   = '/user_notifier/create_event'
    @body[:description] = body
    @content_type = "text/html"
  end

  def gradebook_event(user,current_url,batch)
    setup_html_email(user, current_url)
    @subject += 'Grades have been published'
    @body[:url] = current_url
    @body[:batch] = batch
    @template = '/user_notifier/gradebook_event'
  end

  def homework_event(sender,recipients,subject,body)
    #@user = User.find sender
    if sender == "" or sender == nil
      sender = User.find_by_username('admin').email
      sender ||= "noreply@#{get_domain(current_url)}"
    end

    @recipients = recipients
    @from       = sender
    @subject    = subject
    @sent_on    = Time.now
    @template   = '/user_notifier/create_event'
    @body[:description] = body
    @content_type = "text/html"
  end

  def create_event(sender,recipients,subject,body)
    @recipients = recipients
    @from       = sender
    @subject    = subject
    @sent_on    = Time.now
    @template   = '/user_notifier/create_event'
    @body[:description] = body
    @content_type = "text/html"
  end

  def create_reminder(user,url,subject,body)
    setup_html_email(user, url)
    @subject += subject
    @body[:url] = url
    @body[:content] = body
    @template = '/user_notifier/create_reminder'
  end

  protected
    def setup_email(user, current_url)
      @recipients  = "#{user.email}"
      admin_email = User.find_by_username('admin').email
      admin_email ||= "noreply@#{get_domain(current_url)}"
      @from        = admin_email
      @subject     = " "
      @sent_on     = Time.now
      @body[:user] = user
    end
    
    def setup_html_email(user, current_url)
      @recipients  = "#{user.email}"
      admin_email = User.find_by_username('admin').email
      admin_email ||= "noreply@#{get_domain(current_url)}"
      @from        = admin_email
      @subject     = " "
      @sent_on     = Time.now
      @body[:user] = user
      @content_type = "text/html"
    end  

    def get_domain(current_url)
      url_parts = current_url.split("://").last.split('.')
      url_parts[(url_parts.length - 2) .. (url_parts.length - 1)].join('.')
    end
end