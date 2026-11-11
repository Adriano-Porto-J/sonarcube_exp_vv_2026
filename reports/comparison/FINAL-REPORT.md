# Análise estática de IDURAR e Worklenz com SonarQube

## Introdução

O experimento aplica análise estática a dois sistemas open source de gestão, com o SonarQube Community Build rodando localmente. O SonarQube examina o código com regras de confiabilidade, segurança e manutenibilidade e publica um dashboard. Ele não executa a aplicação nem os testes.

IDURAR ERP/CRM (https://github.com/idurar/idurar-erp-crm) e Worklenz (https://github.com/Worklenz/worklenz) foram escolhidos por serem aplicações reais, com frontend e backend, licença AGPL e bases grandes o bastante para comparar densidade de problemas, não só contagens absolutas.

## Metodologia

Ambiente: Ubuntu em WSL2, Docker Desktop 28.1.1, Compose v2.35.1, Git 2.43.0, Node.js 20.19.4, npm 10.8.2. Disco livre no início: cerca de 915 GB. `vm.max_map_count` já era 262144.

SonarQube Community Build 26.11.0.134175, imagem `sonarqube:community`, container `sonarqube-experiment`, host `http://localhost:9090` (a porta 9000 já era do MinIO). Scanner `sonarsource/sonar-scanner-cli` 8.4.0.16527, na rede Docker `sonarqube-network`, com `SONAR_HOST_URL=http://sonarqube-experiment:9000`.

Commits:

- IDURAR `master` `e935dec13cf8b6082a7e7fc4736669e5151a80a3`
- Worklenz `main` `88edbad54c8ac12cd08555b334a7a9b5e42b6a20`

Fontes analisadas: `backend/src` e `frontend/src` no IDURAR; `worklenz-backend/src`, `worklenz-frontend/src` e `worklenz-client-portal/src` no Worklenz. Exclusões: `node_modules`, `dist`, `build`, `coverage`, minificados, `vendor` e `.git`. No Worklenz, diretórios de teste foram marcados como testes e excluídos das fontes. Configurações em `configs/idurar/sonar-project.properties` e `configs/worklenz/sonar-project.properties`.

Cobertura: nenhum dos projetos gerou LCOV nesta execução. O IDURAR clonado não tem script de teste. O backend do Worklenz declara Node `>=22.12.0`. A propriedade de LCOV do Worklenz aponta para um arquivo que não foi produzido. O campo `coverage=0.0` da API não é uma medição.

## Resultados individuais

### IDURAR

Dashboard: http://localhost:9090/dashboard?id=idurar-erp-crm

20.403 ncloc, 339 arquivos, JavaScript e CSS. 17 bugs, 4 vulnerabilidades, 0 hotspots, 20 code smells, duplicação 23,6%. Ratings: manutenibilidade A, confiabilidade E, segurança C. Quality gate OK. 41 issues abertas.

MongoDB 7 local (`idurar-mongodb`). `npm install` no backend e no frontend concluiu. `npm run setup` criou admin e settings e depois falhou por módulo `PaymentMode` inexistente. Backend na porta 8888. Frontend Vite respondeu em `http://localhost:3000` e foi encerrado para ceder a porta ao Worklenz. Login não foi exercitado.

### Worklenz

Dashboard: http://localhost:9090/dashboard?id=worklenz

472.559 ncloc, 3.692 arquivos, TypeScript, CSS e JavaScript. 404 bugs, 13 vulnerabilidades, 0 hotspots, 917 code smells, duplicação 4,8%. Ratings: manutenibilidade A, confiabilidade E, segurança C. Quality gate OK. 1.334 issues abertas.

`docker compose up -d` subiu Postgres 15, SeaweedFS, backend, frontend e client portal. Frontend: http://localhost:5000 (HTTP 200). Backend: http://localhost:3000. Nginx em loop por ausência de `nginx/ssl/cert.pem`, então a porta 80 não responde. Autenticação de usuário não foi concluída.

## Comparação

| Métrica | IDURAR | Worklenz |
|---|---:|---:|
| ncloc | 20.403 | 472.559 |
| Bugs | 17 | 404 |
| Vulnerabilidades | 4 | 13 |
| Hotspots | 0 | 0 |
| Code smells | 20 | 917 |
| Duplicação | 23,6% | 4,8% |
| Cobertura | indisponível | indisponível |
| Quality gate | OK | OK |

Fórmula: `métrica por 1.000 linhas = (contagem / ncloc) * 1.000`.

Bugs por 1.000 linhas: 0,83 e 0,86. Code smells por 1.000 linhas: 0,98 e 1,94. Vulnerabilidades por 1.000 linhas: 0,20 e 0,03.

Worklenz tem mais problemas absolutos e mais smells por linha. IDURAR duplica muito mais código. Regras dominantes no Worklenz: `typescript:S7773`, `typescript:S9383` e `typescript:S6848`. No IDURAR, `javascript:S7773` e `javascript:S9383`. Separar frontend e backend no dashboard não foi feito; a análise foi um único projeto por repositório.

## Discussão

Análise estática aponta padrões suspeitos. Um bug do SonarQube é uma regra de confiabilidade, não um defeito observado em execução. Vulnerabilidade é uma regra de segurança com local conhecido. Code smell é custo de manutenção. Hotspot é um trecho que pede revisão humana; nesta rodada a métrica veio zerada.

Sem testes executados, não há evidência funcional. Promises não tratadas e expressões idênticas em `&&` merecem leitura do código. Parte das regras de estilo (`parseInt`, `isNaN`, `Math.trunc`) pode ser ruído para o objetivo do experimento. O quality gate OK com reliability E mostra que o gate padrão não resume sozinho o risco.

## Conclusão

Foi possível clonar os dois códigos, subir o SonarQube e concluir as duas análises. Worklenz apresentou mais problemas absolutos e mais code smells por linha. A densidade de bugs ficou equivalente. IDURAR apresentou a maior duplicação.

Investigação manual útil: promises sem tratamento nos dois projetos, o upload em `LocalSingleStorage.js` no IDURAR, e as regex com backtracking (`typescript:S8786`, 55 ocorrências) no Worklenz.

Uma segunda execução pode instalar Node 22, gerar LCOV, importar cobertura, separar projetos de frontend e backend e gerar o certificado que o Nginx do Worklenz espera.

## Reprodução

```bash
cd sonarqube-experiment/sonarqube
docker compose up -d
# token em logs/analysis/sonar.token (não versionar)
docker run --rm --network sonarqube-network \
  -e SONAR_HOST_URL=http://sonarqube-experiment:9000 \
  -e SONAR_TOKEN="$SONAR_TOKEN" \
  -v "$PWD/../projects/idurar-erp-crm:/usr/src" \
  -v "$PWD/../configs/idurar/sonar-project.properties:/usr/src/sonar-project.properties:ro" \
  sonarsource/sonar-scanner-cli
```

O mesmo comando, trocando o volume e o properties, analisa o Worklenz. Logs em `logs/analysis/`. Exportações em `reports/idurar/` e `reports/worklenz/`.
