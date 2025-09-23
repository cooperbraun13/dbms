/*======================================================================
 * 
 *  NAME:    Cooper Braun
 *  ASSIGN:  HW-2, Question 3
 *  COURSE:  CPSC 321, Fall 2025
 *  DESC:    Music schema (albums, tracks, songs, groups, members, 
 *           genres, labels) with constraints, sample data, and
 *           commented failing INSERTs for validation.
 * 
 *======================================================================*/

-- clean recreate (drop in foreign key dependency order)
DROP TABLE IF EXISTS album_track CASCADE;
DROP TABLE IF EXISTS track_contributor CASCADE;
DROP TABLE IF EXISTS track CASCADE;
DROP TABLE IF EXISTS song_writer CASCADE;
DROP TABLE IF EXISTS song CASCADE;
DROP TABLE IF EXISTS membership CASCADE;
DROP TABLE IF EXISTS influence CASCADE;
DROP TABLE IF EXISTS group_genre CASCADE;
DROP TABLE IF EXISTS album CASCADE;
DROP TABLE IF EXISTS musician CASCADE;
DROP TABLE IF EXISTS label CASCADE;
DROP TABLE IF EXISTS genre CASCADE;
DROP TABLE IF EXISTS music_group CASCADE;

-- music_group table:
CREATE TABLE music_group (
  group_name   VARCHAR(100),
  year_formed  INTEGER NOT NULL,
  PRIMARY KEY (group_name)
);

-- genre table:
CREATE TABLE genre (
  genre_label  VARCHAR(50),
  description  VARCHAR(200) NOT NULL,
  PRIMARY KEY (genre_label)
);

-- label table:
CREATE TABLE label (
  name VARCHAR(100),
  PRIMARY KEY (name)
);

-- musician table:
CREATE TABLE musician (
  first_name  VARCHAR(50) NOT NULL,
  last_name   VARCHAR(50) NOT NULL,
  stage_name  VARCHAR(100),
  birth_year  INTEGER,
  PRIMARY KEY (first_name, last_name)
  CONSTRAINT unique_stage_name UNIQUE (stage_name)
);

-- group_genre table:
CREATE TABLE group_genre (
  group_name   VARCHAR(100) NOT NULL,
  genre_label  VARCHAR(50)  NOT NULL,
  PRIMARY KEY (group_name, genre_label),
  FOREIGN KEY (group_name)  REFERENCES music_group(group_name),
  FOREIGN KEY (genre_label) REFERENCES genre(genre_label)
);

-- influence table:
CREATE TABLE influence (
  influencer_group VARCHAR(100) NOT NULL,
  influenced_group VARCHAR(100) NOT NULL,
  PRIMARY KEY (influencer_group, influenced_group),
  FOREIGN KEY (influencer_group) REFERENCES music_group(group_name),
  FOREIGN KEY (influenced_group) REFERENCES music_group(group_name),
  CONSTRAINT influencee_equals_influencer CHECK (influencer_group <> influenced_group)
);

-- membership table:
CREATE TABLE membership (
  group_name  VARCHAR(100) NOT NULL,
  first_name  VARCHAR(50)  NOT NULL,
  last_name   VARCHAR(50)  NOT NULL,
  start_year  INTEGER      NOT NULL,
  end_year    INTEGER,
  PRIMARY KEY (group_name, first_name, last_name),
  FOREIGN KEY (group_name)                 REFERENCES music_group(group_name),
  FOREIGN KEY (first_name, last_name)      REFERENCES musician(first_name, last_name),
  CONSTRAINT valid_end_year CHECK (end_year IS NULL OR end_year >= start_year)
);

-- song table:
CREATE TABLE song (
  title         VARCHAR(100) PRIMARY KEY,
  year_written  INTEGER NOT NULL
);

-- song_writer table:
CREATE TABLE song_writer (
  song_title  VARCHAR(100) NOT NULL,
  first_name  VARCHAR(50)  NOT NULL,
  last_name   VARCHAR(50)  NOT NULL,
  PRIMARY KEY (song_title, first_name, last_name),
  FOREIGN KEY (song_title)            REFERENCES song(title),
  FOREIGN KEY (first_name, last_name) REFERENCES musician(first_name, last_name)
);

-- track table:
CREATE TABLE track (
  track_id       INTEGER      PRIMARY KEY,  -- unique numeric track identifier
  song_title     VARCHAR(100) NOT NULL,
  year_recorded  INTEGER      NOT NULL,
  FOREIGN KEY (song_title) REFERENCES song(title)
);

-- track_contributor table:
CREATE TABLE track_contributor (
  track_id    INTEGER     NOT NULL,
  first_name  VARCHAR(50) NOT NULL,
  last_name   VARCHAR(50) NOT NULL,
  PRIMARY KEY (track_id, first_name, last_name),
  FOREIGN KEY (track_id)               REFERENCES track(track_id),
  FOREIGN KEY (first_name, last_name)  REFERENCES musician(first_name, last_name)
);

-- album table:
CREATE TABLE album (
  group_name     VARCHAR(100) NOT NULL,
  title          VARCHAR(100) NOT NULL,
  year_recorded  INTEGER      NOT NULL,
  label_name     VARCHAR(100) NOT NULL,
  PRIMARY KEY (group_name, title),
  FOREIGN KEY (group_name)  REFERENCES music_group(group_name),
  FOREIGN KEY (label_name)  REFERENCES label(name)
);

-- album_track table:
CREATE TABLE album_track (
  group_name    VARCHAR(100) NOT NULL,
  album_title   VARCHAR(100) NOT NULL,
  track_id      INTEGER      NOT NULL,
  track_number  INTEGER      NOT NULL,
  PRIMARY KEY (group_name, album_title, track_id),
  FOREIGN KEY (group_name, album_title) REFERENCES album(group_name, title),
  FOREIGN KEY (track_id)                REFERENCES track(track_id),
  CONSTRAINT unique_group_and_album UNIQUE (group_name, album_title, track_number),
  CONSTRAINT at_least_one_track CHECK (track_number >= 1)
);