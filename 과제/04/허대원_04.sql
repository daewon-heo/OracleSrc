--16. 환경조경학과 전공과목들의 과목 별 평점을 파악핛 수 있는 SQL 문을 작성하시오.
SELECT 
    TC.CLASS_NO,
    TC.CLASS_NAME,
    LPAD(AVG(POINT),10) AS "AVG(POINT)"
FROM TB_GRADE TG
JOIN TB_CLASS TC ON TG.CLASS_NO = TC.CLASS_NO
JOIN TB_DEPARTMENT TD ON TC.DEPARTMENT_NO = TD.DEPARTMENT_NO
WHERE TD.DEPARTMENT_NAME = '환경조경학과'
AND TC.CLASS_TYPE LIKE '전공%'
GROUP BY TC.CLASS_NO, TC.CLASS_NAME;

--17. 춘 기술대학교에 다니고 있는 최경희 학생과 같은 과 학생들의 이름과 주소를 출력하는
--SQL 문을 작성하시오.
SELECT
    STUDENT_NAME,
    STUDENT_ADDRESS
FROM TB_STUDENT
WHERE DEPARTMENT_NO = (SELECT DEPARTMENT_NO FROM TB_STUDENT WHERE STUDENT_NAME = '최경희');


--18. 국어국문학과에서 총 평점이 가장 높은 학생의 이름과 학번을 표시하는 SQL 문을
--작성하시오.
SELECT
    STUDENT_NO, 
    STUDENT_NAME
FROM
(
SELECT 
    AVG(POINT)  POINT, 
    TG.STUDENT_NO, 
    TS.STUDENT_NAME
FROM TB_GRADE TG
JOIN TB_STUDENT TS ON TS.STUDENT_NO = TG.STUDENT_NO
JOIN TB_DEPARTMENT TD ON TS.DEPARTMENT_NO = TD.DEPARTMENT_NO
WHERE TD.DEPARTMENT_NAME = '국어국문학과'
GROUP BY (TG.STUDENT_NO, TS.STUDENT_NAME)
ORDER BY 1 DESC
) WHERE ROWNUM = 1;


--19. 춘 기술대학교의 "환경조경학과"가 속한 같은 계열 학과들의 학과 별
--전공과목 평점을
--파악하기 위한 적절한 SQL 문을 찾아내시오. 단, 출력헤더는 "계열 학과명",
--"전공평점"으로 표시되도록 하고, 평점은 소수점 한 자리까지만 반올림하여 표시되도록
--한다.
SELECT 
    TD.DEPARTMENT_NAME "계열 학과명",
    ROUND(AVG(TG.POINT),1) "전공평점"
FROM TB_DEPARTMENT TD
JOIN TB_STUDENT TS ON TS.DEPARTMENT_NO = TD.DEPARTMENT_NO
JOIN TB_GRADE TG ON TG.STUDENT_NO = TS.STUDENT_NO
WHERE TD.CATEGORY = (   
                                    SELECT 
                                        CATEGORY 
                                    FROM TB_DEPARTMENT
                                    WHERE DEPARTMENT_NAME = '환경조경학과'
                                    )
GROUP BY TD.DEPARTMENT_NAME
ORDER BY 1;


--4. 현 학과들의 정원을 10% 증가시키게 되었다. 이에 사용할 SQL 문을 작성하시오. (단,
--반올림을 사용하여 소수점 자릿수는 생기지 않도록 한다)

UPDATE TB_DEPARTMENT SET CAPACITY = ROUND(CAPACITY,0);

SELECT 
    *
FROM TB_DEPARTMENT;


--5. 학번 A413042 인 박건우 학생의 주소가 "서울시 종로구 숭인동 181-21 "로 변경되었다고
--한다. 주소지를 정정하기 위해 사용할 SQL 문을 작성하시오.
UPDATE TB_STUDENT SET STUDENT_ADDRESS = '서울시 종로구 숭인동 181-21'
WHERE STUDENT_NO = 'A413042';

SELECT 
    * 
FROM TB_STUDENT
WHERE STUDENT_NO = 'A413042';

--6. 주민등록번호 보호법에 따라 학생정보 테이블에서 주민번호 뒷자리를 저장하지 않기로
--결정하였다. 이 내용을 반영한 적절한 SQL 문장을 작성하시오.
--(예. 830530-2124663 ==> 830530 )
UPDATE TB_STUDENT SET STUDENT_SSN = SUBSTR(STUDENT_SSN,1,6);

SELECT * FROM TB_STUDENT; 

--7. 의학과 김명훈 학생은 2005 년 1 학기에 자신이 수강한 '피부생리학' 점수가
--잘못되었다는 것을 발견하고는 정정을 요청하였다. 담당 교수의 확인 받은 결과 해당
--과목의 학점을 3.5 로 변경키로 결정되었다. 적절한 SQL 문을 작성하시오.
SELECT * FROM  TB_CLASS;
UPDATE TB_GRADE SET POINT = 3.5
WHERE TERM_NO = '200501'
    AND STUDENT_NO = (
                                        SELECT 
                                            TG.STUDENT_NO "STUDENT_NO"
                                        FROM TB_STUDENT TS
                                        JOIN TB_DEPARTMENT TD ON TD.DEPARTMENT_NO = TS.DEPARTMENT_NO
                                        JOIN TB_GRADE TG ON TS.STUDENT_NO = TG.STUDENT_NO
                                        JOIN TB_CLASS TC ON TG.CLASS_NO = TC.CLASS_NO
                                        WHERE STUDENT_NAME = '김명훈'
                                        AND TD.DEPARTMENT_NAME = '의학과'
                                        AND CLASS_NAME = '피부생리학'
                                    );

--8. 성적 테이블(TB_GRADE) 에서 휴학생들의 성적항목을 제거하시오.
UPDATE TB_GRADE SET POINT = NULL
WHERE STUDENT_NO IN (
                                            SELECT STUDENT_NO FROM TB_STUDENT
                                            WHERE ABSENCE_YN = 'Y'
                                        );







