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

-- 2. List the names of students with id in the range of v2 (id) to v3 (inclusive).
-- at this point an index was also added on the id column so that the index is id, name
-- before was
-- '-> Filter: (student.id between <cache>((@v2)) and <cache>((@v3)))  (cost=5.44 rows=44) (actual time=0.963..2.586 rows=278 loops=1)\n    -> Table scan on Student  (cost=5.44 rows=400) (actual time=0.956..2.428 rows=400 loops=1)\n'

-- now this is 
-- '-> Filter: (student.id between <cache>((@v2)) and <cache>((@v3)))  (cost=41.00 rows=278) (actual time=0.595..0.991 rows=278 loops=1)\n    -> Covering index scan on Student using idx_student_id_name  (cost=41.00 rows=400) (actual time=0.037..0.446 rows=400 loops=1)\n'

EXPLAIN ANALYZE SELECT name FROM Student WHERE id BETWEEN @v2 AND @v3;
