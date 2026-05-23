# Аудит веб-студий СНГ и ЕС — v2 с источниками

Выборка: **102 студий** (CIS: **50**, EU: **52**)

## Что изменилось в v2
- Добавлен блок **Sources**
- Добавлено приложение **студия → страна → сайт → источник**
- Прозрачно отмечено, где источник есть прямо в датасете, а где нужна дополнительная ручная верификация

## Покрытие источниками
- **EU:** 52 из 52 записей содержат source-ссылки в текущем датасете
- **CIS:** 50 из 50 записей содержат source-ссылки в текущем датасете
- Важно: наличие source-ссылки не всегда означает глубокую ручную проверку; часть ссылок ведёт на официальный сайт, часть — на рейтинг/листинг

## Ключевые выводы
1. **EU** заметно сильнее в нишевой специализации: Shopify, WordPress, premium branding+web, product design.
2. **CIS** чаще продаёт широту услуг: сайт + портал + CRM/ERP + SEO + поддержка.
3. У сильных студий в обоих регионах повторяются одни и те же trust-маркеры: **кейсы, клиенты, награды, годы на рынке, число проектов, партнёрства**.
4. В **EU** чаще встречается упаковка через awards/certifications, в **CIS** — через объём проектов и универсальность delivery.
5. Лучший рыночный паттерн: не «делаем сайты», а **решаем конкретную бизнес-задачу через веб-продукт**.

## Sources
Ниже — примеры записей с источниками из датасета.

### EU — примеры
| Регион | Студия | Страна | Сайт | Источник |
|---|---|---|---|---|
| EU | Significa | Portugal | https://significa.co | https://significa.co/ |
| EU | Bakken & Bæck | Norway | https://bakkenbaeck.com | https://bakkenbaeck.com/ |
| EU | Netguru | Poland | https://www.netguru.com | https://www.netguru.com/services/web-development |
| EU | Bleech | Germany | https://bleech.de | https://bleech.de/ |
| EU | Build in Amsterdam | Netherlands | https://www.buildinamsterdam.com | https://www.buildinamsterdam.com/ |
| EU | Ask Phill | Netherlands | https://askphill.com | https://askphill.com/ |
| EU | scandiweb | Latvia | https://scandiweb.com | https://scandiweb.com/ |
| EU | Kooba | Ireland | https://www.kooba.ie | https://www.kooba.ie/ |
| EU | ustwo | United Kingdom | https://www.ustwo.com | https://www.ustwo.com/ |
| EU | Dept | Netherlands | https://www.deptagency.com | https://www.deptagency.com/ |
| EU | Imaginary Cloud | Portugal | https://imaginarycloud.com | https://imaginarycloud.com/ |
| EU | Boldare | Poland | https://www.boldare.com | https://www.boldare.com/ |

### CIS — примеры
| Регион | Студия | Страна | Сайт | Источник |
|---|---|---|---|---|
| CIS | UPQODE | Kazakhstan | https://upqode.com | https://upqode.com |
| CIS | DAR | Kazakhstan | https://dar.ee | https://themanifest.com/kz/web-design/agencies |
| CIS | Resolventa | Kazakhstan | https://resolventa.com | https://clutch.co/kz/web-developers |
| CIS | SABYR TECHNOLOGIES | Kazakhstan | https://sabyr.kz | https://clutch.co/kz/web-developers |
| CIS | iBEC Systems | Kazakhstan | https://ibecsystems.kz | https://clutch.co/kz/web-developers |
| CIS | GEXABYTE | Kazakhstan | https://gexabyte.com | https://clutch.co/kz/web-developers |
| CIS | Init.kz | Kazakhstan | https://init.kz | https://themanifest.com/kz/web-design/agencies |
| CIS | Concept House | Kazakhstan | https://concepthouse.kz | https://themanifest.com/kz/web-design/agencies |
| CIS | Rocket Firm IT Production | Kazakhstan | https://rocketfirm.com | https://themanifest.com/kz/web-design/agencies |
| CIS | Kurmashev Studio | Kazakhstan | https://kurmashev.studio | https://themanifest.com/kz/web-design/agencies |
| CIS | Astana Digital Group | Kazakhstan | https://adg.kz | https://www.softwareworld.co/web-development-companies/kazakhstan/ |
| CIS | Purrweb | Kazakhstan | https://www.purrweb.com | https://www.purrweb.com |

## Приложение
Полный список источников вынесен в отдельный CSV:
- `research/studios_sources_appendix.csv`

## Как это использовать
- Для быстрой презентации — основной отчёт и дашборд
- Для защиты выводов — этот v2-отчёт + CSV-приложение с источниками
- Для публичной/клиентской версии — я бы отдельно вручную доверифицировала топ-20/30 студий
