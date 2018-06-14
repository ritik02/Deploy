class UserMailer < ApplicationMailer
	#default from: 'notifications@example.com'

  def sample_email(user , deployment)
    @deployment = deployment
    @user = user
    mail(to: "prakash.d.aux@go-jek.com" , subject: 'Sample Email')
  end
end
