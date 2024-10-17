## Обсуждение версий и сборок Windows

>[!WARNING]
> Эта страница дана только для ознакомления. Это не призыв установки старых версий Windows. Сейчас лучшей версией является Windows 24h2. Остальные рассматривать не имеет смысла, поскольку 24h2 имеет огромный ряд преимуществ, над остальными версиями.

>[!IMPORTANT]
> 11 Windows (с Мая 2023 года) имеет огромный ряд улучшений, по сравнению с Windows 10, включающие в себя CASO, уменьшение фонового потребления, исправления ошибок и другие. Подробнее будет описано ниже. Что я до вас хочу донести: на данный момент Windows 10 полноценно устарела и неактуальна.

- В ранних версиях Windows отсутствует поддержка античитов (из-за отсутствия обновлений безопасности устаревших ОС), поддержка драйверов (обычно GPU, сетевых карт) и приложений в целом, поэтому некоторые пользователи вынуждены использовать более новые сборки. В приведенной ниже таблице указаны минимальные версии, необходимые для установки драйверов для определенных графических процессоров

    |GPU|Минимальная версия Windows|
    |---|---|
    |NVIDIA 10 серия и ниже|Поддерживаются почти все версии Windows|
    |NVIDIA 16, 20 серия|Win7, Win8, Win10 1709+|
    |NVIDIA 30 серия|Win7, Win10 1803+|
    |NVIDIA 40 серия|Win10 1803+|
    |AMD|Обратитесь к странице поддержки драйверов|

- В Windows Server отсутствует поддержка многих потребительских сетевых карт. Такие способы обхода, как [такой](https://github.com/loopback-kr/Intel-I219-V-for-Windows-Server), обычно мешают работе античита из-за недействительных сертификатов подписи.

- Драйверы NVIDIA DCH поддерживаются в Windows 10 1803+ ([1](https://nvidia.custhelp.com/app/answers/detail/a_id/4777/~/nvidia-dch%2Fstandard-display-drivers-for-windows-10-faq))

- Во время воспроизведения мультимедиа исключительно на Windows 10 1709 служба [Multimedia Class Scheduler Service](https://learn.microsoft.com/en-us/windows/win32/procthread/multimedia-class-scheduler-service) повышает разрешение таймера до 0,5 мс, что ограничивает контроль над запрошенным разрешением.

- Windows 10 1809+ требуется для трассировки лучей на графических процессорах NVIDIA

- Microsoft внедрила фиксированную частоту 10 МГц QueryPerformanceFrequency в Windows 10 1809+

- В Windows 10 1903+ обновлен планировщик для процессоров Ryzen с несколькими CCX ([1](https://i.redd.it/y8nxtm08um331.png))

- Для DirectStorage требуется Windows 10 1909+, но, согласно статье, игры, работающие на Windows 11, получают дополнительные преимущества благодаря новым оптимизациям стека хранения ([1](https://devblogs.microsoft.com/directx/directstorage-developer-preview-now-available)).

- Windows 10 2004+ требуется для [Hardware Accelerated GPU Scheduling](https://devblogs.microsoft.com/directx/hardware-accelerated-gpu-scheduling), которая необходима для генерации кадров DLSS ([1](https://developer.nvidia.com/rtx/streamline/get-started)).

- Процессы, повышающие разрешение таймера в Windows 10 2004+, больше не влияют на глобальное разрешение таймера ([1](https://learn.microsoft.com/en-us/windows/win32/api/timeapi/nf-timeapi-timebeginperiod), [2](https://randomascii.wordpress.com/2020/10/04/windows-timer-resolution-the-great-rule-change)), что означает, что оно устанавливается на основе каждого процесса, при этом процессам, которые явно не повышают разрешение, не гарантируется более высокое разрешение и они обслуживаются реже. Это получило дальнейшее развитие в Windows 11: более высокое разрешение не гарантируется вызывающему процессу, если его окно свернуто или заметно заслонено ([1](https://learn.microsoft.com/en-us/windows/win32/api/timeapi/nf-timeapi-timebeginperiod)). Microsoft добавила возможность восстановления глобального поведения на Windows Server 2022+ и Windows 11+ с помощью записи в реестре ([1](https://randomascii.wordpress.com/2020/10/04/windows-timer-resolution-the-great-rule-change)), что означает, что реализация не может быть восстановлена на Windows 10 версий 2004 - 22H2.

- В Windows 11+ есть обновленный планировщик для процессоров Intel 12-го поколения и выше ([1](https://www.anandtech.com/show/16959/intel-innovation-alder-lake-november-4th/3)), но это поведение можно воспроизвести вручную с помощью политик сродства в любой версии Windows, как объясняется в последующих разделах.

- Windows 11+ ограничивает частоту опроса фоновых процессов ([1](https://blogs.windows.com/windowsdeveloper/2023/05/26/delivering-delightful-performance-for-more-than-one-billion-users-worldwide))

- Windows 11 является минимальным требованием для [Cross Adapter Scan-Out](https://videocardz.com/newz/microsoft-cross-adapter-scan-out-caso-delivers-16-fps-increse-on-laptops-without-dgpu-igpu-mux-switch) ([1](https://devblogs.microsoft.com/directx/optimizing-hybrid-laptop-performance-with-cross-adapter-scan-out-caso))

- AllowTelemetry можно установить на 0 в редакциях Windows Server ([1](https://admx.help/?Category=Windows_10_2016&Policy=Microsoft.Policies.DataCollection::AllowTelemetry)).

- Начиная с версии Windows 10 2004 комплект драйверов Windows включает в себя модуль расширения класса сетевого адаптера ([NetAdapterCx](https://learn.microsoft.com/ru-ru/windows-hardware/drivers/netcx)). С версии  Windows 11 24h2 UMDF NetAdapterCx позволяет драйверам сетевого адаптера работать в пользовательском режиме.
  
    - Это замена NDIS(драйвера инетернет адаптера) На драйвер с поддержкой NetAdapter Class Extension, который имеет преимущества над старым ([1](https://learn.microsoft.com/ru-ru/windows-hardware/drivers/netcx/)).

- Также в 24h2 были внесены следующие изменения:
  
    - Был обновленн WDDM до версии 3.2 ([1](https://learn.microsoft.com/en-us/windows-hardware/drivers/what-s-new-in-driver-development#display-and-graphics-drivers))
      
    - Потока инпута (функции GetRawInputData) была убрана связь с DPC от GPU драйвера, что должно положительно сказаться на итоговых результатах.

    - Используется два потока инпута в DWM, вместо трех (23h2).
  
