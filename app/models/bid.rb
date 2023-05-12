class Bid < ApplicationRecord
  belongs_to :user
  belongs_to :batch

  validates :value_in_centavos, presence: true
  validates :value_in_centavos, numericality: { only_integer: true, greater_than: 0 }
  validate :is_bid_valid?
  validate :is_user_allowed_to_make_a_bid?

  private

  # todo: fazer uma verificação para ver se o lote está aprovado, lotes só podem receber um lance se estiverem aprovados

  def is_bid_valid?
    return if self.value_in_centavos.blank?
    return if self.batch.blank?
    return errors.add(:batch, 'não esta no periodo de leilão') unless self.batch.in_progress?

    if self.batch.bids.blank?
      return if self.value_in_centavos > self.batch.min_bid_in_centavos

      errors.add(:value_in_centavos, "deve ser maior ou igual a #{self.batch.min_bid_in_centavos + 1}")
    else
      winning_bid = self.batch.bids.maximum(:value_in_centavos)
      min_diff_between_bids = self.batch.min_diff_between_bids_in_centavos

      return if self.value_in_centavos >= (winning_bid + min_diff_between_bids)

      errors.add(:value_in_centavos, "deve ser maior ou igual a #{winning_bid + min_diff_between_bids}")
    end
  end

  def is_user_allowed_to_make_a_bid?
    if self.user.present? && self.user.is_admin
      errors.add(:user, 'administradores não podem fazer lances')
    end
  end
end
