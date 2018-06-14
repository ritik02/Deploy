class UserMailer < ApplicationMailer
	default from: 'notifications@example.com'
 
  def welcome_email
    # @user = params[:user]
    # @url  = 'http://example.com/login'
    mail(to: "prakash.d.aux@go-jek.com", subject: 'Welcome to My Awesome Site')
  end

  def sample_email(user)
    @user = user
    mail(to: "prakash.d.aux@go-jek.com" , subject: 'Sample Email')
  end
end
