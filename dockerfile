# ETAPA 1
# Imagen base para levantar el proyecto, -alpine significa es lo mas justo en espacio de node
FROM node:22-alpine as Build

#Establecer el directorio de trabajo dentro del contenedor.
WORKDIR /app

#Instalar pnpm
RUN corepack enable

# copiar primero solo los archivos de dependencias ./ significa que ya estoy en /app en docker
COPY package.json pnpm-lock-yaml ./

#instalar las dependencias y --frozen-lockfile significa que copie exacto lo que estaba en mi pc
RUN pnpm install --frozen-lockfile

# copiar el codigo del proyecto

COPY . .

# Ejecutar el proyecto
RUN pnpm Build

# ETAPA 2: PRODUCCION (SACAR A INTERNET)
FROM nginx:alpine AS production

# Copiar hacia Nginx el resultado del build (carpeta dist)
COPY --from=Build /app/dist /usr/share/nginx/html

#Puerto a exponer
EXPOSE 80

# comando para iniciar el contenedor
CMD ["nginx","-g","daemon off"]