-- DAY 10 --

-- CRUD --
-- 응용 프로그램에서의 데이터 처리 기능
-- C : INSERT
-- R : SELECT
-- U : UPDATE
-- D : DELETE

-- TCL --
-- 트랜잭션을 제어하는 명령어
-- 트랜잭션 : 데이터 추가, 수정, 삭제 등의 
--            일련의 서비스 로직을 수행하기 위한
--            하나의 일 처리를 구분 짓는 작업의 최소 단위

-- TCL : 
--      COMMIT : 데이터를 처리한 과정을 실제 데이터 베이스에 반영할 때
--      ROLLBACK : 이전의 작업을 취소하고 원상태로 복귀시킬 때 (원.복)

-- DDL (CREATE, ALTER, DROP)
-- CREATE : 데이터베이스의 객체를
--      - 객체 : 테이블, 뷰, 인덱스, 계정, 시퀀스 ...

-- ALTER : 생성한 객체를 수정할 때
-- DROP : 생성한 객체의 요소(컬럼)를 삭제하거나,
--          객체 자체를 삭제하고자 할 때

-- ALTER

SELECT * FROM DEPT_COPY;

-- DEPT_COPY에 컬럼 추가하기
ALTER TABLE DEPT_COPY
ADD (LNAME VARCHAR2(20));

SELECT * FROM DEPT_COPY;

-- 현재 존재하는 컬럼 제거하기
ALTER TABLE DEPT_COPY
DROP COLUMN LNAME;

SELECT * FROM DEPT_COPY;

-- 컬럼을 추가하면서 기본값 적용하기
ALTER TABLE DEPT_COPY
ADD (LNAME VARCHAR2(20) DEFAULT '한국');

SELECT * FROM DEPT_COPY;

-- 컬럼에 제약조건 추가하기
CREATE TABLE DEPT_COPY2
AS SELECT * FROM DEPARTMENT;

ALTER TABLE DEPT_COPY2
ADD (LNAME VARCHAR2(20) DEFAULT '한국');

SELECT * FROM DEPT_COPY2;

-- 현재 DEPT_COPY2에 기본키, DEPTE_TITLE 고유값,
-- LNAME에 필수 입력 사항 제약 조건을 달아 보기

-- 일반적인 테이블 레벨에 설정했던 것처럼
-- ALTER를 사용하여 제약조건을 설정할 수 있다.
ALTER TABLE DEPT_COPY2
ADD CONSTRAINTS PK_DEPT_COPY2 PRIMARY KEY(DEPT_ID);
ALTER TABLE DEPT_COPY2
ADD CONSTRAINTS UK_DEPT_COPY2 UNIQUE(DEPT_TITLE);

-- NOT NULL은 테이블 레벨에서 제약조건 설정이 불가능한데,
-- 이를 ALTER를 통해 수정할 때에도 일반 제약조건 추가와는 방법이 다르다.
-- NOT NULL을 제약조건으로 추가할 때는 MODIFY 명령어를 사용한다.
ALTER TABLE DEPT_COPY2
MODIFY LNAME CONSTRAINT NN_LNAME NOT NULL;

SELECT * FROM USER_CONSTRAINTS
WHERE TABLE_NAME = 'DEPT_COPY2';

-- 컬럼 자료형 수정하기
ALTER TABLE DEPT_COPY2
MODIFY DEPT_ID CHAR(3)
MODIFY DEPT_TITLE VARCHAR2(30)
MODIFY LOCATION_ID VARCHAR2(2)
MODIFY LNAME CHAR(20);

-- CHAR < -- > VARCHAR2는 서로 변환이 가능하다.
-- 컬럼의 크기도 테이블 생성 이후엔 변경이 가능하다
-- 축소시킬 때에는 반드시 컬럼 안에 실제 들어있는 값의
-- 크기를 확인해야 한다.
-- ORA-01441: cannot decrease column length because some value is too big
ALTER TABLE DEPT_COPY2
MODIFY DEPT_TITLE VARCHAR2(10);

SELECT LENGTHB(DEPT_TITLE)
FROM DEPT_COPY2;

DESC DEPT_COPY2;

INSERT INTO DEPT_COPY2
VALUES('D0', '교육부', 'L1', DEFAULT);

-- DEFAULT 값 변경하기
ALTER TABLE DEPT_COPY2
MODIFY LNAME DEFAULT '미국';

INSERT INTO DEPT_COPY2
VALUES ('D11','생산부', 'L2', DEFAULT);

-- 컬럼의 이름 변경하기
ALTER TABLE DEPT_COPY2
RENAME COLUMN DEPT_TITLE TO DEPT_NAME;

SELECT * FROM DEPT_COPY2;

-- 제약조건 이름 변경하기

ALTER TABLE DEPT_COPY2
ADD CONSTRAINT PK_DEPT_ID PRIMARY KEY(DEPT_ID);

ALTER TABLE DEPT_COPY2
RENAME CONSTRAINT PK_DEPT_ID TO PK_DEPT_CONPY2;

SELECT * FROM USER_CONSTRAINTS
WHERE TABLE_NAME = 'DEPT_COPY2';

-- 테이블 이름 변경하기
ALTER TABLE DEPT_COPY2
RENAME TO DEPT_COPY_SECOND;

SELECT * FROM DEPT_COPY_SECOND;

RENAME DEPT_COPY_SECOND TO DEPT_COPY2;

SELECT * FROM DEPT_COPY2;

-- 컬럼 삭제
ALTER TABLE DEPT_COPY2
DROP COLUMN LNAME;

-- DDL 명령어는 트랜잭션개념이 아닌
-- 사용자 계정 연결에 대한 하나의 세션으로
-- 처리를 하기 때문에 COMMIT / ROLLBACK을 할 수 없다.
-- ROLLBACK;

ALTER TABLE DEPT_COPY2
--DROP COLUMN LOCATION_ID;
--DROP COLUMN DEPT_TITLE;

-- 컬럼을 삭제 시에
-- 한 테이블에 최소한 하나의 컬럼은 존재해야 한다.
-- ORA-12983: cannot drop all columns in a table
DROP COLUMN DEPT_ID;

CREATE TABLE SAMP1(
    PK NUMBER PRIMARY KEY,
    FK NUMBER REFERENCES SAMP1,
    COL1 NUMBER,
    CHECK (COL1 > 0 AND PK > 0 )
);

-- ORA-12992: cannot drop parent key column
-- 참조하는 자식 컬럼이 존재할 경우 삭제 할 수 없다.
ALTER TABLE SAMP1 DROP COLUMN PK;

-- CASCADE를 활용하여 제약 조건과 함께 삭제가 가능하다.
ALTER TABLE SAMP1 
DROP COLUMN PK CASCADE CONSTRAINT;

SELECT * FROM SAMP1;
DESC SAMP1;

-- DROP
-- 객체의 특정 요소를 제거하거나
-- 객체 자체를 제거하고자 할 대 사용하는 구문
-- [사용형식 1]
-- 객체의 요소를 제거할 때
-- ALTER 객체 객체명
-- DROP 지우고자 하는 요소


-- [사용형식 2]
-- 객체를 제거할 때
-- DROP 객체 객체명

-- 컬럼 삭제 : DROP COLUMN 삭제할 컬럼명 [CASCADE CONSTRAINT]
SELECT * FROM DEPT_COPY;

-- DROP (컬럼명) 을 사용해도 컬럼삭제가 가능하다.
ALTER TABLE DEPT_COPY
DROP (LNAME);

-- 여러 컬럼을 한꺼번에 삭제 할 수 도 있다.
ALTER TABLE DEPT_COPY
DROP (DEPT_TITLE, LOCATION_ID);

SELECT * FROM DEPT_COPY;

DESC DEPT_COPY2;

-- 제약 조건을 DROP을 통해 삭제하기
CREATE TABLE CONST_TAB(
    EID CHAR(2),
    ENAME VARCHAR2(15) NOT NULL, -- 컬럼 레벨의 제약조건
    EMAIL VARCHAR2(30) NOT NULL,
    AGE NUMBER NOT NULL,
    DEPT CHAR(5),
    -- 테이블 레벨의 제약조건
    CONSTRAINT PK_TAB PRIMARY KEY(EID),
    CONSTRAINT UK_TAB_EMAIL UNIQUE(EMAIL),
    CONSTRAINT CK_TAB_AGE CHECK (AGE > 0),
    CONSTRAINT FK_TAB_DEPT FOREIGN KEY(DEPT) REFERENCES DEPARTMENT(DEPT_ID) ON DELETE CASCADE
);

-- 제약조건 삭제하기
ALTER TABLE CONST_TAB
DROP CONSTRAINT CK_TAB_AGE;

-- 제약조건 여러 개 삭제하기
ALTER TABLE CONST_TAB

DROP CONSTRAINT UK_TAB_EMAIL
DROP CONSTRAINT FK_TAB_DEPT
DROP CONSTRAINT PK_TAB;

SELECT * FROM USER_CONSTRAINTS
WHERE TABLE_NAME = 'CONST_TAB';

-- NOT NULL을 삭제 할 경우
ALTER TABLE CONST_TAB
MODIFY (ENAME NULL, EMAIL NULL, AGE NULL);

-- 객체 삭제
DROP TABLE CONST_TAB;
DROP TABLE DEPT_COPY2;
DROP TABLE SAMP1;

-- ORA-01031: insufficient privileges
-- 권한이 없음
DROP USER SAMPLE1;


/*
-- 시스템 계정 ---

CREATE USER SAMPLE1 IDENTIFIED BY sample1;

GRANT CONNECT, RESOURCE TO SAMPLE1;

DROP USER SAMPLE1;

*/

-- 데이터 사전 --
-- Data Dictionary --

-- 제약조건을 관리하는 데이터 사전
-- USER_CONSTRAINTS

-- 제약조건을 컬럼별로 관리하는 데이터 사전
-- USER_CONS_COLUMNS;

-- 테이블을 관리하는 데이터 사전
-- USER_TABLES;

-- 테이블의 컬럼들을 관리하는 데이터 사전
-- USER_TAB_COLS;
SELECT * FROM USER_TAB_COLS
WHERE TABLE_NAME = 'EMPLOYEE'
ORDER BY 2;

-- 현재 사용자 계정이 보유한 테이블 별 컬럼 수를 조회 하시오
SELECT
    TABLE_NAME 보유한테이블,
    COUNT(*) 컬럼수
FROM USER_TAB_COLS
GROUP BY TABLE_NAME
ORDER BY 1;

-- 데이터 사전 권한에 따른 접두어
-- 1.USER_XXX : 사용자 계정(자신)이 소유한 객체나, 데이터 설정을 조회 할 수 있는
--              데이터 사전
-- 2.ALL_XXX : 사용자 계정(자신) + 접속 권한을 부여받은 다른 계정들의 객체 정보를 조회
-- 3.DBA_XXX : 데이터베이스 관리자만 접근을 할 수 있는 정보들을 조회
--              (현재 DBMS내의 모든 객체 정보를 조회 할 수 있다.



