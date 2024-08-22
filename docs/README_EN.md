<p align="center">
  <img width="100px" src="../assets/bubbles_logo.png" align="center" alt="Bubbles Logo" />
  <h2 align="center">Bubbles AWS Architecture</h2>
  <p align="center">Security and efficiency with AWS e Terraform for your application!</p>
</p>

<p align="center">
  <a href="../README.md">Portuguese</a> · <a href="#">English</a>
</p>

# 🔍Summary <!-- omit in toc -->
- [Technologies](#technologies)
- [Overview](#overview)
  - [Network](#network)
  - [Security](#security)
  - [Instances](#instances)
  - [Architecture Design](#architecture-design)
- [Installation Guide](#installation-guide)
  - [Chocolatey](#chocolatey)
- [How to Use the Project?](#how-to-use-the-project)
- [Additional Resources](#additional-resources)
  - [Tools](#tools)
  - [Languages and Packages](#languages-and-packages)
  - [Reference Guide](#reference-guide)

# 💻Technologies
<table align="center"><tr>
  <td valign="top" width="20%">

  #### <div align="center">Cloud Platform</div>
  <p align="center">
    <img src="https://skillicons.dev/icons?i=aws" />
  </p>
  <br>
  </td>

  <td valign="top" width="20%">

  #### <div align="center">Operating System</div>
  <p align="center">
    <img src="https://skillicons.dev/icons?i=ubuntu" />
  </p>

  </td>
  
  <td valign="top" width="20%">

  #### <div align="center">Infrastructure as Code</div>
  <p align="center">
    <img src="https://skillicons.dev/icons?i=terraform" />
  </p>

  </td>

  <td valign="top" width="20%">

  #### <div align="center">Containerization and Orchestration</div>
  <p align="center">
    <img src="https://skillicons.dev/icons?i=docker" />
  </p>

  </td>
  
  <td valign="top" width="20%">

  #### <div align="center">Web Server and Reverse Proxy</div>
  <p align="center">
    <img src="https://skillicons.dev/icons?i=nginx" />
  </p>

  </td>
</tr></table>


# 📝Overview
  The Bubbles AWS Architecture is designed to provide a robust, secure and escalable solution for hosting the <a href="https://github.com/Projeto-Bubbles/bubbles-website-app" target="_blank">Bubbles Website</a> and <a href="https://github.com/Projeto-Bubbles/bubbles-spring-api-backend" target="_blank">Bubbles API</a>. By combining the power of AWS with Terraform automation, this repository supplies the necessary files to create and configure a complete infrastructure that prioritizes high availability, load balancing and security. The architecture is organized around three fundamental pillars.

### **🛜Network**
  Ensures secure and efficient isolation, connectivity and routing of resources.

  * **VPC:** Defines the isolated network space on AWS where all resources will run.
  * **Public Subnet:** Hosts internet-accessible resources, such as Nginx gateway and front-end instances.
  * **Private Subnet:** Hosts internal resources, protected from direct internet access, such as back-end instances and the back-end load balancer.
  * **Internet Gateway:** Connects the VPC to the public internet, allowing public resources to be accessible.
  * **Public Route Table:** Directs traffic to the internet through the Internet Gateway.
  * **Private Route Table:** Directs traffic to the internet through the NAT Gateway.
  * **Route Table Associations:** Link the route tables to the corresponding subnets, defining how traffic flows within each subnet.
  * **NAT Gateway:** Enables instances in the private subnet to access the internet.
  * **NAT Gateway Elastic IP:** Ensures that the NAT Gateway has a consistent IP address for external communication.
  * **Gateway Instance Elastic IP:** Ensures that the Gateway instance has a consistent IP address for external communication.
  * **Network ACLs:** Act as an additional firewall for the subnets, controlling network traffic based on specific rules, adding an extra layer of security.

### **🔒Security**
  Implements strict policies to protect both the front-end and back-end against threats.

  * **Public Security Group:** Allows HTTP, HTTPS, SSH and port 8080 traffic from anywhere.
  * **Private Security Group:** Allows HTTP, SSH and port 8080 traffic from anywhere.

### **💾Instances**
  Manages the execution of application components, ensuring proper resource allocation and optimized performance.

  * **Gateway (Nginx):** Routes traffic to the back-end load balancer. It has an elastic IP.
  * **Front-End (2 Instances):** Host the application's user interface, serving static content and interacting with the back-end.
  * **Load Balancer (Nginx):** Distributes incoming requests among the back-end instances, ensuring high availability and scalability for the API.
  * **Back-End (2 Instances):** Execute the application logic, processing data, interacting with the database and providing responses to the front-end.

### **🎨Architecture Design**
  Desenhado para maximizar a segurança e a eficiência, isolando os diferentes componentes da aplicação conforme suas funções e necessidades de acesso, ao mesmo tempo em que proporciona alta disponibilidade e resiliência para a infraestrutura da aplicação.

  <img src="../assets/diagrama_de_arquitetura.png" />

  O diagrama acima ilustra a arquitetura da aplicação Bubbles, destacando a separação e segurança dos recursos em uma VPC (Virtual Private Cloud) na região Norte da Virgínia. A infraestrutura está dividida em sub-redes públicas e privadas, cada uma configurada para atender a diferentes partes da aplicação:

  - Sub-rede Pública (10.0.0.0/25): Hospeda os componentes do front-end e o balanceador de carga do Nginx, permitindo que os usuários acessem a aplicação através da internet. O Internet Gateway conecta essa sub-rede à internet, enquanto uma Tabela de Rotas Pública garante que o tráfego seja direcionado adequadamente. Esta sub-rede é protegida por um Grupo de Segurança Público, que controla o acesso aos recursos expostos. <br>

  - Sub-rede Privada (10.0.0.128/25): Destinada aos componentes críticos de back-end, como as instâncias de Spring Boot que processam a lógica da aplicação. O acesso à internet, quando necessário, é realizado através do NAT Gateway, mantendo os recursos protegidos de acessos externos diretos. A Tabela de Rotas Privada e as ACLs de Rede Privada (NACL) reforçam a segurança desta sub-rede. Os recursos desta área estão sob um Grupo de Segurança Privado que limita estritamente o tráfego permitido. <br>

  - Interconexões e Segurança: As instâncias de front-end e back-end comunicam-se internamente, sendo o tráfego cuidadosamente filtrado por grupos de segurança específicos. O diagrama destaca também o uso de endereços IP elásticos, garantindo que os gateways de rede mantenham endereços IP consistentes, essenciais para a comunicação com o mundo exterior.

# 📖Installation Guide
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


# 💡How to Use the Project?
Após configurar o ambiente na nuvem com sucesso, você pode começar a usar a infraestrutura provisionada para hospedar suas aplicações. Abaixo estão alguns exemplos de como aproveitar os recursos e funcionalidades fornecidos pelo Bubbles AWS Architecture:

### 🖌️Implantação do Front-End
  * Upload de Código: Faça o upload do seu código front-end (HTML, CSS, JavaScript) para as instâncias EC2 configuradas para o front-end. Utilize o SCP ou o Git para transferir os arquivos para o servidor.
  * Configuração do Nginx: O Nginx já está pré-configurado como balanceador de carga para distribuir o tráfego entre as instâncias. Você pode ajustar as configurações no arquivo nginx.conf se necessário.

### 🫧Implantando a API Back-End
  * Deploy da API: Faça o deploy da sua API nas instâncias de back-end, utilizando ferramentas como Jenkins ou simplesmente configurando o CI/CD no seu repositório GitHub para deployment automático.
  * Configuração do Load Balancer: O Load Balancer do back-end foi configurado para distribuir as requisições entre as instâncias de back-end, assegurando alta disponibilidade. Verifique a saúde das instâncias via AWS Console.
### 📈Monitoramento e Escalabilidade
  * Escalabilidade: Se houver necessidade de escalar a aplicação, você pode ajustar a quantidade de instâncias diretamente pelo Terraform ou pelo AWS Auto Scaling. A arquitetura está preparada para suportar esse tipo de ajuste.
### 👷🏼Testes e Verificação
  * Teste de Conectividade: Verifique se os endpoints da sua aplicação (front-end e API) estão acessíveis e funcionando conforme o esperado. Utilize ferramentas como curl ou Postman para testar os endpoints e verificar as respostas.
  * Auditoria de Segurança: Execute auditorias de segurança para garantir que as políticas de grupo de segurança e ACLs estejam devidamente configuradas. Utilize o AWS Inspector ou outras ferramentas de segurança.
### 🔨Atualizações e Manutenção
  * Atualização de Infraestrutura: Para modificar ou atualizar a infraestrutura, edite os arquivos .tf e aplique as mudanças usando: ```terraform apply```. Isso permitirá que você adicione novos recursos ou altere a configuração existente sem afetar a disponibilidade do sistema.
  * Manutenção Programada: Configure janelas de manutenção para aplicar patches de segurança ou atualizar o sistema operacional das instâncias. Utilize o AWS Systems Manager para automação dessas tarefas.

# 🔗Additional Resources
### 🔧Tools
  - <a href="https://code.visualstudio.com/download">Visual Studio Code</a>
  - <a href="https://www.docker.com/products/docker-desktop/">DockerHub (Windows)</a>

### 📦Languages and Packages
  - <a href="https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli">Terraform</a>
  - <a href="https://chocolatey.org/">Chocolatey (Windows)</a> 
  - <a href="https://docs.aws.amazon.com/pt_br/cli/latest/userguide/getting-started-install.html">AWS CLI</a>

### 📖Reference Guide
  - <a href="https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.security/set-executionpolicy?view=powershell-7.4">Alterar Credenciais do Usuário (Windows e Mac)</a>
