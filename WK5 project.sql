
create database WK5_Project
use WK5_Project
select * from spotify_dataset

---- Spotify Top 200 Charts (2020-2021)----------------------------------------------------------------------------------------------

--Dropping columns:
ALTER TABLE Spotify_dataset DROP COLUMN Song_ID
ALTER TABLE Spotify_dataset DROP COLUMN Danceability, Energy, Loudness, Speechiness
Alter table spotify_dataset drop column Acousticness, Liveness, Tempo, Valence, Chord, Popularity
--------------

--- FOCUSING ON THE FIRST 100 ranks ---
--- creating a top 100 table:
CREATE TABLE Top_100(                 
    [Ranking]   INT,                   
   Song_Name VARCHAR (Max),            -- had to max these out since (50) was not enough
   Artist  VARCHAR (Max),            
   Streams  INT,
   Release_Date  VARCHAR(50),
   Weeks_Charted VARCHAR(Max),
   Duration_ms int,
   PRIMARY KEY ([Ranking])
);
INSERT INTO Top_100 
SELECT [Index],Song_Name,Artist,Streams,Release_Date,Weeks_Charted,Duration_ms
   FROM Spotify_dataset
   WHERE [Index] < 101
------------------------
select * from Top_100
------------------------

--Converted duration(milliseconds) to minutes: ----------------------------------------

ALTER TABLE Spotify_dataset ADD Song_mins int;				
UPDATE Spotify_dataset SET Song_mins = Cast(Duration_ms as float)/60000;

ALTER TABLE Top_100 ADD Song_mins int;				
UPDATE Top_100 SET Song_mins = Cast(Duration_ms as float)/60000;

--Select statement provides the decimals: but did not work when adding it as column --

select Song_Name, Artist, Cast(duration_ms as float) / 60000 as Song_mins    ----can i round it 2 d.p?
FROM spotify_dataset;

---------------------------------------------------------------------------------------
select * from spotify_dataset
select * from Top_100
alter table top_100 drop column duration_ms
--------------------------------------------------------------------------------------

--DateDiff for weeks_charted: (new:Weeks_since_release) -------------------------------

ALTER TABLE Top_100 ADD Weeks_since_release int;				
UPDATE Top_100 SET Weeks_since_release = DATEDIFF(WEEK, '2017/12/08' , '2021/07/30') where Ranking = 1  -- ended up changing all
UPDATE Top_100 SET Weeks_since_release = '19' Where Ranking = 10                       -- manually changed some // need to find code for shortcut

select DATEDIFF(WEEK, '2021/06/04', '2021/07/30')  -- the amount of weeks. temp.

---------------------------------------------------------------------------------------
--Replace stream values to their closest Million -----------------------------------------
UPDATE Top_100                               
SET Streams_in_millions= REPLACE(Streams_in_Millions, '40162559', '40') -- manually possible. could not code it for all via update

---View streams to its closest M:
SELECT Ranking, Song_Name, Artist, (Streams/1000000) as Streams_in_Millions     --- This codes it for all but its only viewing
From Top_100
------------------------------------------------------------------------------------------
select * from Top_100
---------------------------------------------------------------------------------------
select COUNT(Distinct Genre) as Types_of_Genres, COUNT(distinct Artist) as Types_of_Artists     --- there are 394 distinct types of genres out of 1555 
From spotify_dataset                                                                            --- there are 716 artists
----------------------------------------------------------------------------------------
--- Checking amount of songs No1 artist & its ranking ---
Select Ranking,Song_Name,Artist,Streams,Weeks_since_release							
from Top_100
where Artist ='Måneskin';

--- Most appeared Artist in Top_100:
select Artist, COUNT(artist) AS Amount_of_songs       -- Olivia Rodrigo with 8 songs in top100 //
from Top_100
GROUP BY Artist
ORDER BY COUNT(Artist) DESC

Select Ranking,Song_Name,Artist,Streams,Weeks_since_release							
from Top_100
where Artist ='Olivia Rodrigo';

--- Most appeared Artist in main database:
select Artist, COUNT(artist) AS Amount_of_songs       -- Taylor Swift w/ 52
from Spotify_dataset
GROUP BY Artist
ORDER BY COUNT(Artist) DESC

--- Most frequent genre:
select Genre, COUNT(genre) AS Most_frequent_genre      -- Dance pop music did the best throughout the ranking (2020-2021) w/ 71 (17%)
from Spotify_dataset                                   -- 75 songs decided that they did not want to be labelled
GROUP BY Genre
ORDER BY COUNT(Genre) DESC

select * from Top_100

--- Avg streams per artist in Top100:
SELECT Artist,AVG(Streams) as Avg_streams             -- Ed Sheeran: 37.7mill (w/ only 1 song in the top100)
FROM Top_100                                          
Group by Artist
Order by AVG(Streams) desc

--- 28.5 biebs [highest avg. within main]
SELECT Artist,AVG(Streams) as Avg_streams             
FROM Spotify_dataset                                          
Group by Artist
Order by AVG(Streams) desc





--- the end ---



--------------------------------------------------------------------------------------------------------------------------------------------------------


-- which artist appears the most in top_100? which artist has most streams altogether?
--- make a new column, calculating days&weeks since release date to first week of charting
--- need to separate weeks charted to left join & right ---
--- will need to make a new column(or 2) beside it: week starting from & week ending
--- turn streams(int?) into text (4million plus)? -- maybe use replace streams>4000000 to "4mill plus"?
---- if i can manage the above, then change artist followers too, to mills
--- Experiment with view -- worth using it for this?

