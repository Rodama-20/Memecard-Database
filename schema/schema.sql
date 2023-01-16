-- Schema definition for memecard application
-- (c) 2023 He-Arc Cyrille Polier


DROP SCHEMA IF EXISTS memecard CASCADE;
CREATE SCHEMA memecard;
SET search_path TO memecard;
SET client_encoding TO 'UTF8';

CREATE TABLE "users" (
  "id" INT GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
  "email" varchar(50) NOT NULL UNIQUE,
  "username" varchar(20) NOT NULL UNIQUE,
  "password" varchar(256) NOT NULL,
  "last_login" timestamptz NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE "card_types" (
  "id" INT GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
  "name" varchar(30) NOT NULL UNIQUE,
  "description" varchar NOT NULL
);

CREATE TABLE "decks" (
  "id" INT GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
  "name" varchar(30) NOT NULL,
  "public" boolean NOT NULL DEFAULT false,
  "strict_one_way" boolean NOT NULL DEFAULT true,
  "card_type_id" int NOT NULL,
  FOREIGN KEY ("card_type_id")
    REFERENCES "card_types"("id")
    ON DELETE CASCADE
    ON UPDATE CASCADE
);

CREATE TABLE "deck_user" (
  "id" INT GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
  "user_id" int REFERENCES "users" ("id") NOT NULL,
  "deck_id" int REFERENCES "decks" ("id") NOT NULL,
  UNIQUE ("user_id", "deck_id"),
  FOREIGN KEY ("user_id")
    REFERENCES "users" ("id")
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  FOREIGN KEY ("deck_id")
    REFERENCES "decks" ("id")
    ON DELETE CASCADE
    ON UPDATE CASCADE
);


CREATE TABLE "tags" (
  "id" INT GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
  "name" varchar(30) NOT NULL UNIQUE
);

CREATE TABLE "deck_tag" (
  "id" INT GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
  "deck_id" int NOT NULL,
  "tag_id" int NOT NULL,
  UNIQUE ("tag_id", "deck_id"),
  FOREIGN KEY ("deck_id")
    REFERENCES "decks" ("id")
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  FOREIGN KEY ("tag_id")
    REFERENCES "tags" ("id")
    ON DELETE CASCADE
    ON UPDATE CASCADE
);

CREATE TABLE "cards" (
  "id" INT GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
  "creator" int,
  "deck_id" int NOT NULL,
  "order" int,
  "public" boolean NOT NULL DEFAULT true,
  "nb_faces" int NOT NULL DEFAULT 1,
  FOREIGN KEY ("creator")
    REFERENCES "users" ("id")
    ON DELETE SET NULL
    ON UPDATE CASCADE,
  FOREIGN KEY ("deck_id")
    REFERENCES "decks" ("id")
    ON DELETE CASCADE
    ON UPDATE CASCADE
  
);

CREATE TABLE "face_types" (
  "id" INT GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
  "name" varchar(30) NOT NULL UNIQUE,
  "description" varchar NOT NULL,
  "question" boolean NOT NULL,
  "response" boolean NOT NULL
);

CREATE TABLE "card_type_face_type" (
  "id" INT GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
  "card_type_id" int NOT NULL REFERENCES "card_types" ("id"),
  "face_type_id" int NOT NULL REFERENCES "face_types" ("id"),
  "name" varchar(30) NOT NULL,
  "required" boolean NOT NULL DEFAULT true,
  UNIQUE ("card_type_id", "face_type_id", "name")
);

CREATE TABLE "memes" (
  "id" INT GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
  "card_id" int NOT NULL,
  "url" varchar(256) NOT NULL,
  "reports" int NOT NULL DEFAULT 0,
  FOREIGN KEY ("card_id")
    REFERENCES "cards" ("id")
    ON DELETE CASCADE
    ON UPDATE CASCADE
);

CREATE TABLE "card_user" (
  "id" INT GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
  "user_id" int NOT NULL,
  "card_id" int NOT NULL,
  "is_learned" boolean NOT NULL DEFAULT false,
  "is_known" boolean NOT NULL DEFAULT false,
  "meme_id" int DEFAULT NULL,
  UNIQUE ("user_id", "card_id"),
  FOREIGN KEY ("user_id")
    REFERENCES "users" ("id")
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  FOREIGN KEY ("card_id")
    REFERENCES "cards" ("id")
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  FOREIGN KEY ("meme_id")
    REFERENCES "memes" ("id")
    ON DELETE SET NULL
    ON UPDATE CASCADE
);

CREATE TABLE "faces" (
  "id" INT GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
  "card_id" int NOT NULL,
  "card_type_face_type_id" int NOT NULL REFERENCES "card_type_face_type" ("id"),
  "content" varchar,
  "reports" int,
  FOREIGN KEY ("card_id")
    REFERENCES "cards" ("id")
    ON DELETE CASCADE
    ON UPDATE CASCADE
);

CREATE TABLE "face_face_user" (
  "id" INT GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
  "user_id" int NOT NULL,
  "face_one_id" int NOT NULL,
  "face_two_id" int NOT NULL,
  "next_due" timestamptz NOT NULL DEFAULT NOW(),
  "repetition" int NOT NULL DEFAULT 0,
  "interval" int NOT NULL DEFAULT 0,
  "easiness_factor" float NOT NULL DEFAULT 2.5,
  "meme_id" int REFERENCES "memes" ("id") ON DELETE SET NULL,
  "is_known" boolean NOT NULL DEFAULT false,
  UNIQUE ("user_id", "face_one_id", "face_two_id"),
  FOREIGN KEY ("user_id")
    REFERENCES "users" ("id")
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  FOREIGN KEY ("face_one_id")
    REFERENCES "faces" ("id")
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  FOREIGN KEY ("face_two_id")
    REFERENCES "faces" ("id")
    ON DELETE CASCADE
    ON UPDATE CASCADE
);

CREATE TABLE "rev_log" (
  "id" INT GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
  "user_id" int NOT NULL,
  "card_id" int NOT NULL,
  "answer" int NOT NULL,
  "interval" int NOT NULL,
  "easiness_factor" int NOT NULL,
  "time" timestamptz NOT NULL,
  -- Revision log is lost when a card or a user is deleted
  FOREIGN KEY ("user_id")
    REFERENCES "users" ("id")
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  FOREIGN KEY ("card_id")
    REFERENCES "cards" ("id")
    ON DELETE CASCADE
    ON UPDATE CASCADE
);

CREATE TABLE "update_deck_log" (
  "id" INT GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
  "user_id" int,
  "deck_id" int,
  "card_id" int,
  "tag_id" int,
  "action" varchar(30) NOT NULL,
  "old_name" varchar(30) NOT NULL,
  "time" timestamptz NOT NULL,
  FOREIGN KEY ("user_id")
    REFERENCES "users" ("id")
    ON DELETE SET NULL
    ON UPDATE CASCADE,
  FOREIGN KEY ("deck_id")
    REFERENCES "decks" ("id")
    ON DELETE SET NULL
    ON UPDATE CASCADE,
  FOREIGN KEY ("card_id")
    REFERENCES "cards" ("id")
    ON DELETE SET NULL
    ON UPDATE CASCADE,
  FOREIGN KEY ("tag_id") 
    REFERENCES "tags" ("id")
    ON DELETE SET NULL
    ON UPDATE CASCADE
);

CREATE TABLE "update_tag_log" (
  "id" INT GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
  "user_id" int,
  "tag_id" int,
  "old_name" varchar(30) NOT NULL,
  "time" timestamptz NOT NULL,
  FOREIGN KEY ("user_id")
    REFERENCES "users" ("id")
    ON DELETE SET NULL
    ON UPDATE CASCADE,
  FOREIGN KEY ("tag_id")
    REFERENCES "tags" ("id")
    ON DELETE SET NULL
    ON UPDATE CASCADE
);

CREATE TABLE "update_card_log" (
  "id" INT GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
  "user_id" int,
  "card_id" int,
  "face_id" int,
  "old_content" varchar NOT NULL,
  "time" timestamptz NOT NULL,
  FOREIGN KEY ("user_id")
    REFERENCES "users" ("id")
    ON DELETE SET NULL
    ON UPDATE CASCADE,
  FOREIGN KEY ("card_id")
    REFERENCES "cards" ("id")
    ON DELETE SET NULL
    ON UPDATE CASCADE
);

CREATE TABLE "update_meme_log" (
  "id" INT GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
  "user_id" int,
  "meme_id" int,
  "old_url" varchar(256) NOT NULL,
  "time" timestamptz NOT NULL,
  FOREIGN KEY ("user_id")
    REFERENCES "users" ("id")
    ON DELETE SET NULL
    ON UPDATE CASCADE,
  FOREIGN KEY ("meme_id")
    REFERENCES "memes" ("id")
    ON DELETE SET NULL
    ON UPDATE CASCADE
);
