CREATE DATABASE IF NOT EXISTS oraksil;

GRANT ALL PRIVILEGES ON oraksil.* TO 'oraksil'@'%' identified by 'oraksil';

USE oraksil;

CREATE TABLE pack (
    id INT NOT NULL AUTO_INCREMENT,
    status INT NOT NULL,
    title VARCHAR(64) NOT NULL,
    maker VARCHAR(64) NOT NULL,
    description text,
    max_players INT, 
    poster_url text,
    rom_name VARCHAR(16),

    PRIMARY KEY (id)
) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

CREATE TABLE player (
    id BIGINT NOT NULL AUTO_INCREMENT,
    name VARCHAR(64) NOT NULL,
    total_coins_used INT,
    coins_used_in_charging INT,
    charging_started_at TIMESTAMP,

    PRIMARY KEY (id)
) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

CREATE TABLE game (
    id BIGINT NOT NULL AUTO_INCREMENT,
    pack_id INT NOT NULL,
    orakki_id VARCHAR(128) NOT NULL,
    orakki_state INT NOT NULL,
    first_player_id BIGINT NOT NULL,
    joined_player_ids VARCHAR(128),
    created_at TIMESTAMP,
    
    PRIMARY KEY (id),
    FOREIGN KEY (first_player_id) REFERENCES player(id)
) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

CREATE TABLE signaling (
    id BIGINT NOT NULL AUTO_INCREMENT,
    token VARCHAR(24) NOT NULL,
    game_id BIGINT NOT NULL,
    player_id BIGINT NOT NULL,
    data VARCHAR(8196),
    created_at TIMESTAMP,

    PRIMARY KEY (id),
    FOREIGN KEY (game_id) REFERENCES game(id)
) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

CREATE TABLE feedback (
    id BIGINT NOT NULL AUTO_INCREMENT,
    content VARCHAR(512) NOT NULL,
    created_at TIMESTAMP,

    PRIMARY KEY (id)
) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

INSERT INTO pack (status, title, maker, description, max_players, poster_url, rom_name)
VALUES
    (0, 'Tekken 3', 'NAMCO', 'Tekken 3 (鉄拳3) is a fighting game, the third installment in the Tekken series.', 2, '/public/images/tekken3.png', 'tekken3'),
    (1, 'Bobl Bubl', 'TAITO', '', 2, '/public/images/bublbobl.png', 'bublbobl'),
    (1, 'Cadilacs Dinosours', 'Capcom', "It is a side-scrolling beat 'em up based on the comic book series Xenozoic Tales. The game was produced as a tie-in to the short-lived Cadillacs and Dinosaurs animated series which was aired during the same year the game was released.", 3, '/public/images/dino.png', 'dino'),
    (0, 'Final Fight II', 'Capcom', '', 3, '/public/images/ffight2b.png', 'ffight2b'),
    (1, 'Metal Slug', 'SNK', '', 2, '/public/images/mslug.png', 'mslug'),
    (1, 'The King of Fighters 97', 'SNK', '', 2, '/public/images/kof97pls.png', 'kof97pls'),
    (0, 'Super Tank', 'Video Games GmbH', '', 2, '/public/images/supertnk.png', 'supertnk');
