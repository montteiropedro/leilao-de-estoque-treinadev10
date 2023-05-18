require 'rails_helper'

describe 'User visits a approved lot details page' do
  it 'from menu' do
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
      creator: admin_user_a, approver: admin_user_b
    )

    visit root_path
    within('#lot-menu') do
      click_on 'Listar Lotes'
    end
    within('section#lots-approved') do
      click_on 'Lote COD123456'
    end

    expect(current_path).to eq lot_path(lot)
  end

  context 'when is a visitant' do
    it 'should see the approved tag' do
      admin_user_a = User.create!(
        name: 'John Doe', cpf: '41760209031',
        email: 'john@leilaodogalpao.com.br', password: 'password123'
      )
      admin_user_b = User.create!(
        name: 'Steve Gates', cpf: '35933681024',
        email: 'steve@leilaodogalpao.com.br', password: 'password123'
      )
      Lot.create!(
        code: 'COD123456', start_date: Date.today, end_date: 3.days.from_now,
        min_bid_in_centavos: 10_000, min_diff_between_bids_in_centavos: 5_000,
        creator: admin_user_a, approver: admin_user_b
      )
  
      visit root_path
      click_on 'Listar Lotes'
      click_on 'Lote COD123456'
  
      expect(page).to have_content 'Aprovado por Steve Gates'
    end

    context 'the admin menu' do
      it 'should not be displayed' do
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
          creator: admin_user_a, approver: admin_user_b
        )
    
        visit root_path
        click_on 'Listar Lotes'
        click_on 'Lote COD123456'
        
        expect(current_path).to eq lot_path(lot)
        expect(page).not_to have_css 'div#admin-menu'
        expect(page).not_to have_button 'Aprovar Lote'
        expect(page).not_to have_button 'Encerrar Lote'
        expect(page).not_to have_button 'Cancelar Lote'
      end
    end

    context 'the bids section' do
      it 'should not be displayed when lot is waiting to start' do
        admin_user_a = User.create!(
          name: 'John Doe', cpf: '41760209031',
          email: 'john@leilaodogalpao.com.br', password: 'password123'
        )
        admin_user_b = User.create!(
          name: 'Steve Gates', cpf: '35933681024',
          email: 'steve@leilaodogalpao.com.br', password: 'password123'
        )
        Lot.create!(
          code: 'COD123456', start_date: 1.week.from_now, end_date: 2.weeks.from_now,
          min_bid_in_centavos: 10_000, min_diff_between_bids_in_centavos: 5_000,
          creator: admin_user_a, approver: admin_user_b
        )
  
        visit root_path
        click_on 'Listar Lotes'
        within('section#lots-waiting-start') do
          click_on 'COD123456'
        end
  
        expect(page).not_to have_css 'h2', text: 'Lances'
        expect(page).not_to have_field 'Lance em reais'
        expect(page).not_to have_button 'Fazer Lance'
      end

      it 'should be displayed without the form to make a bid when lot is in progress' do
        admin_user_a = User.create!(
          name: 'John Doe', cpf: '41760209031',
          email: 'john@leilaodogalpao.com.br', password: 'password123'
        )
        admin_user_b = User.create!(
          name: 'Steve Gates', cpf: '35933681024',
          email: 'steve@leilaodogalpao.com.br', password: 'password123'
        )
        Lot.create!(
          code: 'COD123456', start_date: Date.today, end_date: 1.week.from_now,
          min_bid_in_centavos: 10_000, min_diff_between_bids_in_centavos: 5_000,
          creator: admin_user_a, approver: admin_user_b
        )
  
        visit root_path
        click_on 'Listar Lotes'
        within('section#lots-in-progress') do
          click_on 'COD123456'
        end
  
        within('section#bids') do
          expect(page).to have_css 'h2', text: 'Lances'
          expect(page).to have_content 'O lote ainda não recebeu um lance.'
          expect(page).not_to have_field 'Lance em reais'
          expect(page).not_to have_button 'Fazer Lance'
        end
      end
    end

    it 'should not see the form to add a product to the lot' do
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
        creator: admin_user_a, approver: admin_user_b
      )

      visit root_path
      click_on 'Listar Lotes'
      click_on 'Lote COD123456'
  
      expect(page).not_to have_field 'product_id'
      expect(page).not_to have_button 'Adicionar'
    end
  end

  context 'when is not a admin' do
    it 'should see the approved tag' do
      user = User.create!(
        name: 'Peter Parker', cpf: '73046259026',
        email: 'peter@email.com', password: 'password123'
      )
      admin_user_a = User.create!(
        name: 'John Doe', cpf: '41760209031',
        email: 'john@leilaodogalpao.com.br', password: 'password123'
      )
      admin_user_b = User.create!(
        name: 'Steve Gates', cpf: '35933681024',
        email: 'steve@leilaodogalpao.com.br', password: 'password123'
      )
      Lot.create!(
        code: 'COD123456', start_date: Date.today, end_date: 3.days.from_now,
        min_bid_in_centavos: 10_000, min_diff_between_bids_in_centavos: 5_000,
        creator: admin_user_a, approver: admin_user_b
      )
  
      login_as user
      visit root_path
      click_on 'Listar Lotes'
      click_on 'Lote COD123456'
  
      expect(page).to have_content 'Aprovado por Steve Gates'
    end

    context 'the admin menu' do
      it 'should not be displayed' do
        user = User.create!(
          name: 'Peter Parker', cpf: '73046259026',
          email: 'peter@email.com', password: 'password123'
        )
        admin_user_a = User.create!(
          name: 'John Doe', cpf: '41760209031',
          email: 'john@leilaodogalpao.com.br', password: 'password123'
        )
        admin_user_b = User.create!(
          name: 'Steve Gates', cpf: '35933681024',
          email: 'steve@leilaodogalpao.com.br', password: 'password123'
        )
        lot = Lot.create!(
          code: 'COD123456', start_date: Date.today, end_date: 1.week.from_now,
          min_bid_in_centavos: 10_000, min_diff_between_bids_in_centavos: 5_000,
          creator: admin_user_a, approver: admin_user_b
        )
    
        login_as user
        visit root_path
        click_on 'Listar Lotes'
        click_on 'Lote COD123456'
        
        expect(current_path).to eq lot_path(lot)
        expect(page).not_to have_css 'div#admin-menu'
        expect(page).not_to have_button 'Aprovar Lote'
        expect(page).not_to have_button 'Encerrar Lote'
        expect(page).not_to have_button 'Cancelar Lote'
      end
    end

    context 'the bids section' do
      it 'should not be displayed when lot is waiting to start' do
        user = User.create!(
          name: 'Peter Parker', cpf: '73046259026',
          email: 'peter@email.com', password: 'password123'
        )
        admin_user_a = User.create!(
          name: 'John Doe', cpf: '41760209031',
          email: 'john@leilaodogalpao.com.br', password: 'password123'
        )
        admin_user_b = User.create!(
          name: 'Steve Gates', cpf: '35933681024',
          email: 'steve@leilaodogalpao.com.br', password: 'password123'
        )
        Lot.create!(
          code: 'COD123456', start_date: 1.week.from_now, end_date: 2.weeks.from_now,
          min_bid_in_centavos: 10_000, min_diff_between_bids_in_centavos: 5_000,
          creator: admin_user_a, approver: admin_user_b
        )
  
        login_as user
        visit root_path
        click_on 'Listar Lotes'
        within('section#lots-waiting-start') do
          click_on 'COD123456'
        end
  
        expect(page).not_to have_css 'h2', text: 'Lances'
        expect(page).not_to have_field 'Lance em reais'
        expect(page).not_to have_button 'Fazer Lance'
      end

      it 'should be displayed with the form to make a bid when lot is in progress' do
        user = User.create!(
          name: 'Peter Parker', cpf: '73046259026',
          email: 'peter@email.com', password: 'password123'
        )
        admin_user_a = User.create!(
          name: 'John Doe', cpf: '41760209031',
          email: 'john@leilaodogalpao.com.br', password: 'password123'
        )
        admin_user_b = User.create!(
          name: 'Steve Gates', cpf: '35933681024',
          email: 'steve@leilaodogalpao.com.br', password: 'password123'
        )
        Lot.create!(
          code: 'COD123456', start_date: Date.today, end_date: 3.days.from_now,
          min_bid_in_centavos: 10_000, min_diff_between_bids_in_centavos: 5_000,
          creator: admin_user_a, approver: admin_user_b
        )
  
        login_as user
        visit root_path
        click_on 'Listar Lotes'
        within('section#lots-in-progress') do
          click_on 'COD123456'
        end
  
        within('section#bids') do
          expect(page).to have_css 'h2', text: 'Lances'
          expect(page).to have_content 'O lote ainda não recebeu um lance.'
          within('form') do
            expect(page).to have_field 'Lance em reais'
            expect(page).to have_button 'Fazer Lance'
          end
        end
      end
    end

    it 'should not see the form to add a product to the lot' do
      user = User.create!(
        name: 'Peter Parker', cpf: '73046259026',
        email: 'peter@email.com', password: 'password123'
      )
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
        creator: admin_user_a, approver: admin_user_b
      )

      login_as user
      visit root_path
      click_on 'Listar Lotes'
      click_on 'Lote COD123456'
  
      expect(page).not_to have_field 'product_id'
      expect(page).not_to have_button 'Adicionar'
    end
  end

  context 'when is a admin' do
    it 'should see the approved tag' do
      admin_user_a = User.create!(
        name: 'John Doe', cpf: '41760209031',
        email: 'john@leilaodogalpao.com.br', password: 'password123'
      )
      admin_user_b = User.create!(
        name: 'Steve Gates', cpf: '35933681024',
        email: 'steve@leilaodogalpao.com.br', password: 'password123'
      )
      Lot.create!(
        code: 'COD123456', start_date: Date.today, end_date: 3.days.from_now,
        min_bid_in_centavos: 10_000, min_diff_between_bids_in_centavos: 5_000,
        creator: admin_user_a, approver: admin_user_b
      )
  
      login_as admin_user_a
      visit root_path
      click_on 'Listar Lotes'
      click_on 'Lote COD123456'
  
      expect(page).to have_content 'Aprovado por Steve Gates'
    end

    context 'the admin menu' do
      it 'should show a button to close the lot when it is expired and has at least one bid' do
        user = User.create!(
          name: 'Peter Parker', cpf: '73046259026',
          email: 'peter@email.com', password: 'password123'
        )
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
          creator: admin_user_a, approver: admin_user_b
        )
        Bid.create!(user: user, lot: lot, value_in_centavos: 20_000)
    
        travel_to 1.week.from_now do
          login_as admin_user_a
          visit lot_path(lot)
        end
        
        within('div#admin-menu') do
          expect(page).to have_button 'Encerrar Lote'
          expect(page).not_to have_button 'Cancelar Lote'
          expect(page).not_to have_button 'Aprovar Lote'
        end
      end

      it 'should show a button to cancel the lot when it is expired and has no bids' do
        user = User.create!(
          name: 'Peter Parker', cpf: '73046259026',
          email: 'peter@email.com', password: 'password123'
        )
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
          creator: admin_user_a, approver: admin_user_b
        )
    
        travel_to 1.week.from_now do
          login_as admin_user_a
          visit lot_path(lot)
        end
        
        within('div#admin-menu') do
          expect(page).to have_button 'Cancelar Lote'
          expect(page).not_to have_button 'Encerrar Lote'
          expect(page).not_to have_button 'Aprovar Lote'
        end
      end
    end

    context 'the bids section' do
      it 'should not be displayed when lot is waiting to start' do
        admin_user_a = User.create!(
          name: 'John Doe', cpf: '41760209031',
          email: 'john@leilaodogalpao.com.br', password: 'password123'
        )
        admin_user_b = User.create!(
          name: 'Steve Gates', cpf: '35933681024',
          email: 'steve@leilaodogalpao.com.br', password: 'password123'
        )
        Lot.create!(
          code: 'COD123456', start_date: 1.week.from_now, end_date: 2.weeks.from_now,
          min_bid_in_centavos: 10_000, min_diff_between_bids_in_centavos: 5_000,
          creator: admin_user_a, approver: admin_user_b
        )
  
        login_as admin_user_a
        visit root_path
        click_on 'Listar Lotes'
        within('section#lots-waiting-start') do
          click_on 'COD123456'
        end
  
        expect(page).not_to have_css 'h2', text: 'Lances'
        expect(page).not_to have_field 'Lance em reais'
        expect(page).not_to have_button 'Fazer Lance'
      end

      it 'should be displayed without the form to make a bid when lot is in progress' do
        admin_user_a = User.create!(
          name: 'John Doe', cpf: '41760209031',
          email: 'john@leilaodogalpao.com.br', password: 'password123'
        )
        admin_user_b = User.create!(
          name: 'Steve Gates', cpf: '35933681024',
          email: 'steve@leilaodogalpao.com.br', password: 'password123'
        )
        Lot.create!(
          code: 'COD123456', start_date: Date.today, end_date: 3.days.from_now,
          min_bid_in_centavos: 10_000, min_diff_between_bids_in_centavos: 5_000,
          creator: admin_user_a, approver: admin_user_b
        )
  
        login_as admin_user_a
        visit root_path
        click_on 'Listar Lotes'
        within('section#lots-in-progress') do
          click_on 'COD123456'
        end
  
        within('section#bids') do
          expect(page).to have_css 'h2', text: 'Lances'
          expect(page).to have_content 'O lote ainda não recebeu um lance.'
          expect(page).not_to have_field 'Lance em reais'
          expect(page).not_to have_button 'Fazer Lance'
        end
      end

      it 'should be displayed without the form to make a bid when lot is expired' do
        admin_user_a = User.create!(
          name: 'John Doe', cpf: '41760209031',
          email: 'john@leilaodogalpao.com.br', password: 'password123'
        )
        admin_user_b = User.create!(
          name: 'Steve Gates', cpf: '35933681024',
          email: 'steve@leilaodogalpao.com.br', password: 'password123'
        )
        Lot.create!(
          code: 'COD123456', start_date: Date.today, end_date: 3.day.from_now,
          min_bid_in_centavos: 10_000, min_diff_between_bids_in_centavos: 5_000,
          creator: admin_user_a, approver: admin_user_b
        )
  
        travel_to 1.week.from_now do
          login_as admin_user_a
          visit root_path
          click_on 'Listar Lotes Expirados'
          within('section#lots-expired') do
            click_on 'COD123456'
          end
        end
  
        within('section#bids') do
          expect(page).to have_css 'h2', text: 'Lances'
          expect(page).to have_content 'O lote ainda não recebeu um lance.'
          expect(page).not_to have_field 'Lance em reais'
          expect(page).not_to have_button 'Fazer Lance'
        end
      end
    end

    it 'should not see the form to add a product to the lot' do
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
        creator: admin_user_a, approver: admin_user_b
      )

      login_as admin_user_a
      visit root_path
      click_on 'Listar Lotes'
      click_on 'Lote COD123456'
  
      expect(page).not_to have_field 'product_id'
      expect(page).not_to have_button 'Adicionar'
    end
  end
end
