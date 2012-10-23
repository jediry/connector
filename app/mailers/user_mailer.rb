class UserMailer < ActionMailer::Base
  helper :application

  default from: webmaster_email

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
