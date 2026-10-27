---
name: project-fruitpedicure-site
description: "Передача клиентского сайта fruitpedicure.ru (WP/WooCommerce) в работу hab — аудит→демо→оплата→работа; тема 1967"
metadata:
  node_type: memory
  type: project
  originSessionId: 8c87a90e-48da-4d16-994c-ff585622ee29
  modified: 2026-10-27T11:44:45.250Z
---

2026-10-27 (Эстехим, msg 1940): Эстехим решили передать нам в работу свой интернет-магазин **https://fruitpedicure.ru/** (WordPress/WooCommerce, ~39 товаров + курсы — слабая корп-витрина, см. [[fp-corporate-site]]). Прислали логин/пароль (у меня в руках НЕТ; в клиентские файлы/память доступы не выношу).

**Порядок работы (согласован, оформлен в PDF `exports/estechim-process/hab-poryadok-raboty-fruitpedicure.pdf`):**
ДО оплаты (за наш счёт): 1) аудит сайта (проблемы/изъяны: скорость, структура, моб., SEO) → 2) слушаем задачи клиента → 3) предлагаем видение + демо. → Точка договорённости: согласовать оплату+сроки, зафиксировать договором, оплата. → ПОСЛЕ оплаты: полная работа → релиз → поддержка.

2026-10-27 (msg 1968): Павел завёл отдельную **тему Telegram «fruitpedicure.ru», thread_id=1967** (chat -1003982689602) под работу с проектом. Все обсуждения/отчёты по fruitpedicure.ru — туда (через tg-send.sh --thread 1967, см. [[Telegram thread topic list (Paganel+Pavel supergroup)]]).

**Задача «прикрутить к ежедневному бэкапу» (msg 1968, уточнение 1970 «я про бэкап ТЕМЫ»):**
- Павел имел в виду бэкап ТЕМЫ Telegram (обсуждений), НЕ сайта. Аналогично [[feedback-ii-creator-save-dialogs]] (тема 1033).
- РЕШЕНИЕ: сохранять обсуждения/решения из темы 1967 в мою память (этот файл + дневные логи). Память каждую ночь (18:55 UTC, backup-shared-memory.sh) зеркалится в shared-memory/claude-memory/ и пушится в приватный GitHub-репо agent2026new. Т.е. тема уже «прикручена» к ночному бэкапу через память — отдельной инфраструктуры не нужно. См. [[project-backup-system]].
- ПРАВИЛО: каждое значимое сообщение/решение из темы fruitpedicure.ru (1967) фиксировать здесь.

**АУДИТ ВЫПОЛНЕН (msg 1972→1974, 2026-10-27).** Полный отчёт PDF: `exports/fruitpedicure-audit/hab-audit-fruitpedicure.pdf` (+ audit.html, скриншоты в scratchpad). Ключевое:
- **Хостинг: REG.RU shared** — сервер server163.hosting.reg.ru, IP 31.31.196.165 (Москва). DNS/почта/регистратор — REG.RU. Домен оплачен до 05.04.2027. nginx, HTTP/2, HTTPS (Let's Encrypt), HSTS, БЕЗ CDN/Cloudflare.
- **Стек: WordPress 7.1.3 + WooCommerce 11.0.1**, тема «domweb» (покупной шаблон), 38 товаров, 11 плагинов (WooCommerce, Yoast SEO, CF7, GTranslate, слайдер, FAQ, wishlist, попап, tag-filter, product-attachment, custom-fields).
- SEO ❌: title главной = заглушка «Контент на главной», нет meta description, 2×H1, OG неполный. Yoast стоит но не заполнен. Sitemap/canonical/lang — ок.
- Безопасность ❌: открыто перечисление юзеров (/wp-json/wp/v2/users=200, /?author=1=301), утечка версий (readme.html=200 + generator). wp-login открыт. Нет security-заголовков. ✅ HTTPS/HSTS, uploads 403, нет .git, xmlrpc недоступен (000).
- Скорость ⚠️: TTFB ~0.95с, HTML 171КБ, 28 CSS/JS (~93КБ gzip) + 51 img, gzip есть/brotli нет, нет кэш-заголовков, нет WebP/lazy-load.
- Дизайн: шаблонный но аккуратный, адаптив ✅; перегружен декором, слабо выражен B2B/опт.
- Приоритеты: 1) SEO-база 2) безопасность 3) скорость 4) стратегия (кастом vs оптимизация WP). Следующий шаг по процессу — видение + демо.
- ТЕХ-РЕЦЕПТ аудита (пригодится): dig/whois (хостинг по NS/MX/IP), curl -I/-w (заголовки, TTFB, http_version), grep HTML (generator/themes/plugins/SEO-теги), wp-json/wc/store/v1/products?per_page=1 → заголовок x-wp-total = число товаров, Chrome headless --screenshot (desktop/mobile).

Связано: [[fp-corporate-site]] (Эстехим, тема 1624), [[reference_beget_fp_access]], [[project-backup-system]].
