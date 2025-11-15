# Руководство по настройке Windows

>[!CAUTION]
>**Это не гайд, это просто сборник известных (мне на момент последнего коммита) рабочих настроек, файлов, разборов двордов, документаций и т.д.**


## ВАЖНО

 Если вы хотите задать вопрос, поделиться своими исследованиями или добавить разборы других авторов — вы можете сделать это в моём Discord ([ссылка](https://discord.gg/SzPvGfQGQt)). Поскольку я не могу заниматься исследованиями круглосуточно, обновления гайда будут двух типов: разовые — при появлении новой информации, и мелкие коммиты — для правок табуляции и прочих мелких исправлений.

## Бенчмаркинг
- **[FrameView](https://www.nvidia.com/en-gb/geforce/technologies/frameview)** - Слишком нагруженное приложение. Если хотите - используйте. Я не советую использовать её.

- **[PresentMon](https://github.com/GameTechDev/PresentMon)** - Большое количество метрики и хорошие показатели. Для визуализации используйте **[Frame Time Analysis](https://boringboredom.github.io/Frame-Time-Analysis/)**. Полный список параметров запуска для PresentMon **[здесь](https://github.com/GameTechDev/PresentMon/blob/main/README-CaptureApplication.md#metric-definitions)**.

- **[Windows Performance Toolkit](https://learn.microsoft.com/en-us/windows-hardware/test/wpt)** - Расширенный анализ прерываний для Windows. Измерьте время выполнения ISR/DPC с помощью **[xperf](/files/xperf-test-script.bat)**. Для более детального анализа используется **[Media eXperience Analyzer](https://learn.microsoft.com/en-us/windows-hardware/test/weg/delivering-a-great-media-experience)**.

- **[Mouse Tester](https://github.com/valleyofdoom/MouseTester)** - Проверьте интервал опроса, частоту работы мыши, узнайте о стабильности чувствительности.

- **[NVIDIA Reflex Analyzer](https://www.nvidia.com/en-gb/geforce/news/reflex-latency-analyzer-360hz-g-sync-monitors)** - Полезная утилита для игр с Reflex.

- **[RTSS](https://www.guru3d.com/download/rtss-rivatuner-statistics-server-download/)** - В новой версии добавили полезной метрики (ищите на guru3d или других проверенных источниках бета [версию](https://www.youtube.com/watch?v=7DtEJlx-UQI)).


## [Обсуждение версий и сборок Windows](/guide/About_Versions.md)

## [Руководство по настройке Windows](/guide/Windows_Optimization.md)

## [Исследования](/guide/Explorations.md)

## [Руководство по работе с Xperf](/guide/xperf_guide.md)

## [Рекомендуемые программы и утилиты](/guide/Recommended_Programs_and_Utilities.md)

## Послесловие

Благодарность вот этим классным ребятам: **[Amitxv(valleyofdoom)](https://github.com/valleyofdoom/PC-Tuning)**, **[Timecard](https://github.com/djdallmann/GamingPCSetup)**, **[Boring Boredom](https://github.com/BoringBoredom/PC-Optimization-Hub)** и другие (список будет дополняться).
Я не запрещаю использовать информацию из данного руководства, но если вы все же это делаете (не важно в каком виде, цитируете, используете в своем гайде и т.д.), то пожалуйста, оставляйте ссылки на этот гайд для продвижения (на гайд, а не на автора).
Для обращения или сотрудничества пишите в личные сообщения Discord.
