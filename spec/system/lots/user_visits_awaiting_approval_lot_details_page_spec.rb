require 'rails_helper'

describe 'User visits a lot awaiting approval details page' do
  it 'from menu' do
    admin_user = User.create!(
      name: 'John Doe', cpf: '41760209031',
      email: 'john@leilaodogalpao.com.br', password: 'password123'
    )
    lot = Lot.create!(
      code: 'COD123456', start_date: Date.today, end_date: Date.today + 1.day,
      min_bid_in_centavos: 10_000, min_diff_between_bids_in_centavos: 5_000,
      creator: admin_user
    )

    login_as admin_user
    visit root_path
    within('#lot-menu') do
      click_on 'Listar Lotes'
    end
    within('section#lots-awaiting-approval') do
      click_on 'Lote COD123456'
    end

    expect(current_path).to eq lot_path(lot)
  end

  context 'when is a visitant' do
    it 'should not be able to visit it' do
      admin_user = User.create!(
        name: 'John Doe', cpf: '41760209031',
        email: 'john@leilaodogalpao.com.br', password: 'password123'
      )
      lot = Lot.create!(
        code: 'COD123456', start_date: Date.today, end_date: 3.days.from_now,
        min_bid_in_centavos: 10_000, min_diff_between_bids_in_centavos: 5_000,
        creator: admin_user
      )
  
      visit lot_path(lot)
      
      expect(current_path).not_to eq lot_path(lot)
    end
  end

  context 'when is not a admin' do
    it 'should not be able to visit it' do
      user = User.create!(
        name: 'Peter Parker', cpf: '73046259026',
        email: 'peter@email.com', password: 'password123'
      )
      admin_user = User.create!(
        name: 'John Doe', cpf: '41760209031',
        email: 'john@leilaodogalpao.com.br', password: 'password123'
      )
      lot = Lot.create!(
        code: 'COD123456', start_date: Date.today, end_date: 3.days.from_now,
        min_bid_in_centavos: 10_000, min_diff_between_bids_in_centavos: 5_000,
        creator: admin_user
      )
  
      login_as user
      visit lot_path(lot)
      
      expect(current_path).not_to eq lot_path(lot)
    end
  end

  context 'when is a admin' do
    it 'should be successful' do
      admin_user = User.create!(
        name: 'John Doe', cpf: '41760209031',
        email: 'john@leilaodogalpao.com.br', password: 'password123'
      )
      lot = Lot.create!(
        code: 'COD123456', start_date: Date.today, end_date: 3.days.from_now,
        min_bid_in_centavos: 10_000, min_diff_between_bids_in_centavos: 5_000,
        creator: admin_user
      )
  
      login_as admin_user
      visit root_path
      click_on 'Listar Lotes'
      within('section#lots-awaiting-approval') do
        click_on 'Lote COD123456'
      end
      
      expect(current_path).to eq lot_path(lot)
      expect(page).to have_content 'Lote COD123456'
      expect(page).to have_content 'Administrado por John Doe <john@leilaodogalpao.com.br>'
      expect(page).to have_content "Data de Início: #{lot.start_date.strftime('%d/%m/%Y')}"
      expect(page).to have_content "Data do Fim: #{lot.end_date.strftime('%d/%m/%Y')}"
      expect(page).to have_content 'Lance Mínimo: R$ 100,00'
      expect(page).to have_content 'Diferença Mínima Entre Lances: R$ 50,00'
    end

    context 'the admin menu' do
      it 'should show the button to approve the lot if it was not created by him' do
        admin_user_a = User.create!(
          name: 'John Doe', cpf: '41760209031',
          email: 'john@leilaodogalpao.com.br', password: 'password123'
        )
        admin_user_b = User.create!(
          name: 'Steve Gates', cpf: '35933681024',
          email: 'steve@leilaodogalpao.com.br', password: 'password123'
        )
        lot = Lot.create!(
          code: 'COD123456', start_date: Date.today, end_date: 3.days.from_now,
          min_bid_in_centavos: 10_000, min_diff_between_bids_in_centavos: 5_000,
          creator: admin_user_b
        )
  
        login_as admin_user_a
        visit root_path
        click_on 'Listar Lotes'
        click_on 'Lote COD123456'
    
        within('div#admin-menu') do
          expect(page).to have_button 'Aprovar Lote'
        end
      end
  
      it 'should not show the button to approve the lot if it was created by him' do
        admin_user = User.create!(
          name: 'John Doe', cpf: '41760209031',
          email: 'john@leilaodogalpao.com.br', password: 'password123'
        )
        lot = Lot.create!(
          code: 'COD123456', start_date: Date.today, end_date: 3.days.from_now,
          min_bid_in_centavos: 10_000, min_diff_between_bids_in_centavos: 5_000,
          creator: admin_user
        )
  
        login_as admin_user
        visit root_path
        click_on 'Listar Lotes'
        click_on 'Lote COD123456'
    
        within('div#admin-menu') do
          expect(page).not_to have_button 'Aprovar Lote'
        end
      end

      it 'should show a button to approve the lot when it is not expired' do
        admin_user_a = User.create!(
          name: 'John Doe', cpf: '41760209031',
          email: 'john@leilaodogalpao.com.br', password: 'password123'
        )
        admin_user_b = User.create!(
          name: 'Steve Gates', cpf: '35933681024',
          email: 'steve@leilaodogalpao.com.br', password: 'password123'
        )
        lot = Lot.create!(
          code: 'COD123456', start_date: Date.today, end_date: 3.days.from_now,
          min_bid_in_centavos: 10_000, min_diff_between_bids_in_centavos: 5_000,
          creator: admin_user_a
        )
    
        login_as admin_user_b
        visit lot_path(lot)
        
        within('div#admin-menu') do
          expect(page).to have_button 'Aprovar Lote'
        end
      end

      it 'should not show a button to approve the lot when it is expired' do
        admin_user_a = User.create!(
          name: 'John Doe', cpf: '41760209031',
          email: 'john@leilaodogalpao.com.br', password: 'password123'
        )
        admin_user_b = User.create!(
          name: 'Steve Gates', cpf: '35933681024',
          email: 'steve@leilaodogalpao.com.br', password: 'password123'
        )
        lot = Lot.create!(
          code: 'COD123456', start_date: Date.today, end_date: 3.days.from_now,
          min_bid_in_centavos: 10_000, min_diff_between_bids_in_centavos: 5_000,
          creator: admin_user_a
        )
      
        travel_to 1.week.from_now do
          login_as admin_user_b
          visit lot_path(lot)
        end
        
        within('div#admin-menu') do
          expect(page).not_to have_button 'Aprovar Lote'
        end
      end

      it 'should show a button to cancel the lot when it is expired' do
        admin_user = User.create!(
          name: 'John Doe', cpf: '41760209031',
          email: 'john@leilaodogalpao.com.br', password: 'password123'
        )
        lot = Lot.create!(
          code: 'COD123456', start_date: Date.today, end_date: 3.days.from_now,
          min_bid_in_centavos: 10_000, min_diff_between_bids_in_centavos: 5_000,
          creator: admin_user
        )
    
        travel_to 1.week.from_now do
          login_as admin_user
          visit lot_path(lot)
        end

        within('div#admin-menu') do
          expect(page).to have_button 'Cancelar Lote'
        end
      end

      it 'should not show a button to close the lot when it is expired (and does not have a buyer, as it is awaiting approval yet)' do
        admin_user = User.create!(
          name: 'John Doe', cpf: '41760209031',
          email: 'john@leilaodogalpao.com.br', password: 'password123'
        )
        lot = Lot.create!(
          code: 'COD123456', start_date: Date.today, end_date: 3.days.from_now,
          min_bid_in_centavos: 10_000, min_diff_between_bids_in_centavos: 5_000,
          creator: admin_user
        )
    
        travel_to 1.week.from_now do
          login_as admin_user
          visit lot_path(lot)
        end
        
        within('div#admin-menu') do
          expect(page).not_to have_button 'Encerrar Lote'
        end
      end
    end

    context 'the bids section' do
      it 'should not be displayed when lot is waiting to start' do
        admin_user = User.create!(
          name: 'John Doe', cpf: '41760209031',
          email: 'john@leilaodogalpao.com.br', password: 'password123'
        )
        lot = Lot.create!(
          code: 'COD123456', start_date: 1.week.from_now, end_date: 2.weeks.from_now,
          min_bid_in_centavos: 10_000, min_diff_between_bids_in_centavos: 5_000,
          creator: admin_user
        )
  
        login_as admin_user
        visit root_path
        click_on 'Listar Lotes'
        within('section#lots-awaiting-approval') do
          click_on 'COD123456'
        end
  
        expect(page).not_to have_css 'h2', text: 'Lances'
        expect(page).not_to have_field 'Lance em reais'
        expect(page).not_to have_button 'Fazer Lance'
      end

      it 'should not be displayed when lot is in progress' do
        admin_user = User.create!(
          name: 'John Doe', cpf: '41760209031',
          email: 'john@leilaodogalpao.com.br', password: 'password123'
        )
        Lot.create!(
          code: 'COD123456', start_date: Date.today, end_date: 1.week.from_now,
          min_bid_in_centavos: 10_000, min_diff_between_bids_in_centavos: 5_000,
          creator: admin_user
        )
  
        login_as admin_user
        visit root_path
        click_on 'Listar Lotes'
        within('section#lots-awaiting-approval') do
          click_on 'COD123456'
        end
  
        expect(page).not_to have_css 'h2', text: 'Lances'
        expect(page).not_to have_field 'Lance em reais'
        expect(page).not_to have_button 'Fazer Lance'
      end

      it 'should not be displayed when lot is expired' do
        admin_user = User.create!(
          name: 'John Doe', cpf: '41760209031',
          email: 'john@leilaodogalpao.com.br', password: 'password123'
        )
        lot = Lot.create!(
          code: 'COD123456', start_date: Date.today, end_date: 3.days.from_now,
          min_bid_in_centavos: 10_000, min_diff_between_bids_in_centavos: 5_000,
          creator: admin_user
        )
  
        travel_to 1.week.from_now do
          login_as admin_user
          visit root_path
          click_on 'Listar Lotes Expirados'
          within('section#lots-expired') do
            click_on 'COD123456'
          end
        end
        
        expect(page).not_to have_css 'h2', text: 'Lances'
        expect(page).not_to have_field 'Lance em reais'
        expect(page).not_to have_button 'Fazer Lance'
      end
    end

    it 'should see the form to add a product to it when lot is not expired' do
      admin_user = User.create!(
        name: 'John Doe', cpf: '41760209031',
        email: 'john@leilaodogalpao.com.br', password: 'password123'
      )
      lot = Lot.create!(
        code: 'COD123456', start_date: Date.today, end_date: 3.days.from_now,
        min_bid_in_centavos: 10_000, min_diff_between_bids_in_centavos: 5_000,
        creator: admin_user
      )

      login_as admin_user
      visit root_path
      click_on 'Listar Lotes'
      click_on 'Lote COD123456'
  
      expect(page).to have_field 'product_id'
      expect(page).to have_button 'Adicionar'
    end

    it 'should not see the form to add a product to it when lot is expired' do
      admin_user = User.create!(
        name: 'John Doe', cpf: '41760209031',
        email: 'john@leilaodogalpao.com.br', password: 'password123'
      )
      lot = Lot.create!(
        code: 'COD123456', start_date: Date.today, end_date: 3.days.from_now,
        min_bid_in_centavos: 10_000, min_diff_between_bids_in_centavos: 5_000,
        creator: admin_user
      )

      travel_to 1.week.from_now do
        login_as admin_user
        visit root_path
        click_on 'Listar Lotes Expirados'
        click_on 'Lote COD123456'
      end
  
      expect(page).not_to have_field 'product_id'
      expect(page).not_to have_button 'Adicionar'
    end
  end
end
