SET search_path TO memecard;
SET client_encoding TO 'UTF8';

-- Learn all the card of vocabulary deck
UPDATE card_user SET is_learned = true WHERE user_id = 1 AND card_id <= 3;
