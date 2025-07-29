-- Sample Data for CineMatch

-- Users
INSERT INTO Users (username, email) VALUES
('alice', 'alice@example.com'),
('bob', 'bob@example.com'),
('carol', 'carol@example.com'),
('dave', 'dave@example.com'),
('eve', 'eve@example.com');

-- Genres
INSERT INTO Genres (genre_name) VALUES
('Action'),
('Comedy'),
('Drama'),
('Sci-Fi'),
('Horror');

-- Movies
INSERT INTO Movies (title, release_year, duration, genre_id) VALUES
('The Last Stand', 2015, 120, 1),
('Laugh Out Loud', 2018, 95, 2),
('Tears of the Sun', 2017, 110, 3),
('Space Odyssey', 2019, 130, 4),
('Nightmare Alley', 2020, 105, 5),
('Action Heroes', 2016, 125, 1),
('Funny Bones', 2019, 100, 2),
('Family Ties', 2018, 115, 3),
('Galactic Quest', 2021, 140, 4),
('Haunted House', 2022, 90, 5);

-- Tags
INSERT INTO Tags (tag_name) VALUES
('Epic'),
('Romantic'),
('Thriller'),
('Classic'),
('Family'),
('Adventure');

-- Movie_Tags
INSERT INTO Movie_Tags (movie_id, tag_id) VALUES
(1, 1), (1, 6),
(2, 2), (2, 4),
(3, 3),
(4, 1), (4, 6),
(5, 3),
(6, 1), (6, 4),
(7, 2), (7, 5),
(8, 5),
(9, 6),
(10, 3);

-- Ratings
INSERT INTO Ratings (user_id, movie_id, rating, rating_date) VALUES
(1, 1, 5, '2023-01-10'),
(1, 2, 4, '2023-01-12'),
(1, 3, 3, '2023-01-15'),
(2, 1, 4, '2023-01-11'),
(2, 4, 5, '2023-01-13'),
(2, 5, 2, '2023-01-16'),
(3, 2, 5, '2023-01-12'),
(3, 3, 4, '2023-01-15'),
(3, 6, 3, '2023-01-18'),
(4, 4, 4, '2023-01-14'),
(4, 7, 5, '2023-01-19'),
(4, 8, 3, '2023-01-20'),
(5, 5, 5, '2023-01-17'),
(5, 9, 4, '2023-01-21'),
(5, 10, 2, '2023-01-22'); 