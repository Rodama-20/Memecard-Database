SET search_path TO memecard;
SET client_encoding TO 'UTF8';

INSERT INTO "decks" ("name", "public", "strict_one_way", "card_type_id")
VALUES
    ('Vocabulary FR-EN', true, true, 1),
    ('Railway', true, true, 3);


INSERT INTO "deck_tag" ("deck_id", "tag_id")
VALUES
    (1, 1),
    (2, 2);


INSERT INTO "cards" ("creator", "deck_id", "order")
VALUES
-- Vocabulary
    (1, 1, 1),
    (1, 1, 2),
    (1, 1, 3),
-- Railway
    (1, 2, 1),
    (1, 2, 3),
    (1, 2, 3);

INSERT INTO "faces" ("card_id", "type_id", "content")
VALUES
-- Vocabulary
    (1, 1, 'Bonjour'),
    (1, 2, 'Hello'),
    (2, 1, 'Au revoir'),
    (2, 2, 'Goodbye'),
    (3, 1, 'Merci'),
    (3, 2, 'Thank you'),
-- Railway
    (4, 3, 'Stop'),
    (4, 3, 'Ancien signal stop'),
    (4, 3, 'Nouveau signal stop'),
    (5, 3, 'Rouler vitesse max'),
    (5, 3, 'Ancien signal rouler vitesse max'),
    (5, 3, 'Nouveau signal rouler vitesse max'),
    (6, 3, 'Ralentir 60 km/h'),
    (6, 3, 'Ancien signal ralentir 60 km/h'),
    (6, 3, 'Nouveau signal ralentir 60 km/h');

INSERT INTO "memes" ("card_id", "url")
VALUES
    (1, 'https://media.makeameme.org/created/bonjour-toi-9c57a50a1c.jpg'),
    (2, 'https://media.makeameme.org/created/au-revoir-5aab9e.jpg'),
    (3, 'https://media.makeameme.org/created/merci-kk50gu.jpg'),
    (4, 'https://upload.wikimedia.org/wikipedia/commons/a/a6/Signalisation_suisse_L_principal_90.png'),
    (5, 'https://upload.wikimedia.org/wikipedia/commons/4/46/Signalisation_suisse_L_principal_ouvert.gif'),
    (6, 'https://upload.wikimedia.org/wikipedia/commons/c/cd/Signalisation_suisse_L_principal_60.gif');

INSERT INTO "deck_user" ("deck_id", "user_id")
VALUES
    (1, 1),
    (2, 1);
