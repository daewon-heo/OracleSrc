-- DAY 13 --
-- 허대원 --

-- ORACLE -- 
-- TABLE, USER, VIEW, SEQUENCE, INDEX, SYNONYM
-- TABLE : 행과 열로 이루어져 데이터들을 이차원의 표 형태로 관리하는 객체
-- CREATE TABLE 테이블명(
-- );
-- AS 서브쿼리;
--
-- 제약조건
-- NOT NULL : 필수 입력 사항 (컬럼 레벨에서만 설정이 가능)
--      ALTER TABLE 테이블명 
--      MODIFY 컬럼명 NOT NULL
-- UNIQUE : 중복이 허용되지 않는 설정
-- CHECK : 지정한 범위의 값만 허용할 때
-- PRIMARY KEY : (NOT NULL + UNIQUE)
--      한 테이블에서 반드시 한 개만 존재해야 한다.
--      기본키 제약 조건으로 설정하면 해당 컬럼 혹은 컬럼들이
--      해당 테이블 내 데이터의 식별자가 될 수 있다.
-- FOREIGN KEY : 다른 테이블의 데이터를 참조할 때 사용
--      참조할 수 있는 값들은 반드시 기본키 이거나 UNIQUE 제약 조건을 가져야 한다.


-- VIEW : SQL 쿼리문으로 이루어진 가상의 테이블
--      데이터를 보고 싶은 것만, 가리고 싶은 것을 가릴 수 있는
--      창문의 역할을 수행한다.

-- SEQUENCE : 순차적인 데이터 처리를 위한 데이터베이스 객체

-- INDEX : 이진트리 검색 방식으로 데이터의 검색을 더욱 빠르게 수행시키는 객체
--      단, 데이터가 적은 소용량 데이터 베이스나 값이 자주 변경되는 테이블에서는 
--      성능이 오히려 저하될 수 있으며,데이터 인덱스를 저장하기 위한 공간을 별도로 할당해야 한다.

-- SYNONYM(동의어) :사용자의 테이블에 접근할 수 있는 별칭을 선언하는 객체

-- SET OPERATION --
-- UNION : 두 개 이상의 SELECT 결과를 하나로 합칠 때 사용(합집합)
-- UNION ALL : UNION과 동일하다. (중복을 제거하지 않고 그대로 보여준다.)
-- INTERSECT : 두개 이상의 SELECT 결과중 일치하는 것만 표현 할 때 (교집합)
-- MINUS : 첫번째 SELECT 결과에서 나머지 SELECT 결과들을 합했을 때
--         첫번째 SELECT 결과만 가지는 데이터들을 표현할 때 (차집합)

-- JOIN --
-- INNER JOIN : 두 개 이상의 테이블의 결과셋 중 서로 가지는 값이 일치하는 
--              데이터만 합산하여 출력하는 조인 형태
SELECT * FROM EMPLOYEE
JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID);

-- OUTER JOIN ; 두 개 이상의 테이블을 합하였을 때 서로 가지지 않은, 즉 일치하지 않는
--             칼럼에 대한 결과도 함꼐 출력하는 조인 형태
-- 종류 : LEFT, RIGHT, FULL

-- PL/SQL --
-- (PROCUDURAL LANGUAGE EXTENSION TO SQL)
-- SQL사에서 확장된 형태의 스크립트 언어
-- 오라클 자체에서 내장된 절차적 언어 
-- 기존 SQL의 단점을 극복하기 위해
-- 변수의 정의, 조건처리, 반복처리, 예외 처리등을 지원하는 언어


-- PL/SQL -- 
-- 선언부, 실행부, 예외처리부로 구성됨
-- 선언부 : DECLARE, 변수나 상수를 선언하는 부분
-- 실행부 : BEGIN, 제어문, 반복문, 함수 정의등을 작성하는 부분
-- 예외처리부 : EXCEPTION, 예외 발생 시 처리할 내용을 작성하는 부분
BEGIN
    DBMS_OUTPUT.PUT_LINE('Hello World');
END;
/

-- 화면에 작성한 출력문이 보이도록 설정하기
-- 시스템 관련 설정이기 때문에
-- 접속을 종료하면 다시 초기화 된다.
SET SERVEROUTPUT ON;

-- 변수의 선언과 초기화, 변수값 출력
SELECT * FROM EMPLOYEE;

DECLARE
    EMP_ID NUMBER;
    EMP_NAME VARCHAR2(15);  /*변수의 선언*/
BEGIN
    -- 값 입력 부
    EMP_ID := 300; /* := 오라클의 대입연산자 */
    EMP_NAME := '홍길동';

    -- 값 출력 부
    DBMS_OUTPUT.PUT_LINE('EMP_ID = ' || EMP_ID);
    DBMS_OUTPUT.PUT_LINE('EMP_NAME = ' || EMP_NAME);
END;
/

-- 실제 테이블을 활용한 
-- 레퍼런스 변수(참조 변수)를 선언하고 사용하는 방법
DECLARE
    EID  EMPLOYEE.EMP_ID%TYPE;
    ENAME EMPLOYEE.EMP_NAME%TYPE;
BEGIN
    SELECT EMP_ID, EMP_NAME
    INTO EID, ENAME
    FROM EMPLOYEE
    WHERE EMP_ID = '&EMP_ID';
    
    DBMS_OUTPUT.PUT_LINE('EMP_ID : ' || EID);
    DBMS_OUTPUT.PUT_LINE('EMP_NAME : ' || ENAME);
END;
/

-- 1. 실습
-- EMP_ID, EMP_NAME, DEPT_CODE, JOB_CODE, SALARY를
-- 참조변수로 선언하고, EPLOYEE에서 해당 정보들을 추출하여
-- 선언한 참조 변수에 담아 출력해 보시오.
-- 단, 이름은 직접 입력하며, 월급은 통화기호와 쉼표를 붙여 표현하시오

DECLARE
    EID EMPLOYEE.EMP_ID%TYPE;
    ENAME EMPLOYEE.EMP_NAME%TYPE;
    DCODE EMPLOYEE.DEPT_CODE%TYPE;
    JCODE EMPLOYEE.JOB_CODE%TYPE;
    SAL  EMPLOYEE.SALARY%TYPE;
BEGIN
    SELECT EMP_ID,EMP_NAME,DEPT_CODE, JOB_CODE, SALARY
    INTO EID, ENAME, DCODE, JCODE, SAL
    FROM EMPLOYEE
    WHERE EMP_NAME = '&EMP_NAME';
    
    DBMS_OUTPUT.PUT_LINE('EMP_ID : ' || EID);
    DBMS_OUTPUT.PUT_LINE('EMP_NAME : ' || ENAME);
    DBMS_OUTPUT.PUT_LINE('DEPT_CODE : ' || DCODE);
    DBMS_OUTPUT.PUT_LINE('JOB_CODE : ' || JCODE);
    DBMS_OUTPUT.PUT_LINE('SALARY : ' || TRIM(TO_CHAR(SAL,'L99,999,999')));
END;
/


-- %TYPE : 한 컬럼의 자료형을 받아올 때 사용하는 명령어
-- %ROWTYPE : 테이블의 한 행의 모든 컬럼의 자료형을 참조할 때 사용하는 명령어

DECLARE
    E EMPLOYEE%ROWTYPE;
BEGIN
    SELECT *
    INTO E
    FROM EMPLOYEE
    WHERE EMP_ID = '&사원번호';
    
    DBMS_OUTPUT.PUT_LINE('사원 번호 : ' || E.EMP_ID);
    DBMS_OUTPUT.PUT_LINE('사원명 : ' || E.EMP_NAME);
    DBMS_OUTPUT.PUT_LINE('급여정보 : ' || E.SALARY);
END;
/
        
-- IF : 조건문
-- 
-- 점수를 입력받아 SCORE 변수에 저장하고
-- 90점 이상은 'A'
-- 80점 이상은 'B'
-- 70점 이상은 'C'
-- 그 이하는 'F'로 산정하여
-- '당신의 점수는 00이며, 0학점 입니다.'
-- 라는 결과를 출력해보시오.

DECLARE
    SCORE INT;
    GRADE VARCHAR2(2);
BEGIN
    SCORE := '&점수';
    
--  IF 조건문
    IF SCORE >= 90 THEN GRADE := 'A';
    ELSIF SCORE >= 80 THEN GRADE := 'B';
    ELSIF SCORE >= 70 THEN GRADE := 'C';
    ELSE GRADE := 'F';
    END IF;
    
    DBMS_OUTPUT.PUT_LINE('당신의 점수는 : ' || SCORE || '점이고, 학점은 ' || GRADE || '입니다');
END;
/

-- PL/SQL에서의 반복문 선언하기

-- ORA-01422: exact fetch returns more than requested number of rows
-- 일반적으로 하나의 PL/SQL은 하나의 결과만 반환한다.
-- 이러한 현상을 해결하기 위한 것이 바로 
-- LOOP 반복 구문이다.
DECLARE
    E EMPLOYEE%ROWTYPE;
BEGIN
    SELECT *
    INTO E
    FROM EMPLOYEE;
    
    DBMS_OUTPUT.PUT_LINE('사원 번호 : ' || E.EMP_ID);
    DBMS_OUTPUT.PUT_LINE('사원명 : ' || E.EMP_NAME);
    DBMS_OUTPUT.PUT_LINE('급여정보 : ' || E.SALARY);
END;
/


DECLARE
    N NUMBER := 1; /* 변수 선언과 동시에 초기화 */
BEGIN
    LOOP
        DBMS_OUTPUT.PUT_LINE(N);
        N := N + 1;
        
        IF N > 5 THEN EXIT;
        END IF;
    END LOOP;
END;
/

CREATE TABLE TEST1(
    NO NUMBER,
    TEST_DATE DATE
);

/* FOR LOOP : FOR 반복문 */
BEGIN
    FOR I IN 1..10
        LOOP
            INSERT INTO TEST1 VALUES(I, SYSDATE+1);
        END LOOP;
END;
/

SELECT * FROM TEST1;

SELECT * FROM V_EMP;

-- 즉시 실행하는 PL/SQL 스크립트를 저장하는
-- PL/SQL 객체 프로시저

-- 프로시저 --
-- PL/SQL을 저장하는 객체
-- 필요할 때마나 직접 스크립트를 작성하는 방식이 아니라
-- 특정 스크립트를 저장해 두었다가
-- 필요로 할 때 호출하는 방식
-- 간편한 스크립트 실행이 목적이다

COMMIT;

CREATE TABLE EMP_DUP
AS SELECT * FROM EMPLOYEE;

-- 2. 프로시져 생성하여 스크립트 저장
CREATE OR REPLACE PROCEDURE DEL_DEMP_WITH_ID
IS
BEGIN
    DELETE FROM EMP_DUP
    WHERE EMP_ID = '&사번';
END;
/

-- 3. 생성한 프로시저 호출
EXECUTE DEL_DEMP_WITH_ID;
EXEC DEL_DEMP_WITH_ID;

--DEL_EMP_ALL 이라는 이름으로
--프로시져를 생성하여 EMP_DUP의 정보를 모두 삭제하시오
CREATE OR REPLACE PROCEDURE DEL_EMP_ALL
IS
BEGIN
    DELETE FROM EMP_DUP;
END;
/

EXEC DEL_EMP_ALL;

SELECT * FROM EMP_DUP;

DROP TABLE EMP_DUP;
DROP PROCEDURE DEL_DEMP_WITH_ID;
DROP PROCEDURE DEL_EMP_ALL;

-- 프로시져도 데이터 사전에 등록되어 있다.
-- 프로시저를 관리하는 데이터 사전
SELECT * FROM USER_SOURCE;

-- 트리거 (TRIGGER)
-- 테이블이나 뷰에 INSERT, UPDATE, DELETE등의 DML을 수행할 때
-- 해당 시점을(수행되는 순간) 감지하여 자동으로 스크립트를 실행 시키는
-- 객체를 트리거라고 한다.
-- 즉, 사용자가 직접 스크립트를 호출하여 사용하는 방식이 아니라
-- 데이터베이스에서 자동으로 동작시키는 객체이다.
-- 이러한 트리거의 종류는 크게 전체 트랜잭션에 대한 스크립트를 수행하는 트리거와
-- 각 행의 변경 시점을 감지하여 동작하는 행 별 수행 트리거가 있다.

-- 신입사원 입사 시 입사 안내 공문을 출력하는 트리거

-- 1. 수행할 스크립트를 작성
BEGIN
    DBMS_OUTPUT.PUT_LINE('신입사원이 입사했습니다!');
    DBMS_OUTPUT.PUT_LINE('모두 환영해주세요 ~!! ^ㅡ^');
END;
/

-- 2. 작성한 스크립트가 동작할 트리거를 생성한다.
-- [트리거가 동작하는 시점]
-- DML이 수행되기 전, 후
-- BEFORE | INSERT | UPDATE | DELETE--> 값이 삽입되기 전에!
-- AFTER | INSERT | UPDATE | DELETE --> 값이 삽입된 후에!

CREATE OR REPLACE TRIGGER TRG_01 /* 트리거 이름 설정*/
AFTER INSERT                      /* 트리거 실행 시점 설정*/  
ON EMPLOYEE                         
BEGIN                              /* 트리거 실행 내용 작성*/
    DBMS_OUTPUT.PUT_LINE('신입사원이 입사했습니다!');
    DBMS_OUTPUT.PUT_LINE('모두 환영해주세요 ~!! ^ㅡㅡㅡㅡㅡㅡ^');
END;                               /* 트리거 끝*/
/

SET SERVEROUTPUT ON;

INSERT INTO EMPLOYEE
VALUES(996, '손성일2', '510102-1234566', 'S2ON123@kh.or.kr',
        '01912345678', 'D5', 'J3', 'S4', 40000003, 0.1, 200,
        SYSDATE, NULL, DEFAULT);
        
COMMIT;






