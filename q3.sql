USE springboardopt;

-- -------------------------------------
SET @v1 = 1612521;
SET @v2 = 1145072;
SET @v3 = 1828467;
SET @v4 = 'MGT382';
SET @v5 = 'Amber Hill';
SET @v6 = 'MGT';
SET @v7 = 'EE';			  
SET @v8 = 'MAT';

-- 3. List the names of students who have taken course v4 (crsCode).
--  ************************ORIGINAL *************************

SELECT name FROM Student WHERE id IN (SELECT studId FROM Transcript WHERE crsCode = @v4);



--  ********************************   ANSWER   ***********************************************
-- This has correlated subqueries, use derived tables instead?
-- Use Union all instead of IN?

-- This one runs correctly with the correct students.
-- This uses a CTE and correct type of JOIN to arrive at the same answer
--  ********************************   ANSWER   ***********************************************


WITH studIds AS
(
  SELECT studId FROM Transcript WHERE crsCode = @v4
)

SELECT name FROM Student 
	RIGHT OUTER JOIN studIds ON id=studId;
