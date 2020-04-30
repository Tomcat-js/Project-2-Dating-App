CREATE DATABASE dating_app;

CREATE TABLE users (
  id SERIAL PRIMARY KEY,
  email TEXT,
  password_digest TEXT,
  name TEXT,
  image_url TEXT,
  gender TEXT,
  occupation TEXT,
  interests TEXT,
  idea_of_a_good_time TEXT,
  looking_for_in_a_partner TEXT
);



INSERT INTO users (email, password) 
VALUES ('test@test.com', "123" );

INSERT INTO users (email, password) 
VALUES ('rei', "123" );

INSERT INTO users (email, password) 
VALUES ('rio', "123" );

INSERT INTO users (email, password) 
VALUES ('yoko', "123" );

INSERT INTO users (email, password) 
VALUES ('tom', "123" );

arr = [{:name => "tom"}, {:name => "bob"}, {:name => "paul"}, {:name => "fred"}]