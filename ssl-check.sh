#!/bin/bash

# Запрашиваем доменное имя у пользователя
read -p "Введите доменное имя (например, example.com): " domain

# Проверка SSL-сертификата
echo "Проверка SSL-сертификата для $domain..."

ssl_expiry_date=$(echo | openssl s_client -servername "$domain" -connect "$domain:443" 2>/dev/null | openssl x509 -noout -dates | grep 'notAfter=' | cut -d= -f2)

if [ -z "$ssl_expiry_date" ]; then
    echo "Ошибка: Не удалось получить информацию о SSL-сертификате для $domain."
else
    echo "Дата истечения SSL-сертификата: $ssl_expiry_date"
fi

# Проверка даты истечения регистрации домена
echo "Проверка даты истечения регистрации домена $domain..."

whois_output=$(whois "$domain")
domain_expiry_date=$(echo "$whois_output" | grep -i 'Expiration Date' | awk '{print \$3}' | head -n 1)

if [ -z "$domain_expiry_date" ]; then
    echo "Ошибка: Не удалось получить информацию о регистрации домена для $domain."
else
    echo "Дата истечения регистрации домена: $domain_expiry_date"
fi
