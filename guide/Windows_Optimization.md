# Руководство по настройке Windows

> [!IMPORTANT]
> Этот гайд не рассчитан на "ультра минимальный сетап для одной игры" или "игровой сетап с сохранением полного функционала". Здесь представлено пошаговое руководство для оптимизации работы операционной системы с расчетом на выполнение задач, требующих максимальное быстродействие и отзывчивый отклик. В руководстве не запрещается свободное выполнение рекомендаций (о всех нюансах будет написано в разделе).




## Настройка после установки

Настройте под себя меню пуск, ярлыки, панель задач. Настройками персонализации можно будет воспользоваться попозже.

- При необходимости, установите обновления в Центре обновлений.

Перенесите папку ``files`` из репозитория в корень диска системы (должно получится вот так: ``C:\files\``)

## Импортирования Настроек в регистр

>**⚠**
>  Я не утверждаю, что это идеальная настройка реестра, и что у неё нет проблем. При желании вы можете сами настроить в файле конфигурации. **Скрипт не возвращает настройки при изменении с "true" на "false".**

Это необходимо для выполнения скриптов в репозитории. Откройте PowerShell от имени администратора (не через Win+R, а через пуск) и введите приведенную ниже команду.

```powershell
Set-ExecutionPolicy Unrestricted
```

Откройте файл конфигурации
```bat
C:\files\registry-options.json
```
Проверьте выставленные настройки. При желании измените на необходимые для вас.

### Таблица настроек реестра
|Опция|Стимул|Пояснение|Значение по умолчанию
|---|---|---|---|
|``disable windows update``|1. Снижение нагрузки на процессор<br><br>2. Получение более тонкого контроля над рассматриваемой функцией|Отключение Windows Update входит в рекомендации Microsoft по настройке устройств для производительности в реальном времени ([1](https://learn.microsoft.com/en-us/windows/iot/iot-enterprise/soft-real-time/soft-real-time-device)). Вместо полного отключения Windows Update можно отключить автоматические обновления, что дает тот же эффект с точки зрения снижения нагрузки на процессор, но при этом позволяет обновлять Windows, установив значение ``disable windows update`` в ``false`` и ``disable automatic windows updates`` в ``true``. Известно, что процессы обновления Windows потребляют много ресурсов процессора и памяти. Отключение Windows Update нарушает работу Microsoft Store, однако вы можете загружать и устанавливать пакеты Appx напрямую ([инструкции](https://superuser.com/questions/1721755/is-there-a-way-to-install-microsoft-store-exclusive-apps-without-store))<br><br>Этот вариант не влияет на обновления, которые можно контролировать с помощью групповых политик ([инструкции](https://www.tenforums.com/tutorials/159624-how-specify-target-feature-update-version-windows-10-a.html)). Однако вы ограничены в предотвращении обновлений до тех пор, пока указанная версия не достигнет окончания срока службы|``false``|
|``disable automatic windows updates``|1. Снижение нагрузки на процессор<br><br>2. Получение более тонкого контроля над рассматриваемой функцией|Предотвращает автоматическую загрузку и установку обновлений Windows, вместо того чтобы полностью отключить Windows Update и время от времени проверять наличие обновлений вручную. Обновления могут происходить в неудобное время, что приводит к чрезмерному использованию процессора и памяти через случайные промежутки времени, а также к нарушению процесса выключения в некоторых случаях. Эта опция отменяется, если для параметра ``disable windows update`` установлено значение ``true``. <br><br>Этот параметр не влияет на обновления, которые можно контролировать с помощью групповых политик ([инструкции](https://www.tenforums.com/tutorials/159624-how-specify-target-feature-update-version-windows-10-a.html)). Однако вы можете предотвратить обновления только до тех пор, пока указанная версия не достигнет конца срока службы|``true``|
|``disable driver installation via windows update``|1. Снижение нагрузки на процессор<br><br>2. Получение более тонкого контроля над рассматриваемой функцией|Предотвращает установку устаревших, уязвимых и потенциально плохо работающих драйверов через Windows Update. Рекомендуется вручную устанавливать только минимальные версии драйверов, которые требуются вашей системе (так как полная программа установки часто устанавливает другие программы, которые постоянно работают в фоновом режиме), а также последние версии непосредственно с сайта производителя, как описано в разделе [Установка драйверов](#установка-драйверов). Эта опция отменяется, если для параметра ``disable windows update`` установлено значение ``true``.|``true``|
|``disable automatic store app updates``|1. Снижение нагрузки на процессор<br><br>2. Получение более тонкого контроля над рассматриваемой функцией|Предотвращает автоматическую загрузку и установку обновлений приложений магазина по сравнению с полным отключением обновлений приложений, что нежелательно с точки зрения снижения нагрузки на процессор. Вместо этого время от времени проверяйте наличие обновлений приложений вручную|``true``|
|``disable windows defender``|1. Снижение нагрузки на процессор<br><br>2. Предотвращает проблемы с переходом процессора в состояние C-State 0 ([1](https://www.techpowerup.com/295877/windows-defender-can-significantly-impact-intel-cpu-performance-we-have-the-fix))|Эта опция полностью отключает Защитник Windows. Вместо этого часто запускайте сканирование системы, используйте защищенный браузер с [uBlock Origin](https://ublockorigin.com), держите UAC включенным и отдавайте предпочтение бесплатному, открытому исходному коду и надежному программному обеспечению. Держитесь подальше от проприетарного программного обеспечения, где это возможно, и проверяйте файлы и исполняемые файлы с помощью [VirusTotal](https://www.virustotal.com/gui/home/upload) перед их открытием.|``true``|
|``disable gamebarpresencewriter``|1. Снижение нагрузки на процессор|Процесс постоянно работает в фоновом режиме и, по моим данным, не требуется для работы игрового режима или игровой панели.|``true``|
|``disable background apps``|1. Снижение нагрузки на процессор|Запрещает приложениям работать в фоновом режиме. Фоновые приложения отключаются с помощью политик с этой опцией, поскольку в интерфейсе Windows 11 эта опция недоступна.|``true``|
|``disable transparency effects``|1. Снижение нагрузки на процессор ([1](/assets/images/transparency-effects-benchmark.png))|Отключение эффектов прозрачности|``true``|
|``disable notifications network usage``|1. Смягчение телеметрии ([1](https://learn.microsoft.com/en-gb/windows/privacy/manage-connections-from-windows-operating-system-components-to-microsoft-services#10-live-tiles))|N/A|``true``|
|``disable windows marking file attachments with information about their zone of origin``|1. Уменьшение или отключение навязчивых элементов|Предотвращает [это](https://www.tenforums.com/tutorials/85418-how-disable-downloaded-files-being-blocked-windows.html) навязчивые предупреждения безопасности, поскольку загруженные файлы постоянно требуют разблокировки, однако это может негативно сказаться на безопасности, поскольку пользователь не будет уведомлен о заблокированных файлах с помощью предупреждения безопасности ([1](https://www.tenforums.com/tutorials/85418-how-disable-downloaded-files-being-blocked-windows.html)).|``true``|
|``disable malicious software removal tool updates``|1. Получение более тонкого контроля над рассматриваемой функцией|Предотвращение предложения Windows средства удаления вредоносных программ через Windows Update|``true``|
|``disable sticky keys``|1. Уменьшение или отключение навязчивых элементов|Отключает отображение сообщения "Хотите включить залипание клавиши?" при нажатии горячей клавиши определенное количество раз. Это очень навязчиво в приложениях, использующих клавишу ``Shift'' для управления, например в играх.|``true``|
|``disable pointer acceleration``|1. Уменьшение или отключение навязчивых элементов|Обеспечивает отклик мыши один к одному в играх, которые не подписываются на необработанные события ввода, и на Рабочем столе|``true``|
|``disable fast startup``|1. Уменьшение или отключение навязчивых элементов|Вмешивается в процесс выключения в том смысле, что система не переходит в S5, что может привести к неожиданным проблемам ([объяснение](https://www.youtube.com/watch?v=OBGxt8zhbRk)). Соответствующую информацию см. в разделе [Быстрый запуск, переход в ждущий режим и гибернация](#Быстрый-запуск,-переход-в-ждущий-режим-и-гибернация). Можно завершить работу без отключения быстрого запуска, удерживая ``Shift`` при нажатии ``Выключить`` в меню Пуск. Однако недостатком этого способа является то, что вы можете забыть удерживать клавишу ``Shift``.|``true``|
|``disable customer experience improvement program``|1. Смягчение телеметрии ([1](https://learn.microsoft.com/en-us/previous-versions/windows/it-pro/windows-server-2012-r2-and-2012/jj618322(v=ws.11)))|Рекомендовано [privacyguides.org](https://www.privacyguides.org/en/os/windows/group-policies)|``true``|
|``disable windows error reporting``|1. Смягчение телеметрии|Рекомендовано [privacyguides.org](https://www.privacyguides.org/en/os/windows/group-policies)|``true``|
|``disable clipboard history``|1. Смягчение телеметрии|Рекомендовано [privacyguides.org](https://www.privacyguides.org/en/os/windows/group-policies)|``true``|
|``disable activity feed``|1. Смягчение телеметрии|Рекомендовано [privacyguides.org](https://www.privacyguides.org/en/os/windows/group-policies)|``true``|
|``disable advertising id``|1. Смягчение телеметрии|Рекомендовано [privacyguides.org](https://www.privacyguides.org/en/os/windows/group-policies)|``true``|
|``disable autoplay``|1. Снижение риска безопасности|Рекомендовано [privacyguides.org](https://www.privacyguides.org/en/os/windows/group-policies)|``true``|
|``disable cloud content``|1. Смягчение телеметрии|Рекомендовано [privacyguides.org](https://www.privacyguides.org/en/os/windows/group-policies)|``true``|
|``disable account-based explorer features``|1. Смягчение телеметрии|Рекомендовано [privacyguides.org](https://www.privacyguides.org/en/os/windows/group-policies)|``true``|
|``disable mdm enrollment``|1. Смягчение телеметрии|Рекомендовано [privacyguides.org](https://www.privacyguides.org/en/os/windows/group-policies)|``true``|
|``disable microsoft store push to install feature``|1. Снижение риска безопасности|Рекомендовано [privacyguides.org](https://www.privacyguides.org/en/os/windows/group-policies)|``true``|
|``mitigate web-based search info``|1. Смягчение телеметрии|Рекомендовано [privacyguides.org](https://www.privacyguides.org/en/os/windows/group-policies)|``true``|
|``disable sending inking and typing data to microsoft``|1. Смягчение телеметрии|Рекомендовано [privacyguides.org](https://www.privacyguides.org/en/os/windows/group-policies)|``true``|
|``disable automatic maintenance``|2. Получение более тонкого контроля над рассматриваемой функцией|N/A|``true``|
|``disable program compatibility assistant``|2. Получение более тонкого контроля над рассматриваемой функцией|Предотвращает анонимное применение изменений Windows после запуска средств устранения неполадок|``true``|
|``disable remote assistance``|1. Снижение риска безопасности|N/A|``true``|
|``disable sign-in and lock last interactive user after a restart``|1. Снижение риска безопасности ([1](https://www.stigviewer.com/stig/windows_server_2012_2012_r2_member_server/2014-06-30/finding/V-43245))|N/A|``true``|
|``show file extensions``|1. Снижение риска безопасности ([1](https://www.youtube.com/watch?v=nYdS3FIu3rI))|N/A |``true``|
|``disable widgets``|1. Снижение риска безопасности ([1](https://www.youtube.com/watch?v=m9d-fXl3Z8k))|N/A|``true``|
|``disable telemetry``|1. Смягчение телеметрии|N/A|``true``|
|``disable retrieval of online tips and help in the immersive control panel``|1. Смягчение телеметрии|N/A|``true``|
|``disable typing insights``|1. Смягчение телеметрии|N/A|``true``|
|``disable suggestions in the search box and in search home``|1. Смягчение телеметрии<br><br>2. Reducing or disabling intrusive features|N/A|``true``|
|``disable computer is out of support message``|1. Уменьшение или отключение навязчивых элементов|Отключает [это](https://support.microsoft.com/en-us/topic/you-received-a-notification-your-windows-7-pc-is-out-of-support-3278599f-9613-5cc1-e0ee-4f81f623adcf) навязчивое сообщение. Не актуально для пользователей с современной версией Windows|``true``|
|``disable fault tolerant heap``|2. Получение более тонкого контроля над рассматриваемой функцией|Предотвращает автономное применение Windows средств защиты для предотвращения будущих сбоев на основе каждого приложения ([1](https://learn.microsoft.com/en-us/windows/win32/win7appqual/fault-tolerant-heap)), что может привести к проблемам ([1](https://www.mak.com/mak-one/support/help/knowledge/performance-issues-caused-by-the-fault-tolerant-heap-windows)).|``true``|


- Откройте PowerShell от администратора (не через Win+R, и ручками тоже не получится запустить) и введите

    ```powershell
    C:\files\apply-registry.ps1
    ```

 Если команда не сработала, попробуйте отключить Tamper protection (Защита от Эксплоитов) в Windows Defender. Если это не помогло, перезагрузитесь, а затем выполните команду снова

 Убедитесь, что скрипт выводит в консоль сообщение "successfully applied", если этого не происходит, значит, файлы реестра не были успешно объединены


## Установка драйверов
 
 >**⚠**
 >Драйверы чипсета обычно не требуются, но если они есть, то их функциональность, скорее всего, можно повторить вручную, при этом преимущество заключается в отсутствии накладных расходов, связанных с постоянным запуском драйверов и принудительным переключением контекста. Примером могут служить драйверы чипсета AMD, используемые для управления нагрузкой на каждый процессор для планирования потоков на V-Cache CCX/CCD. [[1](https://hwbusters.com/cpu/amd-ryzen-9-7950x3d-cpu-review-performance-thermals-power-analysis/2)].

- Драйвера чиспета Intel от Fernando: [Chipset Device "Drivers" (= INF files) | Fernando](https://winraid.level1techs.com/t/intel-chipset-device-drivers-inf-files/30920)

>**⚠**
> Драйвера чиспета intel, которые поставляются Microsoft, не имеют большой разницы с установленными вручную, как минимум на процессорах до 12 поколения, так как там уже появляются E-ядра. При желании можно вручную настроить распределение нагрузки между ядрами вручную.


- Вы можете найти драйверы, выполнив поиск драйверов, совместимых с HWID вашего устройства. Смотрите [пример](/docs/device-hwid-example.png) в отношении поиска вашего HWID в диспетчере устройств для данного устройства.

- Постарайтесь получить драйвер в формате INF, чтобы его можно было установить в диспетчере устройств, так как исполняемые программы установки обычно устанавливают вместе с драйвером другие программы. В большинстве случаев для получения драйвера можно распаковать исполняемый файл программы установки с помощью программы 7-Zip.

Рекомендуется обновить и установить следующее: 

- Network Interface Controller
  >Если на этом этапе у вас нет доступа к интернету, вам придется загрузить драйвер сетевой карты с другого устройства или выполнить двойную загрузку, поскольку в некоторых версиях Windows они могут быть вообще не установлены.


    - Другие необходимые драйверы можно установить с помощью [Snappy Driver Installer Origin](https://www.snappy-driver-installer.org).

Настройка Драйвера для видеокарты описана в отдельном разделе.


## Промежуточная настройка некоторых моментов

Активируйте Windows при помощи данного скрипта в ``powershell``:
```powershell
irm https://massgrave.dev/get | iex
```
 - Или используйте другие методы 

Настройте под себя используя  ``intl.cpl`` и ``timedate.cpl`` в ``Win+R``

Настройте раздел ``Time & Language``, который можно вызвать при помощи комбинации ``Win+I``

Установите браузер. 

- Firefox с настройкой от амита: ``C:\files\install-firefox_by_amit.ps1``


Установите проигрыватель, например [VLC](https://www.videolan.org)

## Установка библиотек
Установите библиотеки, которые необходимы для большинства программ:

- [Visual C++ Redistributable](https://github.com/abbodi1406/vcredist)

- [.NET 4.8](https://dotnet.microsoft.com/en-us/download/dotnet-framework/net48) (уже установлено на Windows 10 1909+)

- [WebView](https://developer.microsoft.com/en-us/microsoft-edge/webview2)

- [DirectX](https://www.microsoft.com/en-gb/download/details.aspx?id=8109)


## Настройка Параметров Windows и конфигурация девайсов
- Дальше все настройки можно применять, используя ``cmd``.

По желанию установите максимальный возраст пароля, чтобы он никогда не истекал, чтобы Windows периодически запрашивала смену или ввод пароля ([1](https://www.tenforums.com/tutorials/87386-change-maximum-minimum-password-age-local-accounts-windows-10-a.html))

```bat
net accounts /maxpwage:unlimited
```

Опциональное отключение [зарезервированного хранилища](https://www.tenforums.com/tutorials/124858-enable-disable-reserved-storage-windows-10-a.html) (Windows 10 1903+)

```bat
DISM /Online /Set-ReservedStorageState /State:Disabled
```

По желанию очистите папку WinSxS, чтобы уменьшить ее размер ([1](https://learn.microsoft.com/en-us/windows-hardware/manufacture/desktop/clean-up-the-winsxs-folder?view=windows-11)). Обратите внимание, что это может быть длительным процессом

```bat
DISM /Online /Cleanup-Image /StartComponentCleanup /ResetBase
```

Настройте имя операционной системы, рекомендуется задать ему какое-нибудь значимое или уникальное название, например ``Windows 11 GAMES`` или ``Windows 11 Default`` для наглядности при двойной загрузке. Ярлык раздела также можно переименовать аналогичным образом для наглядности

```bat
bcdedit /set {current} description OS_NAME
```

```bat
label C: OS_NAME
```
Если в системе нет жесткого диска, то Superfetch/Prefetch можно отключить командой, приведенной ниже. Отключение SysMain указано в рекомендациях Microsoft по настройке устройств для производительности в реальном времени ([1](https://learn.microsoft.com/en-us/windows/iot/iot-enterprise/soft-real-time/soft-real-time-device)).

```bat
reg add "HKLM\SYSTEM\CurrentControlSet\Services\SysMain" /v "Start" /t REG_DWORD /d "4" /f
```
Настройте следующее, набрав ``sysdm.cpl`` в ``Win+R``:

> **⚠**
> Отключение данных параметров не влияет на производительность системы.

- ``Дополнительно`` -> ``Производительность`` -> ``Настройки`` - настройте ``Пользовательские``.

- ``Защита системы`` - отключение и удаление точек восстановления системы. Было доказано, что она ненадежна ([1](https://askleo.com/why_i_dont_like_system_restore))

Отключите все ненужные разрешения в разделе ``Приватность``, нажав ``Win+I``.

Только для Windows Server:

- В диспетчере сервера перейдите в раздел ``Управление`` -> ``Свойства диспетчера сервера`` и включите опцию, запрещающую автоматический запуск диспетчера сервера

- Установите тип запуска служб ``Windows Audio`` и ``Windows Audio Endpoint Builder`` на автоматический, набрав ``services.msc`` в ``Win+R``.

- Перейдите в раздел ``Конфигурация компьютера`` -> ``Параметры Windows`` -> ``Параметры безопасности`` -> ``Политики учетных записей`` -> ``Политика паролей``, набрав ``gpedit.msc`` в ``Win+R`` и отключите ``Пароль должен соответствовать требованиям сложности``

- Откройте cmd и введите ``gpupdate /force``, чтобы немедленно применить изменения

- Перейдите в раздел ``Конфигурация компьютера`` -> ``Административные шаблоны`` -> ``Система``, набрав ``gpedit.msc`` в ``Win+R`` и отключите ``Display Shutdown Event Tracker``, чтобы отключить приглашение к выключению.

- Чтобы удалить пароль пользователя, введите свой текущий пароль и оставьте поля для ввода нового/подтверждения пароля пустыми в разделе ``Учетные записи пользователей``, набрав ``control userpasswords`` в ``Win+R``.

## Индексирование поиска
Определенные каталоги в файловой системе индексируются для поиска в Windows, что можно увидеть, набрав ``control srchadmin.dll`` в Win+R. Индексирование происходит периодически в фоновом режиме и часто приводит к заметной нагрузке на процессор, что можно увидеть с помощью Process Explorer. Поэтому лучше предотвратить индексирование поиска глобально, отключив службу Windows Search, однако при этом функции поиска могут быть ограничены. Откройте CMD от имени администратора и введите следующую команду.

  ```bat
  reg add "HKLM\SYSTEM\CurrentControlSet\Services\WSearch" /v "Start" /t REG_DWORD /d "4" /f
  ```


## Удаление неиспользуемого ПО
Откройте [AppxPackagesManager](https://github.com/valleyofdoom/AppxPackagesManager), затем удалите все, что вам не нужно (а это может быть всё). Обычно можно оставить установленные пакеты, если они не работают в фоновом режиме.

Необходимые пакеты для Microsoft Store. Возможно, стоит оставить это, так как при желании вы сможете загружать приложения в будущем. Хотя можно загружать пакеты ``.appx`` напрямую и устанавливать их вручную без магазина, но это может стать утомительным. Дополнительную информацию см. на [здесь](https://superuser.com/questions/1721755/is-there-a-way-to-install-microsoft-store-exclusive-apps-without-store).

- ``Microsoft.WindowsStore``

Необходимые пакеты для Xbox Game Bar. Настоятельно рекомендуется сохранить этот пакет для доступа к ``Помните, что это игра`` в Game Bar, чтобы решить проблемы с обнаружением игр.

- ``Microsoft.XboxGamingOverlay``

Необходимые пакеты для Xbox Game Pass

- ``Microsoft.XboxIdentityProvider``
- ``Microsoft.Xbox.TCUI``
- ``Microsoft.StorePurchaseApp``
- ``Microsoft.GamingApp``
- ``Microsoft.WindowsStore``
- ``Microsoft.GamingServices``
- ``Microsoft.XboxGamingOverlay``


Откройте CMD и введите следующую команду, чтобы удалить OneDrive

```bat
for %a in ("SysWOW64" "System32") do (if exist "%windir%\%~a\OneDriveSetup.exe" ("%windir%\%~a\OneDriveSetup.exe" /uninstall)) && reg delete "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Desktop\NameSpace\{018D5C66-4533-4307-9B53-224DE2ED1FE6}" /f > nul 2>&1
```

Отключите Chromium Microsoft Edge

- Браузер должен быть отключен, а не удален, чтобы сохранить среду выполнения WebView

- Загрузите [Autoruns](https://learn.microsoft.com/en-us/sysinternals/downloads/autoruns) и перейдите в раздел ``Everything``, затем выполните поиск *"edge"*. Отключите все элементы, которые появятся в отфильтрованных результатах

- Обновление браузера отменит некоторые изменения, сделанные на предыдущем этапе. Чтобы браузер не обновлялся при случайном открытии, можно выполнить следующую команду. Убедитесь, что в диспетчере задач не запущено ни одного скрытого процесса Microsoft Edge.

    ```bat
    rd /s /q "C:\Program Files (x86)\Microsoft\EdgeUpdate"
    ```

- Откройте cmd и введите следующую команду, чтобы удалить все связанные с ним ярлыки.

    ```bat
    for /f "delims=" %a in ('where /r C:\ *edge.lnk*') do (del /f /q "%a")
    ```

- Удалите все ненужные программы, набрав ``appwiz.cpl`` в ``Win+R``.

- Отключите Xbox Game Bar в настройках или с помощью приведенных ниже ключей реестра, чтобы предотвратить запуск ``GameBar.exe``.
        
    ```bat
    reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\GameDVR" /v "AppCaptureEnabled" /t REG_DWORD /d "0" /f
    ```

    ```bat
    reg add "HKCU\System\GameConfigStore" /v "GameDVR_Enabled" /t REG_DWORD /d "0" /f
    ```        

- В меню "Пуск" *удалите* остаточные ссылки на приложения. Помните, что эти приложения на самом деле не установлены, они устанавливаются только в том случае, если пользователь нажимает на них, поэтому не нажимайте на них случайно

- Удалите bloatware в разделе ``Приложения -> Установленные приложения``, нажав ``Win+I``.

- В разделе ``Система -> Дополнительные компоненты`` удалите все, что вам не нужно.

- Если Windows Defender был отключен на этапе [Объединить параметры реестра](#импортирования-настроек-в-регистр), ``smartscreen.exe`` игнорирует ключ реестра, контролирующий постоянный запуск в фоновом режиме на более поздних версиях Windows. По этой причине откройте ``cmd`` от имени ``TrustedInstaller`` с помощью команды ``C:\bin\MinSudo.exe --TrustedInstaller --Privileged`` и введите следующую команду для удаления файла

    ```bat
    taskkill /f /im smartscreen.exe > nul 2>&1 & ren C:\Windows\System32\smartscreen.exe smartscreen.exee
    ```

- Вы можете использовать диспетчер задач, чтобы проверить, не запущен ли в фоновом режиме остаточный мусор, и, возможно, создать проблему в репозитории, чтобы ее можно было просмотреть.

## Установка 7-Zip

Скачайте и установите [7-Zip](https://www.7-zip.org). Откройте ``C:\Program Files\7-Zip\7zFM.exe``, затем перейдите ``Tools -> Options`` и ассоциируйте 7-Zip со всеми расширениями файлов, нажав кнопку ``+``. Возможно, вам придется нажать ее дважды, чтобы отменить существующие ассоциированные расширения.

## Настройте графический драйвер

- Смотрите [/guide/setup_nvidia_driver.md](/guide/setup_nvidia_driver.md)

- Смотрите [/guide/setup_amd_driver.md](/guide/setup_amd_driver.md)

## Настройте MSI Afterburner

Если вы используете [MSI Afterburner](https://www.msi.com/Landing/afterburner/graphics-cards), скачайте и установите его.

- Рекомендуется настраивать статическую скорость вентилятора, поскольку использование функции кривой вентилятора требует постоянного запуска программы.

- Чтобы автоматически загрузить профиль (в качестве примера профиль 1) и выйти, введите ``shell:startup`` в ``Win+R``, затем создайте ярлык с целью ``"C:\Program Files (x86)\MSI Afterburner\MSIAfterburner.exe" /Profile1 /Q``.

## Разрешения и режимы масштабирования экрана


- Как правило, у вас есть возможность выполнить масштабирование на GPU или на дисплее. Нативное разрешение не требует масштабирования, поэтому используется режим идентичного масштабирования. Более того, масштабирование в режиме идентичности делает большинство опций масштабирования в панели управления GPU неактуальными. Если вы используете неродное разрешение, есть аргументы в пользу масштабирования на дисплее из-за меньшего объема обработки GPU.

- Стремитесь к ``actual`` целочисленной частоте обновления, например 60,00/240,00, а не 59,94/239,76. Использование exact или exact reduced (exact reduced в приоритете) поможет добиться этого в [Custom Resolution Utility](https://www.monitortests.com/forum/Thread-Custom-Resolution-Utility-CRU).
  
    - Это помогает работе лимитеров фпс и синхронизации кадра.
 
    - Данная настройка затрагивает только вертикальную частоту, итоговая частота монитора не изменится (как и латенси).

- Существует множество способов добиться одинакового результата в отношении масштабирования GPU и дисплея. Примеры сценариев приведены в таблице по ссылке ниже

    - Смотрите [Что такое нативное масштабирование и как его можно использовать?](https://github.com/valleyofdoom/PC-Tuning/blob/main/docs/research.md#8-what-is-identity-scaling-and-how-can-you-use-it)

    - Опционально используйте [QueryDisplayScaling](https://github.com/valleyofdoom/QueryDisplayScaling), чтобы запросить текущий режим масштабирования.

- Попробуйте удалить все разрешения и прочий "мусор" (звуковые блоки), кроме родного разрешения в CRU. Это может быть решением проблемы ~1-секундного черного экрана при переключении альт-таба во время использования ``Hardware: Legacy Flip`` в режиме отображения

    - В системах с графическим процессором NVIDIA убедитесь, что опция ``Display`` для параметра ``Perform scaling on`` по-прежнему доступна. Если нет, то методом проб и ошибок выясните, какое изменение, внесенное вами в CRU, привело к тому, что он стал недоступен. Это можно сделать, запустив ``reset.exe``, чтобы сбросить настройки по умолчанию, а затем заново настроить CRU. После каждого изменения запускайте ``restart64.exe`` и проверяйте, доступна ли еще опция.
     >**⚠**
     > Не советую что-либо трогать в разделе масштабирования панели Nvidia 

- Убедитесь, что разрешение настроено правильно, набрав ``rundll32.exe display.dll,ShowAdapterSettings`` в ``Win+R``.

- Настройте дополнительные дисплеи через настройки Windows ``Win+I`` -> ``Дисплей`` . Уберите галочки в разделе Дополнительные дисплеи ``стереть перемещение курсора между дисплеями `` и ``минимизация отображения при отключении монитора``.

## Установка Open-Shell (Опционально)
>**⚠**
> Этот раздел необходим в случае отключения необходимых служб и компонентов рабочего стола.

- Скачайте и установите [Open-Shell](https://github.com/Open-Shell/Open-Shell-Menu). Установите только ``Меню Open-Shell``.

- Настройки:

    - Общее поведение

        - Проверять наличие обновлений Windows при выключении - отключить

## Установка Explorer Patcher (Опционально)
>**⚠**
> Этот раздел необходим в случае отключения необходимых служб и компонентов рабочего стола. Также позволяет вернуть меню 10 Windows на 11.


- Скачайте и установите [Explorer Patcher](https://github.com/valinet/ExplorerPatcher). Проверьте, что ваш билд подходит под версию программы.

## Spectre, Meltdown и микрокод процессора

> ⛔
> Данный раздел актуален только для Windows 10 и/или процессоров Intel (до 9 поколения включительно)

- Отключите Spectre и Meltdown с помощью [InSpectre](https://www.grc.com/inspectre.htm)

    - AMD не подвержена влиянию Meltdown. В подавляющем большинстве случаев она работает лучше с включенной функцией Spectre ([1](https://www.phoronix.com/review/amd-zen4-spectrev2)).

    - Большинство анти-читов (FACEIT) требуют, чтобы Meltdown был включен

- Перезагрузитесь и используйте функции проверки [InSpectre](https://www.grc.com/inspectre.htm) и [CPU-Z's](https://www.cpuid.com/softwares/cpu-z.html) для проверки состояния после перезагрузки.

    - Смотрите [media/meltdown-spectre-example.png](/docs/meltdown-spectre-example.png)

    - Смотрите [media/cpu-z-vulnerable-microcode.png](/docs/cpu-z-vulnerable-microcode.png)

## Быстрый запуск, переход в режим ожидания и спящий режим

Это зависит от личных предпочтений, восприятия и опыта, однако некоторые люди предпочитают не использовать такие функции, как быстрый запуск, режим ожидания и гибернация, поскольку они могут привести к неожиданным проблемам ([пояснение](https://www.youtube.com/watch?v=OBGxt8zhbRk)), а также предпочитают выполнять чистую загрузку системы вместо сохранения и восстановления состояния ядра и программного обеспечения, ограничивая таким образом состояния питания системы до S0 (рабочее состояние) и S5 (мягкое выключение). О состояниях питания системы и их значении можно узнать [здесь](https://learn.microsoft.com/en-us/windows/win32/power/system-power-states) и [здесь](https://www.sciencedirect.com/topics/computer-science/sleeping-state). Эти опции в BIOS часто называются Fast Startup, Suspend to RAM, S-States (ищите *S1*, *S2*, *S3*, *S4*, *S5*), standby или аналогичные опции. Состояние S-State можно проверить с помощью команды ``powercfg /a`` в CMD.

В Windows также есть переключатель, который отключает быстрый запуск, спящий режим и удаляет ``C:\hiberfil.sys``:

```bat
powercfg /h off
```

## Настройте параметры электропитания
> **⚠**
> Не рекомендуется для ноутбуков.

Откройте CMD и введите приведенные ниже команды.

- Установите ``Высокая производительность`` как активная схема  

    ```bat
    powercfg /setactive 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c
    ```

- Удалите схему сбалансированного питания
  

    ```bat
    powercfg /delete 381b4222-f694-41f0-9685-ff5bb260df2e
    ```

- Удалите схему энергосбережения
    ```bat
    powercfg /delete a1841308-3541-4fab-bc81-f71556f20b4a
    ```

- USB 3 Link Power Management - Выкл (Энергосбережение)

    ```bat
    powercfg /setacvalueindex scheme_current 2a737441-1930-4402-8d77-b2bebba308a3 d4e98f31-5ffe-4ce1-be31-1b38b384c009 0
    ```

- USB Selective Suspend - Выкл (Энергосбережение)

    ```bat
    powercfg /setacvalueindex scheme_current 2a737441-1930-4402-8d77-b2bebba308a3 48e6b7a6-50f5-4782-a5d4-53bb8f07e226 0
    ```

- Processor performance core parking min cores - 100 (Парковка ядер)

    - По умолчанию парковка процессора отключена в схеме питания High Performance ([1](https://learn.microsoft.com/en-us/windows-server/administration/performance-tuning/hardware/power/power-performance-tuning#using-power-plans-in-windows-server)). Однако в Windows 11+ с современными процессорами парковка отменяется и включается. Пользователи могут определить, припаркован ли процессор, набрав ``resmon`` в ``Win+R``. Помимо того, что парковка задумывалась как функция энергосбережения, в таких видео, как [это](https://www.youtube.com/watch?v=2yOYfT_r0xI) и [это](https://www.youtube.com/watch?v=gyg7Gm7aN2A), объясняется, что это желаемое поведение для правильного планирования потоков, что, вероятно, хорошо для обычного пользователя, но они не учитывают штраф за задержку при распарковке ядер (как при переходе в C-State) вместе с активностью в режиме ядра (прерывания, DPC). Что касается планирования для каждого процессора, вы можете легко достичь того же результата, управляя нагрузкой на каждый процессор вручную (например, прикрепить приложение реального времени к [одному CCX/CCD](https://hwbusters.com/cpu/amd-ryzen-9-7950x3d-cpu-review-performance-thermals-power-analysis/2) или P-Core), настроив сродство, при этом преимуществом является отсутствие накладных расходов от драйверов чипсета и процессов Xbox, постоянно работающих в фоновом режиме и заставляющих выполнять ненужные переключения контекста. Дополнительную информацию см. в разделе [Планирование в режиме ядра (прерывания, DPC и многое другое)](#планирование-в-пользовательском-режиме-процессы-потоки)

        ```bat
        powercfg /setacvalueindex scheme_current 54533251-82be-4824-96c1-47b60b740d00 0cc5b647-c1df-4637-891a-dec35c318583 100
        ```

        ```bat
        powercfg /setacvalueindex scheme_current 54533251-82be-4824-96c1-47b60b740d00 0cc5b647-c1df-4637-891a-dec35c318584 100
        ```

- Processor performance time check interval - 5000 (Частота обновления ххх)

    - Существует несколько DPC управления питанием ntoskrnl, которые запланированы на периодический интервал для переоценки P-States и припаркованных ядер. При статической частоте процессора и отключенной парковке ядер эти проверки становятся неактуальными, поэтому ненужные DPC становятся запланированными. Параметр ``Интервал проверки времени производительности процессора`` контролирует частоту этих проверок, поэтому увеличение значения параметра может снизить нагрузку на процессор, так как будет запланировано значительно меньше DPC. Для справки и на момент проверки схемы энергосбережения, сбалансированного и высокопроизводительного питания имеют значения по умолчанию 200, 15 и 15 соответственно. 5000 - это максимально допустимое значение. Конечно, если используется динамическая частота процессора (например, Precision Boost Overdrive, Turbo Boost) и включена парковка, следует оценить эффект от увеличения этого значения, поскольку ядра могут не успеть поднять свою частоту в ответ на рабочую нагрузку, так как ОС будет реже оценивать текущий сценарий.

        <table style="text-align: center;">
            <tr>
                <td rowspan="2">Функция DPC</td>
                <td colspan="3">Средние DPC Rate</td>
                <td colspan="3">Всего DPCs</td>
            </tr>
            <tr>
                <td>15</td>
                <td>200</td>
                <td>5000</td>
                <td>15</td>
                <td>200</td>
                <td>5000</td>
            </tr>
            <tr>
                <td>ntoskrnl!PpmPerfAction</td>
                <td>15.45Hz</td>
                <td>3.07Hz</td>
                <td>N/A</td>
                <td>311</td>
                <td>60</td>
                <td>1</td>
            </tr>
            <tr>
                <td>ntoskrnl!PpmCheckRun</td>
                <td>12.99Hz</td>
                <td>2.29Hz</td>
                <td>N/A</td>
                <td>262</td>
                <td>46</td>
                <td>1</td>
            </tr>
            <tr>
                <td>ntoskrnl!PpmCheckPeriodicStart</td>
                <td>60.39Hz</td>
                <td>4.99Hz</td>
                <td>0.2Hz</td>
                <td>1213</td>
                <td>100</td>
                <td>4</td>
            </tr>
        </table>

        ```bat
        powercfg /setacvalueindex scheme_current 54533251-82be-4824-96c1-47b60b740d00 4d2b0152-7d5c-498b-88e2-34345392a2c5 5000
        ```

- Установите активную схему в качестве текущей

    ```bat
    powercfg /setactive scheme_current
    ```

## Замените диспетчер задач на Process Explorer

Диспетчеру задач не хватает полезных показателей по сравнению с таким инструментом, как Process Explorer. В Windows 8+ диспетчер задач сообщает об использовании процессора в %, что вводит в заблуждение ([1](https://aaron-margosis.medium.com/task-managers-cpu-numbers-are-all-but-meaningless-2d165b421e43)). С другой стороны, в Windows 7 диспетчер задач и Process Explorer сообщают о загруженности по времени. Это также объясняет, почему отключение состояний простоя в ОС приводит к 100 %-ной загрузке процессора в диспетчере задач.

- Загрузите и извлеките [Process Explorer](https://learn.microsoft.com/en-us/sysinternals/downloads/process-explorer)

- Скопируйте файл ``procexp64.exe`` в безопасную директорию, например ``C:\Windows``, и откройте его

- Перейдите в раздел ``Options`` и выберите ``Replace Task Manager``. По желанию настройте следующие параметры:

    - Confirm Kill

    - Allow Only One Instance

    - Always On Top (Полезно для случаев, когда приложения падают и пользовательский интерфейс не реагирует на запросы)

    - Включите следующие столбцы для получения подробных показателей измерения ресурсов

        - Context Switch Delta (Process Performance)

        - CPU Cycles Delta (Process Performance)

        - Delta Reads (Process I/O)

        - Delta Writes (Process I/O)

        - Delta Other (Process I/O)

    - Включите колонку ``VirusTotal``.

## Отключение защиты процессов


Откройте CMD и введите приведенную ниже команду, чтобы отключить [process mitigations](https://docs.microsoft.com/en-us/powershell/module/processmitigations/set-processmitigation?view=windowsserver2019-ps). Эффекты можно посмотреть с помощью ``Get-ProcessMitigation -System`` в PowerShell.

```bat
C:\bin\disable-process-mitigations.bat
```

## Настройка параметров управления памятью

- Откройте PowerShell и введите следующую команду

    ```powershell
    Get-MMAgent
    ```

- Используйте приведенную ниже команду в качестве примера, чтобы отключить определенную настройку. Если в разделе [рекомендации](#рекомендации) вы оставили включенными Superfetch/Prefetch, то, скорее всего, вам нужны включенные функции, связанные с префетчингом

    ```powershell
    Disable-MMAgent -MemoryCompression
    ```

## Настройка сетевого адаптера

- Откройте ``Сетевые подключения``, набрав ``ncpa.cpl`` в ``Win+R``.

- Отключите все неиспользуемые сетевые адаптеры, затем щелкните правой кнопкой мыши на основном адаптере и выберите ``Свойства``.

- Отключите все элементы, которые вам не нужны, а это, как правило, все, кроме ``QoS Packet Scheduler`` и ``Internet Protocol Version 4 (TCP/IPv4)`` для большинства потребителей.

- Отключите ``NetBIOS по TCP/IP`` для всех сетевых адаптеров в ``Internet Protocol Version 4 (TCP/IPv4) -> Properties -> General -> Advanced -> WINS`` для предотвращения ненужного прослушивания системы ([1](https://github.com/djdallmann/GamingPCSetup/blob/master/CONTENT/DOCS/NETWORK/README.md))

## Настройка звуковых устройств

- Панель управления звуком можно открыть, набрав ``mmsys.cpl`` в ``Win+R``.

- Отключение неиспользуемых устройств воспроизведения и записи

- Отключите улучшение звука, так как оно расходует ресурсы ([1](/docs/audio%20enhancements-benchmark.png))

- По желанию установите на вкладке коммуникаций опцию ``Не делать ничего``, чтобы предотвратить автоматическую настройку уровней звука между источниками звука, поскольку это раздражает большинство пользователей ([1](https://multimedia.easeus.com/ai-article/windows-audio-ducking.html), [2](https://superuser.com/questions/1147371/how-can-i-disable-automatic-windows-7-8-10-audio-ducking)).

## Настройте Диспетчер устройств

- Откройте Диспетчер устройств, набрав ``devmgmt.msc`` в ``Win+R``.

- Перейдите в раздел ``Вид -> Устройства по типу``.

  - В категории ``Дисковые накопители`` в разделе ``Свойства -> Политики`` отключите очистку буфера кэша при записи на всех дисках.

  - В категории ``Сетевые адаптеры`` перейдите в раздел ``Свойства -> Дополнительно`` и отключите все функции энергосбережения

- Перейдите в раздел ``Вид -> Устройства по подключению``.

  - Отключите все контроллеры PCIe, SATA, NVMe и XHCI, а также USB-концентраторы, к которым ничего не подключено.

  - Отключите все устройства, не являющиеся GPU, на том же порту PCIe, что и GPU, если они вам не нужны.

- Перейдите в раздел ``Вид -> Ресурсы по подключению``.

  - Отключите все ненужные устройства, использующие IRQ или ресурсы ввода-вывода, всегда спрашивайте, если не уверены, и не торопитесь с этим шагом.

  - Если имеется несколько записей об одних и тех же устройствах, и вы не уверены, какое из них используется, обратитесь к древовидной структуре в ``Вид -> Устройства по подключению``. Это связано с тем, что одно устройство может использовать множество ресурсов (например, IRQ). Вы также можете использовать [MSI Utility](https://forums.guru3d.com/threads/windows-line-based-vs-message-signaled-based-interrupts-msi-tool.378044) для проверки дубликатов и ненужных устройств, если вы случайно пропустили их в загроможденной древовидной структуре диспетчера устройств.

- По желанию используйте [DeviceCleanup](https://www.uwe-sieber.de/files/DeviceCleanup.zip) для удаления скрытых устройств.

## Отключить энергосбережение устройства

Откройте PowerShell и введите приведенную ниже команду, чтобы отключить опцию ``Разрешить компьютеру выключить это устройство для экономии энергии`` для всех соответствующих устройств в диспетчере устройств.

Переподключение устройств может привести к повторному включению этой опции, поэтому либо избегайте этого, выполняя эту команду каждый раз заново, либо поместите ее в сценарий и запускайте при запуске системы в качестве меры предосторожности с помощью планировщика задач ([инструкции](https://www.windowscentral.com/how-create-automated-task-using-task-scheduler-windows-10)). Убедитесь, что все пути заключены в кавычки, если в них есть пробелы. Убедитесь, что все работает правильно после перезагрузки системы. Если требуются привилегии администратора, необходимо включить опцию ``Запуск с наивысшими привилегиями``. Для сценариев PowerShell задайте в качестве запуска программы ``PowerShell``, а в качестве аргументов - путь к сценарию (например, ``C:\device-power-saving.ps1``).

```powershell
Get-WmiObject MSPower_DeviceEnable -Namespace root\wmi | ForEach-Object { $_.enable = $false; $_.psbase.put(); }
```

## Сеансы трассировки событий (ETS)

В этом разделе описаны инструкции по массовому отключению сеансов трассировки событий, которые можно просмотреть, набрав ``perfmon`` в ``Win+R`` и перейдя в ``Data Collector Sets -> Event Trace Sessions``. Программы, которые полагаются на трассировщики событий, не смогут регистрировать данные до тех пор, пока не будут восстановлены необходимые сессии, для чего и создаются два файла реестра, чтобы переключаться между ними. Откройте CMD от имени администратора и введите приведенные ниже команды, чтобы создать файлы реестра в каталоге ``C:\``. Эти файлы реестра должны быть запущены с помощью Trusted Installer (используйте [NSudo](https://github.com/M2TeamArchived/NSudo/releases/latest)), чтобы избежать ошибок с правами доступа.

- ``ets-enable.reg``

    ```bat
    reg export "HKLM\SYSTEM\CurrentControlSet\Control\WMI\Autologger" "C:\ets-enable.reg"
    ```

- ``ets-disable.reg``

    ```bat
    >> "C:\ets-disable.reg" echo Windows Registry Editor Version 5.00 && >> "C:\ets-disable.reg" echo. && >> "C:\ets-disable.reg" echo [-HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\WMI\Autologger]
    ```

- Дополнительно отключите SleepStudy (UserNotPresentSession)

    ```bat
    for %a in ("SleepStudy" "Kernel-Processor-Power" "UserModePowerService") do (wevtutil sl Microsoft-Windows-%~a/Diagnostic /e:false)
    ```

## Настройка Файловой системы

Откройте CMD от имени администратора и введите приведенные ниже команды.

- Отключите создание имен файлов длиной 8,3 символа на томах, отформатированных в FAT и NTFS

  - См. раздел [Следует ли отключить 8dot3 для повышения производительности и безопасности?| TCAT Shelbyville](https://web.archive.org/web/20200217151754/https://ttcshelbyville.wordpress.com/2018/12/02/should-you-disable-8dot3-for-performance-and-security)

  - См. статью [Windows Short (8.3) Filenames - A Security Nightmare? | Bogdan Calin](https://www.acunetix.com/blog/articles/windows-short-8-3-filenames-web-security-problem)

      ```bat
      fsutil behavior set disable8dot3 1
      ```

- Отключите обновление метки времени последнего доступа для каждого каталога, когда каталоги перечислены на томе NTFS. Отключение функции Last Access Time повышает скорость доступа к файлам и каталогам ([1](https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/fsutil-behavior#remarks)). Обратите внимание, что это может повлиять на программы резервного копирования и удаленного хранения данных, согласно официальным замечаниям ([1](https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/fsutil-behavior#remarks)).

    ```bat
    fsutil behavior set disablelastaccess 1
    ```

## Прерывания с сигналом сообщения (Message signaled interrupts (MSI))

Прерывания с сигналом сообщения (MSI) быстрее, чем традиционные прерывания на основе линий, и могут также решить проблему общих прерываний, которые часто являются причиной высокой задержки и стабильности прерываний ([1](https://repo.zenk-security.com/Linux%20et%20systemes%20d.exploitations/Windows%20Internals%20Part%201_6th%20Edition.pdf)).

- Загрузите и откройте [MSI Utility](https://forums.guru3d.com/threads/windows-line-based-vs-message-signaled-based-interrupts-msi-tool.378044) или [GoInterruptPolicy](https://github.com/spddl/GoInterruptPolicy).

- MSI можно включить на устройствах, которые его поддерживают. Стоит отметить, что в намерения разработчика может входить не включать MSI в INF-файле драйвера, поэтому MSI будет отключен по умолчанию после установки драйвера. А именно, NVIDIA, похоже, выборочно включает MSI в зависимости от архитектуры GPU ([1](https://www.nvidia.com/en-us/geforce/forums/game-ready-drivers/13/528356)). Проявите осторожность и проведите тесты, чтобы определить, приведут ли изменения к положительному росту производительности.


- Чтобы проверить, использует ли устройство MSI, перезагрузите компьютер и проверьте, имеет ли данное устройство отрицательный IRQ в MSI Utility.

- Хотя этот шаг можно было пропустить в предыдущем разделе, чтобы исключить аппаратные причины разделения IRQ, программные причины потенциального разделения IRQ можно оценить сейчас, убедившись, что в вашей системе нет разделения IRQ, набрав ``msinfo32`` в ``Win+R`` и перейдя в раздел ``Conflicts/Sharing``.

  - Если устройство ``Системный таймер`` и ``Высокоточный таймер событий`` совместно используют IRQ 0, решением проблемы является отключение драйвера родительского устройства ``Системный таймер``, который является ``Мостом ISA стандартаPCI``. Это можно сделать с помощью следующей команды. Важно отметить, что отключение ``msisadrv`` приводит к поломке клавиатуры на мобильных устройствах

    ```bat
    reg add "HKLM\SYSTEM\CurrentControlSet\Services\msisadrv" /v "Start" /t REG_DWORD /d "4" /f
    ```

## XHCI Модерация прерываний (IMOD)

В большинстве систем Windows 7 используется интервал IMOD в 1 мс, в то время как в последних версиях Windows используется 0,05 мс (50us), если это не указано в установленном драйвере USB. Это означает, что после генерирования прерывания контроллер XHCI ждет (буферный период) в течение указанного интервала времени, чтобы получить больше данных, прежде чем генерировать новое прерывание, что снижает загрузку процессора, но потенциально приводит к тому, что данные с данного устройства поступают с непостоянной скоростью в случае ожидания данных от других устройств в пределах буферного периода, подключенных к тому же контроллеру XHCI.

Например, мышь с частотой опроса 1 кГц будет сообщать данные каждые 1 мс. При перемещении мыши с интервалом IMOD в 1 мс модерация прерываний не будет происходить, поскольку прерывания генерируются со скоростью, меньшей или равной указанному интервалу. В реальности при игре в быстром темпе скорость прерываний при взаимодействии с клавиатурой и звуком легко превысит 1000 прерываний/с, а при перемещении мыши произойдет потеря информации, поскольку вы будете ожидать данных в течение периода ожидания от любого из устройств. Хотя это маловероятно при интервале IMOD в 0,05 мс (50us), это все же может произойти.

Например, интервал IMOD в 1 мс с мышью 8 кГц уже проблематичен, поскольку вы ожидаете данные каждые 0,125 мс, что значительно превышает заданный интервал, что приводит к серьезному узкому месту ([1](https://www.overclock.net/threads/usb-polling-precision.1550666/page-61#post-28576466)).

- Смотрите [How to persistently disable XHCI Interrupt Moderation | BoringBoredom](https://github.com/BoringBoredom/PC-Optimization-Hub/blob/main/content/xhci%20imod/xhci%20imod.md)

- Для загрузки драйвера [RWEverything](http://rweverything.com) может потребоваться отключение блок-листа уязвимых драйверов Microsoft с помощью приведенной ниже команды, однако в некоторых игровых античит-играх отключение блок-листа не предусмотрено (например, CS2, THE FINALS).

    ```bat
    reg add "HKLM\SYSTEM\CurrentControlSet\Control\CI\Config" /v "VulnerableDriverBlocklistEnable" /t REG_DWORD /d "0" /f
    ```

- В некоторых случаях индекс прерывателя может измениться после перезагрузки, что означает, что адрес станет недействительным, если он жестко закодирован. Чтобы обойти эту проблему, можно просто отключить IMOD для всех прерывателей, поместив скрипт [XHCI-IMOD-Interval.ps1](/files/XHCI-IMOD-Interval.ps1) в безопасное место и запустив его при запуске с помощью планировщика задач ([инструкции](https://www.windowscentral.com/how-create-automated-task-using-task-scheduler-windows-10)) или используя пользовательский автозапуск ``Shell:startup``. Убедитесь, что все пути заключены в кавычки, если в них есть пробелы. Убедитесь, что все работает правильно после перезагрузки системы. Если требуются привилегии администратора, необходимо включить опцию ``Запуск с наивысшими привилегиями``. Для сценариев PowerShell задайте в качестве запуска программы ``PowerShell``, а в качестве аргументов - путь к сценарию (например, ``C:\XHCI-IMOD-Interval.ps1``)

  ```bat
  PowerShell C:\XHCI-IMOD-Interval.ps1
  ```

- Чтобы определить, действует ли изменение интервала IMOD, можно временно установить интервал на ``0xFA00`` (62,5 Гц). Если при движении курсор мыши заметно замирает, значит, изменения успешно вступили в силу

## Ограничение частоты кадров


- Установите частоту кадров кратной частоте обновления монитора ([калькулятор](https://boringboredom.github.io/tools/fpscapcalculator)), чтобы предотвратить несовпадение кадров и разрывов ([1](https://www.youtube.com/watch?v=_73gFgNrYVQ), [2](https://github.com/BoringBoredom/PC-Optimization-Hub/blob/main/content/peripherals/mistiming/mistiming.md)). Уменьшение частоты обновления во избежание несовпадения кадров также применимо ([инструкции](https://forums.blurbusters.com/viewtopic.php?t=8946)).

- Убедитесь, что GPU используется не полностью, так как снижение загрузки GPU уменьшает системную задержку ([1](https://www.youtube.com/watch?v=8ZRuFaFZh5M&t=859s), [2](https://www.youtube.com/watch?v=7CKnJ5ujL_Q)).

- Ограничение частоты кадров с помощью [RTSS](https://www.guru3d.com/files-details/rtss-rivatuner-statistics-server-download.html) вместо внутриигрового ограничителя обеспечит стабильную частоту кадров и более плавное воспроизведение, поскольку в этом случае используется функция busy-wait, которая обеспечивает более высокую точность, чем 100% пассивное ожидание, но ценой заметно более высокой задержки и потенциально большей нагрузки на процессор ([1](https://www.youtube.com/watch?t=377&v=T2ENf9cigSk), [2](https://en.wikipedia.org/wiki/Busy_waiting)). Отключение параметра ``Включить службу выделенного сервера кодирования`` предотвращает запуск ``EncoderServer.exe``.

### Режим презентации

Это не рекомендация по выбору режима презентации, а информационный материал.

- Всегда проверяйте, использует ли ваша игра нужный режим презентации с помощью PresentMon ([инструкции](https://boringboredom.github.io/Frame-Time-Analysis)).

- You can experiment and benchmark different presentation modes to assess which you prefer

  - See [Presentation Model | Special K Wiki](https://wiki.special-k.info/en/Presentation_Model)

- Если поиск двоичного имени приложения в ``HKCU\SYSTEM\GameConfigStore`` в реестре не дал результатов, возможно, вам нужно зарегистрировать игру, нажав ``Win+G`` и включив ``Remember this is a game``, пока она открыта. Проверьте, была ли создана запись под вышеупомянутым ключом реестра после завершения регистрации.

- Если вы хотите использовать режим презентации ``Hardware: Legacy Flip``, установите флажок ``Отключить полноэкранную оптимизацию``. Если это не помогло, попробуйте выполнить приведенные ниже команды в CMD и перезагрузиться. К этим ключам реестра обычно обращаются игра и Windows при запуске

    ```bat
    reg add "HKCU\SYSTEM\GameConfigStore" /v "GameDVR_DXGIHonorFSEWindowsCompatible" /t REG_DWORD /d "1" /f
    ```

    ```bat
    reg add "HKCU\SYSTEM\GameConfigStore" /v "GameDVR_FSEBehavior" /t REG_DWORD /d "2" /f
    ```

- Если вы застряли в режиме ``Hardware Composed: Independent Flip`` и хотите использовать другой режим презентации, попробуйте выполнить приведенную ниже команду, чтобы отключить MPO в CMD и перезагрузиться

    ```bat
    reg add "HKLM\SOFTWARE\Microsoft\Windows\Dwm" /v "OverlayTestMode" /t REG_DWORD /d "5" /f
    ```


## Планирование в режиме ядра (прерывания, DPC и многое другое)


Windows по умолчанию планирует прерывания и DPC на CPU 0 для нескольких модулей режима ядра. В любом случае, планирование множества задач на одном ядре может привести к дополнительным накладным расходам и увеличению джиттера из-за их конкуренции за процессорное время. Чтобы смягчить эту проблему, можно настроить аффинити для изоляции определенных модулей от помех, включая обслуживание чувствительных ко времени модулей на недоиспользуемых ядрах, вместо того чтобы сваливать все на один процессор.

- Используйте отчет xperf DPC/ISR, создаваемый скриптом [xperf-dpcisr.bat](/files/xperf-dpcisr.bat), чтобы проанализировать, на каких ядрах обслуживаются модули режима ядра. Вы не сможете управлять сродствами, если не знаете, что и на каком ядре выполняется. Та же концепция применима к потокам пользовательского режима. Кроме того, проверьте, работают ли политики аффинити прерываний так, как ожидается, проанализировав использование каждого процессора для соответствующего модуля, когда устройство занято


- Кроме того, контрольные показатели задержки между ядрами могут помочь в принятии решений по управлению сродством.

  - Смотрите [CXWorld/MicroBenchX](https://github.com/CXWorld/MicroBenchX)

- Убедитесь, что соответствующий DPC для ISR обрабатывается на одном и том же ядре ([пример](/docs/isr-dpc-same-core.png)). Если они обрабатываются на разных ядрах, то могут возникнуть дополнительные накладные расходы, связанные с увеличением межпроцессорного взаимодействия и нарушением согласованности кэша.

- Используйте [Microsoft Interrupt Affinity Tool](https://www.techpowerup.com/download/microsoft-interrupt-affinity-tool) или [GoInterruptPolicy](https://github.com/spddl/GoInterruptPolicy) для настройки аффинити драйверов. Устройство можно определить, проверив ``Расположение`` в разделе ``Свойства -> Общие`` устройства в диспетчере устройств

### XHCI(USB контроллер) и аудиоконтроллер
Модули, связанные с XHCI и аудиоконтроллером, генерируют значительное количество прерываний при взаимодействии с соответствующим устройством. Изолирование соответствующих модулей в малоиспользуемом ядре позволяет уменьшить количество прерываний.

### Сетевая карта

Для правильной работы сетевой карты необходимо, чтобы она поддерживала MSI-X для масштабирования стороны приема ([1](https://old.reddit.com/r/intel/comments/9uc03d/the_i219v_nic_on_your_new_z390_motherboard_and)). В большинстве случаев базового процессора RSS достаточно для переноса DPC и ISR для драйвера сетевой карты, что устраняет необходимость в политике аффинити прерываний. Однако если у вас возникли проблемы с переносом на другие ядра, попробуйте настроить оба.

Приведенная ниже команда может быть использована для настройки базового процессора RSS. Убедитесь, что ключ драйвера соответствует нужной сетевой карте. Помните, что количество очередей RSS определяет количество последовательных CPU, на которых планируется работа сетевого драйвера. Например, драйвер будет запланирован на CPU 2/3/4/5 (2/4/6/8 с включенным HT/SMT), если для базового CPU RSS установлено значение 2, а также настроено 4 очереди RSS.

- Смотрите [Сколько очередей RSS вам нужно?](https://github.com/valleyofdoom/PC-Tuning/blob/main/docs/research.md#4-how-many-rss-queues-do-you-need)

- Смотрите [assets/images/find-driver-key-example.png](/docs/find-driver-key-example.png), чтобы получить правильный ключ драйвера в диспетчере устройств.

    ```bat
    reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e972-e325-11ce-bfc1-08002be10318}\0000" /v "*RssBaseProcNumber" /t REG_SZ /d "6" /f
    ```

- Если RSS работает не так, как ожидалось, смотрите [это](https://github.com/djdallmann/GamingPCSetup/blob/master/CONTENT/RESEARCH/NETWORK/README.md#q-my-onboard-network-adapter-i225-v-supports-rss-msi-and-msi-x-but-why-is-my-indirection-table-missing-that-gives-proper-support-for-rss-in-microsoft-windows) для возможного обходного пути.

## Планирование в пользовательском режиме (процессы, потоки)

Существует несколько методов установки аффинити для процессов. Один из них - диспетчер задач, но он сохраняется только до тех пор, пока процесс не будет закрыт. Более популярным и постоянным решением является [Process Lasso](https://bitsum.com), который позволяет сохранить конфигурацию, однако при этом процесс должен постоянно работать в фоновом режиме, что создает небольшие накладные расходы. Чтобы обойти эту проблему, вы можете просто запускать приложение с заданным сродством процессора, что избавит вас от необходимости использовать такие программы, как Process Lasso, для управления сродством в ущерб удобству использования.

- Используйте [CPU Affinity Mask Calculator](https://bitsum.com/tools/cpu-affinity-calculator), чтобы определить желаемую битовую маску аффинити.

- В некоторых случаях процесс может быть защищен, поэтому указание аффинити может не сработать. Чтобы обойти эту проблему, можно попробовать указать аффинити для родительских процессов, что приведет к тому, что дочерний процесс при порождении унаследует это сродство. Например, программа запуска игр обычно является родительским процессом игры. Для определения родительских и дочерних процессов можно использовать дерево процессов [Process Explorer's](https://learn.microsoft.com/en-us/sysinternals/downloads/process-explorer)

  - [Process Hacker](https://processhacker.sourceforge.io) и [WindowsD](https://github.com/katlogic/WindowsD) могут обойти несколько защит на уровне процессов с помощью эксплойтов, но их не рекомендуется использовать, так как они мешают работе античитов.

- Возможно, стоит проверить эффективность масштабирования производительности вашего приложения в зависимости от количества ядер, поскольку оно может вести себя по-разному из-за плохой реализации планирования в приложении и/или ОС. В некоторых случаях приложение может работать лучше при меньшем количестве ядер, назначенных ему с помощью маски сродства ([1](https://developer.nvidia.com/blog/limiting-cpu-threads-for-better-game-performance)). Это также даст вам примерное представление о том, сколько ядер вы можете зарезервировать. В других случаях это может сильно навредить производительности, поскольку существует вероятность того, что игра создаст больше рабочих потоков, чем процессоров, поскольку игра учитывает только количество доступных физических ядер, поэтому очень важно измерять масштабирование производительности

Приведенная ниже команда запускает ``notepad.exe`` с аффинити CPU 1 и CPU 2, что будет отражено в диспетчере задач. Эту команду можно поместить в bat скрипт для легкого доступа и использовать каждый раз для запуска нужного приложения с указанным сродством.

```bat
start /affinity 0x6 notepad.exe
```

- Иногда процессы, которым вы хотите задать маску аффинити, уже запущены, поэтому предыдущая команда здесь неприменима. В качестве примера ниже приведена команда, устанавливающая маску аффинити для процессов ``svchost.exe`` и ``audiodg.exe`` на CPU 3. Используйте этот пример для создания сценария PowerShell, а затем запустите его при запуске с помощью Task Scheduler ([инструкции](https://www.windowscentral.com/how-create-automated-task-using-task-scheduler-windows-10)) или используя пользовательский автозапуск ``Shell:startup``. Убедитесь, что все пути заключены в кавычки, если в них есть пробелы. Убедитесь, что все работает правильно после перезагрузки системы. Если требуются привилегии администратора, необходимо включить опцию ``Запуск с наивысшими привилегиями``. Для сценариев PowerShell установите для запуска программы значение ``PowerShell``, а в качестве аргументов - путь к сценарию (например, ``C:\process-affinities.ps1``).

    ```powershell
    Get-Process @("svchost", "audiodg") -ErrorAction SilentlyContinue | ForEach-Object { $_.ProcessorAffinity=0x8 }
    ```

## Зарезервированные наборы процессоров



[ReservedCpuSets](https://github.com/valleyofdoom/ReservedCpuSets) можно использовать для предотвращения маршрутизации Windows ISR, DPC и планирования других потоков на определенных ядрах. Изоляция модулей от помех на уровне пользователя и ядра помогает снизить количество конфликтов, джиттера и позволяет чувствительным ко времени модулям получать необходимое им процессорное время.

- Как упоминалось в разделе [Планирование в пользовательском режиме (процессы, потоки)](#планирование-в-пользовательском-режиме-процессы-потоки), вы должны определить, насколько хорошо или плохо производительность вашего приложения зависит от количества ядер, чтобы получить приблизительное представление о том, сколько ядер вы можете позволить себе зарезервировать.

- Поскольку политики аффинити прерываний, аффинити процессов и потоков имеют более высокий приоритет, вы можете использовать их вместе с пользовательскими аффинити, чтобы сделать еще один шаг вперед и гарантировать, что ничего, кроме того, что вы назначили определенным процессорам, не будет запланировано на этих процессорах.

- Убедитесь, что у вас достаточно ядер для работы приложения в реальном времени, и не резервируйте слишком много процессоров, чтобы изолированные модули не обеспечивали производительность в реальном времени.

- Поскольку наборы процессоров считаются мягкими политиками, конфигурация не гарантируется. Процесс с интенсивным использованием процессора, например стресс-тест, будет использовать зарезервированные ядра, если потребуется

### Примеры использования резервации ядер

- Подсказка ОС для планирования задач на группе ядер. Примером такого подхода на современных платформах может быть резервирование E-Core (эффективных ядер) или CCX/CCD, чтобы задачи по умолчанию планировались на P-Core (производительных ядрах) или других CCX/CCD. При таком подходе вы можете явно заставить фоновые и неважные задачи планироваться на зарезервированных процессорах. Обратите внимание, что это всего лишь пример, и логику можно изменить, но некоторые процессы и модули, чувствительные к задержкам, защищены, поэтому политики сродства могут не сработать, что является серьезным ограничением. Существует несколько возможностей и компромиссов, которые необходимо учитывать. Обратите внимание, что производительность может снижаться при резервировании E-Core или других CCX/CCD, поскольку приложения могут их использовать. Поэтому очень важно измерять масштабирование производительности при резервировании ядер, будь то одно, несколько или целый набор процессоров. Другой способ серьезного снижения производительности при резервировании E-Core или CCX/CCD заключается в том, что планировщик или приложения могут специально нацеливаться на зарезервированные ядра для планирования работы на них, поскольку поле ``RealTime`` установлено в 1 в структуре [SYSTEM_CPU_SET_INFORMATION](https://learn.microsoft.com/en-us/windows/win32/api/winnt/ns-winnt-system_cpu_set_information).

- Резервирование процессоров, для которых назначены определенные модули.

## Анализ средства просмотра событий

Этот шаг не является обязательным, но может помочь обосновать необъяснимые проблемы с производительностью или проблемы в целом. Убедитесь в отсутствии ошибок в Event Viewer, набрав ``eventvwr.msc`` в ``Win+R``, поскольку любые изменения в операционной системе могут привести к периодическому возникновению внутренних ошибок или исключений.

- Объедините файл ``ets-enable.reg``, созданный в разделе [Сеансы трассировки событий (ETS)](#сеансы-трассировки-событий-ets), если это необходимо, так как он требуется для регистрации событий

## Безопасность на базе виртуализации (VBS)

Virtualization Based Security негативно влияет на производительность ([1](https://www.tomshardware.com/news/windows-11-gaming-benchmarks-performance-vbs-hvci-security)), и в некоторых случаях она включена по умолчанию. Его статус можно определить, набрав ``msinfo32`` в ``Win+R``, и при необходимости отключить ([1](https://www.tomshardware.com/how-to/disable-vbs-windows-11), [2](https://support.microsoft.com/en-us/windows/options-to-optimize-gaming-performance-in-windows-11-a255f612-2949-4373-a566-ff6f3f474613)). С другой стороны, [privacyguides.org](https://www.privacyguides.org/en/os/windows/group-policies/) рекомендует держать его включенным. 

## Состояния простоя процессора

Отключение состояний простоя приводит к переходу в состояние C-State 0, что можно увидеть в [HWiNFO](https://www.hwinfo.com), а также в рекомендациях Microsoft по настройке устройств для работы в реальном времени ([1](https://learn.microsoft.com/en-us/windows/iot/iot-enterprise/soft-real-time/soft-real-time-device)). Принудительное включение C-State 0 уменьшает нежелательную задержку выполнения новых инструкций на процессоре, который перешел в более глубокое энергосберегающее состояние, за счет повышения температуры и энергопотребления. Поэтому я бы рекомендовал большинству читателей оставить состояние простоя включенным, так как из-за этих побочных эффектов могут возникнуть другие проблемы (например, дросселирование, проблемы с питанием). Температура процессора не должна повышаться до уровня теплового дросселирования.

Если статическая частота процессора не задана, эффект от принудительного отключения состояния C-State 0 следует оценивать с точки зрения поведения при повышении частоты. Например, не стоит отключать состояния простоя, если вы полагаетесь на Precision Boost Overdrive (PBO), Turbo Boost или аналогичные функции. Избегайте отключения состояний простоя при включенной Hyper-Threading/Simultaneous Multithreading, так как производительность однопоточной системы обычно негативно сказывается.

### Включить состояния простоя (по умолчанию)

```bat
powercfg /setacvalueindex scheme_current sub_processor 5d76a2ca-e8c0-402f-a133-2158492d58ad 0 && powercfg /setactive scheme_current
```

### Отключение состояния простоя

```bat
powercfg /setacvalueindex scheme_current sub_processor 5d76a2ca-e8c0-402f-a133-2158492d58ad 1 && powercfg /setactive scheme_current
```

## Квантование и планирование потоков

Квант - это время, в течение которого поток может выполняться до того, как планировщик оценит, не запланирован ли на выполнение другой поток с тем же приоритетом. Если поток завершает свой квант, а другие потоки с его приоритетом не готовы к выполнению, планировщик позволяет потоку продолжить работу еще на один квант. Квант можно контролировать с помощью приведенного ниже ключа реестра, а также определять, сколько времени из кванта отводится фоновым и фоновым потокам. Значение представлено в виде 6-битной битовой маски, каждая из трех пар битов определяет характеристики кванта и распределение времени между фоновыми и фоновыми потоками. По умолчанию установлено значение ``0x2``, что соответствует ``0b000010`` и имеет разные значения в клиентской и серверной версиях, о чем будет рассказано ниже.

```
[HKEY_LOCAL_MACHINE\SYSTEM\ControlSet001\Control\PriorityControl]
"Win32PrioritySeparation"=dword:00000002
```

### Объяснение битовой маски

- Самая левая пара битов (**XX**YYZZ) определяет длину кванта. Она представлена ``PspForegroundQuantum``.

  |Значение|Описание|
  |---|---|
  |00/11|Короткие интервалы (клиент Windows), длинные интервалы (сервер Windows)|
  |01|Длинные интервалы|
  |10|Короткие интервалы|

- Средняя пара битов (XX**YY**ZZ) определяет, является ли длина кванта переменной или фиксированной. Если используется квант фиксированной длины, то крайняя правая битовая пара игнорируется, так как соотношение, определяющее время, выделяемое фоновым и передним потокам в пределах кванта, фиксировано. Это представлено ``PspForegroundQuantum``.

  |Значение|Описание|
  |---|---|
  |00/11|Переменная длина (клиент Windows), фиксированная длина (сервер Windows)|
  |01|Переменная длина|
  |10|фиксированная длина|

- Крайняя правая пара битов (XXYY**ZZ**) определяет соотношение времени в кванте, выделяемого фоновым и передним потокам, при этом передним потокам может быть выделено в три раза больше процессорного времени, чем фоновым. Как уже говорилось, это можно настроить только с квантами переменной длины. Это представлено функцией ``PsPrioritySeparation``

  |Значение|Описание|
  |---|---|
  |00|1:1|
  |01|2:1|
  |10/11|3:1|

- Используя приведенную выше информацию, значение по умолчанию ``0x2`` соответствует короткому, переменной длины, 3:1 на Windows Client и длинному, фиксированной длины, 3:1 на Windows Server.

### Значения Win32PrioritySeparation

Приведенная ниже таблица содержит все возможные значения, которые соответствуют клиентским и серверным редакциям Windows, поскольку ``00`` или ``11`` не использовались в **XXYY**ZZ битовой маске, которая имеет разные значения в клиентских и серверных редакциях. Любое значение, не указанное в таблице, идентично тому, которое указано в таблице, как объяснено [здесь](https://github.com/valleyofdoom/PC-Tuning/blob/main/docs/research.md#5-ambiguous-win32priorityseparation-values-explained), поэтому значения в таблице являются единственными, которые следует использовать. Время в миллисекундах основано на разрешении таймера современных мультипроцессоров x86/x64.

Хотя повышение приоритета переднего плана не может быть использовано при использовании кванта фиксированной длины, PsPrioritySeparation все равно изменяется, и механизм повышения приоритета другого потока просто использует его значение, так что в действительности фиксированный квант 3:1 должен иметь ощутимую разницу по сравнению с фиксированным квантом 1:1. См. приведенный ниже параграф из Windows Internals.

> Как будет описано далее, каждый раз, когда поток в процессе переднего плана завершает операцию ожидания над
объекта ядра, ядро повышает его текущий (не базовый) приоритет на текущее значение
PsPrioritySeparation. (Оконная система отвечает за определение того, какой процесс
считается находящимся на переднем плане). Как описано ранее в этой главе в разделе "Управление
квантами", PsPrioritySeparation отражает индекс таблицы квантов, используемый для выбора квантов для
потоков приложений переднего плана. Однако в данном случае он используется как значение повышения приоритета.

Для большинства читателей я бы просто рекомендовал оставить значение по умолчанию. Хотя, смесь длины кванта и соотношения распределения времени переднего и заднего плана может влиять на то, как часто поток переключает контекст в зависимости от того, превышает ли время выполнения потока выделенное ему время в кванте, как описано ранее, поэтому вы можете проверить, влияет ли это на производительность в выбранных вами приложениях, если хотите. Если вы используете Windows Server на настольной системе, значение может быть установлено в ``0x26``, что имитирует то же поведение, что и ``0x2`` в клиентских версиях Windows.

|**Шестнадцатеричное**|**Десятичное**|**Двоичное**|**Интервал**|**Длина**|**PsPrioSep**|**ПереднийКв**|**ЗаднийВк**|**ОбщийКв**|
|---|---|---|---|---|---|---|---|---|
|0x14|20|0b010100|Длинный|Переменный|0|12 (62.50ms)|12 (62.50ms)|24 (125.00ms)|
|0x15|21|0b010101|Длинный|Переменный|1|24 (125.00ms)|12 (62.50ms)|36 (187.50ms)|
|0x16|22|0b010110|Длинный|Переменный|2|36 (187.50ms)|12 (62.50ms)|48 (250.00ms)|
|0x18|24|0b011000|Длинный|Фиксированный|0|36 (187.50ms)|36 (187.50ms)|72 (375.00ms)|
|0x19|25|0b011001|Длинный|Фиксированный|1|36 (187.50ms)|36 (187.50ms)|72 (375.00ms)|
|0x1A|26|0b011010|Длинный|Фиксированный|2|36 (187.50ms)|36 (187.50ms)|72 (375.00ms)|
|0x24|36|0b100100|Короткий|Переменный|0|6 (31.25ms)|6 (31.25ms)|12 (62.50ms)|
|0x25|37|0b100101|Короткий|Переменный|1|12 (62.50ms)|6 (31.25ms)|18 (93.75ms)|
|0x26|38|0b100110|Короткий|Переменный|2|18 (93.75ms)|6 (31.25ms)|24 (125.00ms)|
|0x28|40|0b101000|Короткий|Фиксированный|0|18 (93.75ms)|18 (93.75ms)|36 (187.5ms)|
|0x29|41|0b101001|Короткий|Фиксированный|1|18 (93.75ms)|18 (93.75ms)|36 (187.5ms)|
|0x2A|42|0b101010|Короткий|Фиксированный|2|18 (93.75ms)|18 (93.75ms)|36 (187.5ms)|

### Рекомендации

Исходя из тестов и эксперементов выяснилось, что Win32PrioritySeparation не влияет на производительность и латенси напрямую. Для того, чтобы дать вам информацию, какое значение всё таки выбрать, я вставлю слова EXO(_iiiexoiii_) чтобы помочь вам в выборе:

**EXO** : Чтобы получить максимальную стабильность и не обделять важные процессы системы, отдавая больше времени "активному приложению" (приложению переднего плана, т.е. буквально то, которое у вас на экране), нам нужно полностью отключить FG буст. А значит, нам нужно будет установить значение PsPrioritySeparation на 0 (чтобы не было буста (1:1)).

Но если выбрать fixed 3:1/fixed 2:1, хоть и в windbg видно, что у BG и FG процессов было одинаковое значение Quantum (QuantumReset у процесса можно прочитать в windbg *(получают одинаковое кол-во времени процессора)*), но исходя из windows internals, можно понять, что значение PsPrioritySeparation будет использоваться в другом механизме буста (Буст приоритета у потока +1/+2 к "current priority" переднего плана *(не base priority)*). 

Значит, нам нужно выбирать только из значений, где PsPrioritySeparation равен 0, это ``0x14``, ``0x18``, ``0x24``, ``0x28``.

У ``0x14`` и ``0x24`` значение **Длины** это **Переменный**, но, поскольку PsPrioritySeparation стоит 0, то это ни на что не влияет. 

Теперь надо определиться с интервалом, **Длинный** или **Короткий**. Значение Квантума определяет количество времени, выделенного для работы потока до переключения на другой поток такого же приоритета. Если количество времени маленькое, то значит система быстрее переключится на другой поток который требует времени *(так как потоку процесса будет даваться мало времени на работу до переключения на другой поток такого же приоритета)*, и это (в теории) улучшит отзывчивость (но увеличит кол-во context switching).

Из нашего списка: ``0x14``, ``0x18``, ``0x24``, ``0x28`` - самые маленькие интервалы у ``0x24``. Если **Переменная длина** ни на что не влияет при значении PsPrioritySeparation 0, как нам говорит windbg, то лучшее значение это ``0x24`` (hex). 

*(Но если вы хотите максимально минимизировать Context-Switching не используя **буст потока переднего плана**, то лучше будет юзнуть ``0x18``)*

**UPD**: Оно никак не заставляет ждать потоки с высоким приоритетом ждать(т.е. системные важные потоки к примеру отвечающие за инпут, *например, поток ``csrss``, ``dwm``*), т.к. потоки с ``Realtime`` приоритетом просто проигнорируют значение квантума и приостановят **любой** поток который ниже приоритетом (тот же поток ``csrss`` легко приостановит любой поток игры, т.к. у потоков игры нет приоритета ``Realtime``) и значение квантума будет влиять только на соревнование потоков игры между собой *(значение квантума имеет смысл только если потоки имеют одинаковый приоритет)*, ведь у них в основном одинаковый приоритет, также соревнование любого потока игры с любым потоком, который имеет такой же приоритет как поток игры, и вот тут **возможно** когда-то применится значение квантума, но это маловероятно *(так как поток в основном приостанавливается, или выполняет всю работу, которую должен был выполнить до того как достигнет значения квантума)*, то есть значение квантума не имеет значения, но зато буст приоритета потока имеет значение, но опять же соревнование потоков одного приоритета *(``Priority_Class`` и приоритеты потоков)*, а почти все важные потоки имеют приоритет выше чем "приложение переднего плана" *(игра)*, соответственно влияние этого преувеличено и возможно буст даже стоит оставлять.
 
Но если вы предпочитаете вручную настраивать приоритеты у потоков игры, то помните обо всëм что я написал здесь, ведь если вы сделаете процессу игры такой же приоритет *(``Priority_Class`` - ``Realtime``)* как у того же процесса ``CSRSS``, то тогда поток инпута ``CSRSS`` не сможет остановить поток игры (Но возможно ничего плохого не будет **(нужно протестировать)**). Ещë при ручной настройке вам не понравится динамический буст приоритета у любого потока игры.

## Частота прерываний по системному таймеру (разрешение таймера)

Частота тактовых прерываний - это частота, с которой системный таймер системы генерируют прерывания, позволяющие планировщику выполнять различные задачи, например хронометраж. В большинстве систем по умолчанию минимальная частота составляет 64 Гц, что означает, что прерывание генерируется каждые 15,625 мс. Более низкая частота приводит к снижению нагрузки на процессор и энергопотребления за счет меньшего количества прерываний, но снижает точность синхронизации и приводит к потенциально менее отзывчивой многозадачности. Максимальная частота составляет 2 кГц, что означает, что прерывание генерируется каждые 0,5 мс. Более высокая частота обеспечивает более высокую точность синхронизации, потенциально более высокую скорость отклика многозадачной системы, но увеличивает нагрузку на процессор и энергопотребление. Минимальное, текущее и максимальное разрешение можно посмотреть в [ClockRes](https://learn.microsoft.com/en-us/sysinternals/downloads/clockres).

Приложения, которым требуется более высокая точность, чем стандартное разрешение 15,625 мс, могут повысить частоту прерывания часов с помощью таких функций, как [timeBeginPeriod](https://learn.microsoft.com/en-us/windows/win32/api/timeapi/nf-timeapi-timebeginperiod) и [NtSetTimerResolution](http://undocumented.ntinternals.net/index.html?page=UserMode%2FUndocumented%20Functions%2FTime%2FNtSetTimerResolution.html). В этих сценариях обычно используются воспроизведение мультимедиа, игры, VoIP-активность и многое другое, что можно увидеть, запустив трассировку энергопотребления ([инструкции](https://support.microsoft.com/en-gb/topic/guided-help-get-a-detailed-power-efficiency-diagnostics-report-for-your-computer-in-windows-7-3f6ce138-fc04-7648-089a-854bcf332810)) во время выполнения. Точность функций, которые полагаются на функции сна для отслеживания событий, напрямую зависит от частоты прерывания часов ([1](https://randomascii.wordpress.com/wp-content/uploads/2020/10/image-5.png)). Если использовать [Sleep](https://learn.microsoft.com/en-us/windows/win32/api/synchapi/nf-synchapi-sleep) в качестве примера, то ``Sleep(n)`` должна спать в течение n миллисекунд на самом деле, а не n плюс/минус произвольное значение, иначе это может привести к неожиданному и непостоянному темпу событий, что не является идеальным для таких функций, как ограничители частоты кадров на основе сна. Обратите внимание, что это пример, и многие реальные приложения не полагаются конкретно на функцию ``Sleep`` для отслеживания событий. Типичным значением, до которого разработчики обычно поднимают разрешение, является 1 мс, что означает, что приложение может поддерживать темп событий в пределах разрешения 1 мс. В очень редких случаях разработчики могут вообще не повышать разрешение, в то время как их приложение полагается на него для точности темпа событий, что приводит к поломке, но это не так часто встречается и может быть применимо к некоторым малоизвестным программам, таким как малоизвестные игры.

Реализация разрешения таймера изменилась в Windows 10 2004+ таким образом, что вызывающий процесс, повышающий разрешение, не влияет на систему на глобальном уровне, то есть процесс A, повышающий разрешение до 1 мс, не влияет на процесс B с разрешением по умолчанию 15,625 мс, как раньше. Это само по себе отличное изменение, поскольку оно снижает накладные расходы, так как другие процессы, такие как неработающие фоновые процессы, не обслуживаются планировщиком часто, а вызывающий процесс получает более высокую точность по мере необходимости. Однако для конечного пользователя это приводит к ограничениям при желании использовать более высокие разрешения, например 0,5 мс.  Учитывая, что игры не имеют открытого исходного кода для его модификации, а также ограничения античита, препятствующие внедрению DLL или исправлению бинарных файлов для повышения разрешения выше 1 мс в рамках каждого процесса, единственным вариантом является использование глобального поведения, которое применимо с ключом реестра, указанным ниже, в Windows Server 2022 и Windows 11+, как подробно объясняется [здесь](https://github.com/valleyofdoom/PC-Tuning/blob/main/docs/research.md#6-fixing-timing-precision-in-windows-after-the-great-rule-change).

```
[HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\kernel]
"GlobalTimerResolutionRequests"=dword:00000001
```
Это дает возможность повышать разрешение в отдельном процессе, что, в свою очередь, приводит к тому, что нужное приложение, например игра, получает более высокую точность. **Однако, как уже говорилось ранее, имплантация в каждый процесс снижает накладные расходы, чего уже не происходит при восстановлении глобального поведения, а фоновые процессы также обслуживаются неоправданно часто.** [RTSS](https://www.guru3d.com/download/rtss-rivatuner-statistics-server-download) является альтернативным методом ограничения частоты кадров и использует гибридное ожидание, которое обеспечивает более высокую точность, устраняя необходимость в восстановлении глобального поведения.

Более высокое разрешение обеспечивает более высокую точность, но в некоторых случаях максимальное поддерживаемое разрешение 0,5 мс обеспечивает меньшую точность, чем несколько меньшее, например 0,507 мс ([1](https://github.com/valleyofdoom/PC-Tuning/blob/main/docs/research.md#7-micro-adjusting-timer-resolution-for-higher-precision)). Поэтому имеет смысл определить, какое разрешение вызова обеспечивает наибольшую точность (наименьшие дельты) в программе [MeasureSleep](https://github.com/valleyofdoom/TimerResolution), а также запросить различные разрешения в программе [SetTimerResolution](https://github.com/valleyofdoom/TimerResolution). Это следует делать под нагрузкой, так как холостые бенчмарки могут вводить в заблуждение. Для автоматизации процесса можно использовать скрипт [micro-adjust-benchmark.ps1](https://github.com/valleyofdoom/TimerResolution).

В заключение своего мнения по этому вопросу **я рекомендую отдать предпочтение реализации per-process (неглобальной)**, где это применимо, так как это снижает накладные расходы, и вместо этого использовать [RTSS](https://www.guru3d.com/download/rtss-rivatuner-statistics-server-download) для точного ограничения частоты кадров.
Стоит отметить, что она может вносить заметно большую задержку ([1](https://www.youtube.com/watch?t=377&v=T2ENf9cigSk), [2](https://en.wikipedia.org/wiki/Busy_waiting)), поэтому я рекомендую сравнивать и тестировать ее с микрорегулировкой запрашиваемого разрешения для большей точности при глобальном поведении. Возможно, на стабильность фреймрейта не влияет повышение разрешения выше 1 мс из-за улучшений внутриигрового ограничителя фреймрейта, и в этом случае никаких действий предпринимать не нужно. **Главное, что я хочу донести до вас, - это сравнить все доступные варианты, отдав предпочтение поведению для каждого процесса, которое используется по умолчанию в Windows 10 2004+, если вы обнаружите, что дальнейшее повышение разрешения практически не влияет на ситуацию.**

### Сериализация окончания таймера (SerializeTimerExpiration)

**EXO** : На W11 24h2 ``SerializeTimerExpiration`` работает так:

``SerializeTimerExpiration``=``1`` (При условии что приложение вызывает 0,5 ms):

- Интервал между прерываниями системного таймера на **ядре 0** равен 0,495-0,500 ms, а интервал между прерываниями системного таймера на **остальных ядрах** равен 1,7 ms

``SerializeTimerExpiration``=``2`` (При условии что приложение вызывает 0,5 ms):

- Интервал между прерываниями системного таймера на всех ядрах равен 0,495-0,500 ms

``SerializeTimerExpiration``=``0``:

- Выбирает автоматически исходя из того доступен ли ``MODERN STANDBY`` (В основном это будет равноценно значению ``1``, если он доступен)


В итоге когда вы ставите значение ``2``, то вы лишь добавляете нагрузку на все ядра вместо одного **(ядро 0)** ради минимального улучшения точности системного таймера, так как судя по всему прерывания системного таймера со всех ядер будут обновлять системное время/часы, а не только прерывания с **ядра 0**, то есть асинхронно.

```
[HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\kernel]
"SerializeTimerExpiration"=dword:00000000
```

### О Tickless kernel (Bcd store параметры) 

- ``UsePlatformTick`` - Microsoft: *Заставляет часы опираться на платформный таймер, синтетические таймеры не допускаются. Опция доступна начиная с Windows 8 и Windows Server 2012* ([1](https://learn.microsoft.com/en-us/windows-hardware/drivers/devtest/bcdedit--set)).

    - Отключает тик-систему TSC и использует вместо него тик источника платформы (RTC)

        - ``useplatformtick`` заставит использовать RTC, который является устаревшой системой тикрейта. Не являясь динамическим тиком и не имея интеллектуальных оптимизаций вычислений, он фактически снизит производительность вашей системы.

        - Форсирует использование таймера в *0.5 ms* и *1.0 ms* 

- ``disabledynamictick`` - Microsoft: *Включает и выключает функцию динамического тика таймера* ([1](https://learn.microsoft.com/en-us/windows-hardware/drivers/devtest/bcdedit--set)).

    - Для большей информации прочитайте [это](https://en.wikipedia.org/wiki/Tickless_kernel#cite_note-ars-technica-win8-1) и [это](https://arstechnica.com/information-technology/2012/10/better-on-the-inside-under-the-hood-of-windows-8/2/) 

        - Когда динамический таймер включен: Функция, вызывающая слияние тиков таймера, когда находится в режиме ожидания.

        - Отключения динамического таймера ничего не даст, потому что начиная с Windows 10 таймер почти не уходит в простой ([1](/docs/idle_by_timer_duration.png)).
     
        - На 11 Windows изза того, что приложения больше не зависят от одного таймера, отключение становится еще более нецелесообразным.

## Уборка и обслуживание

Не лишним будет время от времени пересматривать этот шаг. Установить напоминание об этом может быть полезно для поддержания чистоты системы.

- Полюбите такие инструменты, как [Bulk-Crap-Uninstaller](https://github.com/Klocman/Bulk-Crap-Uninstaller) для удаления программ, поскольку обычная панель управления не удаляет остаточные файлы.

- Используйте [Autoruns](https://learn.microsoft.com/en-us/sysinternals/downloads/autoruns), чтобы удалить все нежелательные программы из запуска, и проверяйте его часто, особенно после установки программы.

- Настройка очистки диска

  - Откройте ``cmd`` и введите приведенную ниже команду, отметьте все пункты, кроме ``DirectX Shader Cache``, затем нажмите ``OK``.

      ```bat
      cleanmgr /sageset:0
      ```

  - Run Disk Cleanup

      ```bat
      cleanmgr /sagerun:0
      ```

- Некоторые места, которые вы можете захотеть проверить на наличие остаточных файлов

  - ``C:\`` - остаточный хлам
  - ``"C:\ProgramData\Microsoft\Windows\Start Menu\Programs"`` - ярлыки стартового меню (не удаляйте ярлыки, связанные с окнами)
  - ``C:\Windows\Prefetch`` - файлы предварительной выборки (эта папка не должна быть заполнена, если супервыборка отключена)
  - ``C:\Windows\SoftwareDistribution`` - Кэш загрузки обновления Windows
  - ``C:\Windows\Temp`` - временные файлы
  - ``"%userprofile%"`` - остаточный хлам
  - ``"%userprofile%\AppData\Local\Temp"`` - временные файлы
  - ``"%userprofile%\AppData\Roaming\Microsoft\Windows\Start Menu\Programs"`` - ярлыки стартового меню (не удаляйте ярлыки, связанные с окнами)
  - Пользовательские каталоги - например, "Загрузки", "Документы", "Изображения", "Музыка", "Видео", "Рабочий стол".

- По желанию очистите папку WinSxS, чтобы уменьшить ее размер ([1](https://learn.microsoft.com/en-us/windows-hardware/manufacture/desktop/clean-up-the-winsxs-folder?view=windows-11)) с помощью приведенной ниже команды в CMD. Обратите внимание, что это может быть длительным процессом

    ```bat
    DISM /Online /Cleanup-Image /StartComponentCleanup /ResetBase
    ```

- Можно удалить устаревшие точки восстановления системы на вкладке ``Защита системы``, набрав ``ysdm.cpl`` в ``Win+R``. Его можно полностью отключить, если вы им не пользуетесь


## Опционально: Отключение ненужных сервисов

Я не несу ответственности, если что-то пойдет не так или у вас возникнет BSOD. Идея заключается в том, чтобы отключить службы при использовании приложения в реальном времени и вернуться к службам по умолчанию для всего остального.

> [!IMPORTANT]
> Начиная с 23h2 (Май 2023 года) фоновые процессы были ограничены в фоновом потреблении ([1](https://blogs.windows.com/windowsdeveloper/2023/05/26/delivering-delightful-performance-for-more-than-one-billion-users-worldwide)). Влияние служб на производительность нулевая. Я настоятельно рекомендую пропустить этот пункт или выполнить отключение самых неиспользуемых служб вручную, при помощи serviwin, соблюдая зависимости.


- Список можно настроить, отредактировав ``C:\bin\minimal-services.ini`` в текстовом редакторе. В файле конфигурации есть несколько комментариев, которые вы можете прочитать, чтобы проверить, нужна ли вам та или иная служба или нет. Например, пользователю с Ethernet не нужны включенные службы Wi-Fi. Если вы планируете редактировать ``minimal-services.ini``, то изучите [синтаксис файла конфигурации](https://github.com/valleyofdoom/service-list-builder)

- [Настроить статический IP-адрес](https://www.youtube.com/watch?t=36&v=5iRp1Nug0PU). Это необходимо, поскольку мы будем отключать службы, расходующие ресурсы, на которые опирается DHCP

- Устройство ``Высокоточный таймер событий`` в диспетчере устройств использует IRQ 0 на большинстве систем AMD и, следовательно, конфликтует с устройством ``Системный таймер``, которое также использует IRQ 0. Единственный известный мне способ разрешить этот конфликт - отключить родительское устройство устройства ``Системный таймер``, которое является ``Мостом ISA стандартаPCI``, отключив драйвер ``msisadrv`` (отредактируйте конфигурацию).

- Используйте приведенную ниже команду, чтобы предотвратить попытку службы Software Protection зарегистрировать перезагрузку каждые 30 с, пока службы отключены ([1](/docs/software-protection-error.png)). Я не знаю точно, что это за проблемная служба, но источники в Интернете указывают на планировщик задач ([1](https://learn.microsoft.com/en-us/troubleshoot/windows-server/deployment/failed-schedule-software-protection), [2](https://superuser.com/questions/1501559/failed-to-schedule-software-protection-service-for-re-start-at-2119-10-19t1807)).

    ```bat
    reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\SoftwareProtectionPlatform" /v "InactivityShutdownDelay" /t REG_DWORD /d "4294967295" /f
    ```

- Загрузите и распакуйте последнюю версию [service-list-builder](https://github.com/valleyofdoom/service-list-builder). Откройте CMD и перейдите с компакт-диска в распакованную папку, где находится исполняемый файл

- Используйте приведенную ниже команду для сборки скриптов в папке ``build``. Переместите папку сборки в безопасное место, например ``C:\``, и не передавайте ее другим людям, поскольку она является специфической для вашей системы. Обратите внимание, что для запуска пакетного скрипта требуется NSudo с опцией ``Enable All Privileges``.

    ```bat
    service-list-builder.exe --config C:\bin\minimal-services.ini
    ```

    - Если появляется предупреждение о службах, не относящихся к Windows, оцените службы в предупреждении, чтобы определить, хотите ли вы оставить их включенными, отредактировав конфигурационный файл, или отключить их с помощью аргумента ``-disable_service_warning``. Например, ``NVIDIA Display Container LS`` может появиться в предупреждении, поскольку это не Windows служба, но отключение ее намеренно, поскольку нам не нужен доступ к панели управления после запуска ``Services-Disable.bat``, но у нас есть возможность получить доступ к ней после запуска ``Services-Enable.bat``. В этом случае использование аргумента для игнорирования предупреждения будет уместным. Другой пример - ``vgc``, который необходим для античита Valorant, поэтому вы не захотите отключать его, а значит, будет уместно добавить его в ``enabled_services`` в конфиге, так как это служба пользовательского режима

    - Если вы хотите перестроить скрипты, предварительно запустите сгенерированный скрипт ``Services-Enable.bat``, поскольку инструмент полагается на текущее состояние служб для построения будущих скриптов

- При желании вы можете использовать [ServiWin](https://www.nirsoft.net/utils/serviwin.html) для проверки наличия остаточных драйверов после отключения служб, а затем, возможно, создать проблему в репозитории, чтобы она была рассмотрена

## (В тестировании) Отключение MMCSS 

- MMCSS является частью операционной системы Microsoft Windows уже довольно давно и изначально была разработана для улучшения обработки мультимедийных приложений, чувствительных к времени, обеспечивая этим процессам/потокам необходимое время работы на процессоре, позволяя при этом работать приложениям с более низким приоритетом. Разработчики могут регистрировать потоки своих приложений в MMCSS под настраиваемым набором групп мультимедийных задач, которые определяют, какой тип приоритета и ресурсов ЦП они должны получить ([1](https://github.com/djdallmann/GamingPCSetup/blob/master/CONTENT/RESEARCH/WINSERVICES/README.md#q-what-is-multimedia-class-scheduler-service-mmcss) [2](https://github.com/djdallmann/GamingPCSetup/blob/master/CONTENT/RESEARCH/WINSERVICES/README.md#q-what-is-multimedia-class-scheduler-service-mmcss)).

- При отключении MMCSS ``audiodg.exe`` перестанет получать буст приоритета, что может вызывать лаги звука на нестабильных системах.

- Отключение значительно понизить количество событий и ресурсов.
