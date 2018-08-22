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

