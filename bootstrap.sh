#!/bin/bash
# 1. Встановлення вебсервера Apache2
apt-get update
apt-get install -y apache2

# 2. Налаштування кастомного TCP порту (згідно з варіантом: ${port})
sed -i 's/Listen 80/Listen ${port}/' /etc/apache2/ports.conf

# 3. Створення та конфігурування DocumentRoot (${doc_root})
mkdir -p ${doc_root}

# 4. Створення сторінки index.html
echo "<html><body style='font-family:sans-serif;'> \
      <h1>Lab 3 - Variant ${variant}</h1> \
      <p>Student: <b>${student_name}</b></p> \
      <p>Server Name: ${server_name}</p> \
      </body></html>" > ${doc_root}/index.html

# 5. Надання прав доступу системному користувачу Apache (www-data)
chown -R www-data:www-data ${doc_root}
chmod -R 755 ${doc_root}

# 6 & 7. Налаштування VirtualHost та запобігання помилці '403 Forbidden'
printf "<VirtualHost *:${port}>
    ServerName ${server_name}
    DocumentRoot ${doc_root}
    
    <Directory ${doc_root}>
        Options Indexes FollowSymLinks
        AllowOverride None
        Require all granted
    </Directory>
    
    ErrorLog $${APACHE_LOG_DIR}/error.log
    CustomLog $${APACHE_LOG_DIR}/access.log combined
</VirtualHost>" > /etc/apache2/sites-available/000-default.conf

# 8. Активація змін та перезапуск служби
systemctl restart apache2