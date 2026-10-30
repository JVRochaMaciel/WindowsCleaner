# WindowsCleaner

Ferramenta de automação para limpeza e manutenção do Windows, desenvolvida em Batch para facilitar tarefas básicas de manutenção e liberar espaço em disco.

## Funcionalidades

- Limpeza de arquivos temporários do usuário.
- Limpeza de arquivos temporários do Windows.
- Remoção de cache de miniaturas.
- Limpeza de caches gráficos conhecidos, como Direct3D e NVIDIA.
- Opção para esvaziar a Lixeira, mediante confirmação.
- Verificação do espaço livre em disco.
- Registro das operações realizadas em arquivos de log.
- Solicitação de permissões administrativas quando necessário.

## Tecnologias utilizadas

- Batch (CMD)
- PowerShell
- Ferramentas nativas do Windows

## Requisitos

- Windows 10 ou Windows 11.
- Permissões administrativas para determinadas operações.
- PowerShell disponível no sistema.

## Como utilizar

1. Baixe ou clone este repositório.
2. Localize o arquivo `WinClean.bat`.
3. Execute o arquivo.
4. Autorize a solicitação de administrador, caso apareça.
5. Aguarde a conclusão do procedimento.

Os arquivos de log são armazenados automaticamente na pasta `Logs`, criada no mesmo diretório do script durante sua execução.

## Segurança

O WindowsCleaner foi desenvolvido com foco em uma limpeza conservadora do sistema.

O programa não tem como objetivo excluir documentos pessoais, desinstalar programas, modificar o Registro do Windows ou desativar serviços e recursos de segurança.

Arquivos em uso ou protegidos pelo sistema podem não ser removidos durante a execução.

**Importante:** revise as opções apresentadas pelo programa antes de confirmar operações como esvaziar a Lixeira.

## Objetivo

O projeto tem como objetivo aplicar conhecimentos de automação, scripts Batch e administração do Windows, oferecendo uma ferramenta simples para auxiliar em tarefas de manutenção do sistema.
