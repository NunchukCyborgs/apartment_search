class EmergencyNotifier < ApplicationMailer

  def notify(user, property, crime)
    @user = user
    @property = property
    @crime = crime
    mail( :to => @user.email,
    :subject => 'An emergency has been reported at your property.' )
  end
end
