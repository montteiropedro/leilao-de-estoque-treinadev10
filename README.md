# Leilão de Estoque - TreinaDev 10

## Versão do ruby
3.2.2

## Dependências e configurações do projeto
As dependências deste projeto, migrations e configurações da database podem ser baixadas/executadas/configuradas automaticamente através do comando abaixo:
```
bin/setup
```
Caso você queira que sua database de desenvolvimento seja populada forma rápida basta executar um seeding rodando o seguinte comando:
```
bin/rails db:seed
```

## Rode os casos de teste com o RSpec
Neste projeto estamos utilizando do RSpec em conjunto com o Capybara, para rodar os testes basta executar o seguinte comando:
```
rspec
```
Se ao rodar o comando `rspec` você ver um erro do tipo `ActiveRecord::EnvironmentMismatchError` no terminal, você pode rodar o comando a seguir para fazer tudo voltar aos trilhos:
```
bin/rails db:reset
```

## Principais gems do projeto
- [Ruby on Rails](https://rubyonrails.org)
- [Devise](https://github.com/heartcombo/devise)
- [Tailwind CSS](https://tailwindcss.com)
- [RSpec Rails](https://github.com/rspec/rspec-rails)
- [Capybara](https://github.com/teamcapybara/capybara)

## Execute o projeto localmente em sua máquina
Como o CSS deste projeto está sendo gerado através do [Tailwind CSS](https://tailwindcss.com/docs/guides/ruby-on-rails), é necessário, para ver as mudanças de estilo feitas durante o desenvolvimento, executar o projeto pelo comando abaixo:
```
bin/dev
```

## Database
### Schema
Ao clicar na imagem você será redirecionado para o link dela e poderá visualiza-lá melhor (zoom disponível pelo navegador).

<p align="center">
  <a href="https://i.imgur.com/yGAndN7.png" target="_blank" rel="noopener noreferrer"><img src="https://i.imgur.com/yGAndN7.png" height="350"/></a>
</a>

## Tópicos a Cobrir
* Instruções para o Deployment
