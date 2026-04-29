---
id: meta-writing-rules
type: meta
title: Writing rules для shared-memory (operational regulament)
author: paganel
status: approved
version: v1.1
created: 2026-04-29T07:10:00Z
updated: 2026-04-29T16:05:00Z
tags: [meta, rules, regulament]
relates_to: [meta-record-schema, proj-shared-memory-hub]
---

# Writing Rules — operational regulament

Канон того, **кто / когда / что / куда** пишет в shared-memory. **Версия v1.1** — расширение модели от 2026-04-29 (Amber + Paganel co-design). Добавлены: тип `summary`, явный canon на ID naming (`meta/id-naming.md`), правило update vs new record. Темы обеих супергрупп с thread_id зафиксированы в §5.2.

## 1. Принцип в одну строчку
**Telegram-тема ≠ память.** Сообщения в Telegram — это поток. Память — это то, что после этого потока остаётся осмысленным. Важное оседает в hub, остальное умирает в чате.

## 2. Кто пишет

Базовая модель: **semantic / operational + shared meta**.

- **Amber — semantic side:** architecture, summaries, decisions, project context, meta-rules.
- **Paganel — operational/technical side:** infra, incidents, automation, security, implementation follow-ups + operational structure.
- **Shared ownership** (оба, equal say, договариваемся через PR-style правки): meta-правила, schema, архитектура самой памяти. Любой из агентов может править, но содержательный конфликт поднимаем Павлу.

Детальная разбивка по зонам:

| Зона | Amber | Paganel |
|---|---|---|
| Memory architecture / hub schema / meta-rules | ✅ co-owner | ✅ co-owner (focus: operational structure + security) |
| Summaries, свёртка контекста | ✅ owner | помощник по запросу |
| Project context (нарратив, состояние) | ✅ owner | вторично (тех. факты) |
| Decisions (стратегия, продукт) | ✅ owner | вторично (тех. решения) |
| Технические изменения, deploy/dev | вторично | ✅ owner |
| Automation (cron, скрипты, бэкапы) | вторично | ✅ owner |
| Incidents (тех. сбои) | вторично | ✅ owner |
| Implementation follow-ups | вторично | ✅ owner |
| Infra (серверы / домены / сервисы) | вторично | ✅ owner |
| Security | вторично | ✅ owner |
| Sources (выжимки) | пишет тот, кто разбирал | пишет тот, кто разбирал |
| Ideas | оба | оба |
| Daily | оба, в общий файл дня | оба, в общий файл дня |

«Owner» — основной автор и хранитель раздела (последнее слово в спорной ситуации в этой зоне). «Co-owner» — равные права и ответственность. «Вторично» — может дополнять, но не переписывает чужое без согласования.

## 3. Когда пишут

- **Оперативно** — сразу, как только появляется значимый контекст (решение, инцидент, изменение проекта/инфры, незавершённый хвост, важный вывод).
- **Daily свёртка** — каждый день в `23:55` по времени Павла (UTC+05:00). Закрывает день: что было, что сделано, что сломалось, что осталось, что нужно от Павла.
- **Бэкап** — автоматический cron 23:55 UTC+5 (см. `infra/backup-shared-memory.md`). Агентам коммитить руками не нужно — backup-script подхватит.

## 4. Что пишем

### Обязательно
- решения и причины (почему именно так)
- изменения инфраструктуры (сервер / домен / сервис)
- незавершённые задачи и хвосты
- root cause проблем
- статусы проектов при сдвиге
- выводы из материалов, не сами материалы целиком
- договорённости по workflow и правилам
- важные ограничения, которые мешают что-то сделать

### Не пишем без необходимости
- "ок / готово / сделал" без контекста
- сырые длинные логи (только выжимка + ссылка)
- мелкая болтовня
- полная переписка как архив всего подряд
- секреты в открытые файлы (никогда — вообще никогда)
- информация, которую можно мгновенно достать из git history / кода

## 5. Куда пишем (routing)

### 5.1 По типу события

Когда возникает важный факт — он маршрутизируется по таблице:

| Что произошло | Куда оседает |
|---|---|
| Случилось событие дня | `daily/YYYY-MM-DD.md` |
| Принято решение | `decisions.md` (раздел по дате) |
| Появился незавершённый хвост | `todo.md` |
| Сдвинулся проект | `projects/<slug>.md` |
| Тронули сервер / домен / сервис | `infra/<slug>.md` |
| Сбой / починка / root cause | `incidents/YYYY-MM-DD-NNN-<slug>.md` + запись в `logs/security_log.json` если security |
| Разобрали внешний материал (видео / статья) | `sources/YYYY-MM-DD-<slug>.md` |
| Появилась идея / гипотеза | `ideas/<slug>.md` |
| Контекст по человеку / агенту | `people/<slug>.md` |
| Правило / схема / соглашение | `meta/<slug>.md` |
| Свёртка периода / проекта / handoff | `summaries/<id>.md` (см. §6.4) |

Один факт может попасть в несколько разделов (например, инцидент → `incidents/` + `daily/` + `decisions.md` если по итогам приняли правило). Это нормально, связи делаются через `relates_to`.

### 5.2 По Telegram-теме (fan-out)

Telegram-тема — surface для обсуждения, не имя раздела памяти. Один разговор в теме может породить записи в нескольких разделах. Таблица показывает, КУДА может ложиться важное из каждой темы. **Primary** — типичный основной адресат; **Secondary** — куда часто попадает дополнительно. Пустой хвост (`daily/`) подразумевается всегда — туда оседают сами события дня.

#### Группа `Amber + Павел` (финальный список 2026-04-29)

| Тема | Primary | Secondary |
|---|---|---|
| `Общее` | `daily/` | `decisions.md`, `todo.md` |
| `Серверы` | `infra/<server>.md` | `incidents/`, `decisions.md`, `daily/` |
| `Сайты` | `projects/<site>.md`, `infra/<site>.md` | `decisions.md`, `incidents/`, `daily/` |
| `Память` | `meta/`, `proj-shared-memory-hub` | `decisions.md`, `todo.md` |
| `Проекты` | `projects/<slug>.md` | `decisions.md`, `infra/`, `sources/`, `todo.md` |
| `Paganel` | (Amber-side) `people/agents.md`, `daily/` | `decisions.md` |
| `Автоматизация` | `infra/<automation>.md` | `decisions.md`, `incidents/`, `proj-shared-memory-hub` |
| `Codex` | `sources/<date>-<slug>.md`, `ideas/<slug>.md` | `decisions.md` |
| `Ремонт` | `incidents/<id>.md`, `infra/<service>.md` | `decisions.md`, `daily/` |
| `Варианты заработка` | `ideas/<slug>.md` | `projects/`, `decisions.md` |
| `VPS агент` | `infra/<vps>.md`, `people/agents.md` | `decisions.md`, `incidents/` |
| `ТЗ для базы знаний` | `projects/<knowledge-base>.md`, `meta/` | `todo.md`, `decisions.md` |
| `Идеи` | `ideas/<slug>.md` | `projects/`, `decisions.md` |
| `Фрукт пед` | `projects/fp-babichnail-online.md`, `infra/fp-babichnail-online.md` | `incidents/`, `decisions.md`, `daily/` (cross-link с `proj-fp-babichnail-online`) |
| `Эксперимент` | `ideas/<slug>.md` или `sources/<date>-<slug>.md` | `projects/`, `decisions.md` |

#### Группа `Paganel + Павел` (`chat_id = -1003982689602`, финальный список 2026-04-29)

| Тема | thread_id | Primary | Secondary |
|---|---|---|---|
| `general` (root) | — | `daily/` | `decisions.md`, `todo.md` |
| `memory` | 7 | `meta/`, `proj-shared-memory-hub` | `decisions.md`, `todo.md` |
| `FrutPed` (project-dedicated) | 49 | `projects/fp-babichnail-online.md`, `infra/fp-babichnail-online.md` | `incidents/`, `decisions.md`, `daily/` |
| `Dev / Разработка` | 114 | `projects/<slug>.md` | `decisions.md`, `infra/`, `incidents/`, `todo.md` |
| `Серверы` | 117 | `infra/<server>.md` | `incidents/`, `decisions.md`, `daily/` |
| `Автоматизация` | 120 | `infra/<automation>.md` | `decisions.md`, `incidents/`, `proj-shared-memory-hub` |
| `Ошибки` | 123 | `incidents/<id>.md` | `decisions.md` (если правило по итогам), `infra/`, `todo.md` |
| `ТЗ` | 126 | `projects/<slug>.md`, `todo.md` | `decisions.md`, `daily/` |
| `Идеи` | 129 | `ideas/<slug>.md` | `projects/`, `decisions.md` |
| `Апгрейд` | 132 | `infra/<service>.md` (раздел «История изменений») | `decisions.md`, `daily/`, `incidents/` |
| `Сайты` | 135 | `projects/<site>.md` или `sources/<date>-<title>.md` | `infra/`, `decisions.md`, `ideas/`, `daily/` |
| `Трейдинг` | 138 | `projects/trading-<slug>.md` | `sources/`, `ideas/`, `decisions.md`, `daily/` |
| `Проверки` | (уточнить thread_id) | `daily/` | `incidents/` (если нашли баг), `decisions.md`, `todo.md` |

### 5.3 Как читать эту таблицу

- Если событие = твой Primary → запись точно туда.
- Если событие задевает Secondary → дополнительная запись с `relates_to` к Primary.
- Если событие не вписывается ни в Primary, ни в Secondary темы — это сигнал, что либо тему выбрали не ту, либо нужна новая категория памяти. Поднимаем Павлу.

## 6. Как пишем

### 6.1 Базовые правила
- Каждый файл начинается с YAML frontmatter по `meta/record-schema.md`. Без исключений.
- Уникальный `id` по канону **`meta/id-naming.md`** (lowercase, hyphens, стабильный slug). Никаких "untitled" / случайных сокращений.
- `author` — кто реально создавал запись.
- `status` — обновляется при изменении состояния (не только при создании).
- `updated` — обновляется при содержательной правке.
- Soft-graph связи (`relates_to` и др.) — только осмысленные. Не «всё ко всему».
- Слог — короткий, по делу, без воды. Если запись > 200 строк — скорее всего, надо разбить.

### 6.2 Update vs new record (правило Amber)

Обновляем существующую запись, если:
- это **тот же объект во времени** (тот же проект, сервер, человек, идея);
- мы уточняем статус, контекст, состояние;
- событие не имеет самостоятельной ценности вне родительского объекта.

Создаём новую запись, если:
- событие самостоятельное и может жить отдельно;
- нужен собственный lifecycle;
- нужен отдельный root cause / source / summary / incident trail;
- запись может стать узлом графа сама по себе.

Примеры:
- изменение статуса сайта → `update projects/<site>.md`;
- новый outage → `new incidents/<id>.md`;
- новая выжимка статьи / видео → `new sources/<src>.md`;
- недельная сводка → `new summaries/<summary>.md`.

### 6.3 Когда bump версии правил/схем

- `v1.0.x` (`v1.0.2`, `v1.0.3` и т.д.) — уточнения формулировок, routing, naming, **без смены модели**.
- `v1.1`, `v1.2` — новый тип записи, новый раздел, новое обязательное правило.
- `v2.0` — ломаем совместимость или меняем базовую модель hub.

### 6.4 Summary-артефакты (с v1.1)

Сводка — это **новый класс записи**, не source. Не прячем в `sources/`.

- **type:** `summary`
- **id:** `summary-<scope>-YYYY-MM-DD-<slug>` (см. `meta/id-naming.md`)
- **scope:** `project`, `weekly`, `quarterly`, `handoff`, `incident-postmortem`
- **папка:** `summaries/` (плоско; если в будущем понадобится вложенность — обсудим)
- **обязательное в frontmatter:** `relates_to` (проект / инцидент / идея / человек), `source_for` (что опирается на эту сводку — решения, project files, todo)
- **tags:** `summary` + scope (например `weekly`, `handoff`)
- **владелец:** обычно Amber (semantic side), но Paganel может писать `incident-postmortem` и `handoff` для технических передач.
- **шаблон:** `summaries/TEMPLATE.md`.

### 6.5 Архитектурный принцип

Не делаем hub слишком «умным» на бумаге раньше времени. Soft-graph — да. Жёсткая taxonomy — только там, где уже реально болит. Меньше «будущих сущностей», больше понятных правил записи сейчас.

### 6.6 Дневной файл

- Один файл на день: `daily/YYYY-MM-DD.md`.
- Оба агента пишут в один файл.
- Внутри — секции (`## События дня`, `## Что сделано` и т.д.). Каждый абзац подписывается автором, если несколько агентов писали:
  ```
  - [paganel] починил cron, push прошёл.
  - [amber] сводка по проекту X: …
  ```
- Если в один день оба агента ведут параллельные большие истории, заводим подсекции `## Paganel — <тема>` / `## Amber — <тема>`.

### 6.7 Конфликты

- Никогда не удалять и не переписывать чужие записи. Дополнять — да, отдельным абзацем со своим `[author]`.
- Если возникает реальное несогласие по факту/решению — фиксируем оба варианта и поднимаем Павлу через `todo.md` или DM.

## 7. Telegram → hub: процесс

1. В Telegram-теме идёт обсуждение.
2. Агент, который ведёт тему, понимает: появился значимый факт.
3. Агент пишет запись в hub по правилу #5 (с frontmatter по #6).
4. В Telegram кратко отвечает: «зафиксировано: <ссылка / id>». Это позволяет Павлу не держать всё в голове.
5. Перед закрытием дня — оба агента сверяются, что важное из тем оказалось в hub.

Темы каждой группы:

| Группа | Темы |
|---|---|
| Amber + Павел | Общее / Проекты / Память / Идеи / Сайты / Серверы |
| Paganel + Павел | Dev / Сервер / Автоматизация / Ошибки / ТЗ / Проверки |

## 8. Backup, приватность и креды

- В git уходит весь `shared-memory/`. Это нормально — там нет секретов.
- Не уходит: `.env`, `logs/`, `data/`, `memory/`, `tmp/`, `media/` (через `.gitignore`).
- Если в shared-memory случайно попал секрет — немедленно убрать, ротировать, записать инцидент.

### 8.1 Правила работы с кредами
- Все секреты (пароли, токены, ключи) живут ТОЛЬКО в `/root/.openclaw/workspace/.env` (chmod 600, gitignored). В shared-memory — только ИМЯ переменной (`VPS_PASS`, `FRUTPED_PASS` и т.д.), без значения.
- **Никаких паролей через Telegram.** Telegram-боты не e2ee, и сообщения хранятся на серверах. Если Павел всё же прислал креды через Telegram — agent:
  1. переносит значения в `.env`,
  2. шреддит локальные копии в harness inbox (`shred -u`),
  3. создаёт incident-запись,
  4. просит Павла удалить сообщение в чате И сменить пароль.
- Для VPS долгосрочно — SSH-ключи, парольный root-логин отключить. Это infra-задача.

## 9. Версионирование этих правил

- Текущая версия отражена в frontmatter (`version:`).
- При содержательных изменениях правил — поднимаем версию (`v1.x`, `v2.0` для major) в шапке и в `decisions.md`.
- Точечные дополнения (новая тема в §5.2, корректировка одной строки) — без bump'а версии, помечаются в истории как `v1.0.1+` уточнения.
- Принимаем правки в стиле PR: если автор не co-owner раздела — обсуждаем, а не переписываем. Любой может предложить.
- История изменений — секция в конце.

## История изменений
- 2026-04-29 v0.1 — Paganel создал draft. Базируется на плане v2 от Amber + расширении Paganel + уточнении ролей Павла.
- 2026-04-29 v0.1.1 — Paganel добавил раздел 5.2 (fan-out маршрутизации по Telegram-темам) и 5.3 (как читать таблицу). По запросу Павла.
- 2026-04-29 v0.1.2 — Paganel добавил project-dedicated тему `FrutPed` в группе `Paganel+Павел` (расширение по правилу плана v2 «новые темы — как расширение»).
- 2026-04-29 v0.1.3 — Paganel расширил §8: добавил §8.1 «Правила работы с кредами» после инцидента `2026-04-29-002` (передача паролей через Telegram).
- 2026-04-29 v1.0 — Утверждено Павлом («ок, делай все что нужно»). Темы supergroup'ов могут уточниться от Pavel'а отдельно — это войдёт точечной правкой §7 без bump'а версии.
- 2026-04-29 v1.0.1 — Pavel прислал финальные списки тем обеих супергрупп. §5.2 переписан: добавлены реальные thread_id для группы Paganel+Pavel (и расширенный набор тем включая Трейдинг, Апгрейд, Дев и т.д.). Для Amber+Pavel — список тем без thread_id (другая группа).
- 2026-04-29 v1.0.1+ — Amber приняла v1.0.1 как канон. По её замечаниям: §2 переформулирован (semantic owner = Amber, operational owner = Paganel, shared ownership на meta-rules); §9 убрано legacy-упоминание v0.1 draft; шапка приведена в соответствие версии. Amber дальше пришлёт patch-list по: summary-стандарту, id naming convention, update-vs-new-record правилу.
- 2026-04-29 v1.1 — co-design Amber + Paganel: добавлен новый тип записи `summary` с папкой `summaries/` и шаблоном; явный canon для ID (`meta/id-naming.md`); §6.2 правило update vs new record; §6.3 политика bump'а версий; §6.4 summary-артефакты; §6.5 архитектурный принцип «не делать hub слишком умным раньше времени». §6.6/6.7 (daily file / conflicts) — переехали из старой §6 без смысловых изменений.
