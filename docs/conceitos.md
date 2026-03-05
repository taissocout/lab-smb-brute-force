# Conceitos Teóricos — Brute Force com Medusa

## O que é Brute Force?
Técnica que testa sistematicamente combinações de usuário/senha até encontrar credenciais válidas.
Eficaz quando não há account lockout, rate limiting ou senhas fortes.

## Tipos de Ataque

| Técnica | Descrição |
|---|---|
| Brute Force | Testa todas as combinações da wordlist |
| Password Spraying | Mesma senha contra múltiplos usuários |
| Credential Stuffing | Credenciais vazadas reutilizadas |
| Dictionary Attack | Wordlist pré-definida com senhas comuns |

## Medusa
Ferramenta de brute force paralelo e modular. Suporta FTP, SSH, SMB, HTTP, RDP e outros.
```
medusa -h <alvo> -U <usuarios> -P <senhas> -M <modulo> -v 6
```

## Protocolos Atacados

### FTP (porta 21)
File Transfer Protocol — transferência de arquivos. Credenciais trafegam em texto plano.

### SMB (porta 445)
Server Message Block — compartilhamento de arquivos Windows/Linux. Muito explorado em redes internas.

### HTTP (porta 80)
Formulários web de login. O módulo http do Medusa simula requisições POST automatizadas.

## Mitigações
- Senhas fortes (mínimo 16 caracteres)
- Account lockout após 5 tentativas falhas
- MFA em todos os serviços
- Monitoramento de logs e alertas SIEM
- Desabilitar serviços desnecessários (FTP legado)
- WAF para proteção de formulários web
