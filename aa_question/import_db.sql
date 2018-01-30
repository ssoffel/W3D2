Drop table if EXISTS users;
CREATE TABLE users(
  id   INTEGER PRIMARY KEY,
  fname TEXT NOT NULL,
  lname TEXT NOT NULL

);

Drop table if EXISTS questions;
CREATE TABLE questions(
  id   INTEGER PRIMARY KEY,
  title TEXT,
  body TEXT,
  user_id INTEGER NOT NULL,

  FOREIGN KEY (user_id) REFERENCES users(id)
);

Drop table if EXISTS question_follows;
CREATE TABLE question_follows(

  question_id INTEGER,
  user_id INTEGER,

  FOREIGN KEY (question_id) REFERENCES questions(id),
  FOREIGN KEY (user_id) REFERENCES users(id)
);

Drop table if EXISTS replies;
CREATE TABLE replies(
  id   INTEGER PRIMARY KEY,
  body TEXT,
  question_id INTEGER NOT NULL,
  user_id INTEGER NOT NULL,
  reply_id INTEGER,


  FOREIGN KEY (question_id) REFERENCES questions(id),
  FOREIGN KEY (user_id) REFERENCES users(id),
  FOREIGN KEY (reply_id) REFERENCES replies(id)
);

DROP TABLE IF EXISTS question_likes;
CREATE TABLE question_likes(
  id   INTEGER PRIMARY KEY,
  user_id INTEGER NOT NULL,
  question_id INTEGER NOT NULL,

  FOREIGN KEY (user_id) REFERENCES users(id),
  FOREIGN KEY (question_id) REFERENCES questions(id)
);


INSERT INTO
users (fname, lname)
VALUES
  ('Scott', 'Sof'),
  ('Jack', 'Zheng'),
  ('Oshie', 'Soffel'),
  ('Peter', 'Puck');

INSERT INTO
questions (title, body, user_id)
VALUES
  ('Reviews for App-Academy','13-week full stack developer program?',(SELECT id  FROM users where fname = 'Scott' and lname = 'Sof')),
  ('Meaning of life', 'What'' the purpose of life?',(SELECT id FROM users where fname = 'Jack' and lname = 'Zheng'));

INSERT INTO
  question_follows(question_id, user_id)
VALUES
  ((SELECT id FROM questions where title = 'Reviews for App-Academy'), (SELECT id FROM users  WHERE fname = 'Scott' and lname = 'Sof')),
  ((SELECT id FROM questions where title = 'Meaning of life'), (SELECT id FROM users  WHERE fname = 'Scott' and lname = 'Sof')),
  ((SELECT id FROM questions where title = 'Reviews for App-Academy'), (SELECT id FROM users  WHERE fname = 'Peter' and lname = 'Puck')),
  ((SELECT id FROM questions where title = 'Reviews for App-Academy'), (SELECT id FROM users  WHERE fname = 'Oshie' and lname = 'Soffel')),
  ((SELECT id FROM questions where title = 'Reviews for App-Academy'), (SELECT id FROM users  WHERE fname = 'Jack' and lname = 'Zheng'));


  INSERT INTO
  replies (body, question_id, user_id, reply_id)
  VALUES
  ('Yes it covers fullstack development in roughly 13 weeks', (SELECT id FROM questions where title = 'Reviews for App-Academy'),(SELECT id FROM users  WHERE fname = 'Scott' and lname = 'Sof'), NULL),
  ('You lie',(SELECT id FROM questions where title = 'Reviews for App-Academy'),(SELECT id FROM users WHERE fname = 'Jack' AND lname = 'Zheng'), 1),
  ('To make the most of it.',(SELECT id FROM questions where title = 'Meaning of life'),(SELECT id FROM users  WHERE fname = 'Scott' and lname = 'Sof'), NULL);

INSERT INTO
question_likes(user_id, question_id)
VALUES
  ((SELECT id FROM users where fname = 'Jack' AND lname = 'Zheng'),(SELECT id FROM questions where title = 'Reviews for App-Academy')),
  ((SELECT id FROM users where fname = 'Scott' AND lname = 'Sof'),(SELECT id FROM questions where title = 'Reviews for App-Academy')),
  ((SELECT id FROM users where fname = 'Scott' AND lname = 'Sof'),(SELECT id FROM questions where title = 'Meaning of life'));
