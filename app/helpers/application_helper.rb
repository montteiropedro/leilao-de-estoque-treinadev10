module ApplicationHelper
  def centavos_to_reais(amount, with_unit:)
    if with_unit
      number_to_currency(amount / 100, unit: 'R$', separator: ',', delimiter: '.')
    else
      number_to_currency(amount / 100, unit: '', separator: ',', delimiter: '.')
    end
  end
end
