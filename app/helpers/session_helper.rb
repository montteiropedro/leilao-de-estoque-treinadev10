module SessionHelper
  def user_is_admin?
    return false unless current_user.is_admin

    true
  end

  def user_cpf_blocked?
    return false unless BlockedCpf.find_by(cpf: current_user.cpf)

    true
  end

  def user_can_make_a_bid?
    return false if user_cpf_blocked? || user_is_admin?

    true
  end
end
