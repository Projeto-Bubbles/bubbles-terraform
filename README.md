<p align="center">
  <img width="100px" src="assets/bubbles_logo.png" align="center" alt="Bubbles Logo" />
  <h2 align="center">Bubbles AWS Architecture</h2>
  <p align="center">Segurança e eficiência com AWS e Terraform para sua aplicação!</p>
</p>

<p align="center">
  <a href="#">Português</a> · <a href="/docs/readme_en.md">English</a>
</p>

# 🔍Índice <!-- omit in toc -->
- [Tecnologias](#tecnologias)
- [Visão Geral](#visão-geral)
  - [Rede](#rede)
  - [Segurança](#segurança)
  - [Instâncias](#instâncias)
  - [Desenho da Arquitetura](#desenho-da-arquitetura)
- [Guia de Instalação](#guia-de-instalação)
  - [Chocolatey](#chocolatey)
- [Como Usar o Projeto?](#como-usar-o-projeto)
- [Recursos Adicionais](#recursos-adicionais)
  - [Ferramentas](#ferramentas)
  - [Linguagens e Pacotes](#linguagens-e-pacotes)
  - [Guias de Referência](#guias-de-referência)

# 💻Tecnologias
<table align="center"><tr>
  <td valign="top" width="20%">

  #### <div align="center"> Plataforma de Nuvem </div>
  <p align="center">
    <img src="https://skillicons.dev/icons?i=aws" />
  </p>
  <br>
  </td>
  
  <td valign="top" width="20%">

  #### <div align="center"> Sistema Operacional </div>
  <p align="center">
    <img src="https://skillicons.dev/icons?i=ubuntu" />
  </p>

  </td>
  
  <td valign="top" width="20%">

  #### <div align="center"> Infraestrutura como Código </div>
  <p align="center">
    <img src="https://skillicons.dev/icons?i=terraform" />
  </p>

  </td>

  <td valign="top" width="20%">

  #### <div align="center"> Containerização e Orquestração </div>
  <p align="center">
    <img src="https://skillicons.dev/icons?i=docker" />
  </p>

  </td>
  
  <td valign="top" width="20%">

  #### <div align="center"> Servidor Web e Proxy Reverso </div>
  <p align="center">
    <img src="https://skillicons.dev/icons?i=nginx" />
  </p>

  </td>
</tr></table>


# 📝Visão Geral
  A Bubbles AWS Architecture foi projetada para oferecer uma solução robusta, segura e escalável para a hospedagem da <a href="https://github.com/Projeto-Bubbles/bubbles-website-app" target="_blank">Bubbles Website</a> e <a href="https://github.com/Projeto-Bubbles/bubbles-spring-api-backend" target="_blank">Bubbles API</a>. Combinando o poder da AWS e a automação do Terraform, este repositório fornece os arquivos necessários para a criação e configuração de uma infraestrutura completa que prioriza alta disponibilidade, balanceamento de carga e segurança. A arquitetura está organizada em três pilares fundamentais.

### **🛜Rede**
  Garante o isolamento, a conectividade e o roteamento seguros e eficientes dos recursos.

  * **VPC**: Define o espaço de rede isolado na AWS onde todos os recursos serão executados.
  * **Sub-rede pública**: Hospeda recursos acessíveis pela internet, como o gateway Nginx e as instâncias de front-end.
  * **Sub-rede privada**: Hospeda recursos internos, protegidos do acesso direto da internet, como as instâncias de back-end e o load balancer do back-end.
  * **Internet Gateway**: Conecta a VPC à internet pública, permitindo que os recursos públicos sejam acessíveis.
  * **Tabela de rota pública**: Direciona o tráfego para a internet através do Internet Gateway.
  * **Tabela de rota privada**: Direciona o tráfego para a internet através do NAT Gateway.
  * **Associações de Tabelas de Rota**: Vinculam as tabelas de rota às sub-redes correspondentes, definindo como o tráfego flui dentro de cada sub-rede.
  * **NAT Gateway**: Permite que as instâncias na sub-rede privada acessem a internet.
  * **Elastic IP do NAT Gateway**: Garante que o NAT Gateway tenha um endereço IP consistente para comunicação externa.
  * **Elastic IP da Instância Gateway**: Garante que a istância Gateway tenha um endereço IP consistente para comunicação externa.
  * **ACLs de Rede**: Atuam como um firewall adicional para as sub-redes, controlando o tráfego de rede com base em regras específicas, adicionando uma camada extra de segurança.

### **🔒Segurança**
  Implementa políticas rigorosas para proteger tanto o front-end quanto o back-end contra ameaças.

  * **Grupo de segurança público**: Permite tráfego HTTP, HTTPS, SSH e tráfego na porta 8080 de qualquer lugar.
  * **Grupo de segurança privado**: Permite tráfego HTTP, SSH e tráfego na porta 8080 de qualquer lugar.

### **💾Instâncias**
  Gerencia a execução dos componentes da aplicação, assegurando a distribuição adequada de recursos e o desempenho otimizado.

  * **Gateway (Nginx)**: Balanceador de carga do front-end, direciona o trafégo para o load balancer do back-end. Possui um IP Elástico.
  * **Front-End (2 Instâncias)**: Hospedam a interface do usuário da aplicação, servindo o conteúdo estático e interagindo com o backend.
  * **Load Balancer do Back-End**: Distribui as requisições recebidas entre as instâncias backend, garantindo alta disponibilidade e escalabilidade para a API.
  * **Back-End (2 Instâncias)**: Executam a lógica da aplicação, processando dados, interagindo com o banco de dados e fornecendo respostas para os frontends.

### **🎨Desenho da Arquitetura**
  Desenhado para maximizar a segurança e a eficiência, isolando os diferentes componentes da aplicação conforme suas funções e necessidades de acesso, ao mesmo tempo em que proporciona alta disponibilidade e resiliência para a infraestrutura da aplicação.

  <img src="assets/diagrama_de_arquitetura.png" />

  O diagrama acima ilustra a arquitetura da aplicação Bubbles, destacando a separação e segurança dos recursos em uma VPC (Virtual Private Cloud) na região Norte da Virgínia. A infraestrutura está dividida em sub-redes públicas e privadas, cada uma configurada para atender a diferentes partes da aplicação:

  - Sub-rede Pública (10.0.0.0/25): Hospeda os componentes do front-end e o balanceador de carga do Nginx, permitindo que os usuários acessem a aplicação através da internet. O Internet Gateway conecta essa sub-rede à internet, enquanto uma Tabela de Rotas Pública garante que o tráfego seja direcionado adequadamente. Esta sub-rede é protegida por um Grupo de Segurança Público, que controla o acesso aos recursos expostos. <br>

  - Sub-rede Privada (10.0.0.128/25): Destinada aos componentes críticos de back-end, como as instâncias de Spring Boot que processam a lógica da aplicação. O acesso à internet, quando necessário, é realizado através do NAT Gateway, mantendo os recursos protegidos de acessos externos diretos. A Tabela de Rotas Privada e as ACLs de Rede Privada (NACL) reforçam a segurança desta sub-rede. Os recursos desta área estão sob um Grupo de Segurança Privado que limita estritamente o tráfego permitido. <br>

  - Interconexões e Segurança: As instâncias de front-end e back-end comunicam-se internamente, sendo o tráfego cuidadosamente filtrado por grupos de segurança específicos. O diagrama destaca também o uso de endereços IP elásticos, garantindo que os gateways de rede mantenham endereços IP consistentes, essenciais para a comunicação com o mundo exterior.

# 📖Guia de Instalação
  Para este tutorial, assumimos que o Terraform e o AWS CLI já estão instalados e configurados em sua máquina. Caso precise de instruções de instalação, consulte a seção [Recursos Adicionais](#recursos-adicionais) no final do documento.
  
  * **Nota:** Se você instalou o Terraform via Chocolatey (Gerenciador de Pacotes para Windows), enfrentou problemas com a instalação tradicional no Windows, ou deseja testar uma abordagem alternativa, siga as instruções específicas a partir da seção [Chocolatey](#chocolatey). Esta etapa é opcional e depende do seu ambiente de configuração.

1. **Obtenha as Credenciais da AWS** <br>
  Antes de começar a configurar o ambiente, você precisará das credenciais da AWS para acessar os serviços necessários. Se estiver utilizando um laboratório ou ambiente temporário, acesse o terminal execute o comando abaixo para exibir as credenciais:
    - **Atenção:** Essas credenciais podem mudar sempre que você iniciar um novo laboratório ou sessão. Certifique-se de obter as novas credenciais toda vez que começar um novo lab. <br><br>
    ```
    cat ~/.aws/credentials
    ```
2. **Configure o AWS CLI** <br>
  Com as credenciais em mãos, você precisará configurar a AWS CLI (Command Line Interface) para interagir com a AWS. Isso pode ser feito usando qualquer terminal, como PowerShell, Bash ou CMD. Digite o comando abaixo no terminal e siga as instruções para inserir a Access Key, Secret Key e a região desejada:

    ```
    aws configure
    ```

3. **Definindo Chaves, Região, Sessão e Token** 
    1. **AWS Access Key ID** <br>
      Insira a chave de acesso obtida no passo anterior.
    2. **AWS Secret Access Key** <br>
      Insira a chave secreta correspondente.
    3. **Default region name** <br>
      Especifique a região (ex.: us-east-1).
    4. **Default output format** <br>
      Deixe como json ou outro formato de sua preferência
    5. **(Opcional, se aplicável) Defina o Token da Sessão** <br>
      Se você precisar de um token de sessão (comumente usado em ambientes temporários ou seguros), use o comando abaixo para configurar e substitua <<token>> pelo valor do token de sessão fornecido.<br><br>
        ```
        aws configure set aws_session_token <<token>>
        ``` 
4. **Inicialize o Terraform** <br>
  Com a AWS CLI configurada, o próximo passo é preparar o Terraform para gerenciar a infraestrutura. E para isso, precisamos baixar todos os provedores necessários e preparar o ambiente de trabalho para o Terraform. Na raiz do diretório do projeto, execute o comando:
    ``` 
    terraform init
    ```    
5. **Aplique a Configuração do Terraform** <br>
  Após a inicialização, você está pronto para criar ou atualizar a infraestrutura na AWS. Para aplicar as configurações definidas nos arquivos .tf e provisionar a infraestrutura na AWS, use o comando:
    ```
    terraform apply
    ```
6. **Revise e Confirme** <br>
  O Terraform apresentará um resumo das mudanças que serão feitas. Revise as alterações e, se estiver de acordo, confirme digitando `yes` quando solicitado.

  ### 🍫Chocolatey
  Para gerenciar a instalação do Terraform usando Chocolatey, siga as etapas abaixo. Recomendamos utilizar o <a href="https://code.visualstudio.com/download">Visual Studio Code</a> para facilitar a visualização do código Terraform e a execução de comandos no terminal integrado. Note que essa etapa não elimina a necessidade de instalar o <a href="https://docs.aws.amazon.com/pt_br/cli/latest/userguide/getting-started-install.html">AWS CLI</a>.

  1. **Configurando Políticas de Execução do Windows** <br>
    Para executar os comandos do Chocolatey e do Terraform, é necessário que as políticas de execução do Windows estejam configuradas corretamente. Certifique-se de que as políticas estejam conforme a imagem abaixo:
    <img src="assets/politicas_de_execucao.jpg" alt="políticas de execução do Windows">

      - Caso não estejam configuradas dessa forma, siga <a href="https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.security/set-executionpolicy?view=powershell-7.4">este guia</a> para ajustá-las.
  
  2. **Instalando o Chocolatey** <br>
    Instale o Chocolatey seguindo as instruções no <a href="https://chocolatey.org/">site oficial</a>. 

  3. **Instalando o Terraform com Chocolatey** <br>
    Abra o terminal do Windows (PowerShell, Bash, Terminal integrado do Visual Studio Code, etc) e execute o seguinte comando para instalar o Terraform:
      ```
      choco install terraform
      ```
  
  4. **Obtenha as Credenciais da AWS** <br>
    No terminal do laboratório da AWS, execute o comando abaixo para exibir as suas credenciais:
      - **Atenção:** Essas credenciais podem mudar sempre que você iniciar um novo laboratório ou sessão. Certifique-se de obter as novas credenciais toda vez que começar um novo lab. <br><br>
      ```
      cat ~/.aws/credentials
      ```
  5. **Configurando Credenciais no Windows** <br>
    Navegue até o diretório `C:\Users\[seu_nome_de_usuario]\.aws` pelo explorador de arquivos ou terminal. Nesse local, você encontrará dois arquivos: config e credentials. Edite os arquivos conforme descrito abaixo:

      * `config`
        ```
          [default]
          region = a
          output = a
        ``` 
      * `credentials`
        ```
          <<credenciais-da-aws>>
        ```
  6. **Inicializando Terraform** <br>
    Agora, pelo terminal, acesse o diretório até onde o arquivo main.tf está localizado. Se estiver usando o Visual Studio Code, você pode navegar facilmente até o diretório. E inicialize o terraform com o comando:
      ```
      terraform init
      ```

  7. **Aplique a Configuração do Terraform** <br>
    Após a inicialização, você está pronto para criar ou atualizar a infraestrutura na AWS. Para aplicar as configurações definidas nos arquivos .tf e provisionar a infraestrutura na AWS, use o comando:
      ```
      terraform apply
      ```
  8. **Revise e Confirme** <br>
  O Terraform apresentará um resumo das mudanças que serão feitas. Revise as alterações e, se estiver de acordo, confirme digitando `yes` quando solicitado.    


# 💡Como Usar o Projeto?

# 🔗Recursos Adicionais
### 🔧Ferramentas
  - <a href="https://code.visualstudio.com/download">Visual Studio Code</a>
  - <a href="https://www.docker.com/products/docker-desktop/">DockerHub (Windows)</a>

### 📦Linguagens e Pacotes
  - <a href="https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli">Terraform</a>
  - <a href="https://chocolatey.org/">Chocolatey (Windows)</a> 
  - <a href="https://docs.aws.amazon.com/pt_br/cli/latest/userguide/getting-started-install.html">AWS CLI</a>

### 📖Guias de Referência
  - <a href="https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.security/set-executionpolicy?view=powershell-7.4">Alterar Credenciais do Usuário (Windows e Mac)</a>
