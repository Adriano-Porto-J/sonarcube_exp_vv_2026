| ID | Projeto | Pendência | Ação necessária | Impacto | Status |
|---|---|---|---|---|---|
| P001 | Ambiente | Porta 9000 ocupada pelo MinIO (`creatorsfy-minio`) | SonarQube publicado em `http://localhost:9090` | Acesso local em porta alternativa | CONCLUÍDO |
| P002 | Ambiente | Portas 5432 e 6379 ocupadas por Postgres e Redis de outro projeto | Worklenz usou PostgreSQL interno sem publicar 5432; Redis do host não foi reutilizado | Sem conflito com os containers atuais | CONCLUÍDO |
| P003 | IDURAR | `npm run setup` falha em `Cannot find module '../models/appModels/PaymentMode'` depois de criar admin e settings | Corrigir o setup no repositório upstream ou aceitar dados parciais | Seed incompleto; login não foi validado | FALHOU |
| P004 | IDURAR | Frontend Vite foi encerrado para liberar a porta 3000 ao backend do Worklenz | Subir de novo com `npm run dev` em `frontend` quando a porta estiver livre | UI do IDURAR não permanece no ar junto com o Worklenz | CONCLUÍDO |
| P005 | Worklenz | Nginx reinicia porque falta `nginx/ssl/cert.pem` | Gerar certificado local ou desabilitar o listener HTTPS | Porta 80 indisponível; frontend responde em `http://localhost:5000` | PENDENTE DO USUÁRIO |
| P006 | Worklenz | Backend exige Node.js `>=22.12.0`; o host tem v20.19.4 | Instalar Node 22 antes de `npm test` no backend | Cobertura LCOV do backend não gerada | PENDENTE DO USUÁRIO |
| P007 | Ambos | Nenhum relatório LCOV foi importado | Rodar os testes com cobertura e repetir o scanner | A métrica `coverage=0.0` da API não é cobertura medida | NÃO APLICÁVEL |
