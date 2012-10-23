class UserMailer < ActionMailer::Base
  helper :application

  default from: "MHDT Connect <ryan.saundersMHDT@gmail.com>"

  def handoff_email(task, assigner, old_assignee)
    @task = task
    @person = task.person
    @assigner = assigner
    @new_assignee = task.contact.person
    @old_assignee = old_assignee
    recipients = make_recipients_list([@assigner, @new_assignee, @old_assignee])

    mail(:to => recipients,
         :subject => '[MHDT Connect] Person (re)assigned to you')
  end

  def welcome_email(user, password)
    @user = user
    @password = password
    @webmaster_email = 'ryan.saundersMHDT@gmail.com'
    recipients = make_recipients_list([@user.person])
    mail(:to => recipients,
         :subject => '[MHDT Connect] Your new user account')
  end

private
  def make_recipients_list(people)
    recipients = []
    people.each do |p|
      if !p.nil? && !p.email.nil?
        recipients << "\"#{p.name}\" <#{p.email}>"
      end
    end
    return recipients
  end
end
