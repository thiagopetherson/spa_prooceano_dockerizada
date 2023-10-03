#!/bin/sh

# Instale as dependências (caso necessário)
npm install

# Verifique se o comando de construção foi passado como argumento
if [ "$1" = "build" ]; then
  # Se o comando for "build", execute o comando de construção do Quasar
  ./node_modules/.bin/quasar build -m pwa
else
  # Caso contrário, execute o comando passado como argumento para o script
  exec "$@"
fi
