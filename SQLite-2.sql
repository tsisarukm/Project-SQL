DROP TABLE IF EXISTS Лейбл;
DROP TABLE IF EXISTS Альбом;
DROP TABLE IF EXISTS Исполнитель;
DROP TABLE IF EXISTS Трек;
DROP TABLE IF EXISTS Пользователь;
DROP TABLE IF EXISTS Стриминговая_площадка;
DROP TABLE IF EXISTS Жанр; 
DROP TABLE IF EXISTS Принадлежит;
DROP TABLE IF EXISTS Добавил;
DROP TABLE IF EXISTS Слушает; 
DROP TABLE IF EXISTS Пользуется;
DROP TABLE IF EXISTS Выпущен_на; 


-- Создание таблиц
--Создадим таблицу лейбла
CREATE TABLE Лейбл (
    id_лейбла VARCHAR(50) PRIMARY KEY,
    Название VARCHAR(100) NOT NULL,--нужно обязательно заполнить
    Страна VARCHAR(100) NOT NULL,--нужно обязательно заполнить
    Дата_основания DATE NOT NULL,--нужно обязательно заполнить
    CHECK (Дата_основания <= CURRENT_DATE) -- Дата основания не может быть в будущем
);
--Для исполнителя
CREATE TABLE Исполнитель (
    id_исполнителя VARCHAR(50) PRIMARY KEY,
    Имя_название VARCHAR(100) NOT NULL,--нужно обязательно заполнить
    Страна VARCHAR(100) NOT NULL,--нужно обязательно заполнить
    id_лейбла VARCHAR(50) NOT NULL,--нужно обязательно заполнить
    FOREIGN KEY (id_лейбла) REFERENCES Лейбл(id_лейбла)--внешний ключ на таблицу лейбл
);
--Для альбома
CREATE TABLE Альбом (
    id_альбома VARCHAR(50) PRIMARY KEY,
    Название VARCHAR(100) NOT NULL, --нужно обязательно заполнить
    Дата_выпуска DATE NOT NULL,--нужно обязательно заполнить
    Количество_песен INT NOT NULL,--нужно обязательно заполнить
    Количество_скачиваний INT NOT NULL,--нужно обязательно заполнить
    id_исполнителя VARCHAR(50) NOT NULL,--нужно обязательно заполнить
    FOREIGN KEY (id_исполнителя) REFERENCES Исполнитель(id_исполнителя), --внешний ключ на таблицу исполнитель
    CHECK (Количество_песен > 0), -- Количество песен должно быть положительным
    CHECK (Количество_скачиваний >= 0), -- Количество скачиваний не может быть отрицательным
    CHECK (Дата_выпуска <= CURRENT_DATE) -- Дата выпуска не может быть в будущем
);
--Для трека
CREATE TABLE Трек (
    id_трека VARCHAR(50) PRIMARY KEY,
    Название VARCHAR(100) NOT NULL,--нужно обязательно заполнить
    Длительность TIME NOT NULL,--нужно обязательно заполнить
    Количество_прослушиваний INT NOT NULL,--нужно обязательно заполнить
    id_исполнителя VARCHAR(50) NOT NULL,--нужно обязательно заполнить
    id_альбома VARCHAR(50) NOT NULL,--нужно обязательно заполнить
    FOREIGN KEY (id_исполнителя) REFERENCES Исполнитель(id_исполнителя),--внешний ключ на таблицу испольнителя
    FOREIGN KEY (id_альбома) REFERENCES Альбом(id_альбома),--внешний ключ на таблицу альбом
    CHECK (Количество_прослушиваний >= 0) -- Количество прослушиваний не может быть отрицательным
);
--Для пользователя
CREATE TABLE Пользователь (
    id_пользователя VARCHAR(50) PRIMARY KEY,
    Логин VARCHAR(100) NOT NULL,--нужно обязательно заполнить
    Электронная_почта VARCHAR(100) NOT NULL UNIQUE,--нужно обязательно заполнить и должно быть уникальным и каждого пользователя
    CHECK (Электронная_почта LIKE '%@%') -- Проверка формата email
);
--Для площадки
CREATE TABLE Стриминговая_площадка (
    id_стриминговой_площадки VARCHAR(50) PRIMARY KEY,
    Название VARCHAR(100) NOT NULL,--нужно обязательно заполнить
    Дата_запуска DATE NOT NULL,--нужно обязательно заполнить
    Количество_пользователей INT NOT NULL,--нужно обязательно заполнить
    CHECK (Количество_пользователей >= 0), -- Количество пользователей не может быть отрицательным
    CHECK (Дата_запуска <= CURRENT_DATE) -- Дата запуска не может быть в будущем
);
--Для жанра
CREATE TABLE Жанр (
    id_жанра VARCHAR(50) PRIMARY KEY,
    Название_жанра VARCHAR(100) NOT NULL,--нужно обязательно заполнить
    Годы_активности VARCHAR(100),-- не обязательно заполнять
    Происхождение VARCHAR(100),-- не обязательно заполнять
    parent_id VARCHAR(50) REFERENCES Жанр(id_жанра)--внешний ключ на жанр(рекурсия)
);

-- Создание таблиц связей
CREATE TABLE Принадлежит (
    id_жанра VARCHAR(50),
    id_альбома VARCHAR(50),
    PRIMARY KEY (id_жанра, id_альбома),--составной первичный ключ
    FOREIGN KEY (id_жанра) REFERENCES Жанр(id_жанра),--внешний ключ на жанр
    FOREIGN KEY (id_альбома) REFERENCES Альбом(id_альбома)--внешний ключ на альбом
);

CREATE TABLE Добавил (
    id_пользователя VARCHAR(50),
    id_альбома VARCHAR(50),
    PRIMARY KEY (id_пользователя, id_альбома),--составной первичный ключ
    FOREIGN KEY (id_пользователя) REFERENCES Пользователь(id_пользователя),--внешний ключ на пользователя
    FOREIGN KEY (id_альбома) REFERENCES Альбом(id_альбома)--внешний ключ на альбом
);

CREATE TABLE Слушает (
    id_трека VARCHAR(50),
    id_пользователя VARCHAR(50),
    PRIMARY KEY (id_трека, id_пользователя),--составной первичный ключ
    FOREIGN KEY (id_трека) REFERENCES Трек(id_трека),--внешний ключ на трек
    FOREIGN KEY (id_пользователя) REFERENCES Пользователь(id_пользователя)--внешний ключ на пользователя
);

CREATE TABLE Пользуется (
    id_пользователя VARCHAR(50),
    id_стриминговой_площадки VARCHAR(50),
    PRIMARY KEY (id_пользователя, id_стриминговой_площадки),--составной первичный ключ
    FOREIGN KEY (id_пользователя) REFERENCES Пользователь(id_пользователя),--внешний ключ на пользователя
    FOREIGN KEY (id_стриминговой_площадки) REFERENCES Стриминговая_площадка(id_стриминговой_площадки)--внешний ключ на площадку
);

CREATE TABLE Выпущен_на (
    id_стриминговой_площадки VARCHAR(50),
    id_альбома VARCHAR(50),
    PRIMARY KEY (id_стриминговой_площадки, id_альбома),--составной первичный ключ
    FOREIGN KEY (id_стриминговой_площадки) REFERENCES Стриминговая_площадка(id_стриминговой_площадки),--внешний ключ на площадку
    FOREIGN KEY (id_альбома) REFERENCES Альбом(id_альбома)--внешний ключ на альбом
);

--Заполняем таблицы
-- Наполнение таблицы Жанр
INSERT INTO Жанр (id_жанра, Название_жанра, Годы_активности, Происхождение, parent_id) VALUES
('j1', 'Rock', '1950s-present', 'USA', NULL),
('j2', 'Pop', '1950s-present', 'USA', NULL),
('j3', 'Hip-Hop', '1970s-present', 'USA', NULL),
('j4', 'Alternative Rock', '1980s-present', 'USA', 'j1'),
('j5', 'Synthpop', '1980s-present', 'UK', 'j2'),
('j6', 'Trap', '2000s-present', 'USA', 'j3'),
('j7', 'Punk Rock', '1970s-present', 'USA', 'j1');

-- Наполнение таблицы Лейбл
INSERT INTO Лейбл (id_лейбла, Название, Страна, Дата_основания) VALUES
('l1', 'Warner Music Group', 'USA', '1958-03-19'),
('l2', 'Sony Music', 'Japan', '1929-01-01'),
('l3', 'Universal Music Group', 'USA', '1934-09-15'),
('l4', 'EMI', 'UK', '1931-03-14'),
('l5', 'Atlantic Records', 'USA', '1947-10-01'),
('l6', 'Columbia Records', 'USA', '1887-01-15'),
('l7', 'Sub Pop', 'USA', '1986-06-01');

-- Наполнение таблицы Исполнитель
INSERT INTO Исполнитель (id_исполнителя, Имя_название, Страна, id_лейбла) VALUES
('art1', 'The Beatles', 'UK', 'l2'),
('art2', 'Kanye West', 'USA', 'l3'),
('art3', 'Taylor Swift', 'USA', 'l1'),
('art4', 'Arctic Monkeys', 'UK', 'l4'),
('art5', 'Ariana Grande', 'USA', 'l5'),
('art6', 'Drake', 'Canada', 'l3'),
('art7', 'Nirvana', 'USA', 'l7');

-- Наполнение таблицы Альбом
INSERT INTO Альбом (id_альбома, Название, Дата_выпуска, Количество_песен, Количество_скачиваний, id_исполнителя) VALUES
('alb1', 'Abbey Road', '1969-09-26', 17, 5000000, 'art1'),
('alb2', 'The College Dropout', '2004-02-10', 21, 4000000, 'art2'),
('alb3', '1989', '2014-10-27', 13, 10000000, 'art3'),
('alb4', 'AM', '2013-09-09', 12, 3000000, 'art4'),
('alb5', 'Thank U, Next', '2019-02-08', 12, 8000000, 'art5'),
('alb6', 'Scorpion', '2018-06-29', 25, 6000000, 'art6'),
('alb7', 'Nevermind', '1991-09-24', 13, 15000000, 'art7'),
('alb8', 'Let It Be', '1970-05-08', 12, 4500000, 'art1'), -- Альбом The Beatles
('alb9', 'Late Registration', '2005-08-30', 21, 3000000, 'art2'), -- Альбом Kanye West
('alb10', 'Reputation', '2017-11-10', 15, 9000000, 'art3'), -- Альбом Taylor Swift
('alb11', 'Favourite Worst Nightmare', '2007-04-23', 12, 4200000, 'art4'), -- Альбом Arctic Monkeys
('alb12', 'Dangerous Woman', '2016-05-20', 15, 5000000, 'art5'), -- Альбом Ariana Grande
('alb13', 'Take Care', '2011-11-15', 17, 11000000, 'art6'), -- Альбом Drake
('alb14', 'In Utero', '1993-09-21', 12, 8000000, 'art7'); -- Альбом Nirvana


-- Наполнение таблицы Трек
INSERT INTO Трек (id_трека, Название, Длительность, Количество_прослушиваний, id_исполнителя, id_альбома) VALUES
('trk1', 'Come Together', '00:04:20', 2000000, 'art1', 'alb1'),
('trk2', 'Jesus Walks', '00:03:13', 1200000, 'art2', 'alb2'),
('trk3', 'Shake It Off', '00:03:39', 5500000, 'art3', 'alb3'),
('trk4', 'Do I Wanna Know?', '00:04:23', 1800000, 'art4', 'alb4'),
('trk5', '7 Rings', '00:02:58', 6000000, 'art5', 'alb5'),
('trk6', 'Gods Plan', '00:03:18', 7000000, 'art6', 'alb6'),
('trk7', 'Smells Like Teen Spirit', '00:05:01', 8000000, 'art7', 'alb7'),
('trk8', 'Across The Universe', '00:03:48', 4000000, 'art1', 'alb8'),
('trk9', 'Hey Jude', '00:07:08', 6000000, 'art1', 'alb8'),
('trk10', 'Touch The Sky', '00:03:58', 1500000, 'art2', 'alb9'),
('trk11', 'Gold Digger', '00:03:27', 5000000, 'art2', 'alb9'),
('trk12', 'Look What You Made Me Do', '00:03:31', 7000000, 'art3', 'alb10'),
('trk13', 'Delicate', '00:03:52', 5500000, 'art3', 'alb10'),
('trk14', 'Ready for It?', '00:03:28', 6500000, 'art3', 'alb10'),
('trk15', 'Brianstorm', '00:02:50', 2900000, 'art4', 'alb11'),
('trk16', 'Fluorescent Adolescent', '00:02:57', 4100000, 'art4', 'alb11'),
('trk17', 'Into You', '00:04:04', 4900000, 'art5', 'alb12'),
('trk18', 'Side to Side', '00:03:46', 5300000, 'art5', 'alb12'),
('trk19', 'Marvins Room', '00:05:47', 5600000, 'art6', 'alb13'),
('trk20', 'Take Care', '00:04:37', 7000000, 'art6', 'alb13'),
('trk21', 'Heart-Shaped Box', '00:04:41', 5000000, 'art7', 'alb14'),
('trk22', 'All Apologies', '00:03:50', 6700000, 'art7', 'alb14');

-- Наполнение таблицы Пользователь
INSERT INTO Пользователь (id_пользователя, Логин, Электронная_почта) VALUES
('usr1', 'john_doe', 'john@gmail.com'),
('usr2', 'jane_smith', 'jane@hotmail.com'),
('usr3', 'music_lover', 'lover@gnail.com'),
('usr4', 'rock_fan', 'rockfan@yahoo.com'),
('usr5', 'pop_queen', 'popqueen@yandex.ru'),
('usr6', 'hiphop_head', 'hiphophead@gmail.com'),
('usr7', 'indie_enthusiast', 'indie@mail.ru');

-- Наполнение таблицы Стриминговая_площадка
INSERT INTO Стриминговая_площадка (id_стриминговой_площадки, Название, Дата_запуска, Количество_пользователей) VALUES
('plt1', 'Spotify', '2008-10-07', 345000000),
('plt2', 'Apple Music', '2015-06-30', 60000000),
('plt3', 'Tidal', '2014-10-28', 3000000),
('plt4', 'Amazon Music', '2007-09-25', 55000000),
('plt5', 'Deezer', '2007-08-22', 16000000),
('plt6', 'YouTube Music', '2015-11-12', 50000000),
('plt7', 'Pandora', '2000-01-01', 64000000);

-- Наполнение таблицы Принадлежит
INSERT INTO Принадлежит (id_жанра, id_альбома) VALUES
('j1', 'alb1'), -- Abbey Road -> Rock
('j3', 'alb2'), -- The College Dropout -> Hip-Hop
('j2', 'alb3'), -- 1989 -> Pop
('j4', 'alb4'), -- AM -> Alternative Rock
('j5', 'alb5'), -- Thank U, Next -> Synthpop
('j6', 'alb6'), -- Scorpion -> Trap
('j7', 'alb7'), -- Nevermind -> Punk Rock
('j1', 'alb8'), -- Let It Be -> Rock
('j3', 'alb9'), -- Late Registration -> Hip-Hop
('j2', 'alb10'), -- Reputation -> Pop
('j4', 'alb11'), -- Favourite Worst Nightmare -> Alternative Rock
('j5', 'alb12'), -- Dangerous Woman -> Synthpop
('j6', 'alb13'), -- Take Care -> Trap
('j7', 'alb14'); -- In Utero -> Punk Rock

-- Наполнение таблицы Добавил
INSERT INTO Добавил (id_пользователя, id_альбома) VALUES
('usr1', 'alb1'),
('usr2', 'alb2'),
('usr3', 'alb3'),
('usr4', 'alb4'),
('usr5', 'alb5'),
('usr6', 'alb6'),
('usr7', 'alb7'),
('usr1', 'alb8'),
('usr2', 'alb9'),
('usr3', 'alb10'),
('usr4', 'alb11'),
('usr5', 'alb12'),
('usr6', 'alb13'),
('usr7', 'alb14');

-- Наполнение таблицы Слушает
INSERT INTO Слушает (id_трека, id_пользователя) VALUES
('trk1', 'usr1'), -- Come Together -> john_doe
('trk2', 'usr2'), -- Jesus Walks -> jane_smith
('trk3', 'usr3'), -- Shake It Off -> music_lover
('trk4', 'usr4'), -- Do I Wanna Know? -> rock_fan
('trk5', 'usr5'), -- 7 Rings -> pop_queen
('trk6', 'usr6'), -- God's Plan -> hiphop_head
('trk7', 'usr7'), -- Smells Like Teen Spirit -> indie_enthusiast
('trk8', 'usr1'), -- Across The Universe -> john_doe
('trk9', 'usr1'), -- Hey Jude -> john_doe
('trk10', 'usr2'), -- Touch The Sky -> jane_smith
('trk11', 'usr2'), -- Gold Digger -> jane_smith
('trk12', 'usr3'), -- Look What You Made Me Do -> music_lover
('trk13', 'usr3'), -- Delicate -> music_lover
('trk14', 'usr3'), -- ...Ready for It? -> music_lover
('trk15', 'usr4'), -- Brianstorm -> rock_fan
('trk16', 'usr4'), -- Fluorescent Adolescent -> rock_fan
('trk17', 'usr5'), -- Into You -> pop_queen
('trk18', 'usr5'), -- Side to Side -> pop_queen
('trk19', 'usr6'), -- Marvins Room -> hiphop_head
('trk20', 'usr6'), -- Take Care -> hiphop_head
('trk21', 'usr7'), -- Heart-Shaped Box -> indie_enthusiast
('trk22', 'usr7'); -- All Apologies -> indie_enthusiast

-- Наполнение таблицы Пользуется
INSERT INTO Пользуется (id_пользователя, id_стриминговой_площадки) VALUES
('usr1', 'plt1'), -- john_doe -> Spotify
('usr2', 'plt2'), -- jane_smith -> Apple Music
('usr3', 'plt3'), -- music_lover -> Tidal
('usr4', 'plt4'), -- rock_fan -> Amazon Music
('usr5', 'plt5'), -- pop_queen -> Deezer
('usr6', 'plt6'), -- hiphop_head -> YouTube Music
('usr7', 'plt7'); -- indie_enthusiast -> Pandora

-- Наполнение таблицы Выпущен_на
INSERT INTO Выпущен_на (id_стриминговой_площадки, id_альбома) VALUES
('plt1', 'alb1'), -- Abbey Road -> Spotify
('plt2', 'alb2'), -- The College Dropout -> Apple Music
('plt3', 'alb3'), -- 1989 -> Tidal
('plt4', 'alb4'), -- AM -> Amazon Music
('plt5', 'alb5'), -- Thank U, Next -> Deezer
('plt6', 'alb6'), -- Scorpion -> YouTube Music
('plt7', 'alb7'), -- Nevermind -> Pandora
('plt1', 'alb8'), -- Let It Be -> Spotify
('plt2', 'alb9'), -- Late Registration -> Apple Music
('plt3', 'alb10'), -- Reputation -> Tidal
('plt4', 'alb11'), -- Favourite Worst Nightmare -> Amazon Music
('plt5', 'alb12'), -- Dangerous Woman -> Deezer
('plt6', 'alb13'), -- Take Care -> YouTube Music
('plt7', 'alb14'); -- In Utero -> Pandora
--Посмотри все таблицы
SELECT * 
FROM Жанр;

SELECT * 
FROM Лейбл;

SELECT * 
FROM Исполнитель;

SELECT * 
FROM Альбом; 

SELECT * 
FROM Трек;

SELECT * 
FROM Пользователь;

SELECT * 
FROM Стриминговая_площадка;

SELECT * 
FROM Принадлежит;

SELECT * 
FROM Добавил;

SELECT * 
FROM Слушает;

SELECT * 
FROM Пользуется;

SELECT * 
FROM Выпущен_на;

-- 1)
-- Вывести количество песен и общее количество прослушиваний для каждого исполнителя, у которых суммарное количество прослушиваний больше 3000000.
SELECT 
    Исполнитель.Имя_название, -- Выбираем имя исполнителя
    COUNT(Трек.id_трека) AS Количество_песен,-- Считаем количество песен
    SUM(Трек.Количество_прослушиваний) AS Общее_количество_прослушиваний -- Считаем общее количество прослушиваний
FROM 

    Трек -- из таблицы с треками
JOIN 
    Исполнитель ON Трек.id_исполнителя = Исполнитель.id_исполнителя -- Присоединяем таблицу исполнителей по id_исполнителя
GROUP BY 
    Исполнитель.Имя_название -- Группируем по имени исполнителя
HAVING 
    SUM(Трек.Количество_прослушиваний) > 3000000 -- Фильтруем исполнителей с общим количеством прослушиваний больше 3000000
ORDER BY 
 
    Общее_количество_прослушиваний DESC;
    
-- 2)    
-- Добавить новый столбец `Премиум` в таблицу Пользователь и установить `TRUE` для пользователей с `@gmail.com` почтой.
-- Добавить новый столбец 'Премиум'
ALTER TABLE Пользователь
ADD Премиум BOOLEAN DEFAULT FALSE;

-- Обновить значение столбца 'Премиум' для пользователей с почтой '@gmail.com'
UPDATE Пользователь
SET Премиум = TRUE
WHERE Электронная_почта LIKE '%@gmail.com';

SELECT * 
FROM Пользователь;

-- 3)
-- Вывести название лейбла и среднее количество скачиваний альбомов на лейбле, если среднее количество скачиваний выше 5000000.
SELECT 
    Лейбл.Название,
    AVG(Альбом.Количество_скачиваний) AS Среднее_количество_скачиваний
FROM 
    Лейбл
JOIN 
    Исполнитель ON Лейбл.id_лейбла = Исполнитель.id_лейбла
JOIN 
    Альбом ON Альбом.id_исполнителя = Исполнитель.id_исполнителя
GROUP BY Лейбл.Название HAVING AVG(Альбом.Количество_скачиваний) > 5000000 ORDER BY Среднее_количество_скачиваний DESC;

-- 4)
--Найти жанры со средним количеством скачиваний альбомов больше 5000000.
SELECT 
    Жанр.Название_жанра,
    AVG(Альбом.Количество_скачиваний) AS Среднее_количество_скачиваний
FROM 
    Жанр
JOIN 
    Принадлежит ON Жанр.id_жанра = Принадлежит.id_жанра
JOIN 
    Альбом ON Принадлежит.id_альбома = Альбом.id_альбома
GROUP BY 
    Жанр.Название_жанра
HAVING 
    AVG(Альбом.Количество_скачиваний) > 5000000;

-- 5) 
-- Вывести имена исполнителей и количество скачиваний всех их альбомов, где общее количество скачиваний всех альбомов больше среднего общего количества скачиваний для всех исполнителей.
SELECT 
    Имя_название,
    Общее_количество_скачиваний
FROM (
    SELECT 
        Исполнитель.Имя_название,
        SUM(Альбом.Количество_скачиваний) AS Общее_количество_скачиваний
    FROM 
        Исполнитель
    JOIN 
        Альбом ON Исполнитель.id_исполнителя = Альбом.id_исполнителя
    GROUP BY 
        Исполнитель.Имя_название
) AS Subquery
WHERE 
    Общее_количество_скачиваний > (SELECT AVG(Общ_кол) FROM (SELECT SUM(Количество_скачиваний) AS Общ_кол FROM Альбом GROUP BY id_исполнителя) AS Temp);

-- 6) 
-- Вывести исполнителя и название альбома с максимальной и минимальной датой выпуска.
SELECT 
    Исполнитель.Имя_название,
    Альбом.Название,
    Альбом.Дата_выпуска
FROM 
    Альбом
JOIN 
    Исполнитель ON Альбом.id_исполнителя = Исполнитель.id_исполнителя
WHERE 
    Альбом.Дата_выпуска = (SELECT MAX(Дата_выпуска) FROM Альбом)
    OR Альбом.Дата_выпуска = (SELECT MIN(Дата_выпуска) FROM Альбом);
    
-- 7)
-- Вывести название жанра и количество альбомов в этом жанре.
SELECT 
    Жанр.Название_жанра,
    COUNT(Принадлежит.id_альбома) AS Количество_альбомов
FROM 
    Жанр
JOIN 
    Принадлежит ON Жанр.id_жанра = Принадлежит.id_жанра
GROUP BY 
    Жанр.Название_жанра
ORDER BY 
    Количество_альбомов DESC;
    
-- 8)
-- Найти уникальные жанры и общее количество прослушиваний всех треков для этих жанров, отсортированных по убыванию количества прослушиваний.
SELECT DISTINCT
    Жанр.Название_жанра,
    SUM(Трек.Количество_прослушиваний) AS Общее_количество_прослушиваний
FROM 
    Трек
JOIN 
    Альбом ON Трек.id_альбома = Альбом.id_альбома
JOIN 
    Принадлежит ON Альбом.id_альбома = Принадлежит.id_альбома
JOIN 
    Жанр ON Принадлежит.id_жанра = Жанр.id_жанра
GROUP BY 
    Жанр.Название_жанра
ORDER BY 
    Общее_количество_прослушиваний DESC;
    
-- 9)
-- Найти уникальных пользователей и среднюю длительность всех треков, которые они слушают, отсортированных по возрастанию средней длительности.
SELECT DISTINCT
    Пользователь.Логин,
    AVG((strftime('%s', Трек.Длительность) - strftime('%s', '00:00:00'))) AS Средняя_длительность_в_секундах
FROM 
    Слушает
INNER JOIN 
    Пользователь ON Слушает.id_пользователя = Пользователь.id_пользователя
INNER JOIN 
    Трек ON Слушает.id_трека = Трек.id_трека
GROUP BY 
    Пользователь.Логин
ORDER BY 
    Средняя_длительность_в_секундах ASC;
    
-- 10)
-- Найти исполнителей, у которых хотя бы один альбом имеет количество скачиваний выше среднего количества скачиваний всех альбомов.
SELECT 
    Исполнитель.Имя_название,
    Альбом.Название AS Название_альбома,
    Альбом.Количество_скачиваний
FROM 
    Исполнитель
INNER JOIN 
    Альбом ON Исполнитель.id_исполнителя = Альбом.id_исполнителя
WHERE 
    Альбом.Количество_скачиваний > (
        SELECT 
            AVG(Количество_скачиваний) 
        FROM 
            Альбом
    );

-- 11) 
-- 1. Добавить новый столбец 'Количество_альбомов' в таблицу 'Исполнитель'
ALTER TABLE Исполнитель
ADD Количество_альбомов INT DEFAULT 0;

-- 2. Обновить столбец 'Количество_альбомов' количеством альбомов, выпущенных каждым исполнителем
UPDATE 
    Исполнитель
SET 
    Количество_альбомов = (
        SELECT COUNT(*)
        FROM Альбом
        WHERE Альбом.id_исполнителя = Исполнитель.id_исполнителя
    );
    
SELECT * 
FROM Исполнитель;

-- 12)
-- Найти стриминговые площадки, на которых выпущены альбомы исполнителей, у которых средняя длительность треков выше средней длительности всех треков во всех альбомах, и количество скачиваний этих альбомов больше среднего количества скачиваний всех альбомов. Отсортировать результаты по названию стриминговой платформы.
SELECT 
    Стриминговая_площадка.Название AS Платформа,
    Исполнитель.Имя_название AS Исполнитель,
    Альбом.Название AS Альбом,
    AVG((strftime('%s', Трек.Длительность) - strftime('%s', '00:00:00'))) AS Средняя_длительность_в_секундах,
    Альбом.Количество_скачиваний
FROM 
    Выпущен_на
INNER JOIN 
    Стриминговая_площадка ON Выпущен_на.id_стриминговой_площадки = Стриминговая_площадка.id_стриминговой_площадки
INNER JOIN 
    Альбом ON Выпущен_на.id_альбома = Альбом.id_альбома
INNER JOIN 
    Исполнитель ON Альбом.id_исполнителя = Исполнитель.id_исполнителя
INNER JOIN 
    Трек ON Альбом.id_альбома = Трек.id_альбома
GROUP BY 
    Платформа, Исполнитель, Альбом
HAVING 
    AVG((strftime('%s', Трек.Длительность) - strftime('%s', '00:00:00'))) > (
        SELECT AVG((strftime('%s', Длительность) - strftime('%s', '00:00:00')))
        FROM Трек
    )
    AND Альбом.Количество_скачиваний > (
        SELECT AVG(Количество_скачиваний)
        FROM Альбом
    )
ORDER BY 
    Платформа;


