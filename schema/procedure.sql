-- Stored procedures for database related operations
-- for memecard application
-- (c) 2023 He-Arc Cyrille Polier

SET search_path TO memecard;
SET client_encoding TO 'UTF8';

CREATE FUNCTION init_card_after_subscribing()
RETURNS trigger AS $$
DECLARE
    card cards%ROWTYPE;
BEGIN
    FOR card IN SELECT * FROM cards WHERE deck_id = NEW.deck_id
    LOOP
        INSERT INTO card_user (card_id, user_id)
        VALUES (card.id, NEW.user_id);
    END LOOP;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER init_card_trigger
    AFTER INSERT ON deck_user
    FOR EACH ROW
    EXECUTE PROCEDURE init_card_after_subscribing();


CREATE FUNCTION remove_card_after_unsubscribing()
RETURNS trigger AS $$
BEGIN
    DELETE FROM card_user
    WHERE card_id IN (SELECT id FROM cards WHERE deck_id = OLD.deck_id)
    AND user_id = OLD.user_id;
    RETURN OLD;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER remove_card_trigger
    BEFORE DELETE ON deck_user
    FOR EACH ROW
    EXECUTE PROCEDURE remove_card_after_unsubscribing();


CREATE FUNCTION remove_face_face_user_after_unsubscribing()
RETURNS trigger AS $$
DECLARE
    face_id int;
BEGIN
    FOR face_id IN SELECT id FROM faces WHERE card_id = OLD.card_id
    LOOP
        DELETE FROM face_face_user
        WHERE (face_one_id = face_id OR face_two_id = face_id)
        AND user_id = OLD.user_id;
    END LOOP;
    RETURN OLD;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER remove_face_face_user_trigger
    BEFORE DELETE ON card_user
    FOR EACH ROW
    EXECUTE PROCEDURE remove_face_face_user_after_unsubscribing();


CREATE FUNCTION init_face_face_user_after_learning()
RETURNS trigger AS $$
DECLARE
    face_one faces%ROWTYPE;
    face_two faces%ROWTYPE;
BEGIN
    FOR face_one IN SELECT *
        FROM faces
        JOIN card_type_face_type ON card_type_face_type_id = card_type_face_type.id
        JOIN face_types ON face_types.id = face_type_id
        WHERE card_id = NEW.card_id AND question = true
    LOOP
        FOR face_two IN SELECT *
            FROM faces
            JOIN card_type_face_type ON card_type_face_type_id = card_type_face_type.id
            JOIN face_types ON face_types.id = face_type_id 
            WHERE card_id = NEW.card_id AND response = true
        LOOP
            IF face_one.id = face_two.id THEN
                CONTINUE;
            END IF;
            INSERT INTO face_face_user (user_id, face_one_id, face_two_id, meme_id)
            VALUES (NEW.user_id, face_one.id, face_two.id, NULL);
        END LOOP;        
    END LOOP;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER init_face_face_user_after_learning_trigger
    AFTER UPDATE ON card_user
    FOR EACH ROW
    WHEN (OLD.is_learned = false AND NEW.is_learned = true)
    EXECUTE PROCEDURE init_face_face_user_after_learning();

CREATE FUNCTION add_card_to_deck()
RETURNS trigger AS $$
DECLARE
    local_user_id int;
BEGIN
    FOR local_user_id IN SELECT user_id FROM deck_user WHERE deck_id = NEW.deck_id
    LOOP
        INSERT INTO card_user (card_id, user_id)
        VALUES (NEW.id, local_user_id);
    END LOOP;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER add_card_to_deck_trigger
    AFTER INSERT ON cards
    FOR EACH ROW
    EXECUTE PROCEDURE add_card_to_deck();
