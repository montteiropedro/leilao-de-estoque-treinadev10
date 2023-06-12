class Bid < ApplicationRecord
  belongs_to :user
  belongs_to :lot

  validates :value_in_centavos, presence: true
  validates :value_in_centavos, numericality: { only_integer: true, greater_than: 0 }
  validate :valid_bid?
  validate :user_can_make_bid?

  private

  def valid_bid?
    return if value_in_centavos.blank?
    return if lot.blank?
    return errors.add(:lot, 'não aprovado') if lot.approver.blank?
    return errors.add(:lot, 'não esta no periodo de leilão') unless lot.in_progress?

    if lot.bids.blank?
      return if value_in_centavos >= (lot.min_bid_in_centavos + 100)

      errors.add(
        :value_in_centavos,
        "deve ser maior ou igual a R$ #{(lot.min_bid_in_centavos + 100) / 100},00"
      )
    else
      winning_bid = lot.bids.maximum(:value_in_centavos)
      min_diff_between_bids = lot.min_diff_between_bids_in_centavos

      return if value_in_centavos >= (winning_bid + min_diff_between_bids)

      errors.add(:value_in_centavos, "deve ser maior ou igual a R$ #{(winning_bid + min_diff_between_bids) / 100},00")
    end
  end

  def user_can_make_bid?
    return if user.blank?

    return errors.add(:user, 'com CPF bloqueado não podem fazer lances') if user.cpf_blocked?
    return errors.add(:user, 'administradores não podem fazer lances') if user.is_admin
  end
end
