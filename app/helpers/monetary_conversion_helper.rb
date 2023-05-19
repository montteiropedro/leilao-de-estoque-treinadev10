module MonetaryConversionHelper
  def centavos_to_reais(amount, with_unit:)
    if with_unit
      number_to_currency(amount / 100, unit: 'R$', separator: ',', delimiter: '.')
    else
      number_to_currency(amount / 100, unit: '', separator: ',', delimiter: '.')
    end
  end

  def format_cpf(text)
    cpf = text.match(/(\d{3})(\d{3})(\d{3})(\d{2})/)

    "#{cpf[1]}.#{cpf[2]}.#{cpf[3]}-#{cpf[4]}"
  end
end
