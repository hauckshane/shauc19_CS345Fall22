-- Listing all movies with their Imbd and title
CREATE TABLE Movies (
  Imbd varchar(20),
  title varchar(50),
  PRIMARY KEY (Imbd)
);

-- Listing all actors that have acted in movies with their name, age and gender
CREATE TABLE Actors (
  ID int,
  name varchar(20),
  age int,
  gender varchar(6),
  PRIMARY KEY (ID)
);

-- Listing all company's that are studios that have movies
CREATE TABLE Studios (
  studioId int,
  company varchar(20),
  PRIMARY KEY (studioId)
);

-- Listing all writers that have written movies
CREATE TABLE Writers (
  ID int,
  name varchar(20),
  PRIMARY KEY (ID)
);

-- Listing all directors that have directed movies
CREATE TABLE Directors (
  ID int,
  name varchar(20),
  PRIMARY KEY (ID)
);

-- Listing all reviewers that have reviewed movies
CREATE TABLE Reviewers (
  reviewerId int,
  name varchar(20),
  age int,
  PRIMARY KEY (reviewerId)
);

-- Listing all producers that have produced movies
CREATE TABLE Producers (
  ID int,
  name varchar(20),
  PRIMARY KEY (ID)
);

-- Relation that contains all ID numbers of actors and the Imbd of the movies they act in
CREATE TABLE Acts_in (
    ID int,
    Imbd varchar(20),
    primary key (ID, Imbd),
    FOREIGN KEY (ID) references Actors ,
    FOREIGN KEY (Imbd) references Movies
);

-- Relation that contains all ID numbers of directors and the Imbd of the movies they direct.
CREATE TABLE Directs (
    ID int,
    Imbd varchar(20),
    primary key (ID, Imbd),
    FOREIGN KEY (ID) references Directors,
    FOREIGN KEY (Imbd) references Movies
);

-- Relation that contains all ID numbers of producers and the Imbd of the movies they produce.
CREATE TABLE Produces (
    ID int,
    Imbd varchar(20),
    primary key (ID, Imbd),
    FOREIGN KEY (ID) references Producers,
    FOREIGN KEY (Imbd) references Movies
);

-- Relation that contains all ID numbers of writers and the Imbd of the movies they write.
CREATE TABLE Writes (
    ID int,
    Imbd varchar(20),
    primary key (ID, Imbd),
    FOREIGN KEY (ID) references Writers,
    FOREIGN KEY (Imbd) references Movies
);

-- Relation that contains all studioId numbers and the Imbd of the movies they own. Also contains the revenue and budget for each movie.
CREATE TABLE Owns (
    studioId int,
    Imbd varchar(20),
    Revenue int,
    Budget int,
    PRIMARY KEY (studioId, Imbd),
    FOREIGN KEY (studioId) references Studios,
    FOREIGN KEY (Imbd) references Movies
);

-- Relation that contains reviewer id numbers and the Imbd of the movies they review. Reviews features written reviews and rating the the scale from 0 - 10
CREATE TABLE Reviews (
    reviewerId int,
    Imbd varchar(20),
    writtenReview varchar(500),
    rating int, check (rating < 11), check (rating > -1),
    primary key (reviewerId, Imbd, writtenReview, rating),
    FOREIGN KEY (reviewerId) references Reviewers,
    FOREIGN KEY (Imbd) references Movies
);

-- Relation that contains all ID numbers of actors, directors, producers and writers and the Imbd of the movies they partake in. Also contains the salary for each individual in each movie. The ID attribute is unique to each person along all 4 referenced relations. (Same person who acts and directs has same ID)
CREATE TABLE Casts (
    ID int,
    Imbd varchar(20),
    Salary int,
    PRIMARY KEY (ID, Imbd),
    CONSTRAINT actor FOREIGN KEY (ID) references Actors,
    CONSTRAINT director FOREIGN KEY (ID) references Directors,
    CONSTRAINT producer FOREIGN KEY (ID) references Producers,
    CONSTRAINT writer FOREIGN KEY (ID) references Writers,
    FOREIGN KEY (Imbd) references Movies
);