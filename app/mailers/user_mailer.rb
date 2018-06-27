class UserMailer < ApplicationMailer
  default from: 'go.deploy@go-jek.com'

  def deployment_request_email(deployment)
    @deployment = deployment
    mail(to: User.find(deployment.reviewer_id).email, subject: 'Production Deployment Approval')
  end

  def status_mail(deployment)
    @deployment = deployment
    mail(to: User.find(deployment.user_id).email, subject: 'Deployment Status Changed')
  end

  def deployment_trigger_mail(deployment, group_mail_id)
    @deployment = deployment
    mail(to: group_mail_id, subject: 'Deployment Trigger Notification')
  end
end
