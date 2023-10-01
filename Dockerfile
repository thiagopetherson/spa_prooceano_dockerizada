# ----- Primeira Etapa ------- #

# Imagem Base
# FROM node:14.21.3-alpine AS base
FROM node:lts-alpine AS base

# Diretório de trabalho (qualquer comando a partir daqui, será rodado naquela pasta ali)
WORKDIR /app

# Copiando os arquivos que tenha o prefixo package.* para dentro do container
COPY ./package.* ./

# Limpando o cache
RUN npm cache clean

# Instale o Quasar CLI globalmente
RUN npm install -g @quasar/cli

# Instalando os pacotes (quando está criando a imagem)
RUN npm install

# Copiando o código fonte para dentro do container
COPY . .

# ----- Segunda Etapa (Dev) ------- #

# Instala dependências e copia arquivos e o dev inicia um servidor de desenvolvimento (Criando a imagem de Dev)
FROM base AS dev

# Copiando o entrypoint quando o container está sendo criado (diferente do run que é quando está criando a imagem)
COPY ./.docker/entrypoint.sh /docker-entrypoint.sh

# Dando permissão de execução ao arquivo
RUN chmod +x /docker-entrypoint.sh

# Dizendo que o entrypoint será executado quando o container estiver sendo criado (diferente do run que é quando está criando a imagem)
ENTRYPOINT [ "/docker-entrypoint.sh" ]

# Expondo a porta 8080 (Esta é a porta padrão usada por vue-cli-service serve(que é o comando subjacente executado por npm run serve)
EXPOSE 8080

# Rodando o comando que sobe o server node (esse comando pode ser sobrescrito se utilizar um comando na hora de executar o container como "docker run -it --rm spa:0.1 ls")
# .. Acima, o "ls" substitui o "CMD ["npm", "run", "serve"]" abaixo
# CMD ["quasar", "dev"]
CMD ["quasar", "dev", "-m", "pwa"]

# ----- Terceira Etapa (Build) ------- #

# Criando a imagem de build (para o estágio de prod)
FROM base AS build

# Rodando esse comando (para construção) dentro do container (criar a pasta dist e tals)
RUN quasar build -m pwa

# ----- Quarta Etapa (Prod) ------- #

# Imagem do Nginx que será o server do aplicação node (estágio de prod)
FROM nginx:1.25.1-alpine AS prod

# Copiando a pasta dist (que contém os arquivos estáticos gerados na etapa anterior) e colocando para dentro do Nginx
# COPY --from=build /app/dist/spa /usr/share/nginx/html
COPY --from=build /app/dist/pwa /usr/share/nginx/html

# Copiando os arquivos de configuração do Nginx
COPY ./config/nginx-spa.conf /etc/nginx/nginx.conf

# Expondo a porta 80 do container
EXPOSE 80

# Executando o comando (substituímos o comando padrão da imagem por nginx -g daemon off. Por padrão, quando você inicia o nginx usando o nginxcomando, ele é executado como um processo em segundo plano, desconectado do shell.) ...
# ...No entanto, ao executar um contêiner docker, ele precisa de um processo de execução demorado. Caso contrário, ele sairá. daemon offsignifica que o nginx é executado em primeiro plano. É um processo de longa duração que “mantém o contêiner ativo”. A -gopção permite passar uma diretiva de configuração para o nginx...
# ...Portanto, quando você executa o nginx -g daemon off, ele é inicializado e executado em primeiro plano, enviando mensagens de log e outras informações para sua sessão de terminal. E o mais importante, manter o contêiner em estado de funcionamento.
CMD ["nginx", "-g", "daemon off;"]
