DROP TABLE IF EXISTS replies; -- drop table with most foreign keys first
DROP TABLE IF EXISTS question_likes; 
DROP TABLE IF EXISTS question_follows; 
DROP TABLE IF EXISTS questions; 
DROP TABLE IF EXISTS users; 

PRAGMA foreign_keys = ON;



CREATE TABLE users (
    id INTEGER PRIMARY KEY,
    fname TEXT NOT NULL,
    lname TEXT NOT NULL
);

CREATE TABLE questions (
    id INTEGER PRIMARY KEY,
    title TEXT NOT NULL,
    body TEXT NOT NULL,
    author_id INTEGER NOT NULL,

    FOREIGN KEY (author_id) REFERENCES users(id)
);

CREATE TABLE question_follows  (
    id INTEGER PRIMARY KEY,
    user_id INTEGER NOT NULL,
    question_id INTEGER NOT NULL,

    
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (question_id) REFERENCES questions(id)
);

CREATE TABLE replies (
    id INTEGER PRIMARY KEY,
    question_id INTEGER NOT NULL,
    parent_reply_id INTEGER,
    reply_author_id INTEGER NOT NULL,
    body TEXT NOT NULL,

    FOREIGN KEY (parent_reply_id) REFERENCES replies(id),
    FOREIGN KEY (reply_author_id) REFERENCES users(id),
    FOREIGN KEY (question_id) REFERENCES questions(id)
);

CREATE TABLE question_likes (
    id INTEGER PRIMARY KEY,
    question_id INTEGER NOT NULL,
    user_id INTEGER NOT NULL,

    FOREIGN KEY (question_id) REFERENCES questions(id),
    FOREIGN KEY (user_id) REFERENCES users(id)
);

INSERT INTO
    users (fname, lname)
VALUES
    ('Akeem', 'Nicholas'),
    ('Jon', 'Su'),
    ('App', 'Academy');

INSERT INTO
    questions (title, body, author_id)
VALUES
    ('HELP ME', 'What is CSS?', (SELECT id FROM users WHERE fname = 'Akeem')),
    ('Existential', 'Who am I?', (SELECT id FROM users WHERE fname = 'Jon')),
    ('Go Study', 'Why aren''t you studying?', (SELECT id FROM users WHERE fname = 'App')),
    ('Math', 'What is 23 + 24', (SELECT id FROM users WHERE fname = 'Jon'));

INSERT INTO
    question_follows (user_id, question_id)
VALUES  
    (1, 1),
    (1, 2),
    (2, 3);

INSERT INTO
    -- each reply has what channel it's on, if it's new or in a thread, who wrote it, and what they wrote
    replies (question_id, parent_reply_id, reply_author_id, body)
VALUES
    ((SELECT id FROM questions WHERE questions.title = 'HELP ME'), NULL, 2, 'lol same, I need  help too'),
    ((SELECT id FROM questions WHERE questions.title = 'Existential'), NULL, 1, 'nothing really matters, anyone can see, nothing really matters to me. any way the wind blows'),
    ((SELECT id FROM questions WHERE questions.title = 'Go Study'), NULL, 2, 'you''re not my dad!'),
    ((SELECT id FROM questions WHERE questions.title = 'Math'), NULL, 3, '47, stoopid'),
    ((SELECT id FROM questions WHERE questions.title = 'Math'), 4, 1, 'ur so mean');
INSERT INTO
    question_likes(question_id, user_id)
VALUES
    (1,1),
    (2,1),
    (3,1),
    (2,2),
    (2,3),
    (4,3);