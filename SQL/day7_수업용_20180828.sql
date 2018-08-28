-- DAY 7 -- 


-- 서브쿼리
-- 메인 쿼리 안에서
-- 조건이나, 하나의 검색을 위한 기반을
-- 형성할 수 있는 또 하나의 쿼리문

-- 단일 행 서브쿼리
--      결과값이 1개 나오는 쿼리
-- EMPLOYEE 테이블에서 가장 적은 급여을 받는 사원의 정보를 조회 하시오

SELECT MIN(SALARY) FROM EMPLOYEE;

SELECT * FROM EMPLOYEE
WHERE SALARY = (
                    SELECT MIN(SALARY) FROM EMPLOYEE
                );
                
-- 다중 행 서브쿼리
--      결과 값이 여러개 나오는 서브 쿼리
-- 각 직급의 최소 급여보다 높게 받는 직원 정보를 조회하시오

SELECT JOB_CODE, MIN(SALARY) 
FROM EMPLOYEE
GROUP BY JOB_CODE;

SELECT *
FROM EMPLOYEE
WHERE SALARY IN ( SELECT MIN(SALARY)
                   FROM EMPLOYEE
                   GROUP BY JOB_CODE
                 );

-- 다중 행 다중 열 서브쿼리
--      컬럼 값과 결과 행의 개수가 여러 개인 서브 쿼리

SELECT *
FROM EMPLOYEE
WHERE (JOB_CODE, SALARY) IN (
                                SELECT JOB_CODE, MIN(SALARY)
                                FROM EMPLOYEE
                                GROUP BY JOB_CODE
                              );
                              
-- 다중 열 서브쿼리
--      여러 컬럼을 결과로 추출하는 서브쿼리

-- 퇴사한 여직원과 같은 직급, 같은 부서에 근무하는
-- 직원들의 정보를 조회 하시오

SELECT *
FROM EMPLOYEE
WHERE ENT_YN = 'Y';

-- 단일 행 서브쿼리로 구현한 예
SELECT * FROM EMPLOYEE
WHERE DEPT_CODE = ( SELECT DEPT_CODE
                     FROM EMPLOYEE
                     WHERE ENT_YN = 'Y'
                   )
        AND JOB_CODE =  ( SELECT JOB_CODE
                           FROM EMPLOYEE
                           WHERE ENT_YN = 'Y')
        AND EMP_NAME != ( SELECT EMP_NAME
                           FROM EMPLOYEE
                           WHERE ENT_YN = 'Y'
                        );
                        
-- 다중 열 서브쿼리로 변경한다면...
SELECT * FROM EMPLOYEE
WHERE (DEPT_CODE, JOB_CODE) = (SELECT DEPT_CODE, JOB_CODE
                                FROM EMPLOYEE
                                WHERE ENT_YN = 'Y')
    AND EMP_NAME <> (SELECT EMP_NAME
                     FROM EMPLOYEE
                     WHERE ENT_YN = 'Y');
                     
-- 서브 쿼리의 사용 위치
-- SELECT, FROM , WHERE, HAVING, GROUP BY, ORDER BY
-- DML 구문 : INSERT, UPDATE, DELETE
-- DDL 구문 : CREATE TABLE, CREATE VIEW

-- FROM 절에서 사용하는 서브쿼리는
-- 테이블을 직접 조회하는 대신에
-- 서브쿼리의 결과셋(Result Set)을 활용하여
-- 데이터를 조회하는데 사용할 수 있다.
-- 테이블을 대체한다는 의미에서 인라인 뷰(Inline View)라고 부른다.

-- 직급 별 평균 급여를 조회하는 서브쿼리를 사용하여
-- 직원들의 정보를 조회하기

SELECT JOB_CODE, FLOOR(AVG(SALARY))
FROM EMPLOYEE
GROUP BY JOB_CODE;

SELECT EMP_NAME, JOB_NAME, SALARY
FROM (
        SELECT JOB_CODE, TRUNC(AVG(SALARY), -5) AS "JOBAVG"
        FROM EMPLOYEE
        GROUP BY JOB_CODE
        ) V
JOIN JOB J ON (J.JOB_CODE = V.JOB_CODE)
JOIN EMPLOYEE E ON (SALARY = JOBAVG AND
                E.JOB_CODE = V.JOB_CODE);
                
                
-- 인라인 뷰를 활용한 데이터 조회하기
SELECT * FROM EMPLOYEE;

SELECT *
FROM (
    SELECT EMP_ID, EMP_NAME, DEPT_CODE, JOB_CODE
    FROM EMPLOYEE
);

-- TOP-N
-- 인라인 뷰를 활용한 TOP-N 분석

-- ROWNUM
-- 데이터를 조회할 때 각 행의 번호를 매기는 함수

SELECT ROWNUM, EMP_NAME, SALARY
FROM EMPLOYEE;


SELECT ROWNUM, EMP_NAME, SALARY
FROM EMPLOYEE
WHERE ROWNUM <= 5;

-- 1. 실습
-- 급여 기준으로 가장 높은 급여를 받는 사원 상위 5명을
-- 조회하여 사번, 사원명, 급여를 출력 하시오,

-- ROWNUM 은 FROM 구문을 실행 할 때
-- 번호를 매기는 방식으로 처리가 된다.

-- SELECT 시에 번호를 하나하나 부여한다.
-- 1. FROM 다음에 실행 된다.
SELECT ROWNUM, EMP_NAME, SALARY
FROM EMPLOYEE
ORDER BY SALARY DESC;

-- 2. ROWNUM은 반드시 1부터 시작하기 때문에
--      1을 초과한 순서를 따질 수 없다.
SELECT * 
FROM (SELECT ROWNUM RNUM, A.*
        FROM (SELECT EMP_NAME, SALARY
            FROM EMPLOYEE
            ORDER BY SALARY DESC) A)
--WHERE RNUM <= 5;
WHERE RNUM > 5 AND RNUM <= 10;

-- 2. 실습
-- 급여 평균이 3위 안에 드는
-- 부서의 부서 코드, 부서명, 급여 평균을 조회하시오.

SELECT ROWNUM, S.DEPT_CODE, D.DEPT_TITLE ,S.AVGSAL
FROM
(
    SELECT DEPT_CODE, FLOOR(AVG(SALARY)) AVGSAL
    FROM EMPLOYEE
    GROUP BY DEPT_CODE
    ORDER BY AVGSAL DESC
) S
JOIN DEPARTMENT D ON D.DEPT_ID = S.DEPT_CODE
WHERE ROWNUM <= 3;

-- TOP-N 분석
SELECT ROWNUM, A.*
FROM (SELECT DEPT_CODE, DEPT_TITLE, FLOOR(AVG(SALARY))
        FROM DEPARTMENT
        JOIN EMPLOYEE ON (DEPT_ID = DEPT_CODE)
        GROUP BY DEPT_CODE, DEPT_TITLE
        ORDER BY 3 DESC) A
WHERE ROWNUM < 4;

-- TOP-N 분석
-- 상위 N개 혹은 하위 N개의 결과값을 조회하는
-- 인라인 뷰와 ROWNUM 혹은 RANK, DENSE_RANK() 함수를 
-- 활용하여 구현할 수 있다.

-- 직원 정보에서 급여를 많이 받는 직원 순위 조회

-- RANK() 함수
-- 동일한 순위 이후의 등 수를 동일한 순위였던
-- 숫자만큼 건너 뛰고 수행하는 함수
-- 1
-- 2
-- 2
-- 4
SELECT EMP_NAME, SALARY, 
        RANK() OVER(ORDER BY SALARY DESC) 순위
FROM EMPLOYEE;

SELECT *
FROM (
        SELECT EMP_NAME, SALARY, 
                RANK() OVER(ORDER BY SALARY DESC) 순위
        FROM EMPLOYEE
      ) 
WHERE 순위 < 4;


-- DENSE_RANK() 함수
-- 중복되는 순위 이후의 등수를 연속지어서
-- 다음 수로 바로 순위를 매기는 함수
-- 1
-- 2
-- 2
-- 3
SELECT EMP_NAME, SALARY,
        DENSE_RANK() OVER(ORDER BY SALARY DESC) 순위
FROM
    EMPLOYEE;
    
-- 3. 실습
--  EMPLOYEE 테이블에서
--  보너스를 포함한 연봉이 가장 높은 직원 상위 5명을
--  RANK() 함수를 활용하여 조회하시오.
--  사번, 사원명, 부서명, 직급명,  입사일, 연봉(보너스포함)
SELECT *
FROM
(SELECT RANK() OVER(ORDER BY SALARY*(1+NVL(BONUS,0)) DESC) "순위" ,
    EMP_NAME,EMP_ID, DEPT_CODE, DEPT_TITLE, HIRE_DATE, SALARY*(1+NVL(BONUS,0)) "연봉(보너스포함)"
FROM EMPLOYEE
JOIN DEPARTMENT ON DEPT_CODE =DEPT_ID
)
WHERE 순위 <= 5;


--  WITH 구문
-- 동일한 서브쿼리를 반본해서 사용할 경우
-- 해당 쿼리문을 미리 저장해두고
-- 필요할 때 별칭을 통해 꺼내어 쓰는 방식
-- 사용 형식 : WITH 별칭 AS (쿼리문)
-- 인라인 뷰에서만 사용이 가능하다.

-- 중복되는 쿼리문을 반복해서 작성할 필요가 없으며
-- 기존에 저장되어 있는 형식을 사용함으로써 실행 속도를
-- 향상 시킬 수 있다.

-- 급여 정보를 기준으로 내림차순한 쿼리를 WITH 구문에 
-- 저장하여 별칭으로 불러다 쓰기


WITH TOPN_SAL AS (
    SELECT EMP_NAME, SALARY
    FROM EMPLOYEE
    ORDER BY SALARY DESC
)
SELECT * 
FROM TOPN_SAL;

-- 4. 실습
-- 부서별 급여 합계가 전체 부서 급여 총합의
-- 20%보다 많은 부서의 부서명과, 부서 급여 합계를 
-- 조회 하시오.

-- 일반 단일행 서브쿼리

SELECT DEPT_TITLE, SUM(SALARY) "부서 급여 합계"
FROM EMPLOYEE
JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID
GROUP BY DEPT_TITLE
HAVING SUM(SALARY) > (SELECT SUM(SALARY)*0.2
FROM EMPLOYEE);


-- 인라인 뷰
SELECT *
FROM
( 
    SELECT DEPT_TITLE, SUM(SALARY) "부서 급여 합계"
    FROM EMPLOYEE
    JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID
    GROUP BY DEPT_TITLE
    HAVING SUM(SALARY) > (SELECT SUM(SALARY)*0.2
    FROM EMPLOYEE)
);

-- WITH
WITH SUMSAL AS(
    SELECT DEPT_TITLE, SUM(SALARY) "부서 급여 합계"
    FROM EMPLOYEE
    JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID
    GROUP BY DEPT_TITLE
    HAVING SUM(SALARY) > (SELECT SUM(SALARY)*0.2
    FROM EMPLOYEE)
)
SELECT * FROM
SUMSAL;



-- WITH 여러개 등록하여 사용하기

SELECT SUM(SALARY) FROM EMPLOYEE;
SELECT AVG(SALARY) FROM EMPLOYEE;

WITH SUM_SAL AS (SELECT SUM(SALARY) FROM EMPLOYEE),
     AVG_SAL AS (SELECT FLOOR(AVG(SALARY)) FROM EMPLOYEE)
SELECT * FROM SUM_SAL
UNION
SELECT * FROM AVG_SAL;


WITH SUM_SAL AS (SELECT SUM(SALARY) FROM EMPLOYEE),
     AVG_SAL AS (SELECT FLOOR(AVG(SALARY)) FROM EMPLOYEE)
SELECT * FROM SUM_SAL, AVG_SAL;

-- 상[호연]관 서브쿼리
-- 일반적으로 서브 쿼리가 만든결과값을 메인쿼리에서 비교하여
-- 사용하는 서브쿼리와는 다르게
-- 메인쿼리가 사용하는 컬럼값, 계산식등을 서브쿼리가 사용해서
-- 결과를 도출하는 방식의 서브쿼리
-- 메인쿼리의 컬럼값이 변경되면 서브쿼리도 그 영향을 받아
-- 도출되는 값이 다르다.

-- 관리자 사번이 EMPLOYEE 테이블에 존재하는 사원들에 대해서 조회
SELECT EMP_ID, EMP_NAME, DEPT_CODE, MANAGER_ID
FROM EMPLOYEE E
-- WHERE MANAGER_ID IS NOT NULL;
WHERE EXISTS (SELECT EMP_ID
                FROM EMPLOYEE M
                WHERE E.MANAGER_ID = M.EMP_ID);
                
-- 사원의 직급에 따른 급여의 평균보다 많이 받는 사원을 조회하시오
SELECT EMP_ID, EMP_NAME, JOB_CODE, SALARY
FROM EMPLOYEE E
WHERE SALARY > (SELECT AVG(SALARY)
                 FROM EMPLOYEE M
                 WHERE E.JOB_CODE = M.JOB_CODE);
                 
-- 스칼라 서브쿼리
-- 단일행 + 상관쿼리
-- SELECT, WHERE, ORDER BY 구문에서 사용한다.
-- 보통 SELECT 구문에서 많이 사용하기 때문에
-- SELECT LIST 라고도 불린다.

-- 5. 실습
-- 모든 사원의 사번, 사원명, 관리자 사번, 관리자명을 조회 하시오.
-- 단, 관리자가 없을 경우 '없음'으로 표시 하시오.
-- SELECT 구문에 서브쿼리를 사용하여 구현하는 방식

SELECT 
    E.EMP_ID "사번", 
    E.EMP_NAME "사원명", 
    E.MANAGER_ID "관리자 사번",
    NVL((SELECT EMP_NAME FROM EMPLOYEE M WHERE E.MANAGER_ID = M.EMP_ID), '없음') 관리자이름
FROM EMPLOYEE E
ORDER BY 4;

-- WHERE 구문에서 스칼라 서브쿼리 사용하기
-- 자신이 속한 직급의 평균 급여보다 많이 받는 사원의 
-- 이름, 직급명, 급여 정보를 조회하시오
SELECT EMP_NAME, JOB_NAME, SALARY
FROM EMPLOYEE E
JOIN JOB J ON( E.JOB_CODE = J.JOB_CODE)
WHERE SALARY > (SELECT AVG(SALARY)
                FROM EMPLOYEE E2
                WHERE E.JOB_CODE = E2.JOB_CODE);


-- 스칼라 서브쿼리는 유일하게
-- ORDER BY 구문에서 사용할 수 있다.

-- 모든 직원의 사번, 사원명, 소속부서를 조회
-- 부서명 내림차순으로 정렬하는 ORDER BY를
-- 서브쿼리를 사용하여 출력 하시오.


-- 스칼라를 활용할 경우



SELECT
    EMP_ID, EMP_NAME, DEPT_TITLE
FROM EMPLOYEE E
JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID
ORDER BY ( SELECT DEPT_TITLE 
            FROM DEPARTMENT
            WHERE E.DEPT_CODE = DEPT_ID) DESC NULLS LAST;

        


