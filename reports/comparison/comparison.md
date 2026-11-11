# Comparação IDURAR e Worklenz

Números abaixo são problemas identificados pelo SonarQube Community Build 26.11.0.134175. Não são bugs funcionais confirmados por teste nem por revisão manual.

| Métrica | IDURAR | Worklenz |
|---|---:|---:|
| ncloc | 20.403 | 472.559 |
| Bugs | 17 | 404 |
| Vulnerabilities | 4 | 13 |
| Hotspots | 0 | 0 |
| Code smells | 20 | 917 |
| Duplicação | 23,6% | 4,8% |
| Cobertura | indisponível | indisponível |
| Quality Gate | OK | OK |

Normalização: `(contagem / ncloc) * 1000`.

- Bugs por 1.000 linhas: IDURAR 0,83; Worklenz 0,86.
- Code smells por 1.000 linhas: IDURAR 0,98; Worklenz 1,94.
- Vulnerabilidades por 1.000 linhas: IDURAR 0,20; Worklenz 0,03.

Worklenz concentra mais smells por linha, sobretudo `Number.isNaN`, promises não tratadas e elementos interativos não nativos. IDURAR duplica uma fração bem maior do código. Os dois receberam reliability E e security C, com quality gate padrão ainda em OK. O gate padrão do Community Build não reprova sozinho um volume alto de bugs major.

Diferença de stack: IDURAR é JavaScript (Express/Mongoose e Vite). Worklenz é majoritariamente TypeScript (frontend, backend e client portal). As regras efetivas não são o mesmo conjunto.
