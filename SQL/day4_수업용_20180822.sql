/*
    DAY4_20180823_허대원
*/

-- GROUP BY 
SELECT DEPT_CODE, SUM(SALARY)
FROM EMPLOYEE
GROUP BY DEPT_CODE
ORDER BY 1;

-- HAVING

SELECT DEPT_CODE, SUM(SALARY)
FROM EMPLOYEE
WHERE DEPT_CODE IS NOT NULL
GROUP BY DEPT_CODE
HAVING SUM(SALARY) > 7000000;


-- 1. 실습
-- EMPLOYEE 테이블에서
-- 직급 별 그룹을 묶어
-- 직급 코드, 급여 합계, 급여 평균, 인원수를 조회 하시오.
SELECT
    JOB_CODE as  "직급코드",
    SUM(SALARY) as "급여합계",
    TRUNC(AVG(SALARY)) as "급여평균",
    COUNT(*) as "인원수"
FROM EMPLOYEE
GROUP BY JOB_CODE
HAVING COUNT(*) > 3
ORDER BY 인원수 DESC;

-- ROLLUP & CUBE
-- 그룹 별 집계를 산출하는 함수
-- 특정 그룹에 대한 집계 및 자동 총 집계를 산출해주며
-- GROUP BY 구문에서만 사용할 수 있다.

-- 일반 쿼리 --
SELECT 
    DEPT_CODE, JOB_CODE, SUM(SALARY)
FROM EMPLOYEE
GROUP BY DEPT_CODE, JOB_CODE
ORDER BY 1,2;

-- ROLLUP
SELECT 
    DEPT_CODE, JOB_CODE, SUM(SALARY)
FROM EMPLOYEE
GROUP BY ROLLUP(DETP_CODE, JOB_CODE)
ORDER BY 1, 2;


SELECT 
    DEPT_CODE, JOB_CODE, SUM(SALARY)
FROM EMPLOYEE
GROUP BY ROLLUP(JOB_CODE, DEPT_CODE)
ORDER BY 1, 2;


-- CUBE -- 
SELECT DEPT_CODE, JOB_CODE, SUM(SALARY)
FROM EMPLOYEE
GROUP BY CUBE(DEPT_CODE, JOB_CODE)
ORDER BY 1, 2;

-- 그룹 우선순위를 변경해도 결과가 동일하다
SELECT DEPT_CODE, JOB_CODE, SUM(SALARY)
FROM EMPLOYEE
GROUP BY CUBE(JOB_CODE, DEPT_CODE)
ORDER BY 1 NULLS FIRST, 2 NULLS LAST;

-- GROUPING 
-- 자동 집계 여부를 확인하는 함수
-- GROUPING(컬럼명) : 
-- 해당 컬럼이 자동 집계될 것인지 확인
-- 1 : 자동으로 집계되어 추가된 컬럼
-- 0 : 본래 쿼리의 결과 (자동 집계되지 않은 결과)

SELECT 
    DEPT_CODE, JOB_CODE, SUM(SALARY),
    GROUPING(DEPT_CODE) "부서 자동집계 여부",
    GROUPING(JOB_CODE) "직급 자동집계 여부"
FROM EMPLOYEE
GROUP BY CUBE(DEPT_CODE, JOB_CODE)
ORDER BY 1,2;

--------------------

SELECT DEPT_CODE, JOB_CODE, SUM(SALARY),
    CASE WHEN GROUPING(DEPT_CODE) = 0
            AND GROUPING(JOB_CODE) = 1
            THEN '부서 총 합계'
          WHEN GROUPING(DEPT_CODE) = 1
            AND GROUPING(JOB_CODE) = 0
            THEN '직급 총 합계'
          WHEN GROUPING(DEPT_CODE) = 1
            AND GROUPING(JOB_CODE) = 1
            THEN '전체 총 합계'
            ELSE '그룹별 합계'
    END "합계 구분"
FROM EMPLOYEE
GROUP BY CUBE(DEPT_CODE, JOB_CODE)
ORDER BY 1, 2, 4;

--------------------------
/*
DECODE 함수와 GROUPING 함수를 활용하여
다음과 같은 결과를 출력하는 SQL을 만드시오.
(단, 부서가 NULL일 경우 DEPT NONE으로 출력한다.)
*/
SELECT 
    DECODE(GROUPING(DEPT_CODE), 1, DECODE(GROUPING(JOB_CODE),  1,'총합계',  0,'직급별합계'), 
                                 0, NVL(DEPT_CODE,'DEPTNONE')) 
                                 AS "부서",
    DECODE(GROUPING(JOB_CODE),  1, DECODE(GROUPING(DEPT_CODE), 1, '-----',  0,'부서별합계'), 
                                 0, JOB_CODE, '------') 
                                 AS "직급",
    SUM(SALARY)
FROM EMPLOYEE
GROUP BY CUBE(DEPT_CODE, JOB_CODE)
ORDER BY 1, 2;



SELECT 
    DECODE(GROUPING(DEPT_CODE), 1 , DECODE( GROUPING(JOB_CODE), 1,'총합계','직급 합계'), NVL(DEPT_CODE,'Dept None')) "부서",
    DECODE(GROUPING(JOB_CODE), 1 , DECODE(GROUPING(DEPT_CODE), 1,'-----', '부서 합계'), JOB_CODE) "직급",
    SUM(SALARY),
    GROUPING(DEPT_CODE),
    GROUPING(JOB_CODE)
FROM EMPLOYEE
GROUP BY CUBE(DEPT_CODE, JOB_CODE)
ORDER BY 1,2;


-- SET OPERATION --
-- 두 개 이상의 SELECT 한 결과(RESULT SET)를 
-- 합치거나, 중복을 별도로 제하거나 하는
-- 집합으로써의 제 2의 결과를 산출해내는 명령어

-- 합집합 --
-- UNION : 두 개 이상의 RESULT SET의 합을 구하는 명령어
--         두 개 이상의 결과를 합쳐서 보여준다
--         (단, 중복되는 결과가 있을 경우 한개의 행만 보여준다.)

-- UNION ALL : 두 개 이상의 결과를 합쳐서 보여준다.
--             중복되는 결과가 있다면 모두 보여 줌으로써 중복을 제거하지 않는다.

-- 교집합 --
-- INTERSECT : 두 개 이상의 결과중 중복되는 결과만 출력한다.

-- 차집합 --
-- MINUS : A 와 B의 결과를 합쳤을때 
--         우선 되는 A 중 B 와 곂치지 않는 결과만 출력하는 명령어.

-- ** 어떤 SET 명령어를 사용하던지, 그 결과의 모양은 반드시 같아야 한다.
-- SELECT 한 결과인 A와 SELECT 한 결과인 B를 합칠경우
-- A와 B의 COLUMN 갯수와 COLUMN의 자료형이 반드시 같아야 한다.


-- UNION(합집합) --
-- 두 결과셋(Result Set)의 합을 구하는 집합 명령어

SELECT EMP_ID,EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE DEPT_CODE = 'D5'

UNION

SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY > 3000000;

-- UNION ALL(합집합) --
-- 두 개 이상의 결과셋(Result Set)을 하나로 합치는 집합 연산자
-- 단, 우선 수행되는 결과셋 기준으로 데이터를 합치며
-- 중복이 발생할 경우에도 중복을 그대로 포함하여 출력한다.
SELECT EMP_ID,EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE DEPT_CODE = 'D5'

UNION ALL

SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY > 3000000;

-- ROLLUP을 CUBE 처럼 조회하는 방법 -- 
SELECT DEPT_CODE, JOB_CODE, SUM(SALARY)
FROM EMPLOYEE
GROUP BY ROLLUP(DEPT_CODE, JOB_CODE)
--ORDER BY 1, 2;

UNION

SELECT '', JOB_CODE, SUM(SALARY)
FROM EMPLOYEE
GROUP BY ROLLUP(JOB_CODE, DEPT_CODE)
ORDER BY 1,2;


-- INTERSECT (교집합)
-- 두 개 이상의 결과들을 합하여
-- 중복되는 값만 추출하는 집합 연산자

-- D5번 부서 직원들의 정보와
-- 급여가 300만원 이상인 직원들의 정보를 합하여,
-- 두 결과중 같은 값만 출력하기

SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE DEPT_CODE = 'D5'

INTERSECT

SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY >= 3000000;


-- MINUS(차집합) --
-- 두 개 이상의 결과셋(Result Set)중
-- 가장 처음 결과 셋어서 다음에 위치하는 결과들을
-- 뺀 나머지를 추출하는 연산자다

SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE DEPT_CODE = 'D5'

MINUS

SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY >= 3000000
ORDER BY 2;


-- GROUPING SET(그룹 집합 연산자)
-- 그룹 별로 처리된 여러개의 결과셋을 하나로 합칠 때 사용한다.

SELECT DEPT_CODE, JOB_CODE, MANAGER_ID, TRUNC(AVG(SALARY))
FROM EMPLOYEE
GROUP BY GROUPING SETS(
        (DEPT_CODE, JOB_CODE, MANAGER_ID),
        (DEPT_CODE, MANAGER_ID),
        (JOB_CODE, MANAGER_ID)
);

---------------------------------------------------
-- JOIN --
-- 두 개 이상의 테이블을 하나로 합칠 때 사용하는 명령어

-- 만약에 'J6'라는 직급을 가진 사원들이 근무하는 부서의 이름을 알고 싶다면..?
SELECT EMP_NAME, JOB_CODE, DEPT_CODE
FROM EMPLOYEE
WHERE JOB_CODE = 'J6';

SELECT * FROM DEPARTMENT;


SELECT DEPT_TITLE
FROM DEPARTMENT
WHERE DEPT_ID IN ('D1', 'D8');

--- 오라클 전용 구문 ---
-- FROM 구문에 ',' 기호를 통해 합치게 될 테이블들을 
-- 나열하고 WHERE 조건을 통해 합칠 테이블 들의 공통점을 연결하여
-- 하나의 테이블 형식으로 구축한다.

SELECT EMP_ID, EMP_NAME, DEPT_CODE, DEPT_TITLE
FROM EMPLOYEE, DEPARTMENT
WHERE DEPT_CODE = DEPT_ID;

SELECT * FROM EMPLOYEE;
SELECT * FROM JOB;

SELECT EMP_ID , EMP_NAME, E.JOB_CODE, J.JOB_NAME
FROM EMPLOYEE E, JOB J
WHERE E.JOB_CODE = J.JOB_CODE;


--- ANSI 표준 구문 ---
-- 조인하고자 하는 테이블을 FROM 구문 다음에
-- JOIN 테이블명 ON() | USING() 구문을 사용하여
-- 두개 이상의 테이블을 합친다.

-- 두개의 테이블이 제공하는 컬럼이름이 다를경우
SELECT EMP_ID, EMP_NAME, DEPT_CODE, DEPT_TITLE
FROM EMPLOYEE 
JOIN DEPARTMENT 
-- ON(EMPLOYEE.DEPT_CODE = DEPARTMENT.DEPT_ID);
ON(DEPT_CODE = DEPT_ID);

-- 두 개의 테이블이 제공하는 컬럼명이 같을 경우
SELECT EMP_ID, EMP_NAME, JOB_CODE, JOB_NAME
FROM EMPLOYEE
JOIN JOB USING(JOB_CODE);

-- 2. 실습
-- EMPLOYEE 테이블의 직원 급여정보와
-- SAL_GRADE의 급여 등급을 합쳐서
-- 사번, 사원명, 급여등급, 등급기준 최소 급여, 최대 급여
SELECT * FROM SAL_GRADE;
SELECT * FROM EMPLOYEE; -- SAL_LEVEL

-- 오라클
SELECT E.EMP_ID, E.EMP_NAME, E.SAL_LEVEL, S.MIN_SAL, S.MAX_SAL
FROM EMPLOYEE E, SAL_GRADE S
WHERE E.SAL_LEVEL = S.SAL_LEVEL;

-- ANSI
SELECT E.EMP_ID, E.EMP_NAME, E.SAL_LEVEL, S.MIN_SAL, S.MAX_SAL
FROM EMPLOYEE E
JOIN SAL_GRADE S ON(E.SAL_LEVEL = S.SAL_LEVEL);
--JOIN SAL_GRADE S ON E.SAL_LEVEL = S.SAL_LEVEL;

SELECT EMP_ID, EMP_NAME, SAL_LEVEL, MIN_SAL, MAX_SAL
FROM EMPLOYEE
JOIN SAL_GRADE USING(SAL_LEVEL);


-- 3. 실습
-- DEPARTMENT 테이블의 위치정보(LOACTION)와
-- LOCATION 테이블을 조인하여
-- 각 부서 별 근무지 위치를 조회하시오
-- 부서코드, 부서명, 근무지 코드, 근무지 위치

-- 오라클
SELECT DEPT_ID, DEPT_TITLE, LOCATION_ID, LOCAL_CODE, LOCAL_NAME
FROM DEPARTMENT, LOCATION
WHERE LOCAL_CODE = LOCATION_ID;


-- ANSI
SELECT D.DEPT_ID, D.DEPT_TITLE, D.LOCATION_ID, L.LOCAL_NAME
FROM DEPARTMENT D
JOIN LOCATION L  ON L.LOCAL_CODE = D.LOCATION_ID;


-- INNER JOIN 과 OUTER JOIN
-- 두 개 이상의 테이블을 하나로 합칠 때,
-- INNER JOIN 은 둘 모두 일치하는 데이터만 추출하고,
-- OUTER JOIN은 둘 중 하나만, 혹은 둘 모두가 가진 모든 값을 추출할 대 사용한다.

-- INNER JOIN
SELECT DEPT_CODE, EMP_NAME
FROM EMPLOYEE
JOIN DEPARTMENT ON(DEPT_CODE = DEPT_ID);

-- LEFT OUTER JOIN : 두 테이블 중 원본 테이블의 정보를
--                   모두 포함하고자 할 때 사용한다.
-- RIGHT OUTER JOIN : 두 테이블 중 JOIN에 명시한 테이블이
--                    가진 모든 정보를 포함할 때 사용한다.
-- FULL OUTER JOIN : 두 테이블이 각각 가지는 모든 정보들을
--                   포함하여 합칠 때 사용한다.

-- LEFT JOIN --

-- ANSI 표준 구문 --
SELECT DEPT_CODE, EMP_NAME
FROM EMPLOYEE
LEFT JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID);

-- ORACLE 구문 --
SELECT DEPT_CODE, EMP_NAME
FROM EMPLOYEE, DEPARTMENT
WHERE DEPT_CODE = DEPT_ID(+);

-- RIGHT JOIN --

SELECT * FROM DEPARTMENT;
SELECT DISTINCT DEPT_CODE
FROM EMPLOYEE;

-- ANSI 표준 구문 --
SELECT DEPT_CODE, DEPT_ID, EMP_NAME
FROM EMPLOYEE
RIGHT JOIN DEPARTMENT ON(DEPT_CODE = DEPT_ID);

-- ORACLE 구문 --
SELECT DEPT_ID, EMP_NAME
FROM EMPLOYEE, DEPARTMENT
WHERE DEPT_CODE(+) = DEPT_ID;


-- FULL OUTER JOIN --

-- ANSI 구문 --
SELECT DEPT_CODE, DEPT_ID, EMP_NAME
FROM EMPLOYEE
FULL JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID);


-- ORACLE 구문 --
-- ORCAL은 FULL OUTER JOIN을 
-- 사용하지 못한다
SELECT DEPT_CODE, DEPT_ID, EMP_NAME
FROM EMPLOYEE, DEPARTMENT
WHERE DEPT_CODE(+) = DEPT_ID(+);

-- CROSS JOIN
-- 기본적으로 JOIN 이라고 하면
-- 양 측의 테이블 모두 하나씩은 일치하는 컬럼을
-- 가지고 JOIN을 수행하는데, 이를 EQUAL JOIN(EQ JOIN)이라고 한다.
-- 만약 서로 같은 값을 가지지 않는 테이블을 조회하려고 할 경우
-- 사용하는 JOIN 방식이 CROSS JOIN 이다.

SELECT EMP_NAME, NATIONAL_CODE
FROM EMPLOYEE
CROSS JOIN NATIONAL;


-- CROSS JOIN을 사용할 경우, JOIN의 결과가
-- 카테시안 곱의 형태로 추출되는데,
-- 카테시안 곱이란, 각 컬럼의 결과가
-- 경우의 수 갯수 형태로 출력되는 것을 이야기 한다.
-- 따라서 CROSS JOIN이란, 가장 사용을 지양하는 조인방식
-- 이며, 어쩔 수 없이 사용할 경우 이러한 형태의 결과로
-- 추출되는 것을 반드시 고려해야 한다.


-- NON EQ JOIN
-- 지정한 컬럼 값 자체가 아닌
-- 특정 범위 내에 존재하는 조건으로 JOIN을 수행할 경우
-- 사용하는 JOIN 방식

-- ON() 안에 들어가는 형식은 컬럼명 뿐만 아니라
-- 계산식이나 범위, 혹은 AND | OR 같은 조건식, 표현식이
-- 가능하다.
SELECT EMP_NAME, DEPT_CODE, SALARY, E.SAL_LEVEL
FROM EMPLOYEE E
JOIN SAL_GRADE S ON (SALARY BETWEEN MIN_SAL AND MAX_SAL);

-- SELF JOIN
-- 자기 자신을 조인의 대상으로 삼아
-- 한 테이블의 정보 중 값 비교가 필요한 정보들을
-- 계산하여 추출하는 방식

SELECT EMP_ID, EMP_NAME, MANAGER_ID
FROM EMPLOYEE;

-- 직원의 정보와 직원을 담당하는 매니저의 정보를 
-- 조회하는 쿼리

-- ORACLE 구문 --
SELECT 
    E.EMP_ID, 
    E.EMP_NAME, 
    E.MANAGER_ID, 
    M.EMP_NAME as "매니저"
FROM EMPLOYEE E, EMPLOYEE M 
WHERE E.MANAGER_ID = M.EMP_ID;


-- ANSI 구문 --
SELECT 
    E.EMP_ID, 
    E.EMP_NAME, 
    E.MANAGER_ID, 
    M.EMP_NAME as "매니저"
FROM EMPLOYEE E
JOIN EMPLOYEE M ON (E.MANAGER_ID = M.EMP_ID);

-- 다중 JOIN
-- 여러 개의 테이블을 JOIN 하는 것은 다중 조인이라고 한다.
-- 일반 조인과 선언 형식은 같으나, 조인 한 결과를 기준으로
-- 다음 조인을 수행하기 때문에 JOIN 선언의
-- 순서에 반드시 유의해야 한다.


-- ORACLE 구문 --
SELECT 
    EMP_ID, EMP_NAME, DEPT_TITLE, LOCAL_NAME
FROM 
    EMPLOYEE, DEPARTMENT, LOCATION
WHERE 
    DEPT_CODE = DEPT_ID
    AND LOCATION_ID = LOCAL_CODE;

-- ANSI 구문 --
SELECT 
    EMP_ID, EMP_NAME, DEPT_TITLE, LOCAL_NAME
FROM 
    EMPLOYEE
JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
JOIN LOCATION ON (LOCATION_ID = LOCAL_CODE);

SELECT * FROM DEPARTMENT; 


-- 4. 직급이 대리이면서 아시아 지역에 근무하는 직원 조회
-- 사번, 사원명, 직급명, 부서명, 근무지역명, 급여를 조회 하시오

-- ORACLE --
SELECT 
    E.EMP_ID, E.EMP_NAME, J.JOB_NAME, D.DEPT_TITLE, L.LOCAL_NAME, E.SALARY
FROM EMPLOYEE E, JOB J, DEPARTMENT D, LOCATION L
WHERE 
    J.JOB_CODE = E.JOB_CODE
    AND DEPT_CODE = DEPT_ID
    AND LOCATION_ID = LOCAL_CODE
    AND J.JOB_NAME='대리'
    AND SUBSTR(L.LOCAL_NAME, 1,4) = 'ASIA';
    --AND L.LOCAL_NAME LIKE 'ASIA%';
    --AND L.LOCAL_NAME IN ('ASIA1', 'ASIA2', 'ASIS3');


-- ANSI --
SELECT 
    E.EMP_ID, E.EMP_NAME, J.JOB_NAME, D.DEPT_TITLE, L.LOCAL_NAME, E.SALARY
FROM EMPLOYEE E
JOIN 
    JOB J USING(JOB_CODE)
JOIN 
    DEPARTMENT D ON (DEPT_CODE = DEPT_ID)
JOIN 
    LOCATION L ON (LOCAL_CODE = LOCATION_ID)
WHERE 
    J.JOB_NAME='대리'
    --AND L.LOCAL_NAME LIKE 'ASIA%';
    --AND L.LOCAL_NAME IN ('ASIA1', 'ASIA2', 'ASIS3');
    AND SUBSTR(L.LOCAL_NAME, 1,4) = 'ASIA';

SELECT * FROM LOCATION;



--JOIN 연습문제
--
--1. 2020년 12월 25일이 무슨 요일인지 조회하시오.
SELECT 
    TO_CHAR(TO_DATE('20201225'), 'day') AS "2020년 12월 25일"
FROM 
    DUAL;

--2. 주민번호가 70년대 생이면서 성별이 여자이고, 성이 전씨인 직원들의 
--사원명, 주민번호, 부서명, 직급명을 조회하시오.
SELECT 
    EMP_NAME AS "사원명",
    EMP_NO AS "주민번호",
    DEPT_TITLE AS "부서명",
    JOB_NAME AS "직급명"
FROM 
    EMPLOYEE
JOIN JOB USING(JOB_CODE)
JOIN DEPARTMENT ON DEPT_ID = DEPT_CODE
WHERE
    SUBSTR(EMP_NO, 1, 1)='7'
    AND SUBSTR(EMP_NO, 8, 1)='2'
    AND EMP_NAME LIKE '전%';
    
SELECT * FROM DEPARTMENT;
SELECT * FROM JOB;
SELECT * FROM EMPLOYEE;


--3. 가장 나이가 적은 직원의 사번, 사원명, 나이, 부서명, 직급명을 조회하시오.
SELECT 
    EMP_ID AS "사번",
    EMP_NAME AS "사원명",
    TRUNC(MONTHS_BETWEEN(SYSDATE,TO_DATE(SUBSTR(EMP_NO,1,6)))/12) AS "나이",
    DEPT_TITLE AS "부서명",
    JOB_NAME AS "직급명"
FROM
EMPLOYEE
JOIN DEPARTMENT ON (DEPT_ID = DEPT_CODE)
JOIN JOB USING(JOB_CODE)
WHERE
    EMP_ID NOT IN('200', '201','214') AND
    TO_DATE(SUBSTR(EMP_NO,1,6)) = (
SELECT 
    MAX(TO_DATE(SUBSTR(EMP_NO,1,6)))
FROM 
    EMPLOYEE
WHERE 
    EMP_ID NOT IN('200', '201','214')
    );


--4. 이름에 '형'자가 들어가는 직원들의 사번, 사원명, 부서명을 조회하시오.
SELECT 
    EMP_ID,
    EMP_NAME,
    DEPT_TITLE
FROM
    EMPLOYEE
JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID
WHERE 
    EMP_NAME LIKE '%형%';    


--5. 해외영업팀에 근무하는 사원명, 직급명, 부서코드, 부서명을 조회하시오.
SELECT 
    EMP_NAME,
    JOB_NAME,
    DEPT_CODE,
    DEPT_TITLE
FROM 
    EMPLOYEE
JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID
JOIN JOB USING(JOB_CODE)
WHERE
    DEPT_TITLE LIKE '해외영업%';

--6. 보너스포인트를 받는 직원들의 사원명, 보너스포인트, 부서명, 근무지역명을 조회하시오.
SELECT 
    EMP_NAME,
    BONUS,
    DEPT_TITLE,
    LOCAL_NAME
FROM 
    EMPLOYEE
JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID
JOIN LOCATION ON  LOCATION_ID = LOCAL_CODE
WHERE BONUS IS NOT NULL;

--7. 부서코드가 D2인 직원들의 사원명, 직급명, 부서명, 근무지역명을 조회하시오.
SELECT 
    EMP_NAME,
    JOB_NAME,
    DEPT_TITLE,
    LOCAL_NAME
FROM
    EMPLOYEE
JOIN JOB USING(JOB_CODE)
JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID
JOIN LOCATION ON LOCAL_CODE = LOCATION_ID
WHERE DEPT_CODE = 'D2';


--8. 연봉의 최소급여(MIN_SAL)보다 많이 받는 직원들의
--사원명, 직급명, 급여, 연봉을 조회하시오.
--연봉에 보너스포인트를 적용하시오.

SELECT
    EMP_NAME "사원명",
    JOB_NAME "직급명",
    SALARY "급여",
    SALARY*12*(1+NVL(BONUS,0)) "연봉"
FROM 
    EMPLOYEE
JOIN JOB USING (JOB_CODE)
JOIN SAL_GRADE USING (SAL_LEVEL)
WHERE SALARY > MIN_SAL;

--9. 한국(KO)과 일본(JP)에 근무하는 직원들의 
--사원명, 부서명, 지역명, 국가명을 조회하시오.
SELECT 
    EMP_NAME,
    DEPT_TITLE,
    LOCAL_NAME,
    NATIONAL_NAME
FROM
    EMPLOYEE
JOIN DEPARTMENT ON DEPT_CODE=DEPT_ID
JOIN LOCATION ON LOCAL_CODE = LOCATION_ID
JOIN NATIONAL USING(NATIONAL_CODE)
WHERE 
    NATIONAL_NAME IN ('한국', '중국');


--10. 같은 부서에 근무하는 직원들의 사원명, 부서코드, 동료이름을 조회하시오.
--self join 사용
SELECT
    E.EMP_NAME "사원명",
    DEPT_CODE "부서코드",
    M.EMP_NAME "동료이름"
FROM
    EMPLOYEE E
JOIN EMPLOYEE M USING(DEPT_CODE)
ORDER BY 1;


--11. 보너스포인트가 없는 직원들 중에서 직급코드가 J4와 J7인 직원들의 사원명, 직급명, 급여를 조회하시오.
--단, join과 IN 사용할 것
SELECT 
    EMP_NAME,
    JOB_NAME,
    SALARY
FROM
    EMPLOYEE
JOIN JOB USING(JOB_CODE)
WHERE BONUS IS NULL
AND JOB_CODE IN ('J4','J7');

--12. 재직중인 직원과 퇴사한 직원의 수를 조회하시오.
SELECT
    COUNT(*)-COUNT(ENT_DATE) AS "재직중인 직원",
    COUNT(ENT_DATE) AS "퇴사한 직원" 
FROM EMPLOYEE;










