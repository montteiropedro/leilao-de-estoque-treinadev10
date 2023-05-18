class CpfValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return if value.blank?
    
    if BlockedCpf.find_by(cpf: value)
      record.errors.add(attribute, options[:message] || 'bloqueado')
    else
      return if cpf_is_valid?(value)
      record.errors.add(attribute, options[:message] || 'não é válido')
    end
  end

  private

  CPF_FORMAT = /^[0-9]{11}$/
  CPF_SIZE = 11

  DENY_LIST = %w[
    00000000000 11111111111 22222222222 33333333333 44444444444 55555555555
    66666666666 77777777777 88888888888 99999999999 12345678909 01234567890
  ].freeze

  def cpf_is_valid?(cpf)
    return unless CPF_FORMAT.match? cpf
    return if DENY_LIST.include? cpf

    verifying_digit = ''
    verifying_digit << cpf_find_verifying_digits(digits: cpf[0..8], descending_sequence_from: 10).to_s
    verifying_digit << cpf_find_verifying_digits(digits: cpf[0..9], descending_sequence_from: 11).to_s
    
    cpf[9..10] == verifying_digit
  end

  def cpf_find_verifying_digits(digits:, descending_sequence_from:)
    final_result = digits.chars.map(&:to_i).sum do |number|
      result = number * descending_sequence_from
      descending_sequence_from -= 1
      
      result
    end

    cpf_define_verifying_digit(CPF_SIZE - (final_result % CPF_SIZE))
  end

  def cpf_define_verifying_digit(number)
    return number if number < 10

    0
  end
end
