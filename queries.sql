-- Example Queries for CineMatch

-- 1. Top Rated Movies by Genre
SELECT g.genre_name, m.title, AVG(r.rating) AS avg_rating
FROM Movies m
JOIN Genres g ON m.genre_id = g.genre_id
JOIN Ratings r ON m.movie_id = r.movie_id
GROUP BY g.genre_name, m.title
HAVING COUNT(r.rating) > 2 -- Lowered for sample data
ORDER BY avg_rating DESC;

-- 2. Personalized Recommendations: Movies in User's Favorite Genre
-- (Find user's favorite genre, then recommend top movies in that genre)
WITH fav_genre AS (
  SELECT g.genre_id, g.genre_name, COUNT(*) AS cnt
  FROM Ratings r
  JOIN Movies m ON r.movie_id = m.movie_id
  JOIN Genres g ON m.genre_id = g.genre_id
  WHERE r.user_id = 1 -- Change to target user
  GROUP BY g.genre_id, g.genre_name
  ORDER BY cnt DESC
  LIMIT 1
)
SELECT m.title, g.genre_name, AVG(r.rating) AS avg_rating
FROM Movies m
JOIN Genres g ON m.genre_id = g.genre_id
LEFT JOIN Ratings r ON m.movie_id = r.movie_id
WHERE m.genre_id = (SELECT genre_id FROM fav_genre)
GROUP BY m.title, g.genre_name
ORDER BY avg_rating DESC NULLS LAST;

-- 3. "Users Like You Also Watched"
-- (Find users with similar ratings, then movies they liked that you haven't seen)
WITH user_movies AS (
  SELECT movie_id FROM Ratings WHERE user_id = 1
),
similar_users AS (
  SELECT r2.user_id
  FROM Ratings r1
  JOIN Ratings r2 ON r1.movie_id = r2.movie_id AND r1.rating = r2.rating
  WHERE r1.user_id = 1 AND r2.user_id != 1
  GROUP BY r2.user_id
  ORDER BY COUNT(*) DESC
  LIMIT 3
)
SELECT DISTINCT m.title
FROM Ratings r
JOIN Movies m ON r.movie_id = m.movie_id
WHERE r.user_id IN (SELECT user_id FROM similar_users)
  AND r.rating >= 4
  AND r.movie_id NOT IN (SELECT movie_id FROM user_movies);

-- 4. Trending Now: Most Rated Movies in the Past Month
SELECT m.title, COUNT(r.rating_id) AS num_ratings
FROM Ratings r
JOIN Movies m ON r.movie_id = m.movie_id
WHERE r.rating_date >= CURRENT_DATE - INTERVAL '30 days'
GROUP BY m.title
ORDER BY num_ratings DESC
LIMIT 5;

-- 5. Search Engine: Search by Title, Genre, or Tag
-- (Search for movies with 'Quest' in title, genre, or tag)
SELECT DISTINCT m.title, g.genre_name, t.tag_name
FROM Movies m
JOIN Genres g ON m.genre_id = g.genre_id
LEFT JOIN Movie_Tags mt ON m.movie_id = mt.movie_id
LEFT JOIN Tags t ON mt.tag_id = t.tag_id
WHERE m.title ILIKE '%Quest%'
   OR g.genre_name ILIKE '%Quest%'
   OR t.tag_name ILIKE '%Quest%'; 