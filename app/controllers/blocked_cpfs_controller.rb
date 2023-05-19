class BlockedCpfsController < ApplicationController
  before_action :authenticate_user!
  before_action :is_admin?

  def index
    @blocked_cpfs = BlockedCpf.order(created_at: :desc)
  end

  def create
    blocked_cpf = BlockedCpf.new(cpf: params[:cpf])

    if blocked_cpf.save
      redirect_to blocked_cpfs_path, notice: 'CPF bloqueado com sucesso.'
    else
      redirect_to blocked_cpfs_path, notice: 'CPF inválido ou já bloqueado.'
    end
  end

  def destroy
    blocked_cpf = BlockedCpf.find(params[:id])

    if blocked_cpf.destroy
      redirect_to blocked_cpfs_path, notice: 'CPF desbloqueado com sucesso.'
    else
      redirect_to blocked_cpfs_path, notice: 'Falha ao desbloquear o CPF.'
    end
  end
end
