---
name: project-youtube-channels
description: "Сеть YouTube-каналов (пилот: детский «Умные Колёсики» запущен 2026-11-17); конвейер производства, ElevenLabs, пороги YPP до 01.02.2027"
metadata:
  node_type: memory
  type: project
  originSessionId: e0301fd3-caf0-499c-949d-c35777b44fdc
  modified: 2026-11-19T19:16:03.058Z
---

Запуск сети YouTube-каналов (решение Павла 2026-11-17, тема «Идеи» 129; план-PDF в exports/youtube-plan/).

**Запущено:** канал «Умные Колёсики» (@UmnyeKolesiki, аккаунт gudhab.media@gmail.com, 2FA вкл), первый ролик опубликован 2026-11-17: https://youtu.be/WdpYSW4OQp8 («Цифры 1–5»). Серии 2 «Цвета», 3 «Формы», 4 «Цифры 6–10» и сборник 10:18 (sbornik-jessica.mp4, 2 прохода с заставками) переданы Павлу для заливки; очередь: Цвета → Формы → Цифры 6-10 → Сборник. Пилоты №2-3 произведены 2026-11-18, ждут создания каналов Павлом (бренд-каналы под gudhab.media, Studio → Создать канал): «Нейропрактикум» (RU, @Neuropraktikum, голос Eric cjVigY5qzO86Huf0OWal, exports/yt-neuro/, ролик «5 нейросетей») и «Wealth Routes» (EN, @WealthRoutesHQ, голос Brian nPczCjzI2devNBz1zQrb, exports/yt-wealth/, ролик «Rule of 72»). Слайдовый конвейер: HTML→wkhtmltoimage (--enable-local-file-access обязателен)→ffmpeg; слайды СТАТИЧНЫЕ + fade-in 0.5с, программный зум по картинке НЕ использовать вовсе (zoompan дёргается, scale+crop дрейфует вниз — два замечания Павла 18.11); фон exports/yt-common/music-calm.py. НОВОЕ 19.11: для взрослых каналов тестируется конвейер OpenMontage (tools/openmontage, наш ELEVENLABS_API_KEY в .env, локальный патч Explainer.tsx: icon для callout — при git pull перенакатить): props JSON → npx remotion render, анимированные карточки; тест — ролик №2 Нейро «ChatGPT: 5 приёмов» (exports/yt-neuro/v2/), ждёт вердикта Павла. Отдельно обсуждается видеоген (Veo через aistudio.google.com под gudhab.media — ждём ключ от Павла; Kling запасной). ИИ-декларация у взрослых каналов — «Да». TG-ветки: Колёсики=2278, Нейро=2281, Wealth=2282 (создаю сам через scripts/tg-topic.sh).

**Конвейер производства** (exports/kids-test/): SVG-ассеты (машинки 5 цветов мордочкой ВЛЕВО — едут справа налево, фигурки с лицами) → озвучка ElevenLabs (ключ /root/.secrets/elevenlabs.key, Starter 40K кредитов/мес, продление 18 дек; голос канала **Jessica cgSgspJ2msm6clMCkdW9**, модель **eleven_v4** — v2 коверкала ударения; settings .45/.8/.4) → build-*.py (ffmpeg-сцены, длительность из ffprobe голоса, музыка music-dur.py подмес 0.16) → обложки/баннеры wkhtmltoimage (баннер YouTube ≤6МБ → jpg).

**Why:** дедлайн — с 01.02.2027 порог YPP удваивается (8000 часов), успеть монетизировать до; детский контент = COPPA (RPM $0.5–2, комменты авто-off, отметка «для детей» обязательна; ИИ-декларация YouTube — честное «Нет», мультик нереалистичный).

**How to apply:** новые серии — копировать паттерн build-colors.py; публикация: Павел заливает комплект (видео+обложка+название+описание+теги) вручную, позже YouTube Data API. Кредиты озвучки ~1200/серию — следить за лимитом 40K. Связано: [[project-backup-system]], [[hab-project]].
