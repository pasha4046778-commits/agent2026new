---
name: reference_frutped_vps_parking
description: FrutPed припаркован на нашем VPS 46.8.79.53 (готов к переносу с Beget) — где что лежит
metadata:
  node_type: memory
  type: reference
  originSessionId: 8c87a90e-48da-4d16-994c-ff585622ee29
  modified: 2026-11-04T16:16:23.885Z
---

2026-11-04: по команде Павла «паркуй фрутпед на наш впс» поднял рабочую копию FrutPed на 46.8.79.53 (этапы 0-2 плана переноса). Боевой на Beget НЕ трогал. Публичного адреса/TLS пока нет (ждёт решения по DNS/домену).

**Где что на VPS:**
- Файлы: `/var/www/frutped/public_html` (178 файлов, без .bak), владелец www-data:www-data.
- `config.php`: `/var/www/frutped/config.php` (640 root:www-data) — восстановлен мной (не с Beget): getDB (PDO→127.0.0.1:3306 БД frutped), generatePassword, sendWelcomeEmail (легаси), sendAdminNewUserNotification; SITE_URL=https://fp-new.babichnail.online (временный!), ADMIN_EMAIL=info@galereya-krasoti.com.
- БД: **Docker-контейнер `frutped-db`** (mariadb:11, restart unless-stopped, порт 127.0.0.1:3306, том `frutped-db-data`). Секреты БД: `/root/frutped/db-secrets.env` (chmod 600). Импортировано: users 303, courses 7, payments 84, user_courses 106, admins 1, lessons 96, preorders 36.
- nginx vhost: `/etc/nginx/sites-available/fp-new.babichnail.online` (+ symlink в sites-enabled), server_name fp-new.babichnail.online, HTTP-only пока, PHP-FPM через `/run/php/php8.3-fpm.sock`, ЧПУ курсов перенесены из .htaccess (/frutped,/light-system,/noborder,/esthetic-pedicure,/esthetic-nails,/content-nail,/bonding,/predzapis).
- Поставил PHP-расширения: `php8.3-mysql php8.3-mbstring php8.3-curl` (были только cli/common/fpm/opcache/readline).
- Полный бэкап (файлы+БД) исходника: `/root/backups/fp-full/frutped-backup-2026-11-04.tar.gz`.

**Тест (локально, Host-заголовок на 127.0.0.1):** / 200, /login.php 200 (форма), /frutped 200, /esthetic-nails 200 (ЧПУ ок), /admin/ 302, /api/confirm-payment.php 400, /config.php 404 (закрыт). Главная рендерится (title ок), ошибок PHP/nginx в логах нет. Поведение 1-в-1 с Beget.

**ОСТАЛОСЬ до боевого (этап 3+):**
1. DNS — зависит от выбора Павла по домену (см. PDF `strategy/fp-migration/domain-options.*`; рекомендовал вариант B: NS babichnail.online → Cloudflare). Без записи нет публичного адреса и TLS.
2. **Почта на VPS** — mail() не настроен; нужен SMTP-релей + SPF/DKIM/DMARC, иначе письма с доступами в спам.
3. Beget-специфика в коде: хардкод `file_put_contents('/home/p/pasha/fp.babichnail.online/webhook_debug.log')` в api/prodamus-webhook.php (на VPS не запишется — поправить путь); каталог загрузки видео (move_uploaded_file) — завести writable-путь.
4. Prodamus: адрес вебхука + return URL завязаны на домен — поменять в ЛК Prodamus при переключении.
5. SITE_URL в config.php сменить на https://fp.babichnail.online при боевом.
6. Добавить дамп локальной БД в бэкап-пайплайн (сейчас ночной mysqldump тянет с Beget по SSH).

**Переключение — только по явной команде Павла.** См. [[reference_beget_fp_access]], [[project_webdev_protocol]].
