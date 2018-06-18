class UserMailer < ApplicationMailer
  default from: 'go.deploy@go-jek.com'
  
  def sample_email(deployment)
    @deployment = deployment
    mail(to: User.find(deployment.reviewer_id).email, subject: 'Production Deployment Approval')
  end
end
