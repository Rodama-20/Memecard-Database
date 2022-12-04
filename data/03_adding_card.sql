SET search_path TO memecard;
SET client_encoding TO 'UTF8';

INSERT INTO "cards" ("creator", "deck_id", "order")
VALUES (1, 2, 4);

INSERT INTO "faces" ("card_id", "type_id", "content")
VALUES
    (7, 3, 'Ralentir 40 km/h'),
    (7, 3, 'Ancien signal ralentir 40 km/h'),
    (7, 3, 'Nouveau signal ralentir 40 km/h');

INSERT INTO "memes" ("card_id", "url")
VALUES (7, 'https://upload.wikimedia.org/wikipedia/commons/b/b1/Signalisation_suisse_L_principal_40.gif');
