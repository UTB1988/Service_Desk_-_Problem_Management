
- Интеграция с Excel
- Excel-тонкий клиент
- Продублировать БД в MS SQL Server
- Экранные формы на Python
- Автоматизировать установку и настройку MySQL
- В карточку issue добавить поле, в котором будет список связанных заявок, чтобы не запрашивать каждый раз
- Логи
- Добавить ограничение на то, что дата изменения не должна быть меньше даты создания
- Добавить транзакции, где надо
- Добавить процедуры
- Добавить функции
- Добавить расписание и джобы
- Личный кабинет
- Голосование
- Проверить поля с целочисленным типом данных и заменить на BIGINT где надо, где другие типы целочисленных типов данных не выступают в качестве проверки или ограничителя. Тоже самое со строками.
- Добавить графу статус к заявкам и проблемам
- Добавить статусную модель
- Добавить документ правил организации кода, в котором, помимо всего прочего, прописать почему всегда ставим BIGINT, а не другие.
- Убрать все ограничители и связи, чтобы можно было спокойно транковать таблицы и загружать исторические данные. Связи лучше отобразить в независимой диаграмме.
- Список backlog разбить на отдельные файлы, чтобы потом компоновать из них релизы
- Список requirements разбить на отдельные файлы
- Данные живут дольше бизнес-правил, при которых они были созаданы, поэтому выкинуть все проверки из БД, а также, когда буду делать приложения делать два: одно для единичной записи, а второе для массовой записи. Также придумать как вести учёт того когда и какая версия правил была и чтобы можно было, когда изменятся правила, загрузить исторические данные используя старую версию.
- Загрузка данных из файла.
- CONSTRAINTS вынести в отдельный скрипт и третьим шагом. Вторым шагом сделать загрузку исторических данных как из скрипта, так и из файла.