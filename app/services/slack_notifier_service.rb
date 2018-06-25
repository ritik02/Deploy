module SlackNotifierService
	def send_message_on_slack_channel(channel_name, message)
		@notifier = Slack::Notifier.new(Figaro.env.slack_webhook) do
			defaults channel: "#" + channel_name,
			username: "go-deploy"
		end
		@notifier.ping message
	end
end