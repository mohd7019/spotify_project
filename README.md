# spotify_project

![Database Schema Screenshot](dataset_spotify/spotify-logo-1024x651.webp)


# 🎵 Spotify Tracks & Performance Data Analysis

A complete SQL project analyzing Spotify tracks, artist popularity, and song performance using **PostgreSQL**. This project answers real-world business questions and music analytics using SQL techniques ranging from basic aggregations to advanced window functions.

---

## 📂 Dataset Overview

**Table Name:** `spotify`

| Column              | Data Type    | Description                                 |
|---------------------|-------------|---------------------------------------------|
| artist              | VARCHAR(255) | Artist name                                |
| track               | VARCHAR(255) | Track name                                 |
| album               | VARCHAR(255) | Album name                                 |
| album_type          | VARCHAR(50)  | Album type (e.g., album, single)           |
| danceability        | FLOAT        | Danceability score (0.0 to 1.0)            |
| energy              | FLOAT        | Energy score (0.0 to 1.0)                  |
| loudness            | FLOAT        | Loudness in dB                             |
| speechiness         | FLOAT        | Speechiness score                          |
| acousticness        | FLOAT        | Acousticness score                         |
| instrumentalness    | FLOAT        | Instrumentalness score                     |
| liveness            | FLOAT        | Liveness score                             |
| valence             | FLOAT        | Musical positivity score                   |
| tempo               | FLOAT        | Tempo (BPM)                                |
| duration_min        | FLOAT        | Duration of track in minutes               |
| title               | VARCHAR(255) | Title of track                             |
| channel             | VARCHAR(255) | Publishing channel                         |
| views               | FLOAT        | Total views (YouTube, Spotify, etc.)       |
| likes               | BIGINT       | Total likes                                |
| comments            | BIGINT       | Total comments                             |
| licensed            | BOOLEAN      | License status (TRUE/FALSE)                |
| official_video      | BOOLEAN      | Official video (TRUE/FALSE)                |
| stream              | BIGINT       | Total streams                              |
| energy_liveness     | FLOAT        | Precomputed energy-liveness ratio          |
| most_played_on      | VARCHAR(50)  | Platform where song is most played         |

---

## 📈 Business & Analytical Questions Solved

### 🎯 Easy Level:
- Total streams, unique artists, unique albums.
- Tracks with more than 1 billion streams.
- Total comments on licensed tracks.
- List of singles and albums.
- Total tracks per artist.

### 🎯 Medium Level:
- Average danceability per album.
- Top 5 highest energy tracks.
- Total views/likes of official videos.
- Track-level comparison between YouTube vs. Spotify streams.
- Album-wise total views.

### 🎯 Advanced Level:
- **Top 3 most-viewed tracks per artist (Window Function).**
- Tracks with liveness above average.
- Energy difference across albums using `WITH` clause.
- Songs with energy-to-liveness ratio > 1.2.
- Cumulative likes ordered by views.
- Analysis: Do high-energy songs perform better than low-energy ones?

---

## 🛠 SQL Techniques Used

- `COUNT()`, `SUM()`, `MAX()`, `AVG()`, `ROUND()`
- `GROUP BY`, `ORDER BY`, `LIMIT`, `HAVING`
- `CASE` statements for classification
- `COALESCE()` and `NULLIF()` handling
- String functions: `LIKE`, `%`, `ILIKE`
- **Window Functions:** `DENSE_RANK()`, `SUM() OVER()`
- **CTEs (Common Table Expressions):** using `WITH`
- Subqueries and derived tables

---

## 📊 Sample Query Insight

**Top 3 Most Viewed Tracks Per Artist (Window Function Example):**

```sql
WITH ranking_artist AS (
    SELECT
        artist,
        track,
        SUM(views) AS total_view,
        DENSE_RANK() OVER (PARTITION BY artist ORDER BY SUM(views) DESC) AS rank
    FROM spotify
    GROUP BY artist, track
)
SELECT *
FROM ranking_artist
WHERE rank <= 3;

------------------------------------------------------------------------------------------------------------
Layout
------------------------------------------------------------------------------------------------------------
project/
├── create_table.sql
├── spotify_analysis_queries.sql
├── README.md
└── screenshots/      # (Optional) Query result images



**How to Run This Project**

Create Table

sql
Copy
Edit
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
Import Dataset (use CSV import in pgAdmin or PostgreSQL tools).

Execute Queries from spotify_analysis_queries.sql.

💡 Insights from the Project
Analyze artist performance using streaming data.

Identify high-performing songs and albums.

Classify songs based on energy, liveness, and descriptive metrics.

Compare platform-specific popularity (YouTube vs. Spotify).

Use advanced SQL techniques for real-time business questions.


