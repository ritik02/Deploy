require "rails_helper"

RSpec.describe UserMailer, type: :mailer do
	fixtures :deployments , :users

	describe "deplyoment_email "do
		let(:mail) { described_class.deployment_request_email(deployments(:one)).deliver_now }
		it 'renders the subject' do
      expect(mail.subject).to eq('Production Deployment Approval')
    end

    it 'renders the receiver email' do
      expect(mail.to).to eq(["prakash.d.aux@go-jek.com"])
    end

    it 'renders the sender email' do
      expect(mail.from).to eq(['go.deploy@go-jek.com'])
    end

    it 'sends an email' do
      expect { described_class.deployment_request_email(deployments(:one)).deliver_now}.to change { ActionMailer::Base.deliveries.count }.by(1)
    end
	end
end
