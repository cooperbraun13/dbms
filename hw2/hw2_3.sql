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
  PRIMARY KEY (first_name, last_name),
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

-- groups
INSERT INTO music_group VALUES
  ('Radiohead', 1985),
  ('Fleetwood Mac', 1967),
  ('Nirvana', 1987),
  ('Daft Punk', 1993);

-- genres
INSERT INTO genre VALUES
  ('alternative rock', 'Guitar-driven alt rock styles from the 80s/90s onward'),
  ('rock',             'Rock and roll and its subgenres'),
  ('grunge',           'Heavier, fuzzed, punk-influenced alt rock from the PNW'),
  ('electronic',       'Electronic dance and listening styles'),
  ('synth-pop',        'Pop music with heavy use of synthesizers');

-- labels
INSERT INTO label VALUES
  ('Parlophone'),
  ('A&M'),
  ('DGC'),
  ('Virgin');

-- musicians
INSERT INTO musician VALUES
  ('Thom','Yorke',       NULL, 1968),
  ('Jonny','Greenwood',  NULL, 1971),
  ('Lindsey','Buckingham', NULL, 1949),
  ('Stevie','Nicks',     NULL, 1948),
  ('Kurt','Cobain',      NULL, 1967),
  ('Krist','Novoselic',  NULL, 1965),
  ('Dave','Grohl',       NULL, 1969),
  ('Thomas','Bangalter', NULL, 1975),
  ('Guy-Manuel','de Homem-Christo', NULL, 1974);

-- group_genre
INSERT INTO group_genre VALUES
  ('Radiohead','alternative rock'),
  ('Fleetwood Mac','rock'),
  ('Nirvana','grunge'),
  ('Daft Punk','electronic'),
  ('Daft Punk','synth-pop');

-- influence
INSERT INTO influence VALUES
  ('Fleetwood Mac','Radiohead'),
  ('Nirvana','Radiohead'),
  ('Radiohead','Daft Punk');

-- membership (artist in group during year ranges)
INSERT INTO membership VALUES
  ('Radiohead','Thom','Yorke',1985,NULL),
  ('Radiohead','Jonny','Greenwood',1991,NULL),
  ('Fleetwood Mac','Lindsey','Buckingham',1975,1987),
  ('Fleetwood Mac','Stevie','Nicks',1975,1991),
  ('Nirvana','Kurt','Cobain',1987,1994),
  ('Nirvana','Krist','Novoselic',1987,1994),
  ('Nirvana','Dave','Grohl',1990,1994),
  ('Daft Punk','Thomas','Bangalter',1993,2021),
  ('Daft Punk','Guy-Manuel','de Homem-Christo',1993,2021);

-- songs (titles unique per spec)
INSERT INTO song VALUES
  ('Paranoid Android',1997),
  ('Street Spirit',1995),
  ('Smells Like Teen Spirit',1991),
  ('Dreams',1977),
  ('Get Lucky',2013);

-- song writers (must exist as musicians)
INSERT INTO song_writer VALUES
  ('Paranoid Android','Thom','Yorke'),
  ('Paranoid Android','Jonny','Greenwood'),
  ('Street Spirit','Thom','Yorke'),
  ('Smells Like Teen Spirit','Kurt','Cobain'),
  ('Smells Like Teen Spirit','Krist','Novoselic'),
  ('Smells Like Teen Spirit','Dave','Grohl'),
  ('Dreams','Stevie','Nicks'),
  ('Get Lucky','Thomas','Bangalter'),
  ('Get Lucky','Guy-Manuel','de Homem-Christo');

-- tracks (recorded versions of songs)
INSERT INTO track VALUES
  (10,'Paranoid Android',1997),
  (11,'Street Spirit',1995),
  (12,'Smells Like Teen Spirit',1991),
  (13,'Dreams',1977),
  (14,'Get Lucky',2013);

-- track contributors (performers on the recording)
INSERT INTO track_contributor VALUES
  (10,'Thom','Yorke'),
  (10,'Jonny','Greenwood'),
  (11,'Thom','Yorke'),
  (12,'Kurt','Cobain'),
  (12,'Krist','Novoselic'),
  (12,'Dave','Grohl'),
  (13,'Stevie','Nicks'),
  (14,'Thomas','Bangalter'),
  (14,'Guy-Manuel','de Homem-Christo');

-- albums (a group has at most one album with a given title)
INSERT INTO album VALUES
  ('Radiohead','OK Computer',1997,'Parlophone'),
  ('Nirvana','Nevermind',1991,'DGC'),
  ('Fleetwood Mac','Rumours',1977,'A&M'),
  ('Daft Punk','Random Access Memories',2013,'Virgin');

-- album contents (ordering per album, tracks can appear on multiple albums)
INSERT INTO album_track VALUES
  ('Radiohead','OK Computer',10,2),            -- Paranoid Android
  ('Radiohead','OK Computer',11,10),           -- Street Spirit (pretend reissue/bonus)
  ('Nirvana','Nevermind',12,1),                -- Smells Like Teen Spirit
  ('Fleetwood Mac','Rumours',13,2),            -- Dreams
  ('Daft Punk','Random Access Memories',14,8); -- Get Lucky

-- music_group
-- INSERT INTO music_group VALUES ('Radiohead',1990); -- duplicate PK
-- INSERT INTO music_group(group_name,year_formed) VALUES ('New Group', NULL); -- NOT NULL

-- genre
-- INSERT INTO genre VALUES ('rock','dup'); -- duplicate PK
-- INSERT INTO genre(genre_label,description) VALUES ('shoegaze', NULL); -- NOT NULL

-- label
-- INSERT INTO label VALUES ('Parlophone'); -- duplicate PK
-- INSERT INTO album VALUES ('Radiohead','Ghost Label Album',1998,'Nonexistent'); -- FK to label fails

-- musician
-- INSERT INTO musician VALUES ('Thom','Yorke',NULL,1968); -- duplicate composite PK
-- INSERT INTO musician(first_name,last_name) VALUES (NULL,'Nobody'); -- NOT NULL

-- group_genre
-- INSERT INTO group_genre VALUES ('Radiohead','alternative rock'); -- duplicate composite PK
-- INSERT INTO group_genre VALUES ('Radiohead','nonexistent-genre'); -- FK to genre fails

-- influence
-- INSERT INTO influence VALUES ('Radiohead','Radiohead'); -- CHECK self-influence
-- INSERT INTO influence VALUES ('Ghost Group','Nirvana'); -- FK to music_group fails

-- membership
-- INSERT INTO membership VALUES ('Radiohead','Thom','Yorke',1995,1990); -- CHECK end_year >= start_year
-- INSERT INTO membership VALUES ('Radiohead','Thom','Yorke',1985,NULL); -- duplicate composite PK

-- song
-- INSERT INTO song VALUES ('Paranoid Android',2000); -- duplicate PK
-- INSERT INTO song(title,year_written) VALUES ('Brand New', NULL); -- NOT NULL

-- song_writer
-- INSERT INTO song_writer VALUES ('Paranoid Android','Thom','Yorke'); -- duplicate composite PK
-- INSERT INTO song_writer VALUES ('Paranoid Android','No','Body'); -- FK to musician fails

-- track
-- INSERT INTO track VALUES (10,'Get Lucky',2013); -- duplicate track_id PK
-- INSERT INTO track VALUES (99,'Ghost Song',2001); -- FK song_title fails

-- track_contributor
-- INSERT INTO track_contributor VALUES (10,'Thom','Yorke'); -- duplicate composite PK
-- INSERT INTO track_contributor VALUES (99,'Thom','Yorke'); -- FK to track fails

-- album
-- INSERT INTO album VALUES ('Radiohead','OK Computer',1998,'Parlophone'); -- duplicate (group_name,title)
-- INSERT INTO album VALUES ('Nirvana','Nevermind',1991,'NoLabel'); -- FK label fails

-- album_track
-- INSERT INTO album_track VALUES ('Radiohead','OK Computer',10,2); -- duplicate composite PK
-- INSERT INTO album_track VALUES ('Nirvana','Nevermind',12,1); -- duplicate track_number per album (UNIQUE)