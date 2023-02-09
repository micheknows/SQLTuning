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

-- an index was created for crsCode, id
-- at that point the results are:
-- '-> Nested loop inner join  (cost=481.00 rows=4000) (actual time=2.273..4.168 rows=2 loops=1)\n    -> Filter: (student.id is not null)  (cost=41.00 rows=400) (actual time=1.290..2.777 rows=400 loops=1)\n        -> Table scan on Student  (cost=41.00 rows=400) (actual time=1.288..2.695 rows=400 loops=1)\n    -> Single-row index lookup on <subquery2> using <auto_distinct_key> (studId=student.id)  (actual time=0.001..0.001 rows=0 loops=400)\n        -> Materialize with deduplication  (cost=11.25..11.25 rows=10) (actual time=1.260..1.261 rows=2 loops=1)\n            -> Filter: (transcript.studId is not null)  (cost=10.25 rows=10) (actual time=0.680..0.853 rows=2 loops=1)\n                -> Filter: (transcript.crsCode = <cache>((@v4)))  (cost=10.25 rows=10) (actual time=0.679..0.852 rows=2 loops=1)\n                    -> Covering index scan on Transcript using my_idx  (cost=10.25 rows=100) (actual time=0.601..0.791 rows=100 loops=1)\n'

-- but then changed to use EXISTS which resulted in
-- '-> Nested loop inner join  (cost=481.00 rows=4000) (actual time=0.476..1.833 rows=2 loops=1)\n    -> Filter: (student.id is not null)  (cost=41.00 rows=400) (actual time=0.042..0.970 rows=400 loops=1)\n        -> Table scan on Student  (cost=41.00 rows=400) (actual time=0.041..0.877 rows=400 loops=1)\n    -> Single-row index lookup on <subquery2> using <auto_distinct_key> (studId=student.id)  (actual time=0.001..0.001 rows=0 loops=400)\n        -> Materialize with deduplication  (cost=11.25..11.25 rows=10) (actual time=0.728..0.729 rows=2 loops=1)\n            -> Filter: (transcript.studId is not null)  (cost=10.25 rows=10) (actual time=0.100..0.296 rows=2 loops=1)\n                -> Filter: (transcript.crsCode = <cache>((@v4)))  (cost=10.25 rows=10) (actual time=0.100..0.295 rows=2 loops=1)\n                    -> Covering index scan on Transcript using my_idx  (cost=10.25 rows=100) (actual time=0.017..0.235 rows=100 loops=1)\n'



-- 3. List the names of students who have taken course v4 (crsCode).
-- SELECT name FROM Student WHERE id IN (SELECT studId FROM Transcript WHERE crsCode = @v4);
SELECT name FROM Student WHERE EXISTS(SELECT 1 FROM Transcript WHERE Transcript.crsCode = @v4 AND Student.id = Transcript.studId);