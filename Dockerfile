FROM nginx:alpine

# Servir la landing estática
COPY index.html /usr/share/nginx/html/index.html
COPY logo.png   /usr/share/nginx/html/logo.png

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
