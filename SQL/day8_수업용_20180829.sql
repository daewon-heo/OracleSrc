-- DAY 8 -- 
-- CRUD --
-- C : CREATE
-- R : READ
-- U : UPDATE
-- D : DELETE

-- R : SELECT

---------------------------
-- CREATE --
-- DDL : 데이터를 정의하는 언어
--  데이터를 관리하는 객체를 생성하고(CREATE)
--  , 수정하고(ALTER),  삭제하는(DROP) 언어

-- 데이터를 관리하는 객체(오라클)
-- TABLE(테이블), VIEW(뷰), 시퀀스(SEQUENCE),
-- INDEX(인덱스), PACKAGE(패키지), TRIGGER(트리거),
-- 프로시져(PROCEDUER), 함수(FUNCTION)
-- 동의어(SYNONYM), 사용자(USER)

-- 테이블 생성 --
-- 데이터를 저장, 수정, 삭제하기 위해
-- 데이터들을 이차원의 표 형태로 담을 수 있는 객체
-- [표현식]
-- CREATE TABLE 테이블명(
--      컬럼명 컬럼의자료형  (자료형 크기)    [제약 조건],
--      컬럼명2    ..          ..              ..
-- );

CREATE TABLE MEMBER(
    MEMBER_NO NUMBER,           -- 회원 번호
    MEMBER_ID VARCHAR2(20),     -- 회원 아이디
    MEMBER_PWD VARCHAR2(20),    -- 회원 비밀번호
    MEMBER_NAME VARCHAR2(20)   -- 회원이름    
);

SELECT * FROM MEMBER;

-- 테이블의 각 컬럼마다 주석을 달 수 있다.
-- COMMENT ON COLUMN 테이블명.컬럼명 IS '주석내용';
COMMENT ON COLUMN MEMBER.MEMBER_NO IS '회원 번호';
COMMENT ON COLUMN MEMBER.MEMBER_ID IS '회원 아이디';
COMMENT ON COLUMN MEMBER.MEMBER_PWD IS '회원 비밀번호';
COMMENT ON COLUMN MEMBER.MEMBER_NAME IS '회원 이름';


-- 데이터 사전 (Data Dictionary)
-- 현재 접속한 사용자 계정이 보유한 테이블 목록
SELECT * FROM USER_TABLES;

-- 현재 사용자 계정이 보유한 테이블 목록의 컬럼들
SELECT * FROM USER_TAB_COLUMNS
WHERE TABLE_NAME = 'MEMBER';

-- 테이블 정보 확인하기
DESC MEMBER;

-- 제약조건 ( CONSTRAINTS)
-- 테이블을 생성할 대 각 컬럼에 대해서
-- 값을 기록하는 것에 대한 제약조건을 설정할 수 있다.
-- 이러한 제약조건을 통해 값이 고유의 값이라는 혹은
-- 값이 문제가 없는 값이라는 데이터 무결성을 보장할 수 있다.
-- 제약조건의 목적은 입력 데이터에 문제가 없는지 자동으로 검사하고,
-- 데이터의 수정/삭제 가능 여부를 판단하여 데이터 무결성을 보장하는 것이
-- 그 목적에 있으며 제약조건의 종류로는
-- NOT NULL, UNIQUE, CHECK, PRIMARY KEY, FOREIGN KEY가 있다.

-- 현재 사용자 계정에 관련된 제약조건 확인하는 데이터 사전
-- 테이블 별 제약 조건 확인하기
DESC USER_CONSTRAINTS;

SELECT * FROM USER_CONSTRAINTS;

-- 테이블의 컬럼별 제약조건 확인하기
DESC USER_CONS_COLUMNS;
SELECT * FROM USER_CONS_COLUMNS;

-- 데이터 사전은 시스템의 설정을 담당하기 때문에
-- 내부의 데이터(값)들을 사용자 계정 함부로 수정할 수 없다.

-- 제약조건 --
-- NOT NULL --
-- '널 값을 허용하지 않는다.'라는 뜻으로 사용하는 제약 조건
-- 제약조건 등록한 컬럼에 반드시 값을 기록해야 한다.
-- 필수 입력사항을 컬럼에 등록해야 할 경우
-- 데이터 삽입/수정/삭제 시에 NULL값을 혀용하지 않도록
-- 컬럼 레벨에서 제약조건을 작성한다.

CREATE TABLE USER_NOCONS(
    USER_NO NUMBER,
    USER_ID VARCHAR2(20),
    USER_PWD VARCHAR2(30),
    USER_NAME VARCHAR2(15),
    GENDER VARCHAR2(3),
    PHONE VARCHAR2(15),
    EMAIL VARCHAR2(30)
);


INSERT INTO USER_NOCONS
VALUES (1,'user01', 'pass01', '홍길동', '남', '010-1111-2222',
        'hong123@kh.or.kr');
        
SELECT * FROM USER_NOCONS;

INSERT INTO USER_NOCONS
VALUES(2, NULL,NULL,NULL,'남','010-2222-3333',NULL);


SELECT * FROM USER_NOCONS;

CREATE TABLE USER_NOTNULL(
    USER_NO NUMBER NOT NULL, -- 컬럼 레벨 제약조건
    USER_ID VARCHAR2(20) NOT NULL,     
    USER_PWD VARCHAR2(30) NOT NULL,
    USER_NAME VARCHAR2(15) NOT NULL,
    GENDER VARCHAR2(3),
    PHONE VARCHAR2(15),
    EMAIL VARCHAR2(30)
);

SELECT * FROM USER_NOTNULL;
DESC USER_NOTNULL;

SELECT * FROM USER_CONSTRAINTS C1
JOIN USER_CONS_COLUMNS C2 ON (C1.CONSTRAINT_NAME = C2.CONSTRAINT_NAME)
WHERE C1.TABLE_NAME = 'USER_NOTNULL';

INSERT INTO USER_NOTNULL
VALUES (1,'user01', 'pass01', '홍길동', '남', '010-1111-2222',
        'hong123@kh.or.kr');

INSERT INTO USER_NOTNULL
VALUES (2, NULL, NULL, NULL, '남', '010-2222-3333', NULL);

-- UNIQUE 제약조건 --
-- 컬럼에 값을 입력/수정할 때에 중복 값을 확인하여
-- 값의 중복을 제한하는 제약조건
-- 컬럼 레벨에서 설정이 가능하며, 테이블 레벨에서도 설정할 수 있다.

INSERT INTO USER_NOCONS
VALUES (1, 'user01', 'pass01', '홍길동', '남','010-1111-2222', 'hong123@kh.or.kr');

SELECT * FROM USER_NOCONS;

-- CHAR(10)        / VARCHAR2(10)
-- '10칸'          / '10칸까지'
-- '남 ... '       / '남'
-- 최대값까지 받되 / 최대값 까지만
-- 남는 자리는 ' ' / 받아서 유동적으로
--                 / 자릿수를 계산

CREATE TABLE USER_UNIQUE(
    USER_NO NUMBER,
    USER_ID VARCHAR2(20) UNIQUE,  -- 컬럼 레벨에서 제약조건을 설정
    USER_PWD VARCHAR2(30) ,
    USER_NAME VARCHAR2(15),
    GENDER VARCHAR2(3),        
    PHONE VARCHAR2(15),
    EMAIL VARCHAR2(30)
);


INSERT INTO USER_UNIQUE
VALUES (1, 'user01', 'pass01', '홍길동', '남','010-1111-2222', 'hong123@kh.or.kr');

INSERT INTO USER_UNIQUE
VALUES (1, 'user01', 'pass01', '홍길동', '남','010-1111-2222', 'hong123@kh.or.kr');

SELECT * 
FROM USER_CONSTRAINTS UC, USER_CONS_COLUMNS UCC
WHERE UC.CONSTRAINT_NAME = 'SYS_C007068'
AND UC.CONSTRAINT_NAME = UCC.CONSTRAINT_NAME;


-- 테이블 레벨에서 UNIQUE 제약조건 설정하기
CREATE TABLE USER_UNIQUE2(
    USER_NO NUMBER,
    -- USER_ID VARCHAR2(20) UNIQUE,  -- 컬럼 레벨에서 제약조건을 설정
    USER_ID VARCHAR2(20),
    USER_PWD VARCHAR2(30) ,
    USER_NAME VARCHAR2(15),
    GENDER VARCHAR2(3),        
    PHONE VARCHAR2(15),
    EMAIL VARCHAR2(30),
    UNIQUE(USER_ID)     -- 컬럼이 모두 작성된 후에
                        -- 제약 조건을 별도로 작성하는 것을
                        -- 테이블 레벨 제약조건 설정이라고 한고.
);


INSERT INTO USER_UNIQUE2
VALUES (1, 'user01', 'pass01', '홍길동', '남','010-1111-2222', 'hong123@kh.or.kr');


SELECT * FROM USER_UNIQUE2;

-- UNIQUE 제약조건을 여러개 컬럼에 설정하기
-- 1반 - user01
--     - user02
-- 2반 - user01
--     - user02
-- 두 개 이상의 컬럼을 UNIQUE 제약조건으로
-- 묶을 경우 테이블 레벨에서 설정행 한다.

CREATE TABLE USER_UNIQUE3(
    USER_NO NUMBER,
    USER_ID VARCHAR2(20),
    USER_PWD VARCHAR2(30) ,
    USER_NAME VARCHAR2(15),
    GENDER VARCHAR2(3),        
    PHONE VARCHAR2(15),
    EMAIL VARCHAR2(30),
    UNIQUE(USER_NO, USER_ID)  -- 두 개 이상의 컬럼값을 중복되지 않게
                                -- 설정하는 경우
);

INSERT INTO USER_UNIQUE3
VALUES (1, 'user01', 'pass01', '홍길동', '남','010-1111-2222', 'hong123@kh.or.kr');



INSERT INTO USER_UNIQUE3
VALUES (2, 'user01', 'pass01', '홍길동', '남','010-1111-2222', 'hong123@kh.or.kr');

INSERT INTO USER_UNIQUE3
VALUES (1, 'user02', 'pass01', '홍길동', '남','010-1111-2222', 'hong123@kh.or.kr');

INSERT INTO USER_UNIQUE3
VALUES (2, 'user02', 'pass01', '홍길동', '남','010-1111-2222', 'hong123@kh.or.kr');

-- HUMAN ERROR
-- 개발자가 코드 작성 후 실행하여
-- 데이터 변경 할 때에 오타나 개발자의 실수로 인해
-- 데이터가 잘못 변경되어 시스템 적용될 경우 
-- 이로 인해 시스템 운영 시에 문제가 발생할 수 있는데
-- 이를 사람이 발생시킨 오류다 라고 해서 'Human error'라고 한다.


SELECT * FROM USER_UNIQUE3;

--  제약조건 이름 설정하기
CREATE TABLE CONS_NAME (
    TEST_DATA1 VARCHAR2(20) CONSTRAINT NN_TEST_DATA1 NOT NULL,
    TEST_DATA2 VARCHAR2(20) CONSTRAINT UN_TEST_DATA2 UNIQUE,
    TEST_DATA3 VARCHAR2(20),
    CONSTRAINT UK_TEST_DATA3 UNIQUE(TEST_DATA3)
);

SELECT  * FROM USER_CONSTRAINTS
WHERE TABLE_NAME = 'CONS_NAME';

-- 일반적으로 제약조건을 생성할 때에
-- 제약조건의 이름을 같이 등록 함으로써
-- 후에 제약조건을 수정하거나 조회할 경우
-- 쉽게 찾아갈 수 있다.


DROP TABLE CONS_NAME;


-- CHECK 제약 조건--
-- 컬럼에 값을 기록할 때 지정한 값 외에는 기록되지 않도록
-- 제한을 두는 제약 조건
-- CHECK(컬럼명 비교연산자 값)
-- EX) CHECK(GENDER IN ('남', '여'))

CREATE TABLE USER_CHECK(
    USER_NO NUMBER PRIMARY KEY,
    USER_ID VARCHAR2(20) UNIQUE,
    USER_PWD VARCHAR2(30) NOT NULL,
    USER_NAME VARCHAR2(15) NOT NULL,
    GENDER VARCHAR2(3) CHECK(GENDER IN ('남', '여')),
    PHONE VARCHAR2(15),
    EMAIL VARCHAR2(30)
);

-- ORA-12899: value too large for column "EMPLOYEE"."USER_CHECK"."GENDER" (actual: 6, maximum: 3)
INSERT INTO USER_CHECK
VALUES(1, 'user01', 'pass01' , '홍길동' , '남자', '010-1111-2222','hong123@kh.or.kr');

select * from user_check;
-- ORA-02290: check constraint (EMPLOYEE.SYS_C007076) violated
INSERT INTO USER_CHECK
VALUES(2, 'user02', 'pass02' , '고길동' , 'm', '010-2222-3333','gogil@kh.or.kr');

select * from user_check;

-- CHECK 제약조건 부등호를 통한 값 비교

CREATE TABLE TEST_CHECK2(
    TEST_DATA NUMBER,
    CONSTRAINT CK_TEST_DATA CHECK(TEST_DATA > 0)
);

INSERT INTO TEST_CHECK2
VALUES(10);

-- ORA-02290: check constraint (EMPLOYEE.CK_TEST_DATA) violated
INSERT INTO TEST_CHECK2
VALUES(-10);

CREATE TABLE TEST_CHECK3(
    C_NAME VARCHAR2(15 CHAR),
    C_PRICE NUMBER,
    C_DATE DATE,
    C_QUAL CHAR(1),
    CONSTRAINT PK_TESTCK3_C_NAME PRIMARY KEY(C_NAME),
    CONSTRAINT CK_TESTCK3_C_PRICE CHECK (C_PRICE BETWEEN 1 AND 99999),
    CONSTRAINT CK_TESTCK3_C_DATE 
        CHECK (C_DATE >= TO_DATE('2010/01/01', 'YYYY/MM/DD')),
    CONSTRAINT CK_TESTCK3_C_QUAL 
        CHECK (C_QUAL >= 'A' AND C_QUAL <= 'F')
);

SELECT * FROM USER_CONSTRAINTS
WHERE TABLE_NAME = 'TEST_CHECK3';

-- 제약 조건 2개 이상 설정할 경우
CREATE TABLE TEST_CONST_DUAL(
    TEST NUMBER NOT NULL UNIQUE,
    TEST_DATA VARCHAR2(30) NOT NULL,
    TEST_DATA2 VARCHAR2(30 CHAR),
    CONSTRAINT CONST_TEST UNIQUE(TEST_DATA2)
);

SELECT * FROM USER_CONSTRAINTS
WHERE TABLE_NAME = 'TEST_CONST_DUAL';

-- PRIMARY KEY 제약조건 --
-- '기본키' 제약 조건
-- 테이블 내의 한 행에서 그 행을 식별하기 위한
-- 고유의 값을 가지는 컬럼을 기본키라고 한다.
-- 테이블 전체의 각 데이터에 대한 식별자(Identifier)의 역할을
-- 하는 컬럼을 설정하여 값이 반드시 들어가고, 중복이 되지 않게
-- 하기 위한 제약조건
-- ** 한 테이블에서 PRIMARY KEY는 반드시 한 개만 존재할 수 있다.
-- PRIMARY KEY는 한 컬럼에 적용할 수도 있고,
-- 여러 컬럼을 하나로 묶어 적용할 수도 있다.
-- 또한 컬럼 레벨, 테이블 레벨에 설정 가능하다.


CREATE TABLE USER_PRIMARY_KEY(
    USER_NO NUMBER CONSTRAINT PK_USER_NO PRIMARY KEY, -- 컬럼 레벨 설정
    USER_ID VARCHAR2(20) UNIQUE,
    USER_PWD VARCHAR2(30) NOT NULL,
    USER_NAME VARCHAR2(15) NOT NULL,
    GENDER VARCHAR2(3) CHECK(GENDER IN ('남', '여')),
    PHONE VARCHAR2(15),
    EMAIL VARCHAR2(30)
);

SELECT * FROM USER_CONSTRAINTS
WHERE TABLE_NAME = 'USER_PRIMARY_KEY';

-- 기본키를 제약조건으로 설정하게 되면
-- 오라클 내부에서 식별하기 위한 고유의 값으로
-- 사용하며, 검색을 더욱 빠르게하는 인덱스를 자동 생성한다.

INSERT INTO USER_PRIMARY_KEY
VALUES(1, 'user01', 'pass01', '홍길동', '남', '010-1111-2222',
        'hong123@kh.or.kr');

SELECT * FROM USER_PRIMARY_KEY;

-- ORA-00001: unique constraint (EMPLOYEE.PK_USER_NO) violated        
INSERT INTO USER_PRIMARY_KEY
VALUES(1, 'user01', 'pass01', '홍길동', '남', '010-1111-2222',
        'hong123@kh.or.kr');

SELECT * FROM USER_PRIMARY_KEY;

-- ORA-01400: cannot insert NULL into ("EMPLOYEE"."USER_PRIMARY_KEY"."USER_NO")
INSERT INTO USER_PRIMARY_KEY
VALUES(NULL, 'user02', 'pass02', '홍길동', '남', '010-1111-2222',
        'hong123@kh.or.kr');
        
SELECT * FROM USER_PRIMARY_KEY;
-- 기본키 제약조건을 설정하면
-- NOT NULL과 UNIQUE 제약조건이 함께 설정된다.

-- 기본키 제약조건을 여러 컬럼에 적용하기
CREATE TABLE USER_PRIMARY_KEY2(
    USER_NO NUMBER,
    USER_ID VARCHAR2(20) UNIQUE,
    USER_PWD VARCHAR2(30) NOT NULL,
    USER_NAME VARCHAR2(15) NOT NULL,
    GENDER VARCHAR2(3) CHECK(GENDER IN ('남', '여')),
    PHONE VARCHAR2(15),
    EMAIL VARCHAR2(30),
    CONSTRAINT PK_USER_2 PRIMARY KEY(USER_NO, USER_ID)
);

INSERT INTO USER_PRIMARY_KEY
VALUES(1, 'user01', 'pass01', '홍길동', '남', '010-1111-2222',
        'hong123@kh.or.kr');

-- ORA-00001: unique constraint (EMPLOYEE.SYS_C007092) violated        
INSERT INTO USER_PRIMARY_KEY
VALUES(2, 'user03', 'pass03', '홍길동', '남', '010-1111-2222',
        'hong123@kh.or.kr');

-- ORA-00001: unique constraint (EMPLOYEE.SYS_C007092) violated        
INSERT INTO USER_PRIMARY_KEY
VALUES(1, 'user02', 'pass02', '홍길동', '남', '010-1111-2222',
        'hong123@kh.or.kr');

-- ORA-00001: unique constraint (EMPLOYEE.SYS_C007092) violated
INSERT INTO USER_PRIMARY_KEY
VALUES(2, 'user01', 'pass01', '홍길동', '남', '010-1111-2222',
        'hong123@kh.or.kr');


SELECT * FROM USER_PRIMARY_KEY;

-- 1. 실습
-- USER 테이블을 생성하여
-- 사용자 정보를 받을 수 있는 테이블 객체를 만들되
-- 회원 번호 NUMBER 기본 키, 
-- 회원 아이디 중복안되고 필수입력 정보 제약조건
-- 회원 비밀번호 필수 입력 정보,
-- 학원 이름,
-- 회원 성별 (M,F)
-- 회원 이메일, 
-- 회원 연락처,
-- 회원 생년월일
-- 위의 정보들을  받을 수 있는 칼럼을 생성하여
-- 테이블을 만들어 보시오.
-- 단, 각 컬럼의 길이는 직접  판단해서 기입하고
-- 위에 생성된 테이블을 기준으로
-- 회원정보를 최소 5개 이상 삽입하여
-- 조회해보시오.
SELECT * FROM USER;

CREATE TABLE USER_MEMBER(
    USER_NO NUMBER PRIMARY KEY,
    USER_ID VARCHAR2(30) NOT NULL UNIQUE,
    USER_PW VARCHAR2(30) NOT NULL,
    USER_NAME VARCHAR2(20 CHAR),
    GENDER VARCHAR2(1) CHECK(GENDER IN ('M', 'F')),
    USER_EMAIL VARCHAR2(50),
    USER_BIRTH DATE
);
SELECT * FROM USER_MEMBER;
INSERT INTO USER_MEMBER VALUES(1, 'user01', 'pass01','user_name', 'M', 'a@a.com', '10/10/10');
INSERT INTO USER_MEMBER VALUES(2, 'user02', 'pass02','user_name2', 'M', 'b@b.com', '14/10/10');
INSERT INTO USER_MEMBER VALUES(3, 'user03', 'pass03','user_name3', 'F', 'c@c.com', '09/10/10');
INSERT INTO USER_MEMBER VALUES(4, 'user04', 'pass04','user_name4', 'F', 'd@d.com', '02/10/10');
INSERT INTO USER_MEMBER VALUES(5, 'user05', 'pass05','user_name5', 'F', 'e@e.com', '11/10/10');

COMMENT ON COLUMN USER_MEMBER.USER_NO IS '유저 번호';
COMMENT ON COLUMN USER_MEMBER.USER_ID IS '유저 아이디';
COMMENT ON COLUMN USER_MEMBER.USER_PW IS '유저 비밀번호';
COMMENT ON COLUMN USER_MEMBER.USER_NAME IS '유저 이름';
COMMENT ON COLUMN USER_MEMBER.GENDER IS '유저 성별';
COMMENT ON COLUMN USER_MEMBER.USER_EMAIL IS '유저 이메일';
COMMENT ON COLUMN USER_MEMBER.USER_BIRTH IS '유저 생일';

-- ALTER TABLE USER_MEMBER 
-- MODIFY USER_EMAIL VARCHAR2(100);

-- DELETE FROM USER_MEMBER;

SELECT TO_CHAR(USER_BIRTH, 'RRRR') FROM USER_MEMBER;



DESC USER_MEMBER;

-- DML구문을 통해서 
-- 데이터를 추가/수정/삭제를 실행했을 경우
-- 수정된 데이터에 대해서
-- 수정완료 혹은 수정 취소를 처리할 수 있는데
-- 이를 TCL이라고 산다.
-- 수정완료는 COMMIT / 수정 취소는 ROLLBACK
COMMIT;

-- FOREIGN KEY 제약조건 --
-- 외래키, 외부키, 참조키라고도 한다.
-- 다른 테이블의 데이터를 참조(REFERENCE)하여
-- 참조하는 테이블의 컬럼값만 사용하는 제한을 설정할 때
-- 사용하는 제약 조건
-- FOREIGN KEY 제약조건을 통해 다른 테이블과의 
-- 관계(RELATIONSHIP)가 형성된다.
-- 다른 테이블의 컬럼과 NULL값 이외에는 데이터를 추가, 수정, 삭제할 수 없다.

-- 컬럼 레벨의 경우
-- 컬럼명 자료형(크기) [CONSTRAINT 제약조건명]
-- REFERENCES 참조할 테이블[(참조할 컬럼명)] [삭제 옵션]

-- 테이블 레벨일 경우
-- [CONSTARINT 제약조건명] FOREIGN KEY (적용할 컬럼명)
-- REFERENCES 참조할 테이블명[(참조할 컬럼명)][삭제 옵션]

-- 참조할 컬럼명 생략될 경우 해당 테이블의 기본키를 
-- 참조할 컬럼으로 가져온다.(해당 테이블의 PRIMARY KEY로 설정된 컬럼)
-- 참조 될 수 있는 컬럼은 반드시 PRIMARY KEY이거나 UNIQUE 제약조건이
-- 설정되어 있어야 한다.

CREATE TABLE USER_GRADE(
    GRADE_CODE NUMBER PRIMARY KEY,
    GRADE_NAME VARCHAR2(30) NOT NULL
);

INSERT INTO USER_GRADE
VALUES(10, '일반회원');

INSERT INTO USER_GRADE
VALUES(20, '우수회원');

INSERT INTO USER_GRADE
VALUES(30, '특별회원');

SELECT * FROM USER_GRADE;

CREATE TABLE USER_FOREIGNKEY(
    USER_NO NUMBER PRIMARY KEY,
    USER_ID VARCHAR2(20),
    USER_PWD VARCHAR2(30),
    USER_NAME VARCHAR2(15),
    GENDER CHAR(1) CHECK(GENDER IN ('M','F')),
    PHONE VARCHAR2(13),
    EMAIL VARCHAR2(30),
    GRADE_CODE NUMBER,
    CONSTRAINT FK_GRADE_CODE FOREIGN KEY (GRADE_CODE)
    REFERENCES USER_GRADE(GRADE_CODE)
);

INSERT INTO USER_FOREIGNKEY VALUES(1, 'user01', 'pass01', '홍길동', 'M', '010-1111-2222', 'hong123@kh.or.kr', 10);
INSERT INTO USER_FOREIGNKEY VALUES(2, 'user02', 'pass02', '김길동', 'M', '010-4444-3333', 'kimdong@kh.or.kr', 10);        
INSERT INTO USER_FOREIGNKEY VALUES(3, 'user03', 'pass03', '고길동', 'F', '011-123-2222', 'go123@kh.or.kr', 10);        
INSERT INTO USER_FOREIGNKEY VALUES(4, 'user04', 'pass04', '황의조', 'F', '010-1234-5432', 'godgodgod@king.god', 20);        
INSERT INTO USER_FOREIGNKEY VALUES(5, 'user05', 'pass05', '손흥민', 'F', '015-123-4444', 'sonny@tot.en', 30);
        
        
SELECT * FROM USER_CONSTRAINTS
WHERE TABLE_NAME = 'USER_FOREIGNKEY';

-- 2. 실습
-- USER_FOREIGNKEY 테이블을 참조하여
-- 회원번호, 회원명, 이메일, 연락처, 회원 등급을
-- 조회 하시오.

SELECT
    USER_NO 회원번호,
    USER_NAME 회원명,
    EMAIL 이메일,
    PHONE 연락처,
    GRADE_NAME 회원등급
FROM USER_FOREIGNKEY
JOIN USER_GRADE USING(GRADE_CODE);


-- 데이터 삭제 옵션
-- ORA-02292: integrity constraint (EMPLOYEE.FK_GRADE_CODE) violated - child record found
DELETE FROM USER_GRADE 
WHERE GRADE_CODE = 10;

-- 참조하고 있는 원본 테이블의 컬럼 값이 삭제될 때
-- 참조한 값을 어떻게 처리할 것인지 설정하는 옵션
-- 일반적으로 참조하는 원본의 컬럼 내용을 삭제하고자 할 때
-- 외래키로 사용 중인 자식 컬럼에서 이미 해당 값을 
-- 사용중이라면 삭제를 할 수가 없다.
-- 따라서 삭제 옵션을 통해 부모 컬럼의 값을 삭제할 때
-- 행동할 자식 컬럼의 값을 정의할 수 있다.


-- 1. 부모 컬럼을 삭제할 때 자식 컬럼을 NULL로 변경하기.
-- ON DELETE SET NULL

-- 만약 테이블의 외래키가 제약조건으로 설정되어 있을 경우
-- 워놉ㄴ 테이블 함부로 삭제할수 없다.
-- 따라서 자식 테이블을 먼저 삭제하거나, 원본테이블과
-- 연결되어 있는 제약조건을 함께 삭제해야 한다.

-- 1-1.
DROP TABLE USER_FOREIGNKEY;
DROP TABLE USER_GRADE;

-- 1-2.
-- DROP TABLE USER_GRADE CASCADE CONSTRAINTS;


CREATE TABLE USER_GRADE(
    GRADE_CODE NUMBER PRIMARY KEY,
    GRADE_NAME VARCHAR2(30) NOT NULL
);

INSERT INTO USER_GRADE
VALUES(10, '일반회원');

INSERT INTO USER_GRADE
VALUES(20, '우수회원');

INSERT INTO USER_GRADE
VALUES(30, '특별회원');

SELECT * FROM USER_GRADE;

CREATE TABLE USER_FOREIGNKEY(
    USER_NO NUMBER PRIMARY KEY,
    USER_ID VARCHAR2(20),
    USER_PWD VARCHAR2(30),
    USER_NAME VARCHAR2(15),
    GENDER CHAR(1) CHECK(GENDER IN ('M','F')),
    PHONE VARCHAR2(13),
    EMAIL VARCHAR2(30),
    GRADE_CODE NUMBER,
    CONSTRAINT FK_GRADE_CODE FOREIGN KEY (GRADE_CODE)
    REFERENCES USER_GRADE(GRADE_CODE) ON DELETE SET NULL
);

INSERT INTO USER_FOREIGNKEY VALUES(1, 'user01', 'pass01', '홍길동', 'M', '010-1111-2222', 'hong123@kh.or.kr', 10);
INSERT INTO USER_FOREIGNKEY VALUES(2, 'user02', 'pass02', '김길동', 'M', '010-4444-3333', 'kimdong@kh.or.kr', 10);        
INSERT INTO USER_FOREIGNKEY VALUES(3, 'user03', 'pass03', '고길동', 'F', '011-123-2222', 'go123@kh.or.kr', 10);        
INSERT INTO USER_FOREIGNKEY VALUES(4, 'user04', 'pass04', '황의조', 'F', '010-1234-5432', 'godgodgod@king.god', 20);        
INSERT INTO USER_FOREIGNKEY VALUES(5, 'user05', 'pass05', '손흥민', 'F', '015-123-4444', 'sonny@tot.en', 30);


SELECT * FROM USER_FOREIGNKEY;

COMMIT;

DELETE FROM USER_GRADE
WHERE GRADE_CODE = 10;

ROLLBACK;

SELECT * FROM USER_FOREIGNKEY;
-- 2. 부모 컬럼을 삭제할 때 자식도 함께 삭제하기
-- ON DELETE_CASCADE

CREATE TABLE USER_FOREIGNKEY(
    USER_NO NUMBER PRIMARY KEY,
    USER_ID VARCHAR2(20),
    USER_PWD VARCHAR2(30),
    USER_NAME VARCHAR2(15),
    GENDER CHAR(1) CHECK(GENDER IN ('M','F')),
    PHONE VARCHAR2(13),
    EMAIL VARCHAR2(30),
    GRADE_CODE NUMBER,
    CONSTRAINT FK_GRADE_CODE FOREIGN KEY (GRADE_CODE)
    REFERENCES USER_GRADE(GRADE_CODE) ON DELETE CASCADE
);

INSERT INTO USER_FOREIGNKEY VALUES(1, 'user01', 'pass01', '홍길동', 'M', '010-1111-2222', 'hong123@kh.or.kr', 10);
INSERT INTO USER_FOREIGNKEY VALUES(2, 'user02', 'pass02', '김길동', 'M', '010-4444-3333', 'kimdong@kh.or.kr', 10);        
INSERT INTO USER_FOREIGNKEY VALUES(3, 'user03', 'pass03', '고길동', 'F', '011-123-2222', 'go123@kh.or.kr', 10);        
INSERT INTO USER_FOREIGNKEY VALUES(4, 'user04', 'pass04', '황의조', 'F', '010-1234-5432', 'godgodgod@king.god', 20);        
INSERT INTO USER_FOREIGNKEY VALUES(5, 'user05', 'pass05', '손흥민', 'F', '015-123-4444', 'sonny@tot.en', 30);


SELECT * FROM USER_FOREIGNKEY;

COMMIT;

DELETE FROM USER_GRADE
WHERE GRADE_CODE = 10;

ROLLBACK;

-- SUBQUERY를 활용해서 테이블 생성하기 --
-- 서브쿼리를 활용하여 테이블을 생성할 경우
-- 컬럼명, 데이터 타입, 값 복사 및 NOT NULL 제약 조건은
-- 복사가 가능하지만,다른 제약조건들은 복사되지 않는다.

SELECT * FROM
USER_CONSTRAINTS
WHERE TABLE_NAME = 'EMPLOYEE';


CREATE TABLE EMPLOYEE_COPY
AS SELECT * FROM EMPLOYEE;


SELECT * FROM EMPLOYEE_COPY;

SELECT * FROM
USER_CONSTRAINTS
WHERE TABLE_NAME = 'EMPLOYEE_COPY';

-- 테이블의 형식만 복사하기
-- 테이블의 값을 제외하고 형식만 복사할수도 있다.
CREATE TABLE EMPLOYEE_COPY2
AS SELECT * FROM EMPLOYEE
    WHERE 1=2;
    
SELECT * FROM EMPLOYEE_COPY2;

-- 서브쿼리를 활용하여 특정 컬럼들만 복사하기

CREATE TABLE EMPLOYEE_COPY3
AS SELECT 
    EMP_ID, EMP_NAME, SALARY 월급, DEPT_CODE "DEPT", JOB_CODE "JOB", HIRE_DATE 
    FROM EMPLOYEE;

-- DESC (DESCRIBE)의 약어
-- 해당 테이블의 컬럼과 컬럼의 자료형을
-- 확인하는 명령어
DESC EMPLOYEE_COPY3;

-- 제약조건을 테이블 생성 후에 추가하고자 할 때
-- ALTER DDL 구문을 사용한다.

-- [사용형식]
-- ALTER TABLE 테이블명 ADD PRIMARY KEY(컬럼명);
-- ALTER TABLE 테이블명 ADD FOREIGN KEY(컬럼명) REFERENCES 테이블명(컬럼명);
-- ALTER TABLE 테이블명 ADD UNIQUE(컬럼명);
-- ALTER TABLE 테이블명 ADD CHECK(조건식);
-- ALTER TABLE 테이블명 MODIFY 컬럼명 NOT NULL;

ALTER TABLE EMPLOYEE_COPY ADD PRIMARY KEY(EMP_ID);

SELECT * FROM EMPLOYEE_COPY;
DESC EMPLOYEE_COPY3;
SELECT * FROM USER_CONSTRAINTS
WHERE TABLE_NAME = 'EMPLOYEE_COPY';

SELECT * FROM EMPLOYEE_COPY3;

-- 각 컬럼에 값을 기록하지 않을 경우 기본값 설정하기 --
CREATE TABLE DEFAULT_TABLE(
    DATA_COL VARCHAR2(20) DEFAULT '없음',
    DATA_COL2 DATE DEFAULT SYSDATE
);

INSERT INTO DEFAULT_TABLE
VALUES (DEFAULT, DEFAULT);

SELECT * FROM DEFAULT_TABLE;

INSERT INTO DEFAULT_TABLE
VALUES (NULL, NULL);


-- 3. 실습
-- EMPLOYEE테이블의 DEPT_CODE에 외래키 제약조건 추가
-- 참조 테이블은 DEPARTMENT, 참조 컬럼은 DEPARTMENT의
ALTER TABLE  EMPLOYEE ADD FOREIGN KEY(DEPT_CODE) REFERENCES DEPARTMENT(DEPT_ID);

-- DEPARTMENT테이블의 LOCATION_ID에 외래키 제약조건 추가
-- 참조 테이블은 LOCATION, 참조 컬럼은 LOCATION의 기본키
ALTER TABLE DEPARTMENT ADD FOREIGN KEY(LOCATION_ID) REFERENCES LOCATION;

-- LOCATION테이블의 NATIONAL_CODE컬럼에 외래키 제약조건 추가
-- 참조 테이블은 NATIONAL 테이블, 참조컬럼은 NATIONAL테이블의 기본키
ALTER TABLE LOCATION ADD FOREIGN KEY(NATIONAL_CODE) REFERENCES NATIONAL;

-- EMPLOYEE테이블의 JOB_CODE에 외래키 제약조건 추가
-- 참조 테이블은 JOB테이블, 참조 컬럼은 JOB테이블의 기본키
ALTER TABLE EMPLOYEE ADD FOREIGN KEY(JOB_CODE) REFERENCES JOB;

-- EMPLOYEE테이블의 SAL_LEVEL에 외래키 제약조건 추가
-- 참조 테이블은 SAL_GRADE테이블, 참조 컬럼은 SAL_GRADE테이블의 기본키
ALTER TABLE EMPLOYEE ADD FOREIGN KEY(SAL_LEVEL) REFERENCES SAL_GRADE;


-- [사용형식]
-- ALTER TABLE 테이블명 ADD PRIMARY KEY(컬럼명);
-- ALTER TABLE 테이블명 ADD FOREIGN KEY(컬럼명) REFERENCES 테이블명(컬럼명);
-- ALTER TABLE 테이블명 ADD UNIQUE(컬럼명);
-- ALTER TABLE 테이블명 ADD CHECK(조건식);
-- ALTER TABLE 테이블명 MODIFY 컬럼명 NOT NULL;

-- EMPLOYEE 테이블의 ENT_YN 컬럼에 CHECK제약조건 추가 ('Y' 혹은 'N')
-- 단, 대소문자 구분함
ALTER TABLE EMPLOYEE ADD CHECK(ENT_YN IN ('Y', 'N'));

-- EMPLOYEE 테이블의 SALARY 컬럼에 CHECK제약조건 추가 (양수)
ALTER TABLE EMPLOYEE ADD CHECK(SALARY >= 0);

-- EMPLOYEE 테이블의 EMP_NO 컬럼에 UNIQUE 제약조건 추가
ALTER TABLE EMPLOYEE ADD UNIQUE(EMP_NO);








