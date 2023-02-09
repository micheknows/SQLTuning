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

-- 4. List the names of students who have taken a course taught by professor v5 (name).
EXPLAIN ANALYZE SELECT name FROM Student,
	(SELECT studId FROM Transcript,
		(SELECT crsCode, semester FROM Professor
			JOIN Teaching
			WHERE Professor.name = @v5 AND Professor.id = Teaching.profId) as alias1
	WHERE Transcript.crsCode = alias1.crsCode AND Transcript.semester = alias1.semester) as alias2
WHERE Student.id = alias2.studId;

-- the original results were
-- '-> Nested loop inner join  (cost=761.00 rows=400) (actual time=17.707..17.707 rows=0 loops=1)\n    -> Nested loop inner join  (cost=321.00 rows=400) (actual time=17.706..17.706 rows=0 loops=1)\n        -> Nested loop inner join  (cost=181.00 rows=400) (actual time=0.107..2.370 rows=100 loops=1)\n            -> Filter: (student.id is not null)  (cost=41.00 rows=400) (actual time=0.036..0.661 rows=400 loops=1)\n                -> Table scan on Student  (cost=41.00 rows=400) (actual time=0.034..0.570 rows=400 loops=1)\n            -> Filter: (transcript.semester is not null)  (cost=0.25 rows=1) (actual time=0.004..0.004 rows=0 loops=400)\n                -> Index lookup on Transcript using my_idx (studId=student.id), with index condition: (transcript.crsCode is not null)  (cost=0.25 rows=1) (actual time=0.003..0.004 rows=0 loops=400)\n        -> Filter: (teaching.profId is not null)  (cost=0.25 rows=1) (actual time=0.153..0.153 rows=0 loops=100)\n            -> Index lookup on Teaching using teaching_idx (crsCode=transcript.crsCode, semester=transcript.semester)  (cost=0.25 rows=1) (actual time=0.153..0.153 rows=0 loops=100)\n    -> Covering index lookup on Professor using prof_idx (id=teaching.profId, name=(@v5))  (cost=1.00 rows=1) (never executed)\n'

-- tried to change to joins but couldn't get a join to work with the alias that seems to be necessary

-- created index for student.id, transcript.stuid, teaching.crscode, teaching.semester, teaching.profid
-- new results
-- '-> Nested loop inner join  (cost=49.22 rows=1) (actual time=1.883..1.883 rows=0 loops=1)\n    -> Nested loop inner join  (cost=48.86 rows=1) (actual time=1.882..1.882 rows=0 loops=1)\n        -> Nested loop inner join  (cost=45.25 rows=10) (actual time=1.471..1.808 rows=1 loops=1)\n            -> Filter: ((teaching.profId is not null) and (teaching.crsCode is not null))  (cost=10.25 rows=100) (actual time=0.053..0.336 rows=100 loops=1)\n                -> Covering index scan on Teaching using idx_teaching_crsCode_semester_profId  (cost=10.25 rows=100) (actual time=0.050..0.287 rows=100 loops=1)\n            -> Filter: (professor.`name` = <cache>((@v5)))  (cost=0.25 rows=0) (actual time=0.014..0.014 rows=0 loops=100)\n                -> Index lookup on Professor using idx_professor_id (id=teaching.profId)  (cost=0.25 rows=1) (actual time=0.011..0.013 rows=1 loops=100)\n        -> Filter: ((transcript.semester = teaching.semester) and (transcript.studId is not null))  (cost=0.26 rows=0) (actual time=0.073..0.073 rows=0 loops=1)\n            -> Index lookup on Transcript using idx_transcript_crsCode (crsCode=teaching.crsCode)  (cost=0.26 rows=1) (actual time=0.061..0.070 rows=2 loops=1)\n    -> Index lookup on Student using idx_student_id (id=transcript.studId)  (cost=0.35 rows=1) (never executed)\n'

