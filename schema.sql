-- CineMatch Database Schema (PostgreSQL)

-- 1. Users
CREATE TABLE Users (
    user_id SERIAL PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    email VARCHAR(100) NOT NULL UNIQUE,
    registration_date DATE NOT NULL DEFAULT CURRENT_DATE
);

-- 2. Genres
CREATE TABLE Genres (
    genre_id SERIAL PRIMARY KEY,
    genre_name VARCHAR(50) NOT NULL UNIQUE
);

-- 3. Movies
CREATE TABLE Movies (
    movie_id SERIAL PRIMARY KEY,
    title VARCHAR(200) NOT NULL,
    release_year INT,
    duration INT, -- in minutes
    genre_id INT REFERENCES Genres(genre_id)
);

-- 4. Tags
CREATE TABLE Tags (
    tag_id SERIAL PRIMARY KEY,
    tag_name VARCHAR(50) NOT NULL UNIQUE
);

-- 5. Movie_Tags (many-to-many)
CREATE TABLE Movie_Tags (
    movie_id INT REFERENCES Movies(movie_id) ON DELETE CASCADE,
    tag_id INT REFERENCES Tags(tag_id) ON DELETE CASCADE,
    PRIMARY KEY (movie_id, tag_id)
);

-- 6. Ratings
CREATE TABLE Ratings (
    rating_id SERIAL PRIMARY KEY,
    user_id INT REFERENCES Users(user_id) ON DELETE CASCADE,
    movie_id INT REFERENCES Movies(movie_id) ON DELETE CASCADE,
    rating INT CHECK (rating >= 1 AND rating <= 5),
    rating_date DATE NOT NULL DEFAULT CURRENT_DATE,
    UNIQUE (user_id, movie_id)
); 