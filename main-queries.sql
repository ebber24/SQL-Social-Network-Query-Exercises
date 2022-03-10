-- Q01 Find the names of all students who are friends with someone named Gabriel.

SELECT H1.name
FROM   Highschooler H1
       INNER JOIN Friend
               ON H1.ID = ID1
       INNER JOIN Highschooler H2
               ON H2.ID = ID2
WHERE  H2.name = "Gabriel" 

-- Q02 For every student who likes someone 2 or more grades younger than themselves, return that student's name and grade, and the name and grade of the student they like.

SELECT H1.name,
       H1.grade,
       H2.name,
       H2.grade
FROM   Highschooler H1
       INNER JOIN Likes
               ON H1.ID = ID1
       INNER JOIN Highschooler H2
               ON H2.ID = ID2
WHERE  Abs(H1.grade - H2.grade) >= 2 

-- Q03 For every pair of students who both like each other, return the name and grade of both students. Include each pair only once, with the two names in alphabetical order.

SELECT H1.name,
       H1.grade,
       H2.name,
       H2.grade
FROM   Highschooler H1,
       Highschooler H2,
       Likes L1,
       Likes L2
WHERE  ( H1.ID = L1.ID1
         AND H2.ID = L1.ID2 )
       AND ( H2.ID = L2.ID1
             AND H1.ID = L2.ID2 )
       AND H1.name  < H2.name 
ORDER  BY H1.name 

-- Q04 Find all students who do not appear in the Likes table (as a student who likes or is liked) and return their names and grades. Sort by grade, then by name within each grade.

SELECT NAME,
       grade
FROM   Highschooler
WHERE  ID NOT IN (SELECT ID1
                  FROM   Likes)
       AND ID NOT IN (SELECT ID2
                      FROM   Likes)
ORDER  BY grade,
          name 

-- Q05 For every situation where student A likes student B, but we have no information about whom B likes (that is, B does not appear as an ID1 in the Likes table), return A and B's names and grades.

SELECT H1.name,
       H1.grade,
       H2.name,
       H2.grade
FROM   Highschooler H1
       INNER JOIN Likes
               ON H1.ID = ID1
       INNER JOIN Highschooler H2
               ON H2.ID = ID2
WHERE  ID2 NOT IN (SELECT ID1
                   FROM   Likes) 

-- Q06 Find names and grades of students who only have friends in the same grade. Return the result sorted by grade, then by name within each grade.

SELECT DISTINCT name,
                grade
FROM   Highschooler
WHERE  ID NOT IN (SELECT ID1
                  FROM   Highschooler H1
                         INNER JOIN Friend
                                 ON H1.ID = ID1
                         INNER JOIN Highschooler H2
                                 ON H2.ID = ID2
                  WHERE  H1.grade <> H2.grade)
ORDER  BY grade,
          name; 

-- Q07 For each student A who likes a student B where the two are not friends, find if they have a friend C in common (who can introduce them!). For all such trios, return the name and grade of A, B, and C.

SELECT H1.name,
       H1.grade,
       H2.name,
       H2.grade,
       H3.name,
       H3.grade
FROM   Highschooler H1,
       Highschooler H2,
       Highschooler H3,
       Friend F1,
       Friend F2,
       (SELECT L.ID1,
               L.ID2
        FROM   Likes L
        EXCEPT
        SELECT F.ID1,
               F.ID2
        FROM   Friend F) L
WHERE  H1.ID = L.ID1
       AND H2.ID = L.ID2
       AND H3.ID = F1.ID1
       AND L.ID1 = F1.ID2
       AND L.ID2 = F2.ID2
       AND F1.ID1 = F2.ID1 
       
-- Q08 Find the difference between the number of students in the school and the number of different first names.

SELECT Count(ID) - Count (DISTINCT name)
FROM   Highschooler 

-- Q09 Find the name and grade of all students who are liked by more than one other student.

SELECT name,
       grade
FROM   Likes
       INNER JOIN Highschooler
               ON ID = ID2
GROUP  BY ID2
HAVING Count(ID2) >= 2 
