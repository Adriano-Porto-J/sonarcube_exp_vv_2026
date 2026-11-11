# Síntese

Os dois repositórios foram analisados no SonarQube local (`http://localhost:9090`). Worklenz tem mais problemas em valor absoluto porque tem cerca de 23 vezes mais linhas. A densidade de bugs é quase a mesma (0,83 e 0,86 por 1.000 linhas). Worklenz tem mais code smells por linha; IDURAR tem bem mais duplicação (23,6% contra 4,8%).

Cobertura não foi medida. O setup do IDURAR não termina, e o Nginx do Worklenz não sobe sem certificado. A análise estática não depende dessas falhas de execução.
