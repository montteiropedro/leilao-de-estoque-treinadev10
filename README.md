# Leilão de Estoque - TreinaDev 10

## Tecnologias
### Ruby Version
- [3.2.2](https://www.ruby-lang.org/en/news/2023/03/30/ruby-3-2-2-released/)
### Principais Gems
- [Ruby on Rails](https://rubyonrails.org)
- [Devise](https://github.com/heartcombo/devise)
- [Tailwind CSS](https://tailwindcss.com)
- [RSpec Rails](https://github.com/rspec/rspec-rails)
- [Capybara](https://github.com/teamcapybara/capybara)

## Dependências e Configurações do Projeto
As dependências deste projeto, migrations e configurações da database podem ser baixadas/executadas/configuradas automaticamente através do comando abaixo:
```
bin/setup
```
Caso você queira que sua database de desenvolvimento seja populada forma rápida basta executar um seeding rodando o seguinte comando:
```
bin/rails db:seed
```

## Teste com o RSpec
Neste projeto estou utilizado o RSpec em conjunto com o Capybara para a criação de teses de sistema e testes unitários.
### Executando os testes
Rodar os testes é muito simples e existem algumas formas possíveis, acompanhe abaixo:

> O comando abaixo executa os testes de acordo com a configuração especificada no arquivo .rspec (nesse projeto esta sendo utilizado a formatação em progresso)
>```
>rspec 
>```
>
> O comando abaixo executa os testes no formato de ***documentação***, ou seja, todos os textos dos casos de teste serão listados na tela
>```
>rspec --format d
>```
> O comando abaixo executa os testes no formato de ***progresso***, ou seja, os textos dos casos de teste não serão listados na tela e no lugar deles você verá pontos. Caso um erro aconteça o RSpec exibira onde ele ocorreu para você, não se preocupe
>```
>rspec --format p
>```

### Como lidar com o `ActiveRecord::EnvironmentMismatchError`?
Se ao rodar o comando `rspec` você ver um erro do tipo `ActiveRecord::EnvironmentMismatchError` no terminal, você pode rodar o comando a seguir para fazer tudo voltar aos trilhos:
```
bin/rails db:reset
```

## Execute o projeto localmente em sua máquina
Como o CSS deste projeto está sendo gerado através do [Tailwind CSS](https://tailwindcss.com/docs/guides/ruby-on-rails), é necessário, para ver as mudanças de estilo feitas durante o desenvolvimento, executar o projeto pelo comando abaixo:
```
bin/dev
```
### Executou o seeding?
Nesse caso sua database estará populada com muitos dados. Os mais importantes deles, que devem ser mencionados aqui, são os dados de ***usuários*** e ***CPFs bloqueados***, irei listar eles aqui para que você não tenha que ficar procurando essas informações diretamente pelo arquivo, vamos lá?

#### Usuários

  | E-mail                      | Senha       | Admin? | CPF Bloqueado? |
  |-----------------------------|-------------|--------|----------------|
  | john@leilaodogalpao.com.br  | password123 | Sim    | Não            |
  | steve@leilaodogalpao.com.br | password123 | Sim    | Não            |
  | peter@email.com.br          | password123 | Não    | Não            |
  | joseph@email.com.br         | password123 | Não    | Sim            |

#### CPFs Bloqueados não vinculados a um usuário

  | CPF         |
  |-------------|
  | 98960586013 |
  | 85120464068 |

### Como criar uma conta administradora?
Para um usuário se tornar um administrador basta ele criar uma conta nova com um e-mail que possua o sufixo `@leilaodogalpao.com.br`.


## Database
### Schema
Ao clicar na imagem você será redirecionado para o link dela e poderá visualiza-lá melhor (zoom disponível pelo navegador).

<p align="center">
  <a href="https://i.imgur.com/yGAndN7.png" target="_blank" rel="noopener noreferrer"><img src="https://i.imgur.com/yGAndN7.png" height="350"/></a>
</a>

## Tópicos a Cobrir
* Instruções para o Deployment
