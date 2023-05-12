require 'rails_helper'

describe 'Admin approves a batch' do
  context 'when is not the batch creator' do
    context 'and batch is expired' do
      it 'should not be sucessful' do
        admin_creator = User.create!(
          name: 'John Doe', cpf: '41760209031',
          email: 'john@leilaodogalpao.com.br', password: 'password123'
        )
        admin_approver = User.create!(
          name: 'Steve Gates', cpf: '35933681024',
          email: 'steve@leilaodogalpao.com.br', password: 'password123'
        )
        Batch.new(
          code: 'COD123456', start_date: Date.today - 1.week, end_date: Date.today - 1.day,
          min_bid_in_centavos: 10_000, min_diff_between_bids_in_centavos: 5_000,
          creator: admin_creator
        ).save!(validate: false)
    
        login_as(admin_approver)
        visit root_path
        click_on 'Listar Lotes Expirados'
        click_on 'Lote COD123456'
        
        expect(page).not_to have_content 'Aprovar Lote'
      end
    end

    context 'and batch is in progress' do
      it 'should be sucessful' do
        admin_creator = User.create!(
          name: 'John Doe', cpf: '41760209031',
          email: 'john@leilaodogalpao.com.br', password: 'password123'
        )
        admin_approver = User.create!(
          name: 'Steve Gates', cpf: '35933681024',
          email: 'steve@leilaodogalpao.com.br', password: 'password123'
        )
        batch = Batch.create!(
          code: 'COD123456', start_date: Date.today, end_date: Date.today + 1.week,
          min_bid_in_centavos: 10_000, min_diff_between_bids_in_centavos: 5_000,
          creator: admin_creator
        )
    
        login_as(admin_approver)
        visit root_path
        click_on 'Listar Lotes'
        click_on 'Lote COD123456'
        click_on 'Aprovar Lote'
    
        expect(page).to have_content 'Lote aprovado com sucesso.'
        expect(page).to have_content 'Aprovado por Steve Gates'
      end
    end

    context 'and batch is waiting for start' do
      it 'should be sucessful' do
        admin_creator = User.create!(
          name: 'John Doe', cpf: '41760209031',
          email: 'john@leilaodogalpao.com.br', password: 'password123'
        )
        admin_approver = User.create!(
          name: 'Steve Gates', cpf: '35933681024',
          email: 'steve@leilaodogalpao.com.br', password: 'password123'
        )
        batch = Batch.create!(
          code: 'COD123456', start_date: Date.today + 1.week, end_date: Date.today + 2.week,
          min_bid_in_centavos: 10_000, min_diff_between_bids_in_centavos: 5_000,
          creator: admin_creator
        )
    
        login_as(admin_approver)
        visit root_path
        click_on 'Listar Lotes'
        click_on 'Lote COD123456'
        click_on 'Aprovar Lote'
    
        expect(page).to have_content 'Lote aprovado com sucesso.'
        expect(page).to have_content 'Aprovado por Steve Gates'
      end
    end
  end

  context 'and is the batch creator' do
    it 'should not be sucessful' do
      admin_creator = User.create!(
        name: 'John Doe', cpf: '41760209031',
        email: 'john@leilaodogalpao.com.br', password: 'password123'
      )
      batch = Batch.create!(
        code: 'COD123456', start_date: Date.today, end_date: Date.today + 1,
        min_bid_in_centavos: 10_000, min_diff_between_bids_in_centavos: 5_000,
        creator: admin_creator
      )
  
      login_as(admin_creator)
      visit root_path
      click_on 'Listar Lotes'
      click_on 'Lote COD123456'
  
      expect(page).not_to have_button 'Aprovar Lote'
    end
  end
end
