\i schema/schema.sql
GRANT ALL ON SCHEMA memecard TO memecard;

GRANT ALL ON TABLE memecard.card_type_face_type TO memecard;
GRANT ALL ON TABLE memecard.card_types TO memecard;
GRANT ALL ON TABLE memecard.card_user TO memecard;
GRANT ALL ON TABLE memecard.cards TO memecard;
GRANT ALL ON TABLE memecard.deck_tag TO memecard;
GRANT ALL ON TABLE memecard.deck_user TO memecard;
GRANT ALL ON TABLE memecard.decks TO memecard;
GRANT ALL ON TABLE memecard.face_face_user TO memecard;
GRANT ALL ON TABLE memecard.face_types TO memecard;
GRANT ALL ON TABLE memecard.faces TO memecard;
GRANT ALL ON TABLE memecard.memes TO memecard;
GRANT ALL ON TABLE memecard.rev_log TO memecard;
GRANT ALL ON TABLE memecard.tags TO memecard;
GRANT ALL ON TABLE memecard.update_card_log TO memecard;
GRANT ALL ON TABLE memecard.update_deck_log TO memecard;
GRANT ALL ON TABLE memecard.update_meme_log TO memecard;
GRANT ALL ON TABLE memecard.update_tag_log TO memecard;
GRANT ALL ON TABLE memecard.users TO memecard;

\i schema/procedure.sql

\i data/01_basic_data.sql
\i data/02_basic_deck.sql
\i data/03_adding_card.sql

\i data/04_learning_card.sql