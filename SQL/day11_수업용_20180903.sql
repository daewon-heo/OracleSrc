-- day 11 --
-- 허대원 --

-- XE버전에서는 권한부여 따로 해줘야함
-- 관리자 계정 -> GRANT CREATE VIEW TO EMPLOYEE;
CREATE OR REPLACE VIEW V_EMP(사번,이름,부서)
AS SELECT EMP_ID, EMP_NAME, DEPT_CODE 
FROM EMPLOYEE;

-- VIEW (뷰)
-- SELECT 쿼리 실행의 결과 화면을 저장한 객체
-- (조회하는 SELECT 쿼리 자체를 저장하여 호출될 때마다
-- 해당 쿼리를 실행하는 객체)
-- 논리적인 가장 테이블
-- 실질적으로 데이터를 담고 있지 않다
-- VIEW를 통한 결과는 일반 테이블과 동일하게 사용할 수 있다.
-- 보통, 일반 사용자에게 노출하고 싶지 않는 정보들이나,
-- 업무에 필요한 정보듣만 출력하고자 할 때 사용한다.

-- [사용방법]
-- CREATE [OR REPLACE] VIEW 뷰이름(뷰에서 사용하고자 하는 컬럼 별칭)
-- AS 서브쿼리(뷰에서 확인할 컬럼을 조회하는 SELECT 쿼리)

SELECT *
FROM V_EMP;

-- 뷰는 SELECT 쿼리문을 저장한 논리적인 가상 테이블이기 떄문에
-- 이미 생성되어 있더라도 새로 생성할 수 있다.
-- 단 'OR REPLACE' 라는 명령어를 포함해야 한다.
CREATE OR REPLACE VIEW V_EMP(사원, 이름, 부서, 직급)
AS SELECT EMP_ID, EMP_NAME, DEPT_CODE, JOB_CODE
FROM EMPLOYEE;


SELECT *
FROM V_EMP;

-- 1.실습
-- 사번, 이름, 직급명, 부서명, 근무지역을 조회하고
-- 그 결과를 V_RESULT_EMP 라는 뷰를 생성하여
-- 뷰를 통해 조회하는 뷰 객체를 만들어 뵈오.
CREATE OR REPLACE VIEW V_RESULT_EMP(사번, 이름, 직급명, 부서명, 근무지역)
AS
SELECT E.EMP_ID, E.EMP_NAME, J.JOB_NAME, D.DEPT_TITLE, L.LOCAL_NAME
FROM EMPLOYEE E 
JOIN DEPARTMENT D ON E.DEPT_CODE = D.DEPT_ID
JOIN JOB J ON J.JOB_CODE = E.JOB_CODE
JOIN LOCATION L ON L.LOCAL_CODE = D.LOCATION_ID;

SELECT * FROM V_RESULT_EMP;

SELECT * FROM LOCATION;
-- 1 - 2. 실습
-- 생성한 뷰 객체를 활용하여
-- 205번의 사번을 가지는 직원을 조회해 보시오
SELECT * FROM V_RESULT_EMP 
WHERE 사번=205;
-- 보안성, 정보 조회의 편의성 향상

-- 등록된 뷰의 정보를 담고 있는 데이터 사전 조회하기
SELECT * FROM USER_VIEWS;

COMMIT;

-- 기존 테이블의 정보가 변경되었을 경우 뷰의 내용 확인하기
UPDATE EMPLOYEE
SET EMP_NAME = '정중앙'
WHERE EMP_ID = 205;

SELECT *
FROM EMPLOYEE
WHERE EMP_ID = 205;

SELECT * 
FROM V_RESULT_EMP
WHERE 사번 = 205;

-- 뷰가 참조하는 원래의 테이블 정보가 변경되었을 때
-- 뷰의 정보도 변경된다.(뷰 실행 시 서브쿼리를 통해 접근하기 때문이다.)

-- 뷰 삭제
DROP VIEW V_RESULT_EMP;

SELECT * FROM USER_VIEWS;

-- 뷰의 컬럼에 별칭을 붙일 수 있다.
CREATE OR REPLACE VIEW V_EMP(사번, 사원명, 부서코드)
AS
SELECT EMP_ID, EMP_NAME, DEPT_CODE
FROM EMPLOYEE;

SELECT * FROM V_EMP;

-- 뷰에 연산 결과도 함께 저장할 수 있다.
-- 사번, 이름, 직급, 성별, 근속년수 조회하는 뷰 생성하기


-- 서브쿼리
SELECT 
    EMP_ID, 
    EMP_NAME, 
    JOB_CODE, 
    DECODE(SUBSTR(EMP_NO,8,1),1,'남','여'),
    EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM HIRE_DATE)
FROM EMPLOYEE;

-- 뷰 생성하기
CREATE OR REPLACE VIEW V_EMP_JOB(사번, 이름, 직급, 성별,근속년수)
AS SELECT 
    EMP_ID, 
    EMP_NAME, 
    JOB_CODE, 
    DECODE(SUBSTR(EMP_NO,8,1),1,'남','여'),
    EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM HIRE_DATE)
FROM EMPLOYEE;

SELECT * FROM V_EMP_JOB;

-- 뷰에 데이터 삽입하기
CREATE OR REPLACE VIEW V_JOB
AS
SELECT * FROM JOB;

SELECT * FROM V_JOB;

ROLLBACK;

INSERT INTO V_JOB VALUES('J8', '인턴');

SELECT * FROM V_JOB;

SELECT * FROM JOB;


-- 뷰를 통한 데이터 삽입도 가능하다,


UPDATE V_JOB
SET JOB_NAME = '알바'
WHERE JOB_CODE = 'J8';

SELECT * FROM V_JOB;
SELECT * FROM JOB;

-- 뷰틀 통한 데이터 수정도 가능하다.
DELETE FROM V_JOB
WHERE JOB_CODE = 'J8';

SELECT * FROM V_JOB;
SELECT * FROM JOB;

-- 뷰를 통한 데이터 입력, 수정, 삭제도 가능하다.

-- DML 명령어(입력, 수정, 삭제)가 사용이 불가능한 경우
-- 1. 뷰에 정의되지 않은 컬럼 값을 변경하고자 할 경우
-- 2. 뷰에 포함되지 않은 컬럼 중,
--      기본이 되는 테이블 컬럼이 NOT NULL 제약조건을 가진 경우
-- 3. 산술 연산이 포함된 경우 DML을 사용할 수 없다.
-- 4. JOIN을 이용한 여러 테이블을 참조하는 경우
        -- 조회하는 정보 중 기본키의 요소가 단 하나일 경우는 가능(복합 뷰)
        -- 일반적으로는 불가능
-- 5.  DISTINCT를 사용했을 경우
        -- 삽입, 수정, 삭제의 대상이 명확하지 않기 때문에 DML 사용이 불가능하다.
-- 6.  그룹함수를 사용하거나, GROUP BY를 통한 결과일 경우


-- 뷰에 정의되어 있지 않은 컬럼을 수정할 경우
CREATE OR REPLACE VIEW V_JOB2 
AS SELECT JOB_CODE FROM JOB;

-- SQL 오류: ORA-00913: too many values
INSERT INTO V_JOB2(JOB_NAME)
VALUES('J8', '인턴');

-- SQL 오류: ORA-00904: "JOB_NAME": invalid identifier
UPDATE V_JOB2
SET JOB_NAME = '인턴'
WHERE JOB_CODE = 'J7';


-- 산술표현식으로 작성된 경우
CREATE OR REPLACE VIEW V_EMP_SAL
AS
    SELECT EMP_ID, EMP_NAME, SALARY,
    SALARY + (SALARY*NVL(BONUS,0))*12 연봉
FROM EMPLOYEE;

SELECT * FROM V_EMP_SAL;

-- SQL 오류: ORA-01733: virtual column not allowed here
INSERT INTO V_EMP_SAL
VALUES (800, '손승민', 3000000, 40000000);


-- COMMIT;

-- DELETE 할 때에는  VIEW를 통해서도 가능하다.
--DELETE FROM V_EMP_SAL
--WHERE 연봉 = 40920000;
SELECT * FROM V_EMP_SAL;

SELECT * FROM EMPLOYEE
WHERE EMP_NAME = '이소근';

-- JOIN을 통해 VIEW의 정보를 수정하는 경우
CREATE OR REPLACE VIEW V_JOIN_EMP
AS
SELECT EMP_ID, EMP_NAME, DEPT_TITLE
FROM EMPLOYEE
LEFT JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID);

SELECT * FROM V_JOIN_EMP;

-- SQL 오류: ORA-01776: cannot modify more than one base table through a join view
INSERT INTO V_JOIN_EMP
VALUES(801, '조세오', '인사관리부');


-- SQL 오류: ORA-01779: cannot modify a column which maps to a non key-preserved table
UPDATE V_JOIN_EMP
SET DEPT_TITLE = '인사관리부'
WHERE EMP_ID = '218';

DELETE FROM V_JOIN_EMP
WHERE DEPT_TITLE = '기술지원부';


SELECT 
* FROM V_JOIN_EMP;

ROLLBACK;

-- DISTINCT를 사용한 경우
CREATE OR REPLACE VIEW V_DEPT_EMP
AS
    SELECT DISTINCT DEPT_CODE
    FROM EMPLOYEE;
    
SELECT * FROM V_DEPT_EMP;

-- SQL 오류: ORA-01732: data manipulation operation not legal on this view
INSERT INTO V_DEPT_EMP
VALUES('D0');

-- SQL 오류: ORA-01732: data manipulation operation not legal on this view
-- DISTINCT를 사용했을 경우 DELETE도 안된다.
DELETE FROM V_DEPT_EMP
WHERE DEPT_CODE = 'D9';

-- 그룹 합수나 GROUP BY 구문을 포함했을 경우
CREATE OR REPLACE VIEW V_GROUP_DEPT
AS
SELECT DEPT_CODE, SUM(SALARY) 합계, TRUNC(AVG(SALARY),-5) 평균
FROM EMPLOYEE
GROUP BY DEPT_CODE;

SELECT * FROM V_GROUP_DEPT;

-- SQL 오류: ORA-01733: virtual column not allowed here
INSERT INTO V_GROUP_DEPT
VALUES('D10', 6000000,  40000000);

-- SQL 오류: ORA-01732: data manipulation operation not legal on this view
UPDATE V_GROUP_DEPT
SET DEPT_CODE = 'D10'
WHERE DEPT_CODE = 'D1';

-- SQL 오류: ORA-01732: data manipulation operation not legal on this view
DELETE FROM V_GROUP_DEPT
WHERE DEPT_CODE = 'D9';

-- VIEW 생성 시에 설정할 수 있는 옵션
-- OR REPLACE : 기존에 존재하던 동일한 이름의 뷰가 있을 경우
--              해당 뷰를 덮어쓰고, 만약 없다면 새로 생성하는 옵션
-- FORCE / NOFORCE: 서브쿼리에 사용된 테이블이 존재하지 않아도 뷰를 생성할 수 있는 옵션
-- WITH CHECK : 옵션을 설정한 컬럼의 값을 변경하지 못하게 막는 옵션

-- 경고: 컴파일 오류와 함께 뷰가 생성되었습니다.
CREATE OR REPLACE FORCE VIEW V_EMP
AS
SELECT TCODE, TNAME, TCONTENT
FROM T_TABLE;

-- ORA-04063: view "EMPLOYEE.V_EMP" has errors
SELECT * FROM V_EMP;

SELECT * FROM USER_VIEWS;

-- NOFORCE : 만약 생성하려는 뷰의 테이블이 존재하지 않는다면 생성하지 않는다.

-- ORA-00942: table or view does not exist
CREATE OR REPLACE NOFORCE VIEW V_EMP
AS
SELECT TCODE, TNAME, TCONNECT
FROM TTABLE;

-- 기본값은 NOFORCE이다.

-- WITH CHECK : 옵션으로 지정한 컬럼값을 수정하지 못하게 막는 옵션
CREATE OR REPLACE VIEW V_EMP
AS
SELECT * FROM EMPLOYEE
WITH CHECK OPTION;

SELECT * FROM V_EMP;

-- SQL 오류: ORA-32575: Explicit column default is not supported for modifying views
INSERT INTO V_EMP
VALUES (802, '민경운', '101010-1234567' , 'mingh@kh.or.kr', '01012344321', 'D1', 'J7', 'S1', 8000000, 0.1, 201, SYSDATE, NULL, DEFAULT);

-- DELETE는 가능하다
DELETE FROM V_EMP
WHERE EMP_ID = '500';

SELECT * FROM V_EMP;

-- VIEW의 원래 목적은 필요한 값들을
-- 별도의 테이블 형태로 조회하기 위함
-- 정보의 보안성(은닉성), 검색의 편리성

-- WITH READ ONLY : DML을 통한 데이터 입력, 수정, 삭제를 
--                     불가능하게 막는 옵션

CREATE OR REPLACE VIEW V_EMP
AS
SELECT * FROM EMPLOYEE
WITH READ ONLY;

-- SQL 오류: ORA-42399: cannot perform a DML operation on a read-only view
-- 읽기만 허용하여 데이터의 변경을 막을 수 있다.
DELETE FROM V_EMP;


-------------------------------------------------------

-- SEQUENCE(시퀀스) : 
-- 1,2,3, ... 9,10의 형식으로
-- 숫자 데이터를 처리하기 위한 객체
-- 자동 번호 발생기
-- 순차적으로 정수값을 생성해주는 객체(+/-)

/*
    CREATE SEQUENCE 시퀀스이름
    [INCREMENT BY 숫자] : 다음 값에 대한 증감수치, 생략할 경우 1씩 증가한다.
        --[INCREMENT BY 5] --> 5씩 증가
        --[INCREMENT BY -5] --> 5씩 감소
    [START WITH 숫자] : 처음 시작될 숫자를 지정한다. 생략하면 1부터 시작.
    [MAXVALUE 숫자 | NOMAXVALUE] -- 발생시킬 최대값 설정(10^27 - 1)
    [MINVALUE 숫자 | NOMINVALUE] -- 발생시킬 최소값 설정(-10^26)
    [CYCLE | NOCYCLE] -- 값의 순환 여부를 설정
    [CACHE 바이트 크기 | NOCACHE] -- 값을 미리 생성하는 설정,
                                  -- 기본값은 20바이트, 최소값은 2바이트
*/

-- 시퀀스 생성하기
CREATE SEQUENCE SEQ_EMPID
START WITH 300
INCREMENT BY 5
MAXVALUE 310
NOCYCLE
NOCACHE;

-- ORA-08002: sequence SEQ_EMPID.CURRVAL is not yet defined in this session
-- 시퀀스를 처음 생성했을 경우 반드시 1번은 동작 시켜야 한다.
SELECT SEQ_EMPID.CURRVAL FROM DUAL;

-- 시퀀스 실행하기
SELECT SEQ_EMPID.NEXTVAL FROM DUAL;
SELECT SEQ_EMPID.NEXTVAL FROM DUAL;
SELECT SEQ_EMPID.NEXTVAL FROM DUAL;

-- ORA-08004: sequence SEQ_EMPID.NEXTVAL exceeds MAXVALUE and cannot be instantiated
SELECT SEQ_EMPID.NEXTVAL FROM DUAL;

SELECT SEQ_EMPID.CURRVAL FROM DUAL;

-- 시퀀스 변경
-- ORA-02283: cannot alter starting sequence number
-- 시퀀스 변경 시에 초기값 설정을 할 수 없다.
-- 따라서 초기값을 변경하고자 할 경우
-- 기존의 시퀀스를 삭제(DROP)하고 새로운 시퀀스 객체를 만들어야 한다.

ALTER SEQUENCE SEQ_EMPID 
-- START WITH 315
INCREMENT BY 10
MAXVALUE 400
NOCYCLE
NOCACHE;

-- 시퀀스 정보가 들어있는 데이터 사전
SELECT * FROM USER_SEQUENCES;

-- SELECT 구문에서 데이터 조회 시에
-- SEQUENCE를 함께 사용할 수 있다.
-- INSERT 구문에서 VALUES 를 통한 값 입력 시 사용할 수 있고,
-- UPDATE 구문에서도 SET을 통한 값 변경 시 사용할 수 있다.

-- 단, 서브쿼리의 SELECT 구문에서는 사용이 불가능
-- VIEW 객체에서도 SELECT 시에 사용이 불가능하다.
-- DISTINCT 를 선언 할 시 사용할 수 없다.
-- GROUP BY, HAVING 같은 그룹 조건에서도 사용할 수 없다.
-- ORDER BY 에서도 사용할 수 없다.
-- CREATE TABLE 시에 컬럼의 기본값,
-- ALTER TABLE 시의 기본값 선언에서 사용할 수 없다.(mysql은 되지만,ORACLE은 안된다.)

-- 시퀀스 삭제
DROP SEQUENCE SEQ_EMPID;

-- 사용 사례
CREATE SEQUENCE SEQ_EID
START WITH 300
INCREMENT BY 1
MAXVALUE 10000
NOCYCLE
NOCACHE;


-- 시퀀스를 활용한 INSERT 구문 생성하기
INSERT INTO EMPLOYEE 
VALUES(SEQ_EID.NEXTVAL, '홍길동' , '101010-1234567','hong@kh.or.kr',
        '01012344321','D9', 'J7','S1', 5000000, 0.1, 200, SYSDATE, 
        NULL, DEFAULT);
        
INSERT INTO EMPLOYEE 
VALUES(SEQ_EID.NEXTVAL, '김길동' , '111111-1234567','kim@kh.or.kr',
        '01012341234','D9', 'J7','S1', 6000000, 0.2, 201, SYSDATE, 
        NULL, DEFAULT);
        
INSERT INTO EMPLOYEE 
VALUES(SEQ_EID.NEXTVAL, '박길동' , '121212-1234567','park@kh.or.kr',
        '01043214321','D9', 'J7','S1', 7000000, 0.3, 202, SYSDATE, 
        NULL, DEFAULT);
        
INSERT INTO EMPLOYEE 
VALUES(SEQ_EID.NEXTVAL, '최길동' , '121211-1234567','choi@kh.or.kr',
        '01010001000','D9', 'J7','S1', 8000000, 0.4, 203, SYSDATE, 
        NULL, DEFAULT);
        
INSERT INTO EMPLOYEE 
VALUES(SEQ_EID.NEXTVAL, '이길동' , '920109-1234567','lee@kh.or.kr',
        '01022223333','D9', 'J7','S1', 4000000, 0.5, 204, SYSDATE, 
        NULL, DEFAULT);  

UPDATE EMPLOYEE SET DEPT_CODE = 'D9'
WHERE EMP_ID = 300;

SELECT * FROM EMPLOYEE
WHERE DEPT_CODE = 'D9';

-- CYCLE 옵션
CREATE SEQUENCE SEQ_CYCLE
START WITH 200
INCREMENT BY 10
MAXVALUE 230
MINVALUE 15
CYCLE
NOCACHE;

SELECT SEQ_CYCLE.NEXTVAL FROM DUAL;
SELECT SEQ_CYCLE.NEXTVAL FROM DUAL;
SELECT SEQ_CYCLE.NEXTVAL FROM DUAL;
SELECT SEQ_CYCLE.NEXTVAL FROM DUAL; -- 최대값 도달
SELECT SEQ_CYCLE.NEXTVAL FROM DUAL; 
-- CYCLE을 설정했을 경우 최대값 도달 시 최고값부터 시작

SELECT SEQ_CYCLE.NEXTVAL FROM DUAL;

SELECT * FROM USER_SEQUENCES
WHERE SEQUENCE_NAME = 'SEQ_CYCLE';

-- CACHE / NOCACHE
-- CACHE : CPU가 연산을 그때 그때 즉시 수행하지 않고
--          미리 한번에 연산을 수행하여 연산한 결과들을 메모리에
--          담아 놓았다가 사용하는 방식
--  Ex) 빵을 미리 구워서 파는 가게

-- NOCACHE : CPUT가 연산을 즉시 수행하는 설정 방식
--  Ex) 빵을 주문받을 때마다 굽는 가게

CREATE SEQUENCE SEQ_CACHE
START WITH 10
INCREMENT BY 1
CACHE 5
NOCYCLE;

SELECT SEQ_CACHE.NEXTVAL FROM DUAL;

SELECT 
    SEQUENCE_NAME, 
    SEQ_CACHE.CURRVAL,
    INCREMENT_BY,
    CACHE_SIZE,
    LAST_NUMBER
FROM USER_SEQUENCES
WHERE SEQUENCE_NAME = 'SEQ_CACHE';


SELECT SEQ_CACHE.NEXTVAL FROM DUAL;
SELECT SEQ_CACHE.NEXTVAL FROM DUAL;
SELECT SEQ_CACHE.NEXTVAL FROM DUAL;
SELECT SEQ_CACHE.NEXTVAL FROM DUAL;
SELECT SEQ_CACHE.NEXTVAL FROM DUAL; -- LAST NUMBER에 도착했을 때



-- CACHE의 경우
-- 값을 미리 지정된 캐시의 사이즈만큼 수행 한 후
-- 데이터를 하나씩 사용하는 방식으로
-- 수행 속도는 빠를 수 있으나,
-- 만약 데이터 처리 중간에 데이터베이스에 오류가 발생하여
-- 계산을 다시 수행해야 할 경우 이미 계산해 두었던 값을
-- 버리고 마지막 부분에서 새로 시작한다.
-- 따라서 순차적인 데이터 처리의 누수현상이 발생할 수 있다.

