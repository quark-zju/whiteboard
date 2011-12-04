
class ApplicationController < ActionController::Base
  protect_from_forgery

  # Redirect users to public board by default.
  def root
    redirect_to controller: 'boards', action: 'show', id: 'public'
  end
end
