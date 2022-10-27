-- Shane Hauck
-- Movie DDL

-- Listing all movies with their Imbd and title
CREATE TABLE Movies (
  Imbd varchar(20),
  title varchar(50),
  PRIMARY KEY (Imbd, title)
);

-- Listing all actors that have acted in movies with their name, age, gender and wikipedia url
CREATE TABLE Actors (
  name varchar(20),
  age int,
  gender varchar(6),
  wikipedia varchar(100),
  PRIMARY KEY (name, wikipedia)
);

-- Listing all company's that are studios that have movies and their wikipedia url
CREATE TABLE Studios (
  company varchar(20),
  wikipedia varchar(100),
  PRIMARY KEY (company, wikipedia)
);

-- Listing all writers that have written movies and their wikipedia url
CREATE TABLE Writers (
  name varchar(20),
  wikipedia varchar(100),
  PRIMARY KEY (name, wikipedia)
);

-- Listing all directors that have directed movies and their wikipedia urls
CREATE TABLE Directors (
  name varchar(20),
  wikipedia varchar(100),
  PRIMARY KEY (name, wikipedia)
);

-- Listing all reviewers that have reviewed movies
CREATE TABLE Reviewers (
  username varchar(15),
  name varchar(20),
  age int,
  PRIMARY KEY (username)
);

-- Listing all producers that have produced movies and their wikipedia url
CREATE TABLE Producers (
  name varchar(20),
  wikipedia varchar(100),
  PRIMARY KEY (name, wikipedia)
);

-- Relation that contains actors and the movies they act in
CREATE TABLE Acts_in (
    Imbd varchar(20),
    title varchar(50),
    name varchar(20),
    wikipedia varchar(100),
    primary key (Imbd, title, name, wikipedia),
    FOREIGN KEY (name, wikipedia) references Actors,
    FOREIGN KEY (Imbd, title) references Movies
);

-- Relation that contains all directors and the movies they direct.
CREATE TABLE Directs (
    Imbd varchar(20),
    title varchar(50),
    name varchar(20),
    wikipedia varchar(100),
    primary key (Imbd, title, name, wikipedia),
    FOREIGN KEY (name, wikipedia) references Directors,
    FOREIGN KEY (Imbd, title) references Movies
);

-- Relation that contains all producers and the movies they produce.
CREATE TABLE Produces (
    Imbd varchar(20),
    title varchar(50),
    name varchar(20),
    wikipedia varchar(100),
    primary key (Imbd, title, name, wikipedia),
    FOREIGN KEY (name, wikipedia) references Producers,
    FOREIGN KEY (Imbd, title) references Movies
);

-- Relation that contains all writers and the movies they write.
CREATE TABLE Writes (
    Imbd varchar(20),
    title varchar(50),
    name varchar(20),
    wikipedia varchar(100),
    primary key (Imbd, title, name, wikipedia),
    FOREIGN KEY (name, wikipedia) references Writers,
    FOREIGN KEY (Imbd, title) references Movies
);

-- Relation that contains all studios and the movies they own. Also contains the revenue and budget for each movie.
CREATE TABLE Owns (
    Imbd varchar(20),
    title varchar(50),
    company varchar(20),
    wikipedia varchar(100),
    Revenue int,
    Budget int,
    PRIMARY KEY (Imbd, title, company, wikipedia),
    FOREIGN KEY (company, wikipedia) references Studios,
    FOREIGN KEY (Imbd, title) references Movies
);

-- Relation that contains reviewers and the movies they review. Reviews features written reviews and rating the the scale from 0 - 10.
CREATE TABLE Reviews (
    username varchar(15),
    Imbd varchar(20),
    title varchar(50),
    writtenReview varchar(500),
    rating int, check (rating < 11), check (rating > 0),
    primary key (username, Imbd, writtenReview, rating),
    FOREIGN KEY (username) references Reviewers,
    FOREIGN KEY (Imbd, title) references Movies
);

-- Relation that contains all actors, directors, producers and writers and the movies they partake in. Also contains the salary for each individual in each movie. 
CREATE TABLE Casts (
    Imbd varchar(20),
    title varchar(50),
    name varchar(20),
    wikipedia varchar(100),
    Salary int,
    PRIMARY KEY (Imbd, title, name, wikipedia),
    CONSTRAINT actor FOREIGN KEY (name, wikipedia) references Actors,
    CONSTRAINT director FOREIGN KEY (name, wikipedia) references Directors,
    CONSTRAINT producer FOREIGN KEY (name, wikipedia) references Producers,
    CONSTRAINT writer FOREIGN KEY (name, wikipedia) references Writers,
    FOREIGN KEY (Imbd, title) references Movies
);