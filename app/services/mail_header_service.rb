class MailHeaderService
  require 'smtpapi'

  def self.payment_request_confirmation_headers(payment_request)
      header = Smtpapi::Header.new
      header.add_to(payment_request.user_email)
      add_standard_headers(header)
      header.add_filter('templates', 'enable', 1)
      header.add_filter('templates', 'template_id', "d08b5a65-2c6a-4017-b853-155666b56e3c")
      header.add_substitution('user_name', payment_request.name)
      header.add_substitution('property_address', "#{payment_request.property_address1} #{payment_request.property_address2}")
      header.add_substitution('property_image_url', payment_request.property_main_image_url)
      header.add_substitution('payment_request_total', ActionController::Base.helpers.number_to_currency(payment_request.total, precision: 0))
      header.add_substitution('dashboard_url', "https://roomhere.io/account/dashboard")
      header.to_json
  end


  private

  def self.add_standard_headers(header)
    header.add_substitution('roomhere_url', 'https://roomhere.io')
    header.add_substitution('roomhere_url_formatted', 'Roomhere.io')
    header.add_substitution('roomhere_phone_url', 'tel:5732902363')
    header.add_substitution('roomhere_phone_formatted', '(573) 290-2363')
    header.add_substitution('roomhere_email_url', 'mailto:support@roomhere.io')
    header.add_substitution('roomhere_email_formatted', 'support@roomhere.io')
  end
end
