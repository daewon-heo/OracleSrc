-- day3

-- 숫자 데이터 함수

-- ABS() : 주어진 컬럼값이나 숫자 데이터를 절대값으로 변경하는 함수
SELECT ABS(10), ABS(-10)
FROM DUAL;

-- MOD(컬럼명 | 숫자데이터, 나눌숫자) : 주어진 컬럼이나 값을 나눈 나머지를 반환
SELECT MOD(10, 3), MOD(10, 2), MOD(10,5)
FROM DUAL;

-- 1. 실습
-- EMPLOYEE 테이블에서 입사한 사원이 홀수 월인 직원들의
-- 사번, 사원명, 입사일을 조회하시오
SELECT EMP_ID, EMP_NAME , HIRE_DATE, TO_CHAR(HIRE_DATE, 'MM')
FROM EMPLOYEE
WHERE MOD(EXTRACT(MONTH FROM HIRE_DATE), 2) = 1;

-- 표현식 : 컬럼명 | 숫자데이터 | 계산된 데이터
-- ROUND(표현식) : 지정한 자릿수에 맞게 반올림하는 함수
SELECT ROUND(123.456, 0),
        ROUND(123.456, 1),  -- 소수점 둘째자리에서 반올림을 수행
        ROUND(123.456, 2),  -- 소수점 셋째자리에서 반올림을 수행
        ROUND(123.456, -2),  -- 음수일 경우 10의 제곱수에 따른 10의 자리반올림
        ROUND(123.456, -1)  -- 음수일 경우 10의 제곱수에 따른 10의 자리반올림
FROM DUAL;

-- CEIL(표현식) : 소수점 첫째자리에서 올림하는 함수
SELECT CEIL(123.456) FROM DUAL;

-- FLOOR(표현식) : 소수점 이하 자리를 버림하는 함수
SELECT FLOOR(123.456) FROM DUAL;

-- TRUNC(표현식, 자릿수) : 지정한 위치까지 절삭(버림)하는 함수
SELECT TRUNC(123.456, 0),
        TRUNC(123.456, 1),
        TRUNC(123.456, 2),
        TRUNC(123.456, -2),
        TRUNC(123.456, -1)
FROM DUAL;

-----------------------------

-- 날짜 데이터 함수
-- SYSTADET, MOTHS_BETWEEN, ADD_MONTH
-- NEXT_DAY, LAST_DAY, EXTRACT

-- 오늘 날짜를 불러오는 함수
-- SYSDATE : 오늘 날짜를 불러오는 함수
-- SYSTIMESTAMP : 오늘 날짜와 시간을 모두 가져오는 함수
SELECT SYSDATE FROM DUAL;

SELECT SYSDATE, SYSTIMESTAMP FROM DUAL;

-- MONTH_BETWEEN(날짜1, 날짜2) : 
-- 두 날짜 사이의 개월 수를 계산하는 함수
SELECT EMP_NAME,
        HIRE_DATE,
        TRUNC(MONTHS_BETWEEN(SYSDATE, HIRE_DATE))
FROM EMPLOYEE;

-- ADD MONTHS(특정 날짜, 이후의 개월 수)
-- 지정한 개월 후의 날짜를 계산하여 반환하는 함수
SELECT EMP_NAME,
        HIRE_DATE,
        ADD_MONTHS(HIRE_DATE, 6)
FROM EMPLOYEE;

-- NEXT_DAY(날짜, 요일명) : 가장 가까운 요일을 계산하여 반환하는 함수

SELECT NEXT_DAY(SYSDATE, '토요일') FROM DUAL;
SELECT NEXT_DAY(SYSDATE, '토') FROM DUAL;

-- 요일을 숫자로 구분할 수도 있다 1:일요일 ~ 7:토요일
SELECT NEXT_DAY(SYSDATE, 7) FROM DUAL;
SELECT NEXT_DAY(SYSDATE, 'SATURDAY') FROM DUAL;

-- 현재 계정에 설정된 데이터 베이스 정보 확인하기
-- 데이터 딕셔너리 : 
-- 관계형 데이터 베이스는 DBMS의 설정 정보들을
-- 테이블 형태로 관리하는데 
-- 이를 데이터 사전(데이터 딕셔너리)라고 한다.
-- 기본적으로 시스템의 관리자만 설정을 변경할 수 있다.
-- 단, 사용자 계정과 관련된 설정은 사용자가 접속한 동안에
-- 임시로 변경할 수 있으며,
-- 계정을 접속 해제할 때 설정이 초기화 되어
-- 재접속할 경우 이전의 설정 내용이 반영 되지 않는다.
SELECT * FROM V$NLS_PARAMETERS;

-- ALTER SESSION SET NLS_LANGUAGE = AMERICAN;
ALTER SESSION SET NLS_LANGUAGE = KOREAN;

-- LAST_DAY(날짜) : 해당 날짜의 마지막 일자를 반환하는 함수
SELECT LAST_DAY(SYSDATE) FROM DUAL;

-- 2. 실습
-- EMPLOYEE 테이블에서 사원 정보를 조회하되
-- 근무 년수가 20년 이상인 사원들의 
-- 사번, 사원명, 부서코드, 입사일을  조회하시오
SELECT 
    EMP_ID, 
    EMP_NAME, 
    DEPT_CODE, 
    HIRE_DATE
    
FROM EMPLOYEE
-- WHERE MONTHS_BETWEEN(SYSDATE,HIRE_DATE)/12 > 20;
-- WHERE (SYSDATE-HIRE_DATE)/365 > 20;
WHERE ADD_MONTHS(HIRE_DATE, 240) < SYSDATE;

-- 날짜값은 가장 최근 날짜일 수록 점점 더 큰 값으로 판단하며
-- 날짜값 끼리는  +, - 이 가능하다.
        
-- EXTRACT(년|월|일 FROM 날짜) : 날짜로부터 년|월|일의 정보를 추출하는 함수
SELECT 
    EXTRACT(YEAR FROM SYSDATE),
    EXTRACT(MONTH FROM SYSDATE),
    EXTRACT(DAY FROM SYSDATE)
FROM 
    DUAL;
    
-- 3. 실습
-- EMPLOYEE 테이블에서 각 직원들의
-- 사번, 사원명, 입사일, 근무년수를 조회 하시오.

-- EXTRACT()
SELECT 
    EMP_ID, 
    EMP_NAME, 
    EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM HIRE_DATE) AS 근무년수
FROM EMPLOYEE;

-- MONTH_BETWEEN()
SELECT 
    EMP_ID, 
    EMP_NAME, 
    FLOOR(MONTHS_BETWEEN(SYSDATE, HIRE_DATE)/12) AS 근무년수
FROM EMPLOYEE;

-----------------------------------------------------

-- 형변환 함수 --
-- TO_CHAR(날짜 | 숫자, '포맷') : 
-- 날짜나 숫자 데이터를 특정 포맷에 맞게 변환하는 함수

SELECT 
    TO_CHAR(1234),
    TO_CHAR(1234, '99999'),
    TO_CHAR(1234, '00000')
FROM 
    DUAL;
    
SELECT
    TO_CHAR(1234, '$99,999'),
    TO_CHAR(1234, 'L99,999'),
    TO_CHAR(1234, '99,999')
FROM 
    DUAL;


-- 4. 실습
-- EMPLOYEE 테이블에서 모든 직원들의
-- 사번, 사원명, 급여, 정보를 조회하되
-- 급여는 \50,000,000의 형식으로 출력하시오
SELECT EMP_ID, EMP_NAME, TO_CHAR(SALARY, 'L999,999,999')
FROM EMPLOYEE;

SELECT
    TO_CHAR(SYSDATE, 'PM HH24:MI:SS'),
    TO_CHAR(SYSDATE, 'AM HH:MI:SS')
FROM 
    DUAL;
    
SELECT 
    TO_CHAR(SYSDATE, 'MON DY,YYYY'),
    TO_CHAR(SYSDATE, 'YYYY-fmmm-DD DAY'),
    TO_CHAR(SYSDATE, 'YYYY-MM-DD DAY'),
--    TO_CHAR(SYSDATE, 'YEAR, Q') || '분기'
    TO_CHAR(SYSDATE, 'YEAR, Q"분기"'),
    TO_CHAR(SYSDATE, 'YYYY, Q"분기"')
FROM DUAL;

-- 오늘 날짜에 대한 4자리와 2자리 년도 포맷 문자
-- Y / R
SELECT 
    TO_CHAR(SYSDATE, 'YYYY'),
    TO_CHAR(SYSDATE, 'RRRR'),
    TO_CHAR(SYSDATE, 'YY'),
    TO_CHAR(SYSDATE, 'RR')
FROM DUAL;

-- YY와 RR의 차이
-- 4자리의 년도를 추가할 경우 문제는 없으나
-- 2자리의 데이터를 년도로 추가할 경우 반드시 고려해야 할
-- 포맷 문자형식으로
-- YY는 현재 세기(2000년대)를  기준으로 적용하고
-- RR은 반세기(50년대)를 기준으로 적용한다.

-- 올해는 반세기 기준으로 50년보다 작으므로,
-- 두자리의 년도를 네 자리로 바꿀 때
-- 바꿀 년도 50미만이면 현세기(2000)를 적용하고,
-- 50이상이면 전세기(1900)를 적용한다.

-- 만약, 현재 년도가 50년 이상일 경우
-- 바꿀 년도가 50 미만이면 다음 세기를 적용하고(2100)
-- 50이상이면 현세기를 적용한다. (2000)


SELECT
    TO_CHAR(TO_DATE(49, 'YY'), 'YYYY'),
    TO_CHAR(TO_DATE(49, 'RR'), 'RRRR'),
    TO_CHAR(TO_DATE(51, 'YY'), 'YYYY'),
    TO_CHAR(TO_DATE(51, 'RR'), 'RRRR')
FROM DUAL;

-- 오늘 날짜에서 일자만 처리하기
SELECT 
    TO_CHAR(SYSDATE, '"1년 기준" DDD'),
    TO_CHAR(SYSDATE, '"1달 기준" DD'),
    TO_CHAR(SYSDATE, '"1주 기준" D')
FROM DUAL;

-- 5. 실습
-- EMPLOYEE 테이블에서 사원명과, 입사일을 조회하되
-- 0000년 00월 00일 (0요일) 형식으로 조회하여 출력하시오
SELECT
    EMP_NAME,
    TO_CHAR(HIRE_DATE, 'YYYY"년" MM"월" DD"일" "("DAY")"') AS 입사년도
FROM EMPLOYEE;

-- TO_DATE(문자 | 숫자 데이터, '읽을 포맷')
-- : 특정 값을 날짜의 포맷 형식을 통해 읽어서 바꿔주는 함수

SELECT 
    TO_DATE(20000101, 'YYYYMMDD')
FROM DUAL;

SELECT
    TO_CHAR(TO_DATE('20101010', 'YYYYMMDD'), 'YEAR, MON')
FROM DUAL;

-- TO_NUMBER(문자데이터, 숫자포맷) : 문자 데이터를 숫자로 변겨해주는 함수
SELECT TO_NUMBER('123456') FROM DUAL;

-- 숫자 테이터와 다른 데이터는 기본적으로 사칙연산을 수행할 수 없다.
SELECT '123' || '123ABC' FROM DUAL;

SELECT '123' + '456' FROM DUAL;

-----------------------------------------------

-- 선택 함수

-- DECODE(표현식, 결과1, 값1[, 결과2, 값2 ...],  기본값)
SELECT
    EMP_NAME,
    EMP_NO,
    DECODE(SUBSTR(EMP_NO,8,1), '1', '남자', '2', '여자')
FROM EMPLOYEE;

-- CASE
--  WHEN 조건식1 THEN 결과1
--  WHEN 조건식2 THEN 결과2
--  ELSE 기본값
--  END

SELECT 
    EMP_NAME,
    EMP_NO,
    CASE
        WHEN SUBSTR(EMP_NO,8,1) IN (1,3) THEN '남자'
        WHEN SUBSTR(EMP_NO,8,1) IN (2,4) THEN '여자'
        ELSE '외계인'
    END AS 성별
FROM EMPLOYEE;

-- 6. 실습
-- EMPLOYEE 테이블에서
-- 오늘은 연봉 협상의 날이다.
-- 다음에 해당하는 조건으로 직원들의 연봉을 급여를 인상하고자 한다.
-- 직급코드가 J5인 직원들은 급여의 20%,
-- 직급코드가 J6인 직원들은 급여의 15%,
-- 직급코드가 J7인 직원들은 급여의 10%,
-- 그 외 직원들은 급여의 5%를 인상하려고 할 때
-- EMPLOYEE 테이블에서 해당 조건을 만족하는 직원들의 
-- 사번, 사원명, 직급코드, 인상된 급여 정보를 조회하여 출력하시오
SELECT
    EMP_ID AS "사번",
    EMP_NAME AS "사원명",
    JOB_CODE AS "직급코드",
    TO_CHAR(SALARY, 'L999,999,999') AS "원 급여",
    TO_CHAR(
        CASE
            WHEN JOB_CODE ='J5' THEN SALARY*1.2
            WHEN JOB_CODE ='J6' THEN SALARY*1.15
            WHEN JOB_CODE ='J7' THEN SALARY*1.1
            ELSE SALARY+SALARY*0.05
        END, 
    'L999,999,999') AS "인상된 급여"
FROM EMPLOYEE;


--함수 연습문제
--
--1. 직원명과 주민번호를 조회함
--  단, 주민번호 9번째 자리부터 끝까지는 '*'문자로 채움
--  예 : 홍길동 771120-1******
SELECT
    EMP_NAME,
    RPAD(SUBSTR(EMP_NO,1,8),14,'*')
FROM EMPLOYEE;


--2. 직원명, 직급코드, 연봉(원) 조회
--  단, 연봉은 ￦57,000,000 으로 표시되게 함
--     연봉은 보너스포인트가 적용된 1년치 급여임
SELECT 
    EMP_NAME,
    JOB_CODE,
    TO_CHAR( (SALARY+ SALARY*NVL(BONUS, 0))*12,'L99,999,999,999') AS 연봉
FROM EMPLOYEE;
SELECT * FROM EMPLOYEE;


--3. 부서코드가 D5, D9인 직원들 중에서 2004년도에 입사한 직원의 
--   수 조회함.
--   사번 사원명 부서코드 입사일
SELECT 
    EMP_ID,
    EMP_NAME,
    DEPT_CODE,
    HIRE_DATE
FROM EMPLOYEE
WHERE 
    DEPT_CODE IN ('D5','D9')
    AND EXTRACT(YEAR FROM HIRE_DATE) = '2004';


--4. 직원명, 입사일, 입사한 달의 근무일수 조회
--   단, 주말도 포함함
SELECT
    EMP_NAME,
    HIRE_DATE,
    LAST_DAY(HIRE_DATE) - HIRE_DATE AS "입사월 근무 일수"
FROM EMPLOYEE;
    


--5. 직원명, 부서코드, 생년월일, 나이(만) 조회
--   단, 생년월일은 주민번호에서 추출해서, 
--   ㅇㅇ년 ㅇㅇ월 ㅇㅇ일로 출력되게 함.
--   나이는 주민번호에서 추출해서 날짜데이터로 변환한 다음, 계산함
SELECT
    EMP_NAME AS "직원명",
    DEPT_CODE AS "부서코드",
   TO_CHAR(TO_DATE(SUBSTR(EMP_NO,1,6)), 'YY"년" MM "월" DD"일"') AS "생년월일",
   FLOOR(MONTHS_BETWEEN(SYSDATE,TO_DATE(SUBSTR(EMP_NO,1,6)))/12) AS "나이(만)"
FROM EMPLOYEE
WHERE EMP_ID NOT IN (201,200,214);
    

--6. 직원들의 입사일로 부터 년도만 가지고, 각 년도별 입사인원수를 구하시오.
--  아래의 년도에 입사한 인원수를 조회하시오.
--  => to_char, decode, sum 사용
--
--	-------------------------------------------------------------
--	전체직원수   2001년   2002년   2003년   2004년
--	-------------------------------------------------------------
SELECT 
    SUM(COUNT(SUBSTR(HIRE_DATE, 1, 2))) AS "전체직원수",
   SUM(COUNT(DECODE(SUBSTR(HIRE_DATE, 1, 2), 01, '2001년'))) AS "2001년",
   SUM(COUNT(DECODE(SUBSTR(HIRE_DATE, 1, 2), 02, '2002년'))) AS "2002년",
   SUM(COUNT(DECODE(SUBSTR(HIRE_DATE, 1, 2), 03, '2003년'))) AS "2003년",
   SUM(COUNT(DECODE(SUBSTR(HIRE_DATE, 1, 2), 04, '2004년'))) AS "2004년"
FROM EMPLOYEE
GROUP BY SUBSTR(HIRE_DATE, 1, 2);

SELECT SUBSTR(HIRE_DATE, 1, 2) FROM EMPLOYEE;


--7.  부서코드가 D5이면 총무부, D6이면 기획부, D9이면 영업부로 처리하시오.
--   단, 부서코드가 D5, D6, D9 인 직원의 정보만 조회함
--  => case 사용
--   부서코드 기준 오름차순 정렬함.
SELECT
    EMP_NAME,
    CASE 
        WHEN DEPT_CODE = 'D5' THEN '총무부'
        WHEN DEPT_CODE = 'D6' THEN '기획부'
        WHEN DEPT_CODE = 'D9' THEN '영업부'
    END 부서명
FROM EMPLOYEE
WHERE 
    DEPT_CODE IN ('D5','D6','D9')
ORDER BY DEPT_CODE ASC;

----------------------------------------------------------------------------

-- ORDER BY 구문
-- 조회한 행의 결과들을 특정 기준에 따라 오름차순, 내림차순으로 정렬
SELECT EMP_ID, EMP_NAME, DEPT_CODE, JOB_CODE, SALARY
FROM EMPLOYEE
-- ORDER BY EMP_ID;
-- ORDER BY EMP_NAME;
-- ORDER BY DEPT_CODE DESC;
ORDER BY 4;

/*
    -- SELECT 구문 실행 순서
    5 : SELECT 컬럼명 AS 별칭, 계산식, 함수식
    1 : FROM 테이블명
    2 : WHERE 조건
    3 : GROUP BY 그룹을 묶을 컬럼명
    4 : HAVING 그룹에 대한 함수식, 조건식
    6 : ORDER BY 컬럼명 | 별칭 | 컬럼 순서 [ASC | DESC] [, 컬럼명 ...]
*/

SELECT 
    AVG(SALARY)
FROM 
    EMPLOYEE
WHERE 
    DEPT_CODE = 'D1';


SELECT
    AVG(SALARY)
FROM 
    EMPLOYEE
WHERE DEPT_CODE = 'D6';


-- GROUP BY 구문 --
---- 특정 컬럼이나, 계산식을 하나의 그룹으로 묶어
---- 한 테이블 내에 소그룹 별로 조회를 수행하는 구문
SELECT DEPT_CODE, AVG(SALARY)
FROM EMPLOYEE
GROUP BY DEPT_CODE;

-- 7. 실습
-- EMPLOYEE 테이블에서
-- 부서별 총 인원, 급여 합계 , 급여 평균, 최대 급여, 최소 급여를
-- 조회하여 출력하시오.
-- 단, 모든 숫자 데이터는 정수형 데이터로 처리하시오
SELECT 
    DEPT_CODE,
    COUNT(*) AS "총인원",
    FLOOR(SUM(SALARY)) AS "급여합계",
    FLOOR(AVG(SALARY)) AS "급여평균",
    FLOOR(MAX(SALARY)) AS "최대급여",
    FLOOR(SUM(SALARY)) AS "최소급여"
FROM EMPLOYEE
GROUP BY
    DEPT_CODE;
    
-- 8. 실습 2
-- EMPLOYEE 테이블에서
-- 직급코드, 보너스를 받는 사원의 수를 조회하고
-- 직급코드 순으로 오름차순 정렬하여 출력하세요
SELECT 
     JOB_CODE,COUNT(BONUS)
FROM EMPLOYEE
GROUP BY JOB_CODE
ORDER BY JOB_CODE;

-- 9. 실습
-- EMPLOYEE 테이블에서
-- 남성 직원과 여성 직원의 수를 조회하시오

SELECT 
    DECODE(SUBSTR(EMP_NO, 8, 1), 1, '남성', 2, '여성') AS 성별,
    COUNT(*) 직원수
FROM EMPLOYEE
GROUP BY SUBSTR(EMP_NO, 8, 1);

-- HAVING 구문
-- GROUP BY 한 각 소그룹에 대한 조건을 설정하고자 할 때
-- 그룹 함수와 함께 사용하는 조건 구문
SELECT 
    DEPT_CODE,
    FLOOR(AVG(SALARY)) 평균급여
FROM EMPLOYEE
GROUP BY DEPT_CODE
HAVING AVG(SALARY) > 3000000;

-- 10. 실습
-- 부서별 그룹의 급여 합계 중 900만원을 초과하는
-- 부서의 코드와 급여 합계를 조회하시오
SELECT 
    DEPT_CODE,
    TO_CHAR(SUM(SALARY),'L99,999,999')
FROM EMPLOYEE
GROUP BY 
    DEPT_CODE
HAVING SUM(SALARY) > 9000000
ORDER BY 
    DEPT_CODE;
    
    
-- 11. 실습
-- 급여의 합계가 가장 높은 부서를 찾고,
-- 해당 부서의 부서 코드와 급여 합계를 구하시오,
SELECT
    DEPT_CODE,
    SUM(SALARY)
FROM EMPLOYEE
GROUP BY
    DEPT_CODE;
    
SELECT
    DEPT_CODE,
    SUM(SALARY)
FROM EMPLOYEE
GROUP BY
    DEPT_CODE
HAVING
    SUM(SALARY) = 17700000;


-- SUB QUERY -- 
    

SELECT
    DEPT_CODE,
    SUM(SALARY)
FROM EMPLOYEE
GROUP BY
    DEPT_CODE
HAVING
    SUM(SALARY) = (
        SELECT
            MAX(SUM(SALARY))
        FROM 
            EMPLOYEE
        GROUP BY
            DEPT_CODE
    );
    
    
-- 집계 함수 --


-- ROLLUP : 특정 그룹별 중간 집계 및 총 집계를 산출하는 함수
-- GROUP BY 구문에서만 사용한다.
-- 그룹 별로 묶인 값들에 대해서 총 집계 값을 자동으로 계산해 준다.

-- 직급 별 급여 합계
SELECT JOB_CODE 직급,
        SUM(SALARY) 급여합계
FROM EMPLOYEE
GROUP BY ROLLUP(JOB_CODE)
ORDER BY 1;


-- CUBE : 특정 그룹별 자동 집계를 제공하는 함수
-- GROUP BY 구문에서만 사용하며,
-- 각각의 소계 및 총 합계를 자동으로 산출 해준다.
SELECT JOB_CODE 직급,
        SUM(SALARY) 급여합계
FROM EMPLOYEE
GROUP BY CUBE(JOB_CODE)
ORDER BY 1;

-- ROLLUP 과 CUBE는 사용형식이 다르지만
-- 한 개의 컬럼에 대한 그룹 집계를 계산할 때에는
-- 동일한 결과가 나온다.

-- 다중 그룹 지정하기
-- ROLLUP을 사용할 경우
-- 인자로 전달한 컬럼 그룹 중 가장 먼저 지정한
-- 그룹별 집계와 총 합계를 기준으로 동작한다.
SELECT DEPT_CODE, JOB_CODE, SUM(SALARY)
FROM EMPLOYEE
GROUP BY ROLLUP(DEPT_CODE, JOB_CODE)
ORDER BY 1, 2;

-- 그룹으로 지정된 모든 그룹에 대한 집계를 계산하여 각 그룹간 집계,
-- 전체 집계를 각각 산출하는 함수
SELECT DEPT_CODE, JOB_CODE, SUM(SALARY)
FROM EMPLOYEE
GROUP BY CUBE(DEPT_CODE, JOB_CODE)
ORDER BY 1, 2;

-- GROUPING(컬럼명)
-- 해당 컬럼의 값이 자동 집계된 컬럼 값인지
-- 확인하기 위한 함수
-- 컬럼의 값이 자동으로 만들어진 값이면 1,
-- 원래 있던 컬럼의 값이면 0


SELECT DEPT_CODE, JOB_CODE, SUM(SALARY),
    GROUPING(DEPT_CODE) "부서별 자동 집계 유무",
    GROUPING(JOB_CODE) "직급별 자동 집계 유무"
FROM EMPLOYEE
GROUP BY ROLLUP(DEPT_CODE, JOB_CODE)
ORDER BY 1,2;
    
-- GROUPING 응용 --

-- 각 컬럼의 결과가 자동 집계된 결과인지 확인하는 SQL
SELECT 
    DEPT_CODE, JOB_CODE, SUM(SALARY),
    CASE
        WHEN GROUPING(DEPT_CODE) = 0
        AND GROUPING(JOB_CODE) = 1
            THEN '부서별 합계'
        WHEN GROUPING(DEPT_CODE) = 1
        AND GROUPING(JOB_CODE) = 0
            THEN '직급별 합계'
        WHEN GROUPING(DEPT_CODE) = 0
        AND GROUPING(JOB_CODE) = 0
            THEN '그룹별 합계'
        ELSE
            '전체 합계'
    END AS 구분
FROM EMPLOYEE
GROUP BY CUBE(DEPT_CODE, JOB_CODE)
ORDER BY 1, 2;
        
