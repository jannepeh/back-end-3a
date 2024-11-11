-- tietokanta
CREATE DATABASE IF NOT EXISTS MediaSharingAppDB;
USE MediaSharingAppDB;

-- Taulujen luonti

-- Käyttäjät Table
CREATE TABLE Users (
    user_id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(50) UNIQUE NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    bio TEXT
);

-- Media Table
CREATE TABLE Media (
    media_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT,
    media_url VARCHAR(255) NOT NULL,
    media_type ENUM('image', 'video', 'audio'),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    description TEXT,
    FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE CASCADE
);

-- Kommentit Table
CREATE TABLE Comments (
    comment_id INT PRIMARY KEY AUTO_INCREMENT,
    media_id INT,
    user_id INT,
    comment_text TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (media_id) REFERENCES Media(media_id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE CASCADE
);

-- Tykkäykset Table
CREATE TABLE Likes (
    like_id INT PRIMARY KEY AUTO_INCREMENT,
    media_id INT,
    user_id INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (media_id) REFERENCES Media(media_id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE CASCADE
);

-- Seuraajat Table
CREATE TABLE Followers (
    follower_id INT PRIMARY KEY AUTO_INCREMENT,
    follower INT,
    following INT,
    FOREIGN KEY (follower) REFERENCES Users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (following) REFERENCES Users(user_id) ON DELETE CASCADE
);

-- Tags Table
CREATE TABLE Tags (
    tag_id INT PRIMARY KEY AUTO_INCREMENT,
    tag_name VARCHAR(50) UNIQUE NOT NULL
);

-- Media_Tags Table
CREATE TABLE Media_Tags (
    media_tag_id INT PRIMARY KEY AUTO_INCREMENT,
    media_id INT,
    tag_id INT,
    FOREIGN KEY (media_id) REFERENCES Media(media_id) ON DELETE CASCADE,
    FOREIGN KEY (tag_id) REFERENCES Tags(tag_id) ON DELETE CASCADE
);

-- Datan lisääminen tauluihin

-- Insert Käyttäjät
INSERT INTO Users (username, email, bio) VALUES 
('johndoe', 'johndoe@example.com', 'Photographer from NYC'),
('janedoe', 'janedoe@example.com', 'Videographer and traveler'),
('user123', 'user123@example.com', 'Love sharing nature photos');

-- Insert Media
INSERT INTO Media (user_id, media_url, media_type, description) VALUES 
(1, 'https://example.com/photo1.jpg', 'image', 'A beautiful sunset'),
(2, 'https://example.com/video1.mp4', 'video', 'Traveling through the mountains'),
(3, 'https://example.com/photo2.jpg', 'image', 'Peaceful forest scene');

-- Insert Kommentit
INSERT INTO Comments (media_id, user_id, comment_text) VALUES 
(1, 2, 'Amazing photo!'),
(2, 1, 'Looks beautiful!'),
(3, 2, 'Such a calming view');

-- Insert Tykkäykset
INSERT INTO Likes (media_id, user_id) VALUES 
(1, 2),
(2, 3),
(3, 1);

-- Insert Seuraajat
INSERT INTO Followers (follower, following) VALUES 
(1, 2),
(2, 3),
(3, 1);

-- Insert Tags
INSERT INTO Tags (tag_name) VALUES 
('sunset'),
('travel'),
('nature');

-- Insert Media_Tags
INSERT INTO Media_Tags (media_id, tag_id) VALUES 
(1, 1),
(2, 2),
(3, 3);

-- Kyselyt ja päivitykset esimerkkinä käytöstä

-- Suosituimmat media-postaukset (eniten tykkäyksiä)
SELECT Media.media_id, Media.media_url, COUNT(Likes.like_id) AS like_count
FROM Media
LEFT JOIN Likes ON Media.media_id = Likes.media_id
GROUP BY Media.media_id
ORDER BY like_count DESC;

-- Päivitä käyttäjän bio
UPDATE Users SET bio = 'Updated bio for more followers!' WHERE user_id = 1;

-- Poista tietty mediapostaus
DELETE FROM Media WHERE media_id = 1;
