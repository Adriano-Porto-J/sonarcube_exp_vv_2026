# IDURAR ERP/CRM

- Repositório: https://github.com/idurar/idurar-erp-crm
- Branch: `master`
- Commit: `e935dec13cf8b6082a7e7fc4736669e5151a80a3` (2026-08-15)
- Licença: GNU AGPL v3
- Dashboard: http://localhost:9090/dashboard?id=idurar-erp-crm

Análise estática concluída. A aplicação não ficou plenamente operacional: o setup aborta ao exigir o módulo `PaymentMode`, ausente nesta revisão. Backend respondeu na porta 8888 e o frontend Vite chegou a responder 200 em `http://localhost:3000` antes de ser encerrado.

| Métrica | Valor |
|---|---|
| Bugs | 17 |
| Vulnerabilities | 4 |
| Security hotspots | 0 |
| Code smells | 20 |
| Duplicação | 23,6% (5.480 linhas) |
| Cobertura | indisponível (sem LCOV; a API devolve `0.0`) |
| Linhas (ncloc) | 20.403 |
| Arquivos | 339 |
| Linguagens | JavaScript 19.912, CSS 491 |
| Maintainability | A (`sqale_rating` 1.0) |
| Reliability | E (`reliability_rating` 5.0) |
| Security | C (`security_rating` 3.0) |
| Quality Gate | OK |

Issues abertas: 41 (5 blocker, 1 critical, 21 major, 14 minor).

Problemas recorrentes: `javascript:S7773` (10), `javascript:S9383` promises sem tratamento (8). Vulnerabilidades apontadas em `backend/src/middlewares/uploadMiddleware/LocalSingleStorage.js` e `frontend/src/config/serverApiConfig.js`. Esses itens são achados do SonarQube, ainda sem revisão manual.
