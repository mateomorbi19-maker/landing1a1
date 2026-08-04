FROM nginx:alpine

# gzip + cache headers: la config por defecto de la imagen no comprime nada
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Servir la landing estática
COPY index.html /usr/share/nginx/html/index.html
COPY logo.webp  /usr/share/nginx/html/logo.webp

# og.png es lo que ven WhatsApp, Instagram y Facebook cuando alguien pega el
# link; los iconos evitan el 404 a /favicon.ico en cada primera carga.
COPY og.png              /usr/share/nginx/html/og.png
COPY favicon.png         /usr/share/nginx/html/favicon.png
COPY apple-touch-icon.png /usr/share/nginx/html/apple-touch-icon.png
COPY mateo.webp          /usr/share/nginx/html/mateo.webp

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
