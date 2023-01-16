SET search_path TO memecard;
SET client_encoding TO 'UTF8';

INSERT INTO "users" ("email", "username", "password")
VALUES ('test@example.com', 'test', '01707299cbf3f8b6ea4b4686047139a6d32072e44eafe164eeed916c13c62f6740029db95eddc69d483d17abfe261191f6d1086b4c3e514a7be28699418062a7');

INSERT INTO "card_types" ("name", "description")
VALUES
    ('Vocabulary', 'basic one way card'),
    ('image-text', 'image on one side, text on the other'),
    ('image-image-text', 'rotary question over the tree sides');

INSERT INTO "face_types" ("name", "description", "question", "response")
VALUES
    ('question', 'Question text', true, false),
    ('answer', 'Answer text', false, true),
    ('both', 'Question and answer text', true, true);

INSERT INTO "card_type_face_type" ("card_type_id", "face_type_id", "name")
VALUES
    (1, 1, 'Question'),
    (1, 2, 'Answer'),
    (2, 1, 'Image'),
    (2, 2, 'Descrition'),
    (3, 3, 'Description'),
    (3, 3, 'Old image'),
    (3, 3, 'New image');

INSERT INTO "tags" ("name")
VALUES
    ('Vocabulary'),
    ('Railway');


