В группах по 2-3 человека написать 2 shell-скрипта (.sh) для любого Unix-like окружения. Скрипт должен:

1. Для переданного пути в виде аргумента проверить заполнение папки (далее условно /log), в процентах.

2. Если папка занята более чем на X% (параметр X может варьироваться в качестве передаваемого параметра, можно взять за значение 70%), то нужно заархивировать файлы в /backup и удалить их из /log для архивирования можно использовать tar + gz.

3. Перед архивацией произвести фильтрацию списка файлов. Архивируем N самых старых файлов (в зависимости от даты модификации).

4. Написать 2-ой скрипт, который будет генерировать тест-кейсы и проверять корректность базового скрипта (фактически написать тесты), как минимум 4 теста. Во всех тест-кейсах папка /log должна весить минимум 0,5 GB.

Дополнительно: написать те же скрипты, но для Windows(.bat)
