# Experimento SonarQube: IDURAR e Worklenz

Análise estática local dos projetos [IDURAR ERP/CRM](https://github.com/idurar/idurar-erp-crm) e [Worklenz](https://github.com/Worklenz/worklenz) com SonarQube Community Build. Os códigos-fonte não entram neste repositório: cada pessoa clona os originais. Os relatórios desta execução estão em `reports/`.

## Requisitos

- Docker com Compose
- Git
- Node.js 20 e npm, para executar o IDURAR
- Node.js 22, somente se for rodar os testes do backend do Worklenz

Confira se as portas 9090, 27017, 3000, 5000 e 8888 estão livres. Este Compose publica o SonarQube em **9090** porque, na máquina original, a 9000 já estava ocupada. Se a 9000 estiver livre, troque o mapeamento em `sonarqube/docker-compose.yml` para `9000:9000` e use essa porta no lugar de 9090.

## 1. Clonar os projetos

A partir da pasta do experimento:

```bash
git clone https://github.com/idurar/idurar-erp-crm.git projects/idurar-erp-crm
git clone https://github.com/Worklenz/worklenz.git projects/worklenz
```

O resultado é `projects/idurar-erp-crm` e `projects/worklenz`. Essas pastas estão no `.gitignore`.

Os commits analisados no relatório são:

- IDURAR `master` `e935dec13cf8b6082a7e7fc4736669e5151a80a3`
- Worklenz `main` `88edbad54c8ac12cd08555b334a7a9b5e42b6a20`

## 2. SonarQube

```bash
cd sonarqube
docker compose up -d
```

Abra http://localhost:9090. Na primeira vez o usuário e a senha são `admin` / `admin`. O servidor pede a troca da senha. Crie um token em **My Account → Security** e guarde-o fora do Git.

## 3. IDURAR

```bash
docker run -d --name idurar-mongodb -p 27017:27017 -v idurar_mongodb_data:/data/db mongo:7
```

Em `projects/idurar-erp-crm/backend/.env`, use uma URI local e um segredo só desta máquina:

```text
DATABASE="mongodb://127.0.0.1:27017/idurar"
JWT_SECRET="um-segredo-local"
NODE_ENV="development"
```

```bash
cd projects/idurar-erp-crm/backend
npm install
npm run dev
```

O backend escuta em http://localhost:8888. Em outro terminal:

```bash
cd projects/idurar-erp-crm/frontend
npm install
npm run dev
```

O frontend usa http://localhost:3000. Essa porta também é a da API do Worklenz. `npm run setup` cria o admin e em seguida falha: o commit clonado exige o módulo `PaymentMode`, que não está na árvore. O login não fica utilizável por causa disso.

## 4. Worklenz

```bash
chmod +x scripts/prepare-worklenz-env.sh scripts/analyze.sh
./scripts/prepare-worklenz-env.sh
cd projects/worklenz
docker compose up -d
```

Frontend: http://localhost:5000. API: http://localhost:3000. O Nginx só sobe se existir `projects/worklenz/nginx/ssl/cert.pem`. Sem esse certificado, a porta 80 não responde. O `.env` gerado fica só na máquina.

## 5. Análise

Com o SonarQube no ar e o token exportado:

```bash
export SONAR_TOKEN="cole-o-token-aqui"
./scripts/analyze.sh all
```

`./scripts/analyze.sh idurar` ou `./scripts/analyze.sh worklenz` analisa um projeto. Os dashboards ficam em:

- http://localhost:9090/dashboard?id=idurar-erp-crm
- http://localhost:9090/dashboard?id=worklenz

As configurações usadas estão em `configs/`. A cobertura não entra no resultado enquanto não houver um arquivo LCOV. O valor `0.0` da interface, nesse caso, não é uma cobertura medida.

## O que já está neste repositório

- `sonarqube/docker-compose.yml`
- `configs/` com os `sonar-project.properties`
- `reports/` com a coleta e o relatório comparativo
- `PENDENCIAS.md` com o que ficou bloqueado na execução original
- logs de setup e de análise, sem token e sem senha
