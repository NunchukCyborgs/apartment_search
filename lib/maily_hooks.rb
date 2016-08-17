user = User.first
property = Property.first
crime = Crime.new(property.address1, "PROPERTY DAMAGE", "V: BRIAN M. HEADRICK, DOOR", "1155")

Maily.hooks_for('ApplicationMailer') do |mailer|
end

Maily.hooks_for('EmergencyNotifier') do |mailer|
  mailer.register_hook(:notify, user, property, crime)
end
