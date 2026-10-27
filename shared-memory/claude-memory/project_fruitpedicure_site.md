---
name: project-fruitpedicure-site
description: "Передача клиентского сайта fruitpedicure.ru (WP/WooCommerce) в работу hab — аудит→демо→оплата→работа; тема 1967"
metadata:
  node_type: memory
  type: project
  originSessionId: 8c87a90e-48da-4d16-994c-ff585622ee29
  modified: 2026-10-27T11:32:51.493Z
---

2026-10-27 (Эстехим, msg 1940): Эстехим решили передать нам в работу свой интернет-магазин **https://fruitpedicure.ru/** (WordPress/WooCommerce, ~39 товаров + курсы — слабая корп-витрина, см. [[fp-corporate-site]]). Прислали логин/пароль (у меня в руках НЕТ; в клиентские файлы/память доступы не выношу).

**Порядок работы (согласован, оформлен в PDF `exports/estechim-process/hab-poryadok-raboty-fruitpedicure.pdf`):**
ДО оплаты (за наш счёт): 1) аудит сайта (проблемы/изъяны: скорость, структура, моб., SEO) → 2) слушаем задачи клиента → 3) предлагаем видение + демо. → Точка договорённости: согласовать оплату+сроки, зафиксировать договором, оплата. → ПОСЛЕ оплаты: полная работа → релиз → поддержка.

2026-10-27 (msg 1968): Павел завёл отдельную **тему Telegram «fruitpedicure.ru», thread_id=1967** (chat -1003982689602) под работу с проектом. Все обсуждения/отчёты по fruitpedicure.ru — туда (через tg-send.sh --thread 1967, см. [[Telegram thread topic list (Paganel+Pavel supergroup)]]).

**Задача «прикрутить к ежедневному бэкапу» (msg 1968, уточнение 1970 «я про бэкап ТЕМЫ»):**
- Павел имел в виду бэкап ТЕМЫ Telegram (обсуждений), НЕ сайта. Аналогично [[feedback-ii-creator-save-dialogs]] (тема 1033).
- РЕШЕНИЕ: сохранять обсуждения/решения из темы 1967 в мою память (этот файл + дневные логи). Память каждую ночь (18:55 UTC, backup-shared-memory.sh) зеркалится в shared-memory/claude-memory/ и пушится в приватный GitHub-репо agent2026new. Т.е. тема уже «прикручена» к ночному бэкапу через память — отдельной инфраструктуры не нужно. См. [[project-backup-system]].
- ПРАВИЛО: каждое значимое сообщение/решение из темы fruitpedicure.ru (1967) фиксировать здесь.

Связано: [[fp-corporate-site]] (Эстехим, тема 1624), [[reference_beget_fp_access]], [[project-backup-system]].
