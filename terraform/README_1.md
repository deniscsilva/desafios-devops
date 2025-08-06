# Documentação do Projeto Terraform

## Descrição do Projeto

Este projeto Terraform provisiona uma instância EC2 na AWS com as seguintes características:

- Instância Linux (Amazon Linux 2) do tipo `t2.micro`.
- Acesso HTTP (porta 80) e HTTPS (porta 443) liberado para todos os IPs.
- Acesso SSH (porta 22) liberado apenas para um IP ou range de IPs específico.
- Docker é pré-instalado na instância e um container com a imagem do Apache (httpd) é iniciado, expondo a porta 80.

## Configuração

O projeto utiliza um backend S3 para armazenar o arquivo de estado do Terraform. A configuração do backend está no arquivo `backend.tf`. Certifique-se de que o bucket S3 exista e que você tenha as permissões necess��rias para acessá-lo.

As seguintes variáveis podem ser configuradas:

- `aws_region`: Região da AWS para provisionar os recursos. O padrão é `us-east-1`.
- `ssh_location`: O IP ou range de IPs (formato CIDR) para liberar o acesso SSH. **Este valor precisa ser fornecido.**
- `key_name`: Nome da chave SSH registrada na AWS para acessar a instância. **Este valor precisa ser fornecido.**
- `instance_type`: Tipo da instância EC2. O padrão é `t2.micro`.

## Como usar

1. **Inicialize o Terraform:**

   ```bash
   terraform init
   ```
2. **Valide a sintaxe dos arquivos**
   
    ```bash
   terraform validate
   ```

3. **Formate todos arquivos (recursivamente)**

   ```bash
   terraform fmt --recursive
   ```

4. **Planeje a infraestrutura:**

   ```bash
   terraform plan 
   ```

5. **Aplique as alterações:**

   ```bash
   terraform apply 
   ```

6. **Destrua a infraestrutura:**

   ```bash
   terraform destroy 
   ```

## Saídas (Outputs)

- `public_ip`: O endereço de IP público da instância EC2.

## Módulos

- **`ec2_instance`**: Módulo responsável por criar a instância EC2, instalar o Docker e iniciar o container do Apache.
- **`security_group`**: Módulo responsável por criar o Security Group com as regras de firewall.
