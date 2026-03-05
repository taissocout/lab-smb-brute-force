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
