class Devise::PasswordsController < DeviseTokenAuth::PasswordsController

  def render_edit_error
    redirect_to "https://roomhere.io"
  end

end
