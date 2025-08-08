# 🎯 Currículo Interativo em Bash

Um currículo inovador e interativo desenvolvido em Bash Script para demonstrar habilidades técnicas de forma criativa e memorável.

## 🚀 Conceito

Este projeto substitui o tradicional PDF de currículo por uma experiência interativa via SSH, onde o recrutador pode navegar pelos módulos do currículo em tempo real, visualizando:

- 🎨 ASCII Art colorido das tecnologias
- 📊 Barras de progresso de habilidades  
- 🎭 Animações de digitação e loading
- 📋 Navegação interativa por módulos
- 🔒 Sistema seguro com usuário restrito
- 🛡️ Tratamento robusto de erros

## 📁 Estrutura do Projeto

```
curriculo/
├── curriculo.sh              # Script principal do currículo
├── install.sh                # Instalador automático (NOVO!)
├── manage.sh                 # Gerenciador do sistema (NOVO!)
├── teste_sistema.sh          # Script de testes
├── configurando_server.txt   # Tutorial completo manual
├── README.md                 # Este arquivo
├── utils/
│   └── colors.sh            # Sistema avançado de cores e efeitos
├── modulos/
│   ├── 01_sobre_mim.sh      # Perfil profissional
│   ├── 02_experiencia.sh    # Experiência de trabalho
│   ├── 03_formacao.sh       # Formação acadêmica
│   ├── 04_tecnologias.sh    # Stack técnico com barras de progresso
│   ├── 05_certificacoes.sh  # Certificações e projetos
│   └── 06_contato.sh        # Informações de contato
└── ascii/
    ├── welcome.txt          # Logo personalizado de boas-vindas
    ├── docker.txt           # Logo Docker
    ├── aws.txt             # Logo AWS
    ├── linux.txt           # Logo Linux/Tux
    ├── php.txt             # Logo PHP
    ├── oracle.txt          # Logo Oracle
    ├── ansible.txt         # Logo Ansible
    ├── git.txt             # Logo Git
    └── bash.txt            # Logo Bash
```

## ⚡ Instalação Rápida (Recomendada)

### 1. Download e Preparação
```bash
# Fazer upload dos arquivos para o servidor
# ou clonar repositório
git clone <seu-repo> curriculo
cd curriculo
```

### 2. Instalação Automática
```bash
# Executar o instalador (como root)
sudo chmod +x install.sh
sudo ./install.sh
```

O instalador automático irá:
- ✅ Verificar pré-requisitos do sistema
- ✅ Criar usuário restrito 'curriculo'
- ✅ Configurar shell personalizado com recuperação de erro
- ✅ Configurar SSH de forma segura
- ✅ Configurar sistema de logs
- ✅ Executar testes de validação
- ✅ Mostrar informações de acesso

### 3. Gerenciamento do Sistema
```bash
# Para administrar o sistema após instalação
sudo ./manage.sh
```

## 🛠️ Instalação Manual (Avançada)

Se preferir instalação manual, consulte o arquivo `configurando_server.txt` que contém tutorial completo passo-a-passo.

## 🎮 Como Usar

### Acesso via SSH:
```bash
ssh curriculo@seu-servidor.com
# Digite a senha configurada durante a instalação
```

### Menu de Navegação:
1. **Ver todos os módulos** - Apresentação completa sequencial
2. **Navegar por módulos** - Escolher módulos específicos  
3. **Informações do sistema** - Estatísticas e detalhes técnicos
4. **Sair** - Finalizar sessão

## 🛡️ Recursos de Segurança

### 🔒 Usuário Restrito:
- Usuario 'curriculo' só pode executar o currículo
- Shell personalizado que não permite acesso ao sistema
- Timeout automático de 30 minutos
- Logs detalhados de todos os acessos

### 🔄 Recuperação de Erros:
- Sistema tenta 3 vezes antes de falhar
- Verificações automáticas de integridade
- Mensagens amigáveis em caso de problema  
- Restart automático em caso de falha
- Usuário nunca fica "preso" no sistema

### 📊 Monitoramento:
- Logs centralizados em `/var/log/cvshell.log`
- Rotação automática de logs
- Estatísticas de uso
- Rastreamento de IPs e sessões

## 🎨 Recursos Visuais Implementados

### ✨ Efeitos Especiais:
```bash
# Efeito máquina de escrever
typewriter "Texto animado" 0.05 "$GREEN"

# Barras de progresso
for i in 1..5; do echo "█"; done

# Caixas decorativas  
box "Título" "$BLUE"

# Loading animado
loading 3 "Carregando" "$CYAN"
```

### 🌈 Sistema de Cores:
- 16 cores básicas + cores RGB
- Cores de fundo e efeitos especiais
- Separadores estilizados
- Formatação consistente

### 🖼️ ASCII Art:
- Logo personalizado de boas-vindas
- Logos coloridos de tecnologias
- Elementos visuais informativos

## 🔧 Scripts de Administração

### `install.sh` - Instalador Automático
- Instalação completa em um comando
- Verificação de pré-requisitos
- Configuração segura automática
- Testes de validação

### `manage.sh` - Gerenciador do Sistema
Interface completa para administração:
- 📊 Status do sistema
- 📋 Logs em tempo real  
- 👥 Usuários conectados
- 🔄 Reiniciar serviços
- 🧪 Testes do sistema
- � Backup automático
- 🔧 Atualização de arquivos
- 📈 Estatísticas de uso
- 🗑️ Remoção completa

### `teste_sistema.sh` - Validação
- Verificação de arquivos
- Teste de permissões
- Validação de cores

## 📈 Monitoramento e Logs

### Visualizar logs em tempo real:
```bash
sudo tail -f /var/log/cvshell.log
```

### Estatísticas de uso:
```bash
sudo ./manage.sh
# Opção 8 - Estatísticas de uso
```

### Backup do sistema:
```bash
sudo ./manage.sh  
# Opção 6 - Backup dos arquivos
```

## 🌟 Diferenciais Competitivos

- **🎯 Inovação**: Abordagem única para apresentação profissional
- **⚡ Técnico**: Demonstra habilidades em Bash, Linux, SSH, automação
- **🎭 Memorável**: Experiência interativa que impressiona
- **🔒 Seguro**: Sistema restrito e monitorado
- **📱 Responsivo**: Funciona em qualquer terminal SSH
- **🛠️ Profissional**: Informações completas e bem organizadas
- **🔄 Robusto**: Recuperação automática de erros
- **📊 Analítico**: Sistema de logs e estatísticas

## 🚀 Casos de Uso

1. **Entrevistas Técnicas**: Demonstrar conhecimentos práticos
2. **Networking**: Ferramenta de conversação em eventos
3. **Portfolio**: Complementar CV tradicional
4. **Demonstração**: Mostrar habilidades em Linux/DevOps
5. **Diferenciação**: Destacar-se no mercado competitivo

## 🔧 Personalização

### Adicionar nova tecnologia:
1. Criar arquivo ASCII em `ascii/nova_tech.txt`
2. Atualizar `modulos/04_tecnologias.sh`
3. Executar `sudo ./manage.sh` → Opção 7 (Atualizar)

### Modificar informações:
1. Editar módulos em `modulos/`
2. Atualizar via `sudo ./manage.sh` → Opção 7

### Personalizar cores:
1. Modificar `utils/colors.sh`
2. Usar novas variáveis nos módulos

## 🐛 Troubleshooting

### Problema: Usuário não consegue conectar
```bash
# Verificar SSH
sudo systemctl status ssh
sudo ./manage.sh # Opção 1 - Status

# Verificar logs
sudo tail -f /var/log/cvshell.log
```

### Problema: Script não executa
```bash
# Verificar permissões
sudo ./manage.sh # Opção 5 - Testar sistema

# Restaurar permissões
sudo chmod +x /opt/curriculo/curriculo.sh
sudo chmod +x /opt/curriculo/modulos/*.sh
```

### Problema: Sistema trava
- Sistema tem timeout automático de 30 minutos
- Máximo 3 tentativas de recuperação
- Ctrl+C sempre funciona para sair

## 📞 Contato e Suporte

**Gabriel Lucas Dias de Sant'Anna**
- 📧 **Email**: gabriellucas2002br@outlook.com
- 💼 **LinkedIn**: https://www.linkedin.com/in/gabsantanna/
- 📱 **WhatsApp**: +55 (21) 99801-4245
- 🏠 **Localização**: Rio de Janeiro, RJ

## 📜 Licença

Este projeto foi desenvolvido como demonstração de habilidades técnicas. Sinta-se livre para usar como inspiração para seu próprio currículo interativo!

---

*"Transformando a apresentação profissional através da tecnologia e criatividade"* 🚀

### 💡 Dica Final
> Este próprio README é parte da demonstração das minhas habilidades de documentação técnica! 📚
