-- DAY 9 --
/*
     CREATE : 데이터베이스의 객체를 생성하는 DDL
     CREATE TABLE 테이블명(
          컬렴명 자료형(크기) 제약조건
      );
    
     제약조건 : 
     NOT NULL - 널이 들어갈 수 없다. (필수 입력 사항)
     UNIQUE - 중복 값을 허용하지 않는다.
     CHECK - CHECK 조건 안에 들어있는 값만 허용한다.
     PRIMARY KEY - (NOT NULL + UNIQUE) 하나만 설정할 수 있는
                   테이블 내의 식별자 역할을 하는 컬럼 제약조건
     FOREIGN KEY - 다른 테이블과 연결해 주는 제약 조건
                  (기본키이거나 UNIQUE 제약조건이 걸려있는 컬럼만 참조할 수 있다)
*/

-- DML (데이터 조작 언어) -- 
-- INSERT, UPDATE, DELETE,SELECT
-- [ CRUD ] - 프로그램이 데이터를 처리하는 기능
-- C(CREATE) : INSERT : 데이터 추가
-- R(READ)   : SELECT : 데이터 조회
-- U(UPDATE) : UPDATE : 데이터 변경
-- D(DELETE) : DELETE : 데이터 삭제

-- DML : 데이터를 추가, 수정, 삭제하는 등의 데이터 처리와 관련된 기능을
--       제공하는 명령어들

-- INSERT : 새로운 행을 테이블에 추가하는 명령어
--          실행하고 난 뒤에 테이블 행의 갯수가 증가한다.

-- [사용형식]
-- 1)
-- INSERT INTO 테이블명[(컬럼명,...)]
-- VALUES (값1,값2, ...);
-- 해당 테이블의 특정 컬럼이나 모든 컬럼에 해당하는 값들을 추가할 때 사용한다.

-- 2)
-- INSERT INTO 테이블명
-- VALUES (값1,값2, ...);
-- 해당 테이블에 있는 모든 컬럼에 대한 값들을 추가할 때 사용한다.

INSERT INTO EMPLOYEE(EMP_ID, EMP_NAME, EMP_NO, EMAIL, PHONE,DEPT_CODE, JOB_CODE, SAL_LEVEL, SALARY, BONUS, MANAGER_ID, HIRE_DATE, ENT_DATE, ENT_YN)
VALUES(500, '이소근', '741230-1234567', 'leesg007@kh.or.kr','01022334455', 'D1', 'J7', 'S4', 3100000, 0.1,'200',
        SYSDATE, NULL, DEFAULT);

SELECT * FROM EMPLOYEE
WHERE EMP_NAME = '이소근';

-- 컬럼을 생략하여 사용하는 경우 (모든 컬럼의 값을 기입)
INSERT INTO EMPLOYEE (EMP_ID, EMP_NAME, EMP_NO, EMAIL, PHONE,
DEPT_CODE, JOB_CODE, SAL_LEVEL, SALARY, BONUS, MANAGER_ID,
HIRE_DATE, ENT_DATE, ENT_YN)
VALUES(900, '장채현', '901123-1080503', 'jang_ch@kh.or.kr', '01055569512',
'D1', 'J7', 'S3', 4300000, 0.2, '200', SYSDATE, NULL, DEFAULT);

SELECT * FROM EMPLOYEE
WHERE EMP_NAME IN ('이소근', '장채현');

COMMIT;

-- INSERT 구문에 서브쿼리를 사용할 수 있다.
-- INSERT 구문에 VALUES 대신 서브 쿼리를 이용하여 값을 추가하는 경우

CREATE TABLE EMP_01(
    EMP_ID NUMBER,
    EMP_NAME VARCHAR2(30),
    DEPT_TITLE VARCHAR2(35)
);

INSERT INTO EMP_01(
    SELECT EMP_ID, EMP_NAME, DEPT_TITLE
    FROM EMPLOYEE 
    LEFT JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
);

SELECT * FROM EMP_01;

COMMIT;

/*
    INSERT ALL
    1) 서브 쿼리를 활용하여 INSERT를 수행할 때 서브쿼리가 사용하는 테이블이 같다면
        두 개 이상의 테이블 INSERT를 INSERT ALL을 이용하여 한 번에  처리할 수 있다.
        단, 이 때의 각 서브쿼리 조건 구문은 반드시 같아야 한다.

    2) 만약 서브쿼리 조건에 관계없이 단순히 INSERT 구문을 여러개 묶어서 실행하고자 하는 경우
        서브쿼리가 들어갈 조건 부분에 'SELECT * FROM DUAL'을 작성하여 VALUES 부분을 
        값을 전부 직접 가입해서 여러 개를 묶어서 처리할 수 있다.
*/


CREATE TABLE EMP_DEPT_D1
AS SELECT EMP_ID, EMP_NAME, DEPT_CODE, HIRE_DATE
    FROM EMPLOYEE
    WHERE 1 = 2;

SELECT * FROM EMP_DEPT_D1;

CREATE TABLE EMP_MANAGER
AS SELECT EMP_ID, EMP_NAME, DEPT_CODE, MANAGER_ID
    FROM EMPLOYEE
    WHERE 1 = 2;
    
SELECT * FROM EMP_MANAGER;

-- 1. 실습
-- EMP_DEPT_D1 테이블에 EMPLOYEE 테이블에 존재하는 D1 부서의 사원 정보들을
-- 조회하여 사번, 이름, 부서코드, 입사일을 추가해 보시오.
INSERT INTO EMP_DEPT_D1
(
    SELECT EMP_ID, EMP_NAME, DEPT_CODE, HIRE_DATE FROM EMPLOYEE
    WHERE DEPT_CODE = 'D1'
);

SELECT * FROM EMP_DEPT_D1;

-- EMP_MANAGER 테이블에, EMPLOYEE 테이블에 존재하는 D1부서의 사원 정보들을
-- 조회하여 사번, 이름, 부서코드, 관리자 사번을 추가해 보시오.
INSERT INTO EMP_MANAGER
(
    SELECT EMP_ID, EMP_NAME, DEPT_CODE, MANAGER_ID
    FROM EMPLOYEE 
    WHERE DEPT_CODE = 'D1'
);

SELECT * FROM EMP_MANAGER;

DELETE FROM EMP_DEPT_D1;
DELETE FROM EMP_MANAGER;

SELECT * FROM EMP_DEPT_D1;
SELECT * FROM EMP_MANAGER;

INSERT ALL
    INTO EMP_DEPT_D1 VALUES(EMP_ID, EMP_NAME, DEPT_CODE, HIRE_DATE)
    INTO EMP_MANAGER VALUES(EMP_ID, EMP_NAME, DEPT_CODE, MANAGER_ID)
SELECT EMP_ID, EMP_NAME, DEPT_CODE, HIRE_DATE, MANAGER_ID
FROM EMPLOYEE
WHERE DEPT_CODE = 'D1';

SELECT * FROM EMP_DEPT_D1;
SELECT * FROM EMP_MANAGER;

COMMIT;


CREATE TABLE EMP_OLD
 AS SELECT EMP_ID, EMP_NAME, HIRE_DATE, SALARY
 FROM EMPLOYEE
 WHERE 1=2;
 
 SELECT * FROM EMP_OLD;
 
 CREATE TABLE EMP_NEW
    AS SELECT EMP_ID, EMP_NAME, HIRE_DATE, SALARY
    FROM EMPLOYEE
    WHERE 1=2;

SELECT * FROM EMP_NEW;

-- 2. 실습
-- EMPLOYEE 테입르에서 입사일 기준으로
-- 2000년 1월 1일 이전에 입사한 사원의 사번, 이름, 입사일 급여를
-- 조회하여 EMP_OLD 테이블에 추가하고,
-- 그 이후 입사자들은 EMP_NEW 테이블에 추가하는 쿼리를 작성해 보시오
SELECT EMP_ID, EMP_NAME, HIRE_DATE, SALARY
FROM EMPLOYEE
WHERE HIRE_DATE > TO_DATE('20000101', 'YYYYMMDD');

INSERT ALL
    WHEN HIRE_DATE < '2000/01/01' THEN
    INTO EMP_OLD VALUES(EMP_ID, EMP_NAME, HIRE_DATE, SALARY)
    WHEN HIRE_DATE >= '2000/01/01' THEN
    INTO EMP_NEW VALUES(EMP_ID, EMP_NAME, HIRE_DATE, SALARY)
SELECT EMP_ID, EMP_NAME, HIRE_DATE, SALARY
FROM EMPLOYEE;

SELECT * FROM EMP_OLD;
SELECT * FROM EMP_NEW;

-- UPDATE : 해당 테이블의 데이터를 수정하는 명령어
-- [사용형식]
-- UPDATE 테이블명 SET 컬럼명 = 바꿀값
-- [WHERE 컬럼명 비교연산자] 
-- 실행 후의 테이블 행 전체 갯수가 변화하지 않고(데이터 갯수 변하지 않는다.)
-- 단순히 내부의 수정하고자 하는 컬럼값만 변경된다.

CREATE TABLE DEPT_COPY
AS SELECT * FROM DEPARTMENT;
 
SELECT * FROM DEPT_COPY;

-- 'D9'번 부서의 이름을 총무부서가 아닌
-- '전략기획팀'
UPDATE DEPT_COPY SET DEPT_TITLE = '전략기획팀'
WHERE DEPT_ID = 'D9';

SELECT * FROM DEPT_COPY WHERE DEPT_ID = 'D9';


-- 3. EMPLOYEE 테이블에서 주민번호가 잘못 등록되어 있는 사원들이 있다.
-- 현재 주민 번호가 잘못 등록 되어 있는 사원들(200,201,214)을 찾아
-- 200번은 앞자리를 '621230'으로
-- 201번은 앞자리를 '631126'으로
-- 214번은 앞자리를 '850705'로 변경하는 UPDATE 구문을 구현해 보시오.
SELECT * FROM EMPLOYEE WHERE EMP_ID IN (200,201,214);

UPDATE EMPLOYEE SET EMP_NO = '631230' || SUBSTR(EMP_NO,7)
WHERE EMP_ID = 200;

UPDATE EMPLOYEE SET EMP_NO = '631126' || SUBSTR(EMP_NO,7)
WHERE EMP_ID = 201;

UPDATE EMPLOYEE SET EMP_NO = '850705' || SUBSTR(EMP_NO,7)
WHERE EMP_ID = 214;

COMMIT;

-- UPDATE 구문과 서브쿼리
-- UPDATE 구문을 실행 할 때
-- 여러행을 변경하거나, 여러 칼럼의 값을 변경하고자 할 때
-- 서브쿼리를 사용하여 스크립트를 작성할 수 있다.
-- UPDATE 테이블명 SET 컬럼명 = (서브쿼리)

CREATE TABLE EMP_SALARY
AS SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY, BONUS
FROM EMPLOYEE;

SELECT * FROM EMP_SALARY
WHERE EMP_NAME IN ('유재식', '방명수');

-- 유재식 사원과 같은 급여와 보너스를 받고 싶어하는 방명수 사원의
-- 급여와 보너스를 유재식 사원과 똑같은 값으로 변경하는 쿼리를 작성해 보시오.

-- 단일 행 서브쿼리로 해결
UPDATE EMP_SALARY
SET SALARY = (SELECT SALARY FROM EMP_SALARY
                WHERE EMP_NAME = '유재식')
,BONUS = (SELECT BONUS FROM EMP_SALARY
                WHERE EMP_NAME = '유재식')
WHERE EMP_NAME = '방명수';

SELECT * FROM EMP_SALARY
WHERE EMP_NAME IN ('유재식', '방명수');

-- 4. 실습
-- 방명수 사원의 급여 인상 소식을 전해들은 
-- '노옹철', '전형동', '정중하', '하동운' 사원들이
-- 자신들도 급여와 보너스를 인상해 달라며 파업을 하고 있다.

-- 노옹철, 전형돈, 정중하, 하동운 사원의 급여를 
-- 유재식 사원과 같은 급여, 보너스로 수정하는 UPDATE 구문을
-- 작성하시오
-- 단, 다중 행 서브 쿼리로 구현하여 작성해 보시오.

UPDATE EMP_SALARY
SET (SALARY,BONUS) = (SELECT SALARY, BONUS FROM EMP_SALARY WHERE EMP_NAME = '유재식')
WHERE EMP_NAME IN ('노옹철','전형돈','정중하','하동운');

SELECT * FROM EMP_SALARY WHERE EMP_NAME IN ('유재식','방명수','노옹철','전형돈','정중하','하동운');

-- 5. 실습
-- 위와 같은 직원들의 급여 인상 소식이 메스컴으로 통해
-- 퍼져나가 아시아 지역에 근무하는 전 직원들의 급여도 인상해 달라는
-- 시위가 진행되고 이싿.
-- 이에 난감한 운영측은 급여는 인상이 불가 하지만, 보너스는 0.5로 인상을
-- 해주겠다고 시위 대표자인 선동일 사원과 합의를 보게 되었다.
-- EMP_SALARY 테이블에서 아시아 지역에 근무하는 모든 직원들의
-- 보너스를 0.5로 인상하는 UPDATE구문을 작성하시오
UPDATE EMP_SALARY
SET BONUS = 0.5
WHERE EMP_ID IN (
                    SELECT EMP_ID FROM EMP_SALARY
                    JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID
                    JOIN LOCATION ON LOCATION_ID = LOCAL_CODE
                    WHERE LOCAL_NAME LIKE 'ASIA%'
                );
                
-- UPDATE 시에 변경할 값은 해당 컬럼의 제약조건에 위배되지 않아야 한다.
-- ORA-02291: integrity constraint (EMPLOYEE.SYS_C007130) violated - parent key not found
UPDATE EMPLOYEE
SET DEPT_CODE = 'D0'
WHERE DEPT_CODE = 'D6';

-- ORA-01407: cannot update ("EMPLOYEE"."EMPLOYEE"."EMP_ID") to NULL
UPDATE EMPLOYEE
SET EMP_ID = NULL
WHERE EMP_ID = 900;

-- ORA-00001: unique constraint (EMPLOYEE.SYS_C007137) violated
UPDATE EMPLOYEE
SET EMP_NO = '741230-1234567'
WHERE EMP_NAME = '선동일';

SELECT * FROM EMPLOYEE
WHERE ENT_YN = 'Y';

-- UPDATE 시에 기본값(DEFAULT)을 활용할 수 있다.
UPDATE EMPLOYEE
SET ENT_YN = DEFAULT
WHERE EMP_ID = 222;


COMMIT;

-- MERGE -- 
-- 구조가 동일한 두 개의 테이블을 하나로 합칠 때 사용하는 명령
-- [사용형식]
-- MERGE INTO A_TABLE USING B_TABLE ON (A.컬럼명 = B.컬럼명)
--  WHEN MATCHED THEN   -- A 테이블의 컬럼과 B 테이블의 컬럼이 곂칠 경우
--  WHEN NOT MATCHED THEN   -- A 테이블의 컬럼과 B 테이블의 컬럼이 곂치지 않을 경우

CREATE TABLE EMP_M01
AS SELECT * FROM EMPLOYEE;

CREATE TABLE EMP_M02
AS SELECT * FROM EMPLOYEE
WHERE JOB_CODE = 'J4';

SELECT * FROM EMP_M01;
SELECT * FROM EMP_M02;

INSERT INTO EMP_M02
VALUES (501, '고길동', '561212-1234567' , 'gogildong@kh.or.kr',
        '01011112222', 'D9', 'J4', 'S1', 9000000, 0.5, NULL,
        SYSDATE, NULL, DEFAULT);

UPDATE EMP_M02
SET BONUS = 0;

COMMIT;

SELECT EMP_NAME, SALARY, BONUS FROM EMP_M02;


-- MERGE를 활용하여
-- EMP_M02의 정보를 활용하여 EMP_M01에 합치기
MERGE INTO EMP_M01 USING EMP_M02 ON (EMP_M01.EMP_ID = EMP_M02.EMP_ID)
WHEN MATCHED THEN -- 컬럼의 내용이 곂칠때
UPDATE SET
EMP_M01.EMP_NAME = EMP_M02.EMP_NAME ,
EMP_M01.EMP_NO = EMP_M02.EMP_NO ,
EMP_M01.EMAIL = EMP_M02.EMAIL ,
EMP_M01.PHONE = EMP_M02.PHONE ,
EMP_M01.DEPT_CODE = EMP_M02.DEPT_CODE ,
EMP_M01.JOB_CODE = EMP_M02.JOB_CODE ,
EMP_M01.SAL_LEVEL = EMP_M02.SAL_LEVEL ,
EMP_M01.SALARY = EMP_M02.SALARY ,
EMP_M01.BONUS = EMP_M02.BONUS ,
EMP_M01.MANAGER_ID = EMP_M02.MANAGER_ID ,
EMP_M01.HIRE_DATE = EMP_M02.HIRE_DATE ,
EMP_M01.ENT_DATE = EMP_M02.ENT_DATE ,
EMP_M01.ENT_YN = EMP_M02.ENT_YN
WHEN NOT MATCHED THEN -- 컬럼 내용이 곂지치 않을 때
INSERT VALUES(
EMP_M02.EMP_ID,
EMP_M02.EMP_NAME,
EMP_M02.EMP_NO,
EMP_M02.EMAIL,
EMP_M02.PHONE,
EMP_M02.DEPT_CODE,
EMP_M02.JOB_CODE,
EMP_M02.SAL_LEVEL,
EMP_M02.SALARY,
EMP_M02.BONUS,
EMP_M02.MANAGER_ID,
EMP_M02.HIRE_DATE,
EMP_M02.ENT_DATE,
EMP_M02.ENT_YN
);

SELECT * FROM EMP_M01
WHERE JOB_CODE ='J4';
SELECT * FROM EMP_M02;

SELECT * FROM EMPLOYEE
WHERE JOB_CODE = 'J4';

-- DELETE --
-- 테이블의 행을 삭제하는 구문
-- 테이블의 행의 개수가 줄어든다.
-- [사용형식]
-- DELETE FROM 테이블명 [WHERE 조건]
-- 만약에 WHERE 조건을 작성하지 않고
-- 실행할 경우에 해당 테이블의 모든 정보가 삭제된다.

SELECT * FROM EMPLOYEE_COPY;

DROP TABLE TEST_DELETE;

CREATE TABLE TEST_DELETE
AS SELECT * FROM EMPLOYEE;

SELECT * FROM TEST_DELETE;

COMMIT;

DELETE FROM TEST_DELETE;

ROLLBACK;

-- ORA-02292: integrity constraint (EMPLOYEE.SYS_C007130) violated - child record found
-- D1을 참조하는 다른 테이블의 자식 컬럼이 존재하기 때문에
-- 부 모컬럼값을 함부로 지울수 없다.
DELETE FROM DEPARTMENT
WHERE DEPT_ID = 'D1';

SELECT * FROM EMPLOYEE
WHERE DEPT_CODE = 'D3';

DELETE FROM DEPARTMENT
WHERE DEPT_ID = 'D3';

ROLLBACK;

-- 제약조건을 비활성화하여
-- 해당 컬럼의 값을 삭제할 수도 있습니다.

SELECT * FROM USER_CONSTRAINTS
WHERE TABLE_NAME = 'EMPLOYEE';

ALTER TABLE EMPLOYEE
DISABLE CONSTRAINT SYS_C007130 CASCADE;

DELETE FROM DEPARTMENT
WHERE DEPT_ID = 'D1';

SELECT EMP_ID, EMP_NAME, DEPT_CODE FROM EMPLOYEE;


ROLLBACK;

-- 비활성화된 제약조건을 다시 활성화하기
ALTER TABLE EMPLOYEE
ENABLE CONSTRAINT SYS_C007130;

-- ORA-02292: integrity constraint (EMPLOYEE.SYS_C007130) violated - child record found
DELETE FROM DEPARTMENT
WHERE DEPT_ID = 'D1';

-- TRUNCATE : DELETE와 유사하게 데이터를 삭제하는 명령어
--  테이블 전체행의 데이터를 삭제하며,
--  DELETE보다 실행 속도가 빠르다.
-- ROLLBACK을 수행할 수 없다.
SELECT * FROM EMP_SALARY;

COMMIT;


DELETE FROM EMP_SALARY;
SELECT * FROM EMP_SALARY;

ROLLBACK;

SELECT * FROM EMP_SALARY;

-- TRUNCATE를 통한 데이터 전체 삭제 수행시...
TRUNCATE TABLE EMP_SALARY;

SELECT * FROM EMP_SALARY;

ROLLBACK;

SELECT * FROM EMP_SALARY;
-- 데이터가 복구되지 않는다.

-- TCL
-- (TRANSACTION CONTROL LANGUAGE)
-- 트랜잭션 제어 언어
-- COMMIT / ROLLBACK ... / SAVEPOINT

-- 트랜잭션이란?
-- 데이터 처리와 관련된 작업의 최소 단위를 트랜잭션이라고 한다.
-- 논리적 작업 단위(LUW : Logical Unit of Work)
-- 하나의트랜잭션으로 이루어진 작업은 반드시 한꺼번에 작업 내용이 한꺼번에
-- 저자되거나 취소되어야 한다.
-- 따라서 해당 작업 시점을 구분하여 
-- commit(작업 내역 저장) / ROLLBACK(작업내역 취소)을 반드시 처리할 수 있어야 한다.


-- ex)  ATM 기기에서 인출하는 상황일 경우
/*
    1.카드 삽입
    2.메뉴 선택(인출)
    3.비밀번호 입력
    4.금액 입력
    5.금액 확인
    6.인출 내역 기록
    7.현금 수령
    8.명세표 출력
*/

-- COMMIT : 트랜잭션(작업)이 종료될 때 정상적으로 종료되었으면
--          변경한(작업한) 내용을 영구히 저장하겠다.
-- ROLLBACK : 트랜잭션(작업)이 실행 중 잘못 수행된 내용이 있을 경우
--              이를 취소하고자 할 때 가장 최근 COMMIT(저장) 시점으로 다시 돌아가겠다.
-- SAVEPOINT 임시저장소명 : 현재 트랜잭션 진행 중 구역을 나누어
--          현재가지 진행된 내용을 중간 저장해야할 경우에 사용함
-- ROLLBACK TO 임시저장소명 : 트랜잭션 작업을 임시 저장한 SAVEPOINT 시점까지 작업한
--          내용들을 취소하고자 할 때 사용함.
COMMIT;

CREATE TABLE USER_TBL(
    USERNO NUMBER UNIQUE,
    USERID VARCHAR2(20) NOT NULL UNIQUE,
    USERPWD VARCHAR2(30) NOT NULL
);

SELECT * FROM USER_TBL;

INSERT INTO USER_TBL
VALUES(1,'test1','pass1');
INSERT INTO USER_TBL
VALUES(2,'test2','pass2');
INSERT INTO USER_TBL
VALUES(3,'test3','pass3');

SELECT * FROM USER_TBL;

COMMIT;

INSERT INTO USER_TBL
VALUES(4,'test4','pass4');

SAVEPOINT SP1;

INSERT INTO USER_TBL
VALUES(5,'test5','pass5');

SELECT * FROM USER_TBL;

ROLLBACK;

SELECT * FROM EMPLOYEE
JOIN DEPARTMENT ON (DEPT_ID = DEPT_CODE)
JOIN LOCATION ON (LOCATION_ID = LOCAL_CODE)
JOIN NATIONAL USING(NATIONAL_CODE);




