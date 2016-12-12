class RoomhereMailer < Devise::Mailer
  include Devise::Controllers::UrlHelpers # Optional. eg. `confirmation_url`
  default template_path: 'devise/mailer'

  def confirmation_instructions(record, token, opts={})
    @payment_request_token = opts[:payment_request_token]
    super
  end
end
