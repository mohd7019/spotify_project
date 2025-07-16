-- create table

CREATE TABLE spotify (
    artist VARCHAR(255),
    track VARCHAR(255),
    album VARCHAR(255),
    album_type VARCHAR(50),
    danceability FLOAT,
    energy FLOAT,
    loudness FLOAT,
    speechiness FLOAT,
    acousticness FLOAT,
    instrumentalness FLOAT,
    liveness FLOAT,
    valence FLOAT,
    tempo FLOAT,
    duration_min FLOAT,
    title VARCHAR(255),
    channel VARCHAR(255),
    views FLOAT,
    likes BIGINT,
    comments BIGINT,
    licensed BOOLEAN,
    official_video BOOLEAN,
    stream BIGINT,
    energy_liveness FLOAT,
    most_played_on VARCHAR(50)
);

SELECT COUNT(*) FROM SPOTIFY;

SELECT COUNT(DISTINCT ARTIST) FROM SPOTIFY;

SELECT COUNT(DISTINCT ALBUM) FROM SPOTIFY;

SELECT DISTINCT ALBUM_TYPE FROM SPOTIFY;

SELECT DURATION_MIN FROM SPOTIFY;

SELECT MAX(DURATION_MIN) FROM SPOTIFY;

SELECT DURATION_MIN FROM SPOTIFY
WHERE DURATION_MIN = 0;

DELETE FROM SPOTIFY 
WHERE DURATION_MIN = 0;

SELECT DISTINCT CHANNEL
FROM SPOTIFY;

SELECT most_played_on
FROM SPOTIFY;

SELECT *
FROM SPOTIFY
WHERE most_played_on = 'Youtube';

--TOP SONG BEEN PLAYED

SELECT artist , title
FROM SPOTIFY
WHERE most_played_on = 'Youtube'
ORDER BY  artist DESC
LIMIT 10;


---------------------------------------

EASY CATEGORY

---------------------------------------


--Q1. Retrieve the names of all tracks that have more than 1 billion streams.


SELECT track, stream
FROM SPOTIFY
where stream > 1000000000;

--Q2. List all albums along with their respective artists.

SELECT artist , album
FROM SPOTIFY;

SELECT distinct artist , album
FROM SPOTIFY;

select distinct album
from spotify
order by 1;


--suppose one album has two or more artist

SELECT artist, album
FROM SPOTIFY
WHERE artist LIKE '%,%';


--Q3. Get the total number of comments for tracks where licensed = TRUE.

select distinct licensed from spotify

SELECT sum(comments) as total_comments
from spotify
where licensed = true;

SELECT COUNT(comments)
from spotify
where licensed = true;


--Q4. Find all tracks that belong to the album type single.

select * from spotify

select track , album_type
from spotify
where album_type = 'single';

SELECT DISTINCT track
FROM spotify
WHERE album_type = 'single';



--Q5. Count the total number of tracks by each artist.

select artist --1 , count(track) as total_no_of_songs --2
from spotify 
group by artist;


--in desc

select artist  , count(track) as total_no_of_songs --2
from spotify 
group by artist
order by 2 desc;

--in asc

select artist  , count(track) as total_no_of_songs --2
from spotify 
group by artist
order by 2 ;



---------------------------------------

MEDIUM CATEGORY

---------------------------------------

--Q6. Calculate the average danceability of tracks in each album.


 SELECT album , avg(danceability)
 from spotify 
 group by album
 order by 2 desc;


 --Q7. Find the top 5 tracks with the highest energy values.

SELECT * FROM SPOTIFY;

select  track , max(energy)
from spotify
group by track
order by 2
limit 5



--Q8. List all tracks along with their views and likes where official_video = TRUE.


select track , sum(views) , sum(likes) 
from spotify
where official_video = true
group by 1
order by 2 desc
limit 5;



--Q9. For each album, calculate the total views of all associated tracks.
select * from spotify

select album , sum(views) , track
from spotify
group by 1 , 3
order by 2
limit 10


--Q10. Retrieve the track names that have been streamed on Spotify more than YouTube.

-- this is taking 128ms

SELECT * FROM
(
    SELECT
        track,
        --most_played_on,
        COALESCE(SUM(CASE WHEN most_played_on = 'Youtube' THEN stream END), 0) AS streamed_on_youtube,
        COALESCE(SUM(CASE WHEN most_played_on = 'Spotify' THEN stream END), 0) AS streamed_on_spotify
    FROM spotify
    GROUP BY 1
) AS tl
WHERE streamed_on_spotify > streamed_on_youtube
  AND streamed_on_youtube <> 0;


--track, most_played_on -- Selecting the song name and source platform.
--CASE WHEN	-- Conditional check:  if platform is YouTube or Spotify, sum streams accordingly.
--SUM(CASE WHEN ... THEN ... END)-- Aggregates total streams separately for YouTube and Spotify per track.
--COALESCE(..., 0) -- Handles NULL results by replacing them with 0  



--this is taking 198ms

SELECT
    track,
    SUM(CASE WHEN most_played_on = 'Youtube' THEN stream ELSE 0 END) AS streamed_on_youtube,
    SUM(CASE WHEN most_played_on = 'Spotify' THEN stream ELSE 0 END) AS streamed_on_spotify
FROM spotify
GROUP BY track
HAVING SUM(CASE WHEN most_played_on = 'Spotify' THEN stream ELSE 0 END)
       > SUM(CASE WHEN most_played_on = 'Youtube' THEN stream ELSE 0 END)
   AND SUM(CASE WHEN most_played_on = 'Youtube' THEN stream ELSE 0 END) <> 0
ORDER BY streamed_on_spotify DESC;


---------------------------------------

HIGH CATEGORY

---------------------------------------




--Q11. Find the top 3 most-viewed tracks for each artist using window functions.

--Window Function : Window functions let you perform calculations across rows related 
                  --to the current row — without grouping or collapsing the result like GROUP BY does.

select * from spotify

--breaking
--each artist and total views for each track
--track with highest views for each artist(we need top)
--dense rank
--ste and filder rank <= 3

select artist , track , sum(views)
from spotify
group by 1, 2

--adding order by

select artist , track , sum(views) as total_views , dense_rank over(partition by artist )
from spotify
group by 1, 2
order by 1, 3 --desc

--next add up -- using window function we are creating new cloumn with the help of that we wil do partition
              -- we are using dense rank as same artist could have multiple songs with same views 
			  -- so there is a possibility that some songs may have sam eranking 
			  

-- final query 

with ranking_artist
as
(SELECT
    artist,
    track,
    SUM(views) AS total_view,
    DENSE_RANK() OVER (PARTITION BY artist ORDER BY SUM(views) DESC) AS rank
FROM spotify
GROUP BY 1, 2
ORDER BY 1, 3 DESC)
select * from ranking_artist
where rank <=3

--what i have learned in this query

--How to apply window functions like DENSE_RANK.
--How to rank rows within a group (artist).
--How to aggregate views and rank tracks efficiently.


--Q12. Write a query to find tracks where the liveness score is above the average.
select * from spotify

select artist ,track , liveness
from spotify 
where liveness > (select avg(liveness)
from spotify);



--Q13. Use a WITH clause to calculate the difference between the highest and 
       --lowest energy values for tracks in each album.

with cte as 
(select album, max(energy) as highest_energy , min(energy) as lowest_energy
from spotify
group by 1)
select album, highest_energy - lowest_energy
from cte 
order by 2 desc;


------------------------------------


 SOME NEW UNDERSTANDING


------------------------------------



--Q14.Find tracks where the energy-to-liveness ratio is greater than 1.2.

SELECT Track,
       Artist,
       Energy,
       Liveness,
       ROUND(Energy / NULLIF(Liveness, 0), 2) AS energy_to_liveness_ratio
FROM spotify
WHERE (Energy / NULLIF(Liveness, 0)) > 1.2
ORDER BY energy_to_liveness_ratio DESC;

--NULLIF -- Prevent crashes from zero-divide errors (very common!).
--ROUND(Energy / NULLIF(Liveness, 0), 2):
--We’re dividing Energy by Liveness for each track.
--If Liveness = 0, SQL avoids dividing by zero (using NULLIF).
--ROUND(..., 2) means: After dividing, round the result to 2 decimal places (so the number is easier to read).
--AS energy_to_liveness_ratio: This is just naming the new column –
          --"Call this new number column 'energy_to_liveness_ratio'."

--Q15. Calculate the cumulative sum of likes for tracks ordered by the number of views, using window functions.

SELECT
    Track,
    Views,
    Likes,
    SUM(Likes) OVER (ORDER BY Views DESC) AS cumulative_likes
FROM spotify
ORDER BY Views DESC;


--Q16. Do high-energy songs perform better than low-energy ones?

SELECT CASE WHEN energy >= 0.5 THEN 'High Energy' ELSE 'Low Energy' END AS energy_band,
       ROUND(AVG(stream), 0) AS avg_streams_per_track, -- ROUND(..., 0): Rounds the result to 0 decimal places (no fractions).
       COUNT(*) AS total_tracks
FROM spotify
GROUP BY energy_band
ORDER BY avg_streams_per_track DESC;






			  






















