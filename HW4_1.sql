
-- ДЗ 4


--1 количество исполнителей в каждом жанре;

SELECT genre_id, COUNT(singer_id) FROM SingerGenre
GROUP BY genre_id;



--2 средняя продолжительность треков по каждому альбому;

SELECT album_id, AVG(duration) FROM Track
GROUP BY album_id;



--3 количество треков, вошедших в альбомы 2019-2020 годов;

SELECT year_of_release, COUNT(duration) FROM Track t
LEFT JOIN Album a ON t.album_id = a.id
where a.year_of_release IN ('2019', '2020')
GROUP BY a.year_of_release;


   
--4 все исполнители, которые не выпустили альбомы в 2020 году;

SELECT s.name FROM Singer s
where s.name not IN (
	SELECT s.name FROM Singer s
	JOIN SingerAlbum sa ON s.id = sa.singer_id
	JOIN Album a ON sa.album_id = a.id
	where a.year_of_release IN ('2020')
);



--5 названия сборников, в которых присутствует конкретный исполнитель (выберите сами);
--Лобода
SELECT s.name, c.name, t.name FROM Compilation c
JOIN Track t ON c.track_id = t.id
JOIN Album a ON t.album_id = a.id
JOIN SingerAlbum sa ON a.id = sa.id
JOIN Singer s ON sa.singer_id = s.id
where s.name IN ('Лобода');

   
   
--6 название альбомов, в которых присутствуют исполнители более 1 жанра;
-- возможно, имелось ввиду "название СБОРНИКОВ, в которых присутствуют исполнители более 1 жанра"   
-- в данном случае: в 1 альбоме 1 исполнитель и он в 1 жанре


SELECT a.name, s.name, g.name, COUNT(g.name) FROM Album a
JOIN SingerAlbum sa ON a.id = sa.id
left JOIN Singer s ON sa.singer_id = s.id
left JOIN SingerGenre sg ON s.id = sg.singer_id
left JOIN Genre g ON sg.genre_id = g.id
GROUP BY a.name, s.name, g.name 
having COUNT(g.name) > 1;

   
--7 наименование треков, которые не входят в сборники;
   
SELECT t.name, c.name  FROM Compilation c
right JOIN Track t ON c.track_id = t.id
where c.name is null;

   
--8 исполнителя(-ей), написавшего самый короткий по продолжительности трек (теоретически таких треков может быть несколько);
SELECT s.name, t.name,  min(t.duration) FROM Track t
JOIN Album a ON t.album_id = a.id
JOIN SingerAlbum sa ON a.id = sa.id
JOIN Singer s ON sa.singer_id = s.id
WHERE t.duration = (SELECT min(duration) FROM Track t)
GROUP BY s.name,t.name; 


--9 название альбомов, содержащих наименьшее количество треков.

SELECT a.name, count_t from (
	SELECT t.album_id, COUNT(t.album_id) count_t FROM Track t
	GROUP BY t.album_id
	) as ac
JOIN Album a ON a.id = ac.album_id 
GROUP BY a.name, ac.count_t
HAVING count_t = (
	SELECT MIN(my_count) FROM (
		SELECT album_id, count(album_id) my_count 
		FROM track GROUP BY album_id
	) as am
);
	

	
