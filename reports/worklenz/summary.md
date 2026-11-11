# Worklenz

- Repositório: https://github.com/Worklenz/worklenz
- Branch: `main`
- Commit: `88edbad54c8ac12cd08555b334a7a9b5e42b6a20` (2026-11-05)
- Licença: GNU AGPL v3
- Dashboard: http://localhost:9090/dashboard?id=worklenz

Análise estática concluída. PostgreSQL e SeaweedFS ficaram healthy. Frontend respondeu 200 em `http://localhost:5000`. Backend escuta em `http://localhost:3000` (raiz retorna 404, típico de API). Nginx não sobe: falta `nginx/ssl/cert.pem`. Testes com cobertura não rodaram: o backend pede Node `>=22.12.0`.

| Métrica | Valor |
|---|---|
| Bugs | 404 |
| Vulnerabilities | 13 |
| Security hotspots | 0 |
| Code smells | 917 |
| Duplicação | 4,8% (30.842 linhas) |
| Cobertura | indisponível (sem LCOV; a API devolve `0.0`) |
| Linhas (ncloc) | 472.559 |
| Arquivos | 3.692 |
| Linguagens | TypeScript 427.602, CSS 34.276, JavaScript 10.681 |
| Maintainability | A (`sqale_rating` 1.0) |
| Reliability | E (`reliability_rating` 5.0) |
| Security | C (`security_rating` 3.0) |
| Quality Gate | OK |

Issues abertas: 1.334 (13 blocker, 14 critical, 704 major, 603 minor).

Regras mais frequentes: `typescript:S7773` (590), `typescript:S9383` (301), `typescript:S6848` acessibilidade de elementos interativos (213). A contagem absoluta é maior porque o código analisado é cerca de 23 vezes o do IDURAR. Achados do scanner, sem confirmação manual.
