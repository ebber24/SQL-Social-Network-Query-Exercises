-- Q01 For every situation where student A likes student B, but student B likes a different student C, return the names and grades of A, B, and C.

SELECT H1.name,
       H1.grade,
       H2.name,
       H2.grade,
       H3.name,
       H3.grade
FROM   Likes L1,
       Likes L2,
       Highschooler H1,
       Highschooler H2,
       Highschooler H3
WHERE  L1.ID2 = L2.ID1
       AND H1.ID = L1.ID1
       AND H2.ID = L1.ID2
       AND H3.ID = L2.iID
       AND L1.ID1 <> L2.ID2; 

-- Q02 Find those students for whom all of their friends are in different grades from themselves. Return the students' names and grades.

SELECT name,
       grade
FROM   Highschooler
WHERE  ID NOT IN (SELECT ID1
                  FROM   Highschooler H1,
                         Highschooler H2,
                         Friend
                  WHERE  H1.ID = ID1
                         AND H2.ID = ID2
                         AND H1.grade = H2.grade) 
                         
-- Q03 What is the average number of friends per student? (Your result should be just one number.)

SELECT Avg(count)
FROM   (SELECT Count(ID1) AS count
        FROM   Friend
        GROUP  BY ID1) 
        
-- Q04 Find the number of students who are either friends with Cassandra or are friends of friends of Cassandra. Do not count Cassandra, even though technically she is a friend of a friend.

SELECT Count (ID1)
FROM   Friend
WHERE  ID1 IN (SELECT ID2
               FROM   Friend
               WHERE  ID1 IN (SELECT ID
                              FROM   Highschooler
                              WHERE  name = 'Cassandra')); 

-- Q05 Find the name and grade of the student(s) with the greatest number of friends.

SELECT name,
       Grade
FROM   Highschooler
       INNER JOIN Friend
               ON ID = ID1
GROUP  BY ID1
HAVING Count(ID1) >= (SELECT Max(Friends)
                      FROM   (SELECT Count(*) AS Friends
                              FROM   Friend
                              GROUP  BY ID1)) 
                              
