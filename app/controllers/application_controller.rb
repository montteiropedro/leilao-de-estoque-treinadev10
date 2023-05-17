class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :cpf])
  end

  private

  def is_admin?
    redirect_to root_path unless current_user.is_admin
  end

  def reais_to_centavos(amount)
    amount.to_i * 100 unless amount.blank?
  end
end
