require 'rails_helper'

describe 'User visits a lot details page' do
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

    login_as(admin_user)
    visit root_path
    within('#lot-menu') do
      click_on 'Listar Lotes'
    end
    click_on 'Lote COD123456'

    expect(current_path).to eq lot_path(lot)
  end

  it 'should be successful' do
    admin_user = User.create!(
      name: 'John Doe', cpf: '41760209031',
      email: 'john@leilaodogalpao.com.br', password: 'password123'
    )
    lot = Lot.create!(
      code: 'COD123456', start_date: Date.today, end_date: Date.today + 1.day,
      min_bid_in_centavos: 10_000, min_diff_between_bids_in_centavos: 5_000,
      creator: admin_user
    )

    login_as(admin_user)
    visit root_path
    click_on 'Listar Lotes'
    click_on 'Lote COD123456'

    expect(page).to have_content 'Lote COD123456'
    expect(page).to have_content 'Administrado por John Doe <john@leilaodogalpao.com.br>'
    expect(page).to have_content "Data de Início: #{lot.start_date.strftime('%d/%m/%Y')}"
    expect(page).to have_content "Data do Fim: #{lot.end_date.strftime('%d/%m/%Y')}"
    expect(page).to have_content 'Lance Mínimo: 10000 centavos'
    expect(page).to have_content 'Diferença Mínima Entre Lances: 5000 centavos'
  end

  it 'should show products linked to it' do
    admin_user = User.create!(
      name: 'John Doe', cpf: '41760209031',
      email: 'john@leilaodogalpao.com.br', password: 'password123'
    )
    lot = Lot.create!(
      code: 'COD123456', start_date: Date.today, end_date: Date.today + 1.day,
      min_bid_in_centavos: 10_000, min_diff_between_bids_in_centavos: 5_000,
      creator: admin_user
    )
    product = Product.create!(
      name: 'Quadro', weight: 1_000,
      width: 30, height: 50, depth: 5,
      lot: lot
    )

    login_as(admin_user)
    visit root_path
    click_on 'Listar Lotes'
    click_on 'Lote COD123456'

    expect(page).to have_content 'Quadro'
  end

  it 'should show a message when there is no products linked to it' do
    admin_user = User.create!(
      name: 'John Doe', cpf: '41760209031',
      email: 'john@leilaodogalpao.com.br', password: 'password123'
    )
    lot = Lot.create!(
      code: 'COD123456', start_date: Date.today, end_date: Date.today + 1.day,
      min_bid_in_centavos: 10_000, min_diff_between_bids_in_centavos: 5_000,
      creator: admin_user
    )

    login_as(admin_user)
    visit root_path
    click_on 'Listar Lotes'
    click_on 'Lote COD123456'

    expect(page).to have_content 'Não existem produtos vinculados a este lote.'
  end

  context 'when is a visitant' do
    context 'and the lot is approved' do
      it 'should be successful' do
        first_admin_user = User.create!(
          name: 'John Doe', cpf: '41760209031',
          email: 'john@leilaodogalpao.com.br', password: 'password123'
        )
        second_admin_user = User.create!(
          name: 'Steve Gates', cpf: '35933681024',
          email: 'steve@leilaodogalpao.com.br', password: 'password123'
        )
        lot = Lot.create!(
          code: 'COD123456', start_date: Date.today, end_date: Date.today + 1.day,
          min_bid_in_centavos: 10_000, min_diff_between_bids_in_centavos: 5_000,
          creator: first_admin_user, approver: second_admin_user
        )
    
        visit root_path
        click_on 'Listar Lotes'
        click_on 'Lote COD123456'
        
        expect(current_path).to eq lot_path(lot)
        expect(page).to have_content 'Aprovado por Steve Gates'
      end

      context 'the admin menu' do
        it 'should not be displayed' do
          first_admin_user = User.create!(
            name: 'John Doe', cpf: '41760209031',
            email: 'john@leilaodogalpao.com.br', password: 'password123'
          )
          second_admin_user = User.create!(
            name: 'Steve Gates', cpf: '35933681024',
            email: 'steve@leilaodogalpao.com.br', password: 'password123'
          )
          lot = Lot.create!(
            code: 'COD123456', start_date: Date.today, end_date: Date.today + 1.day,
            min_bid_in_centavos: 10_000, min_diff_between_bids_in_centavos: 5_000,
            creator: first_admin_user, approver: second_admin_user
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

      context 'the bids session' do
        it 'should not be displayed when lot is waiting to start' do
          first_admin_user = User.create!(
            name: 'John Doe', cpf: '41760209031',
            email: 'john@leilaodogalpao.com.br', password: 'password123'
          )
          second_admin_user = User.create!(
            name: 'Steve Gates', cpf: '35933681024',
            email: 'steve@leilaodogalpao.com.br', password: 'password123'
          )
          Lot.create!(
            code: 'COD123456', start_date: Date.today + 1.week, end_date: Date.today + 2.weeks,
            min_bid_in_centavos: 10_000, min_diff_between_bids_in_centavos: 5_000,
            creator: first_admin_user, approver: second_admin_user
          )
    
          visit root_path
          click_on 'Listar Lotes'
          within('div#lots-waiting-start') do
            click_on 'COD123456'
          end
    
          expect(page).not_to have_css 'h2', text: 'Lances'
          expect(page).not_to have_field 'Faça seu lance'
          expect(page).not_to have_button 'Fazer Lance'
        end

        it 'should be displayed without the form to make a bid when lot is in progress' do
          first_admin_user = User.create!(
            name: 'John Doe', cpf: '41760209031',
            email: 'john@leilaodogalpao.com.br', password: 'password123'
          )
          second_admin_user = User.create!(
            name: 'Steve Gates', cpf: '35933681024',
            email: 'steve@leilaodogalpao.com.br', password: 'password123'
          )
          Lot.create!(
            code: 'COD123456', start_date: Date.today, end_date: Date.today + 1.week,
            min_bid_in_centavos: 10_000, min_diff_between_bids_in_centavos: 5_000,
            creator: first_admin_user, approver: second_admin_user
          )
    
          visit root_path
          click_on 'Listar Lotes'
          within('div#lots-in-progress') do
            click_on 'COD123456'
          end
    
          within('div#bids-session') do
            expect(page).to have_css 'h2', text: 'Lances'
            expect(page).to have_content 'Último lance: 0 centavos'
            expect(page).not_to have_field 'Faça seu lance'
            expect(page).not_to have_button 'Fazer Lance'
          end
        end
      end
    end

    it 'should not be able to visit a lot awaiting approval' do
      admin_user = User.create!(
        name: 'John Doe', cpf: '41760209031',
        email: 'john@leilaodogalpao.com.br', password: 'password123'
      )
      lot = Lot.create!(
        code: 'COD123456', start_date: Date.today, end_date: Date.today + 1.day,
        min_bid_in_centavos: 10_000, min_diff_between_bids_in_centavos: 5_000,
        creator: admin_user
      )
  
      visit lot_path(lot)
      
      expect(current_path).not_to eq lot_path(lot)
    end

    it 'should not be able to visit a expired lot' do
      admin_user = User.create!(
        name: 'John Doe', cpf: '41760209031',
        email: 'john@leilaodogalpao.com.br', password: 'password123'
      )
      Lot.new(
        code: 'COD123456', start_date: Date.today - 1.week, end_date: Date.today - 1.day,
        min_bid_in_centavos: 10_000, min_diff_between_bids_in_centavos: 5_000,
        creator: admin_user
      ).save!(validate: false)
  
      visit lot_path(Lot.last)
      
      expect(current_path).not_to eq lot_path(Lot.last)
      expect(current_path).to eq root_path
    end

    it 'should not see the button to add a product to the lot' do
      john_admin = User.create!(
        name: 'John Doe', cpf: '41760209031',
        email: 'john@leilaodogalpao.com.br', password: 'password123'
      )
      steve_admin = User.create!(
        name: 'Steve Gates', cpf: '35933681024',
        email: 'steve@leilaodogalpao.com.br', password: 'password123'
      )
      lot = Lot.create!(
        code: 'COD123456', start_date: Date.today, end_date: Date.today + 1.day,
        min_bid_in_centavos: 10_000, min_diff_between_bids_in_centavos: 5_000,
        creator: john_admin, approver: steve_admin
      )

      visit root_path
      click_on 'Listar Lotes'
      click_on 'Lote COD123456'
  
      expect(page).not_to have_field 'product_id'
      expect(page).not_to have_button 'Adicionar'
    end
  end

  context 'when is not a admin' do
    context 'and the lot is approved' do
      it 'should be successful' do
        user = User.create!(
          name: 'Peter Parker', cpf: '73046259026',
          email: 'peter@email.com', password: 'password123'
        )
        first_admin_user = User.create!(
          name: 'John Doe', cpf: '41760209031',
          email: 'john@leilaodogalpao.com.br', password: 'password123'
        )
        second_admin_user = User.create!(
          name: 'Steve Gates', cpf: '35933681024',
          email: 'steve@leilaodogalpao.com.br', password: 'password123'
        )
        lot = Lot.create!(
          code: 'COD123456', start_date: Date.today, end_date: Date.today + 1.week,
          min_bid_in_centavos: 10_000, min_diff_between_bids_in_centavos: 5_000,
          creator: first_admin_user, approver: second_admin_user
        )
    
        login_as(user)
        visit root_path
        click_on 'Listar Lotes'
        click_on 'Lote COD123456'
        
        expect(current_path).to eq lot_path(lot)
        expect(page).to have_content 'Aprovado por Steve Gates'
      end

      context 'the admin menu' do
        it 'should not be displayed' do
          user = User.create!(
            name: 'Peter Parker', cpf: '73046259026',
            email: 'peter@email.com', password: 'password123'
          )
          first_admin_user = User.create!(
            name: 'John Doe', cpf: '41760209031',
            email: 'john@leilaodogalpao.com.br', password: 'password123'
          )
          second_admin_user = User.create!(
            name: 'Steve Gates', cpf: '35933681024',
            email: 'steve@leilaodogalpao.com.br', password: 'password123'
          )
          lot = Lot.create!(
            code: 'COD123456', start_date: Date.today, end_date: Date.today + 1.week,
            min_bid_in_centavos: 10_000, min_diff_between_bids_in_centavos: 5_000,
            creator: first_admin_user, approver: second_admin_user
          )
      
          login_as(user)
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

      context 'the bids session' do
        it 'should not be displayed when lot is waiting to start' do
          user = User.create!(
            name: 'Peter Parker', cpf: '73046259026',
            email: 'peter@email.com', password: 'password123'
          )
          first_admin_user = User.create!(
            name: 'John Doe', cpf: '41760209031',
            email: 'john@leilaodogalpao.com.br', password: 'password123'
          )
          second_admin_user = User.create!(
            name: 'Steve Gates', cpf: '35933681024',
            email: 'steve@leilaodogalpao.com.br', password: 'password123'
          )
          Lot.create!(
            code: 'COD123456', start_date: Date.today + 1.week, end_date: Date.today + 2.weeks,
            min_bid_in_centavos: 10_000, min_diff_between_bids_in_centavos: 5_000,
            creator: first_admin_user, approver: second_admin_user
          )
    
          login_as(user)
          visit root_path
          click_on 'Listar Lotes'
          within('div#lots-waiting-start') do
            click_on 'COD123456'
          end
    
          expect(page).not_to have_css 'h2', text: 'Lances'
          expect(page).not_to have_field 'Faça seu lance'
          expect(page).not_to have_button 'Fazer Lance'
        end

        it 'should be displayed with the form to make a bid when lot is in progress' do
          user = User.create!(
            name: 'Peter Parker', cpf: '73046259026',
            email: 'peter@email.com', password: 'password123'
          )
          first_admin_user = User.create!(
            name: 'John Doe', cpf: '41760209031',
            email: 'john@leilaodogalpao.com.br', password: 'password123'
          )
          second_admin_user = User.create!(
            name: 'Steve Gates', cpf: '35933681024',
            email: 'steve@leilaodogalpao.com.br', password: 'password123'
          )
          Lot.create!(
            code: 'COD123456', start_date: Date.today, end_date: Date.today + 1.week,
            min_bid_in_centavos: 10_000, min_diff_between_bids_in_centavos: 5_000,
            creator: first_admin_user, approver: second_admin_user
          )
    
          login_as(user)
          visit root_path
          click_on 'Listar Lotes'
          within('div#lots-in-progress') do
            click_on 'COD123456'
          end
    
          within('div#bids-session') do
            expect(page).to have_css 'h2', text: 'Lances'
            expect(page).to have_content 'Último lance: 0 centavos'
            within('form') do
              expect(page).to have_field 'Faça seu lance'
              expect(page).to have_button 'Fazer Lance'
            end
          end
        end
      end
    end

    it 'should not be able to visit a lot awaiting approval' do
      peter = User.create!(
        name: 'Peter Parker', cpf: '73046259026',
        email: 'peter@email.com', password: 'password123'
      )
      john_admin = User.create!(
        name: 'John Doe', cpf: '41760209031',
        email: 'john@leilaodogalpao.com.br', password: 'password123'
      )
      lot = Lot.create!(
        code: 'COD123456', start_date: Date.today, end_date: Date.today + 1.day,
        min_bid_in_centavos: 10_000, min_diff_between_bids_in_centavos: 5_000,
        creator: john_admin
      )
  
      login_as(peter)
      visit lot_path(lot)
      
      expect(current_path).not_to eq lot_path(lot)
    end

    it 'should not be able to visit a expired lot' do
      user = User.create!(
        name: 'Peter Parker', cpf: '73046259026',
        email: 'peter@email.com', password: 'password123'
      )
      admin_user = User.create!(
        name: 'John Doe', cpf: '41760209031',
        email: 'john@leilaodogalpao.com.br', password: 'password123'
      )
      Lot.new(
        code: 'COD123456', start_date: Date.today - 1.week, end_date: Date.today - 1.day,
        min_bid_in_centavos: 10_000, min_diff_between_bids_in_centavos: 5_000,
        creator: admin_user
      ).save!(validate: false)
  
      login_as(user)
      visit lot_path(Lot.last)
      
      expect(current_path).not_to eq lot_path(Lot.last)
      expect(current_path).to eq root_path
    end

    it 'should not see the button to add a product to the lot' do
      peter = User.create!(
        name: 'Peter Parker', cpf: '73046259026',
        email: 'peter@email.com', password: 'password123'
      )
      john_admin = User.create!(
        name: 'John Doe', cpf: '41760209031',
        email: 'john@leilaodogalpao.com.br', password: 'password123'
      )
      steve_admin = User.create!(
        name: 'Steve Gates', cpf: '35933681024',
        email: 'steve@leilaodogalpao.com.br', password: 'password123'
      )
      lot = Lot.create!(
        code: 'COD123456', start_date: Date.today, end_date: Date.today + 1.day,
        min_bid_in_centavos: 10_000, min_diff_between_bids_in_centavos: 5_000,
        creator: john_admin, approver: steve_admin
      )

      login_as(peter)
      visit root_path
      click_on 'Listar Lotes'
      click_on 'Lote COD123456'
  
      expect(page).not_to have_field 'product_id'
      expect(page).not_to have_button 'Adicionar'
    end
  end

  context 'when is a admin' do
    it 'should see the admin menu' do
      first_admin_user = User.create!(
        name: 'John Doe', cpf: '41760209031',
        email: 'john@leilaodogalpao.com.br', password: 'password123'
      )
      second_admin_user = User.create!(
        name: 'Steve Gates', cpf: '35933681024',
        email: 'steve@leilaodogalpao.com.br', password: 'password123'
      )
      lot = Lot.create!(
        code: 'COD123456', start_date: Date.today, end_date: Date.today + 1.day,
        min_bid_in_centavos: 10_000, min_diff_between_bids_in_centavos: 5_000,
        creator: first_admin_user, approver: second_admin_user
      )
  
      login_as(first_admin_user)
      visit root_path
      click_on 'Listar Lotes'
      click_on 'Lote COD123456'
      
      expect(current_path).to eq lot_path(lot)
      expect(page).to have_css 'div#admin-menu'
    end

    context 'and the lot is approved' do
      it 'should be successful' do
        first_admin_user = User.create!(
          name: 'John Doe', cpf: '41760209031',
          email: 'john@leilaodogalpao.com.br', password: 'password123'
        )
        second_admin_user = User.create!(
          name: 'Steve Gates', cpf: '35933681024',
          email: 'steve@leilaodogalpao.com.br', password: 'password123'
        )
        lot = Lot.create!(
          code: 'COD123456', start_date: Date.today, end_date: Date.today + 1.day,
          min_bid_in_centavos: 10_000, min_diff_between_bids_in_centavos: 5_000,
          creator: first_admin_user, approver: second_admin_user
        )
    
        login_as(first_admin_user)
        visit root_path
        click_on 'Listar Lotes'
        click_on 'Lote COD123456'
        
        expect(current_path).to eq lot_path(lot)
        expect(page).to have_content 'Aprovado por Steve Gates'
      end

      context 'the admin menu' do
        it 'should show a button to close the lot when it is expired and has at least one bid' do
          user = User.create!(
            name: 'Peter Parker', cpf: '73046259026',
            email: 'peter@email.com', password: 'password123'
          )
          first_admin_user = User.create!(
            name: 'John Doe', cpf: '41760209031',
            email: 'john@leilaodogalpao.com.br', password: 'password123'
          )
          second_admin_user = User.create!(
            name: 'Steve Gates', cpf: '35933681024',
            email: 'steve@leilaodogalpao.com.br', password: 'password123'
          )
          Lot.new(
            code: 'COD123456', start_date: Date.today - 1.week, end_date: Date.today - 1.day,
            min_bid_in_centavos: 10_000, min_diff_between_bids_in_centavos: 5_000,
            creator: first_admin_user, approver: second_admin_user
          ).save!(validate: false)
          Bid.new(user: user, lot: Lot.last, value_in_centavos: 20_000).save!(validate: false)
      
          login_as(first_admin_user)
          visit lot_path(Lot.last)
          
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
          first_admin_user = User.create!(
            name: 'John Doe', cpf: '41760209031',
            email: 'john@leilaodogalpao.com.br', password: 'password123'
          )
          second_admin_user = User.create!(
            name: 'Steve Gates', cpf: '35933681024',
            email: 'steve@leilaodogalpao.com.br', password: 'password123'
          )
          Lot.new(
            code: 'COD123456', start_date: Date.today - 1.week, end_date: Date.today - 1.day,
            min_bid_in_centavos: 10_000, min_diff_between_bids_in_centavos: 5_000,
            creator: first_admin_user, approver: second_admin_user
          ).save!(validate: false)
      
          login_as(first_admin_user)
          visit lot_path(Lot.last)
          
          within('div#admin-menu') do
            expect(page).to have_button 'Cancelar Lote'
            expect(page).not_to have_button 'Encerrar Lote'
            expect(page).not_to have_button 'Aprovar Lote'
          end
        end
      end

      context 'the bids session' do
        it 'should not be displayed when lot is waiting to start' do
          first_admin_user = User.create!(
            name: 'John Doe', cpf: '41760209031',
            email: 'john@leilaodogalpao.com.br', password: 'password123'
          )
          second_admin_user = User.create!(
            name: 'Steve Gates', cpf: '35933681024',
            email: 'steve@leilaodogalpao.com.br', password: 'password123'
          )
          Lot.create!(
            code: 'COD123456', start_date: Date.today + 1.week, end_date: Date.today + 2.weeks,
            min_bid_in_centavos: 10_000, min_diff_between_bids_in_centavos: 5_000,
            creator: first_admin_user, approver: second_admin_user
          )
    
          login_as(first_admin_user)
          visit root_path
          click_on 'Listar Lotes'
          within('div#lots-waiting-start') do
            click_on 'COD123456'
          end
    
          expect(page).not_to have_css 'h2', text: 'Lances'
          expect(page).not_to have_field 'Faça seu lance'
          expect(page).not_to have_button 'Fazer Lance'
        end

        it 'should be displayed without the form to make a bid when lot is in progress' do
          first_admin_user = User.create!(
            name: 'John Doe', cpf: '41760209031',
            email: 'john@leilaodogalpao.com.br', password: 'password123'
          )
          second_admin_user = User.create!(
            name: 'Steve Gates', cpf: '35933681024',
            email: 'steve@leilaodogalpao.com.br', password: 'password123'
          )
          Lot.create!(
            code: 'COD123456', start_date: Date.today, end_date: Date.today + 1.week,
            min_bid_in_centavos: 10_000, min_diff_between_bids_in_centavos: 5_000,
            creator: first_admin_user, approver: second_admin_user
          )
    
          login_as(first_admin_user)
          visit root_path
          click_on 'Listar Lotes'
          within('div#lots-in-progress') do
            click_on 'COD123456'
          end
    
          within('div#bids-session') do
            expect(page).to have_css 'h2', text: 'Lances'
            expect(page).to have_content 'Último lance: 0 centavos'
            expect(page).not_to have_field 'Faça seu lance'
            expect(page).not_to have_button 'Fazer Lance'
          end
        end

        it 'should be displayed without the form to make a bid when lot is expired' do
          first_admin_user = User.create!(
            name: 'John Doe', cpf: '41760209031',
            email: 'john@leilaodogalpao.com.br', password: 'password123'
          )
          second_admin_user = User.create!(
            name: 'Steve Gates', cpf: '35933681024',
            email: 'steve@leilaodogalpao.com.br', password: 'password123'
          )
          Lot.new(
            code: 'COD123456', start_date: Date.today - 1.week, end_date: Date.today - 1.day,
            min_bid_in_centavos: 10_000, min_diff_between_bids_in_centavos: 5_000,
            creator: first_admin_user, approver: second_admin_user
          ).save!(validate: false)
    
          login_as(first_admin_user)
          visit root_path
          click_on 'Listar Lotes Expirados'
          within('div#lots-expired') do
            click_on 'COD123456'
          end
    
          within('div#bids-session') do
            expect(page).to have_css 'h2', text: 'Lances'
            expect(page).to have_content 'Último lance: 0 centavos'
            expect(page).not_to have_field 'Faça seu lance'
            expect(page).not_to have_button 'Fazer Lance'
          end
        end
      end
    end

    context 'and the lot is awaiting approval' do
      it 'should be successful' do
        admin_user = User.create!(
          name: 'John Doe', cpf: '41760209031',
          email: 'john@leilaodogalpao.com.br', password: 'password123'
        )
        lot = Lot.create!(
          code: 'COD123456', start_date: Date.today, end_date: Date.today + 1.day,
          min_bid_in_centavos: 10_000, min_diff_between_bids_in_centavos: 5_000,
          creator: admin_user
        )
    
        login_as(admin_user)
        visit root_path
        click_on 'Listar Lotes'
        within('div#lots-awaiting-approval') do
          click_on 'Lote COD123456'
        end
        
        expect(current_path).to eq lot_path(lot)
      end

      context 'the admin menu' do
        it 'should show the button to approve the lot if it was not created by him' do
          first_admin_user = User.create!(
            name: 'John Doe', cpf: '41760209031',
            email: 'john@leilaodogalpao.com.br', password: 'password123'
          )
          second_admin_user = User.create!(
            name: 'Steve Gates', cpf: '35933681024',
            email: 'steve@leilaodogalpao.com.br', password: 'password123'
          )
          lot = Lot.create!(
            code: 'COD123456', start_date: Date.today, end_date: Date.today + 1.day,
            min_bid_in_centavos: 10_000, min_diff_between_bids_in_centavos: 5_000,
            creator: second_admin_user
          )
    
          login_as(first_admin_user)
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
            code: 'COD123456', start_date: Date.today, end_date: Date.today + 1.day,
            min_bid_in_centavos: 10_000, min_diff_between_bids_in_centavos: 5_000,
            creator: admin_user
          )
    
          login_as(admin_user)
          visit root_path
          click_on 'Listar Lotes'
          click_on 'Lote COD123456'
      
          within('div#admin-menu') do
            expect(page).not_to have_button 'Aprovar Lote'
          end
        end

        it 'should show a button to approve the lot when it is not expired' do
          first_admin_user = User.create!(
            name: 'John Doe', cpf: '41760209031',
            email: 'john@leilaodogalpao.com.br', password: 'password123'
          )
          second_admin_user = User.create!(
            name: 'Steve Gates', cpf: '35933681024',
            email: 'steve@leilaodogalpao.com.br', password: 'password123'
          )
          lot = Lot.create!(
            code: 'COD123456', start_date: Date.today, end_date: Date.today + 1.day,
            min_bid_in_centavos: 10_000, min_diff_between_bids_in_centavos: 5_000,
            creator: first_admin_user
          )
      
          login_as(second_admin_user)
          visit lot_path(lot)
          
          within('div#admin-menu') do
            expect(page).to have_button 'Aprovar Lote'
          end
        end

        it 'should not show a button to approve the lot when it is expired' do
          first_admin_user = User.create!(
            name: 'John Doe', cpf: '41760209031',
            email: 'john@leilaodogalpao.com.br', password: 'password123'
          )
          second_admin_user = User.create!(
            name: 'Steve Gates', cpf: '35933681024',
            email: 'steve@leilaodogalpao.com.br', password: 'password123'
          )
          Lot.new(
            code: 'COD123456', start_date: Date.today - 1.week, end_date: Date.today - 1.day,
            min_bid_in_centavos: 10_000, min_diff_between_bids_in_centavos: 5_000,
            creator: first_admin_user
          ).save!(validate: false)
      
          login_as(second_admin_user)
          visit lot_path(Lot.last)
          
          within('div#admin-menu') do
            expect(page).not_to have_button 'Aprovar Lote'
          end
        end

        it 'should show a button to cancel the lot when it is expired' do
          first_admin_user = User.create!(
            name: 'John Doe', cpf: '41760209031',
            email: 'john@leilaodogalpao.com.br', password: 'password123'
          )
          second_admin_user = User.create!(
            name: 'Steve Gates', cpf: '35933681024',
            email: 'steve@leilaodogalpao.com.br', password: 'password123'
          )
          Lot.new(
            code: 'COD123456', start_date: Date.today - 1.week, end_date: Date.today - 1.day,
            min_bid_in_centavos: 10_000, min_diff_between_bids_in_centavos: 5_000,
            creator: first_admin_user
          ).save!(validate: false)
      
          login_as(second_admin_user)
          visit lot_path(Lot.last)
          
          within('div#admin-menu') do
            expect(page).to have_button 'Cancelar Lote'
          end
        end

        it 'should not show a button to close the lot when it is expired' do
          first_admin_user = User.create!(
            name: 'John Doe', cpf: '41760209031',
            email: 'john@leilaodogalpao.com.br', password: 'password123'
          )
          second_admin_user = User.create!(
            name: 'Steve Gates', cpf: '35933681024',
            email: 'steve@leilaodogalpao.com.br', password: 'password123'
          )
          Lot.new(
            code: 'COD123456', start_date: Date.today - 1.week, end_date: Date.today - 1.day,
            min_bid_in_centavos: 10_000, min_diff_between_bids_in_centavos: 5_000,
            creator: first_admin_user
          ).save!(validate: false)
      
          login_as(second_admin_user)
          visit lot_path(Lot.last)
          
          within('div#admin-menu') do
            expect(page).not_to have_button 'Encerrar Lote'
          end
        end
      end
    end

    context 'and the lot is expired' do
      it 'should be successful' do
        admin_user = User.create!(
          name: 'John Doe', cpf: '41760209031',
          email: 'john@leilaodogalpao.com.br', password: 'password123'
        )
        Lot.new(
          code: 'COD123456', start_date: Date.today - 1.week, end_date: Date.today - 1.day,
          min_bid_in_centavos: 10_000, min_diff_between_bids_in_centavos: 5_000,
          creator: admin_user
        ).save!(validate: false)
    
        login_as(admin_user)
        visit lot_path(Lot.last)
        
        expect(current_path).to eq lot_path(Lot.last)
      end
    end

    it 'should see the form to add a product to the lot' do
      john_admin = User.create!(
        name: 'John Doe', cpf: '41760209031',
        email: 'john@leilaodogalpao.com.br', password: 'password123'
      )
      lot = Lot.create!(
        code: 'COD123456', start_date: Date.today, end_date: Date.today + 1.day,
        min_bid_in_centavos: 10_000, min_diff_between_bids_in_centavos: 5_000,
        creator: john_admin
      )

      login_as(john_admin)
      visit root_path
      click_on 'Listar Lotes'
      click_on 'Lote COD123456'
  
      expect(page).to have_field 'product_id'
      expect(page).to have_button 'Adicionar'
    end
  end
end