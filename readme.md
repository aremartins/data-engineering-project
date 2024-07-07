# Projeto de Infraestrutura de Dados na AWS com Terraform

## Visão Geral
Este projeto configura uma infraestrutura de dados na AWS utilizando Terraform. A infraestrutura inclui a criação de buckets S3 para armazenamento de dados brutos e resultados de consultas do Athena, além da configuração de roles e policies no IAM para permitir que o AWS Glue execute tarefas de ETL.

## Estrutura do Projeto
```plaintext
projeto_pipeline/
├── infra/
│   └── terraform/
│       ├── main.tf
│       ├── providers.tf
│       ├── variables.tf
│       └── outputs.tf
└── scripts/
```

## Pré-requisitos
- Conta na AWS
- Terraform instalado
- AWS CLI instalado e configurado

## Configuração do Ambiente

1. **Clonar o Repositório**:
   ```bash
   git clone https://github.com/aremartins/data-engineering-project.git
   cd projeto_pipeline/infra/terraform
  

2. **Configurar Credenciais AWS**:
    Certifique-se de que suas credenciais AWS estão configuradas corretamente. Você pode fazer isso usando o comando:
    aws configure

3. **Inicializar o Terraform**:    
    terraform init

4. **Planejar e Aplicar as Mudanças**:
    Planeje as mudanças e depois aplique-as:
    
    terraform plan
    terraform apply

## Recursos Criados

### Buckets S3:
```plaintext
my-company-data-raw-transactions
my-company-data-raw-customers
my-company-data-raw-logs
my-company-data-athena-results
```

### Roles e Policies IAM:

 AWSGlueServiceRole com a policy AWSGlueServicePolicy anexada.


## Verificação dos Recursos

    Após aplicar o Terraform, você pode verificar se os recursos foram criados corretamente no Console da AWS:

        Buckets S3: Navegue até o serviço S3 e verifique os buckets criados.
        Roles IAM: Navegue até IAM > Roles e verifique a role AWSGlueServiceRole e sua policy anexada.


