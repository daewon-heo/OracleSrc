/*
    DAY4_20180823_����
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


-- 1. �ǽ�
-- EMPLOYEE ���̺���
-- ���� �� �׷��� ����
-- ���� �ڵ�, �޿� �հ�, �޿� ���, �ο����� ��ȸ �Ͻÿ�.
SELECT
    JOB_CODE as  "�����ڵ�",
    SUM(SALARY) as "�޿��հ�",
    TRUNC(AVG(SALARY)) as "�޿����",
    COUNT(*) as "�ο���"
FROM EMPLOYEE
GROUP BY JOB_CODE
HAVING COUNT(*) > 3
ORDER BY �ο��� DESC;

-- ROLLUP & CUBE
-- �׷� �� ���踦 �����ϴ� �Լ�
-- Ư�� �׷쿡 ���� ���� �� �ڵ� �� ���踦 �������ָ�
-- GROUP BY ���������� ����� �� �ִ�.

-- �Ϲ� ���� --
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

-- �׷� �켱������ �����ص� ����� �����ϴ�
SELECT DEPT_CODE, JOB_CODE, SUM(SALARY)
FROM EMPLOYEE
GROUP BY CUBE(JOB_CODE, DEPT_CODE)
ORDER BY 1 NULLS FIRST, 2 NULLS LAST;

-- GROUPING 
-- �ڵ� ���� ���θ� Ȯ���ϴ� �Լ�
-- GROUPING(�÷���) : 
-- �ش� �÷��� �ڵ� ����� ������ Ȯ��
-- 1 : �ڵ����� ����Ǿ� �߰��� �÷�
-- 0 : ���� ������ ��� (�ڵ� ������� ���� ���)

SELECT 
    DEPT_CODE, JOB_CODE, SUM(SALARY),
    GROUPING(DEPT_CODE) "�μ� �ڵ����� ����",
    GROUPING(JOB_CODE) "���� �ڵ����� ����"
FROM EMPLOYEE
GROUP BY CUBE(DEPT_CODE, JOB_CODE)
ORDER BY 1,2;

--------------------

SELECT DEPT_CODE, JOB_CODE, SUM(SALARY),
    CASE WHEN GROUPING(DEPT_CODE) = 0
            AND GROUPING(JOB_CODE) = 1
            THEN '�μ� �� �հ�'
          WHEN GROUPING(DEPT_CODE) = 1
            AND GROUPING(JOB_CODE) = 0
            THEN '���� �� �հ�'
          WHEN GROUPING(DEPT_CODE) = 1
            AND GROUPING(JOB_CODE) = 1
            THEN '��ü �� �հ�'
            ELSE '�׷캰 �հ�'
    END "�հ� ����"
FROM EMPLOYEE
GROUP BY CUBE(DEPT_CODE, JOB_CODE)
ORDER BY 1, 2, 4;

--------------------------
/*
DECODE �Լ��� GROUPING �Լ��� Ȱ���Ͽ�
������ ���� ����� ����ϴ� SQL�� ����ÿ�.
(��, �μ��� NULL�� ��� DEPT NONE���� ����Ѵ�.)
*/
SELECT 
    DECODE(GROUPING(DEPT_CODE), 1, DECODE(GROUPING(JOB_CODE),  1,'���հ�',  0,'���޺��հ�'), 
                                 0, NVL(DEPT_CODE,'DEPTNONE')) 
                                 AS "�μ�",
    DECODE(GROUPING(JOB_CODE),  1, DECODE(GROUPING(DEPT_CODE), 1, '-----',  0,'�μ����հ�'), 
                                 0, JOB_CODE, '------') 
                                 AS "����",
    SUM(SALARY)
FROM EMPLOYEE
GROUP BY CUBE(DEPT_CODE, JOB_CODE)
ORDER BY 1, 2;



SELECT 
    DECODE(GROUPING(DEPT_CODE), 1 , DECODE( GROUPING(JOB_CODE), 1,'���հ�','���� �հ�'), NVL(DEPT_CODE,'Dept None')) "�μ�",
    DECODE(GROUPING(JOB_CODE), 1 , DECODE(GROUPING(DEPT_CODE), 1,'-----', '�μ� �հ�'), JOB_CODE) "����",
    SUM(SALARY),
    GROUPING(DEPT_CODE),
    GROUPING(JOB_CODE)
FROM EMPLOYEE
GROUP BY CUBE(DEPT_CODE, JOB_CODE)
ORDER BY 1,2;


-- SET OPERATION --
-- �� �� �̻��� SELECT �� ���(RESULT SET)�� 
-- ��ġ�ų�, �ߺ��� ������ ���ϰų� �ϴ�
-- �������ν��� �� 2�� ����� �����س��� ��ɾ�

-- ������ --
-- UNION : �� �� �̻��� RESULT SET�� ���� ���ϴ� ��ɾ�
--         �� �� �̻��� ����� ���ļ� �����ش�
--         (��, �ߺ��Ǵ� ����� ���� ��� �Ѱ��� �ุ �����ش�.)

-- UNION ALL : �� �� �̻��� ����� ���ļ� �����ش�.
--             �ߺ��Ǵ� ����� �ִٸ� ��� ���� �����ν� �ߺ��� �������� �ʴ´�.

-- ������ --
-- INTERSECT : �� �� �̻��� ����� �ߺ��Ǵ� ����� ����Ѵ�.

-- ������ --
-- MINUS : A �� B�� ����� �������� 
--         �켱 �Ǵ� A �� B �� ��ġ�� �ʴ� ����� ����ϴ� ��ɾ�.

-- ** � SET ��ɾ ����ϴ���, �� ����� ����� �ݵ�� ���ƾ� �Ѵ�.
-- SELECT �� ����� A�� SELECT �� ����� B�� ��ĥ���
-- A�� B�� COLUMN ������ COLUMN�� �ڷ����� �ݵ�� ���ƾ� �Ѵ�.


-- UNION(������) --
-- �� �����(Result Set)�� ���� ���ϴ� ���� ��ɾ�

SELECT EMP_ID,EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE DEPT_CODE = 'D5'

UNION

SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY > 3000000;

-- UNION ALL(������) --
-- �� �� �̻��� �����(Result Set)�� �ϳ��� ��ġ�� ���� ������
-- ��, �켱 ����Ǵ� ����� �������� �����͸� ��ġ��
-- �ߺ��� �߻��� ��쿡�� �ߺ��� �״�� �����Ͽ� ����Ѵ�.
SELECT EMP_ID,EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE DEPT_CODE = 'D5'

UNION ALL

SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY > 3000000;

-- ROLLUP�� CUBE ó�� ��ȸ�ϴ� ��� -- 
SELECT DEPT_CODE, JOB_CODE, SUM(SALARY)
FROM EMPLOYEE
GROUP BY ROLLUP(DEPT_CODE, JOB_CODE)
--ORDER BY 1, 2;

UNION

SELECT '', JOB_CODE, SUM(SALARY)
FROM EMPLOYEE
GROUP BY ROLLUP(JOB_CODE, DEPT_CODE)
ORDER BY 1,2;


-- INTERSECT (������)
-- �� �� �̻��� ������� ���Ͽ�
-- �ߺ��Ǵ� ���� �����ϴ� ���� ������

-- D5�� �μ� �������� ������
-- �޿��� 300���� �̻��� �������� ������ ���Ͽ�,
-- �� ����� ���� ���� ����ϱ�

SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE DEPT_CODE = 'D5'

INTERSECT

SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY >= 3000000;


-- MINUS(������) --
-- �� �� �̻��� �����(Result Set)��
-- ���� ó�� ��� �¾ ������ ��ġ�ϴ� �������
-- �� �������� �����ϴ� �����ڴ�

SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE DEPT_CODE = 'D5'

MINUS

SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY >= 3000000
ORDER BY 2;


-- GROUPING SET(�׷� ���� ������)
-- �׷� ���� ó���� �������� ������� �ϳ��� ��ĥ �� ����Ѵ�.

SELECT DEPT_CODE, JOB_CODE, MANAGER_ID, TRUNC(AVG(SALARY))
FROM EMPLOYEE
GROUP BY GROUPING SETS(
        (DEPT_CODE, JOB_CODE, MANAGER_ID),
        (DEPT_CODE, MANAGER_ID),
        (JOB_CODE, MANAGER_ID)
);

---------------------------------------------------
-- JOIN --
-- �� �� �̻��� ���̺��� �ϳ��� ��ĥ �� ����ϴ� ��ɾ�

-- ���࿡ 'J6'��� ������ ���� ������� �ٹ��ϴ� �μ��� �̸��� �˰� �ʹٸ�..?
SELECT EMP_NAME, JOB_CODE, DEPT_CODE
FROM EMPLOYEE
WHERE JOB_CODE = 'J6';

SELECT * FROM DEPARTMENT;


SELECT DEPT_TITLE
FROM DEPARTMENT
WHERE DEPT_ID IN ('D1', 'D8');

--- ����Ŭ ���� ���� ---
-- FROM ������ ',' ��ȣ�� ���� ��ġ�� �� ���̺���� 
-- �����ϰ� WHERE ������ ���� ��ĥ ���̺� ���� �������� �����Ͽ�
-- �ϳ��� ���̺� �������� �����Ѵ�.

SELECT EMP_ID, EMP_NAME, DEPT_CODE, DEPT_TITLE
FROM EMPLOYEE, DEPARTMENT
WHERE DEPT_CODE = DEPT_ID;

SELECT * FROM EMPLOYEE;
SELECT * FROM JOB;

SELECT EMP_ID , EMP_NAME, E.JOB_CODE, J.JOB_NAME
FROM EMPLOYEE E, JOB J
WHERE E.JOB_CODE = J.JOB_CODE;


--- ANSI ǥ�� ���� ---
-- �����ϰ��� �ϴ� ���̺��� FROM ���� ������
-- JOIN ���̺�� ON() | USING() ������ ����Ͽ�
-- �ΰ� �̻��� ���̺��� ��ģ��.

-- �ΰ��� ���̺��� �����ϴ� �÷��̸��� �ٸ����
SELECT EMP_ID, EMP_NAME, DEPT_CODE, DEPT_TITLE
FROM EMPLOYEE 
JOIN DEPARTMENT 
-- ON(EMPLOYEE.DEPT_CODE = DEPARTMENT.DEPT_ID);
ON(DEPT_CODE = DEPT_ID);

-- �� ���� ���̺��� �����ϴ� �÷����� ���� ���
SELECT EMP_ID, EMP_NAME, JOB_CODE, JOB_NAME
FROM EMPLOYEE
JOIN JOB USING(JOB_CODE);

-- 2. �ǽ�
-- EMPLOYEE ���̺��� ���� �޿�������
-- SAL_GRADE�� �޿� ����� ���ļ�
-- ���, �����, �޿����, ��ޱ��� �ּ� �޿�, �ִ� �޿�
SELECT * FROM SAL_GRADE;
SELECT * FROM EMPLOYEE; -- SAL_LEVEL

-- ����Ŭ
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


-- 3. �ǽ�
-- DEPARTMENT ���̺��� ��ġ����(LOACTION)��
-- LOCATION ���̺��� �����Ͽ�
-- �� �μ� �� �ٹ��� ��ġ�� ��ȸ�Ͻÿ�
-- �μ��ڵ�, �μ���, �ٹ��� �ڵ�, �ٹ��� ��ġ

-- ����Ŭ
SELECT DEPT_ID, DEPT_TITLE, LOCATION_ID, LOCAL_CODE, LOCAL_NAME
FROM DEPARTMENT, LOCATION
WHERE LOCAL_CODE = LOCATION_ID;


-- ANSI
SELECT D.DEPT_ID, D.DEPT_TITLE, D.LOCATION_ID, L.LOCAL_NAME
FROM DEPARTMENT D
JOIN LOCATION L  ON L.LOCAL_CODE = D.LOCATION_ID;


-- INNER JOIN �� OUTER JOIN
-- �� �� �̻��� ���̺��� �ϳ��� ��ĥ ��,
-- INNER JOIN �� �� ��� ��ġ�ϴ� �����͸� �����ϰ�,
-- OUTER JOIN�� �� �� �ϳ���, Ȥ�� �� ��ΰ� ���� ��� ���� ������ �� ����Ѵ�.

-- INNER JOIN
SELECT DEPT_CODE, EMP_NAME
FROM EMPLOYEE
JOIN DEPARTMENT ON(DEPT_CODE = DEPT_ID);

-- LEFT OUTER JOIN : �� ���̺� �� ���� ���̺��� ������
--                   ��� �����ϰ��� �� �� ����Ѵ�.
-- RIGHT OUTER JOIN : �� ���̺� �� JOIN�� ����� ���̺���
--                    ���� ��� ������ ������ �� ����Ѵ�.
-- FULL OUTER JOIN : �� ���̺��� ���� ������ ��� ��������
--                   �����Ͽ� ��ĥ �� ����Ѵ�.

-- LEFT JOIN --

-- ANSI ǥ�� ���� --
SELECT DEPT_CODE, EMP_NAME
FROM EMPLOYEE
LEFT JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID);

-- ORACLE ���� --
SELECT DEPT_CODE, EMP_NAME
FROM EMPLOYEE, DEPARTMENT
WHERE DEPT_CODE = DEPT_ID(+);

-- RIGHT JOIN --

SELECT * FROM DEPARTMENT;
SELECT DISTINCT DEPT_CODE
FROM EMPLOYEE;

-- ANSI ǥ�� ���� --
SELECT DEPT_CODE, DEPT_ID, EMP_NAME
FROM EMPLOYEE
RIGHT JOIN DEPARTMENT ON(DEPT_CODE = DEPT_ID);

-- ORACLE ���� --
SELECT DEPT_ID, EMP_NAME
FROM EMPLOYEE, DEPARTMENT
WHERE DEPT_CODE(+) = DEPT_ID;


-- FULL OUTER JOIN --

-- ANSI ���� --
SELECT DEPT_CODE, DEPT_ID, EMP_NAME
FROM EMPLOYEE
FULL JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID);


-- ORACLE ���� --
-- ORCAL�� FULL OUTER JOIN�� 
-- ������� ���Ѵ�
SELECT DEPT_CODE, DEPT_ID, EMP_NAME
FROM EMPLOYEE, DEPARTMENT
WHERE DEPT_CODE(+) = DEPT_ID(+);

-- CROSS JOIN
-- �⺻������ JOIN �̶�� �ϸ�
-- �� ���� ���̺� ��� �ϳ����� ��ġ�ϴ� �÷���
-- ������ JOIN�� �����ϴµ�, �̸� EQUAL JOIN(EQ JOIN)�̶�� �Ѵ�.
-- ���� ���� ���� ���� ������ �ʴ� ���̺��� ��ȸ�Ϸ��� �� ���
-- ����ϴ� JOIN ����� CROSS JOIN �̴�.

SELECT EMP_NAME, NATIONAL_CODE
FROM EMPLOYEE
CROSS JOIN NATIONAL;


-- CROSS JOIN�� ����� ���, JOIN�� �����
-- ī�׽þ� ���� ���·� ����Ǵµ�,
-- ī�׽þ� ���̶�, �� �÷��� �����
-- ����� �� ���� ���·� ��µǴ� ���� �̾߱� �Ѵ�.
-- ���� CROSS JOIN�̶�, ���� ����� �����ϴ� ���ι��
-- �̸�, ��¿ �� ���� ����� ��� �̷��� ������ �����
-- ����Ǵ� ���� �ݵ�� ����ؾ� �Ѵ�.


-- NON EQ JOIN
-- ������ �÷� �� ��ü�� �ƴ�
-- Ư�� ���� ���� �����ϴ� �������� JOIN�� ������ ���
-- ����ϴ� JOIN ���

-- ON() �ȿ� ���� ������ �÷��� �Ӹ� �ƴ϶�
-- �����̳� ����, Ȥ�� AND | OR ���� ���ǽ�, ǥ������
-- �����ϴ�.
SELECT EMP_NAME, DEPT_CODE, SALARY, E.SAL_LEVEL
FROM EMPLOYEE E
JOIN SAL_GRADE S ON (SALARY BETWEEN MIN_SAL AND MAX_SAL);

-- SELF JOIN
-- �ڱ� �ڽ��� ������ ������� ���
-- �� ���̺��� ���� �� �� �񱳰� �ʿ��� ��������
-- ����Ͽ� �����ϴ� ���

SELECT EMP_ID, EMP_NAME, MANAGER_ID
FROM EMPLOYEE;

-- ������ ������ ������ ����ϴ� �Ŵ����� ������ 
-- ��ȸ�ϴ� ����

-- ORACLE ���� --
SELECT 
    E.EMP_ID, 
    E.EMP_NAME, 
    E.MANAGER_ID, 
    M.EMP_NAME as "�Ŵ���"
FROM EMPLOYEE E, EMPLOYEE M 
WHERE E.MANAGER_ID = M.EMP_ID;


-- ANSI ���� --
SELECT 
    E.EMP_ID, 
    E.EMP_NAME, 
    E.MANAGER_ID, 
    M.EMP_NAME as "�Ŵ���"
FROM EMPLOYEE E
JOIN EMPLOYEE M ON (E.MANAGER_ID = M.EMP_ID);

-- ���� JOIN
-- ���� ���� ���̺��� JOIN �ϴ� ���� ���� �����̶�� �Ѵ�.
-- �Ϲ� ���ΰ� ���� ������ ������, ���� �� ����� ��������
-- ���� ������ �����ϱ� ������ JOIN ������
-- ������ �ݵ�� �����ؾ� �Ѵ�.


-- ORACLE ���� --
SELECT 
    EMP_ID, EMP_NAME, DEPT_TITLE, LOCAL_NAME
FROM 
    EMPLOYEE, DEPARTMENT, LOCATION
WHERE 
    DEPT_CODE = DEPT_ID
    AND LOCATION_ID = LOCAL_CODE;

-- ANSI ���� --
SELECT 
    EMP_ID, EMP_NAME, DEPT_TITLE, LOCAL_NAME
FROM 
    EMPLOYEE
JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
JOIN LOCATION ON (LOCATION_ID = LOCAL_CODE);

SELECT * FROM DEPARTMENT; 


-- 4. ������ �븮�̸鼭 �ƽþ� ������ �ٹ��ϴ� ���� ��ȸ
-- ���, �����, ���޸�, �μ���, �ٹ�������, �޿��� ��ȸ �Ͻÿ�

-- ORACLE --
SELECT 
    E.EMP_ID, E.EMP_NAME, J.JOB_NAME, D.DEPT_TITLE, L.LOCAL_NAME, E.SALARY
FROM EMPLOYEE E, JOB J, DEPARTMENT D, LOCATION L
WHERE 
    J.JOB_CODE = E.JOB_CODE
    AND DEPT_CODE = DEPT_ID
    AND LOCATION_ID = LOCAL_CODE
    AND J.JOB_NAME='�븮'
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
    J.JOB_NAME='�븮'
    --AND L.LOCAL_NAME LIKE 'ASIA%';
    --AND L.LOCAL_NAME IN ('ASIA1', 'ASIA2', 'ASIS3');
    AND SUBSTR(L.LOCAL_NAME, 1,4) = 'ASIA';

SELECT * FROM LOCATION;



--JOIN ��������
--
--1. 2020�� 12�� 25���� ���� �������� ��ȸ�Ͻÿ�.
SELECT 
    TO_CHAR(TO_DATE('20201225'), 'day') AS "2020�� 12�� 25��"
FROM 
    DUAL;

--2. �ֹι�ȣ�� 70��� ���̸鼭 ������ �����̰�, ���� ������ �������� 
--�����, �ֹι�ȣ, �μ���, ���޸��� ��ȸ�Ͻÿ�.
SELECT 
    EMP_NAME AS "�����",
    EMP_NO AS "�ֹι�ȣ",
    DEPT_TITLE AS "�μ���",
    JOB_NAME AS "���޸�"
FROM 
    EMPLOYEE
JOIN JOB USING(JOB_CODE)
JOIN DEPARTMENT ON DEPT_ID = DEPT_CODE
WHERE
    SUBSTR(EMP_NO, 1, 1)='7'
    AND SUBSTR(EMP_NO, 8, 1)='2'
    AND EMP_NAME LIKE '��%';
    
SELECT * FROM DEPARTMENT;
SELECT * FROM JOB;
SELECT * FROM EMPLOYEE;


--3. ���� ���̰� ���� ������ ���, �����, ����, �μ���, ���޸��� ��ȸ�Ͻÿ�.
SELECT 
    EMP_ID AS "���",
    EMP_NAME AS "�����",
    TRUNC(MONTHS_BETWEEN(SYSDATE,TO_DATE(SUBSTR(EMP_NO,1,6)))/12) AS "����",
    DEPT_TITLE AS "�μ���",
    JOB_NAME AS "���޸�"
FROM
EMPLOYEE
JOIN DEPARTMENT ON (DEPT_ID = DEPT_CODE)
JOIN JOB USING(JOB_CODE)
WHERE
    EMP_ID NOT IN('201','214') AND
    TO_DATE(SUBSTR(EMP_NO,1,6)) = (
SELECT 
    MAX(TO_DATE(SUBSTR(EMP_NO,1,6)))
FROM 
    EMPLOYEE
WHERE 
    EMP_ID NOT IN('201','214')
    );


--4. �̸��� '��'�ڰ� ���� �������� ���, �����, �μ����� ��ȸ�Ͻÿ�.
SELECT 
    EMP_ID,
    EMP_NAME,
    DEPT_TITLE
FROM
    EMPLOYEE
JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID
WHERE 
    EMP_NAME LIKE '%��%';    


--5. �ؿܿ������� �ٹ��ϴ� �����, ���޸�, �μ��ڵ�, �μ����� ��ȸ�Ͻÿ�.
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
    DEPT_TITLE LIKE '�ؿܿ���%';

--6. ���ʽ�����Ʈ�� �޴� �������� �����, ���ʽ�����Ʈ, �μ���, �ٹ��������� ��ȸ�Ͻÿ�.
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

--7. �μ��ڵ尡 D2�� �������� �����, ���޸�, �μ���, �ٹ��������� ��ȸ�Ͻÿ�.
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


--8. ������ �ּұ޿�(MIN_SAL)���� ���� �޴� ��������
--�����, ���޸�, �޿�, ������ ��ȸ�Ͻÿ�.
--������ ���ʽ�����Ʈ�� �����Ͻÿ�.

SELECT
    EMP_NAME "�����",
    JOB_NAME "���޸�",
    SALARY "�޿�",
    SALARY*12*(1+NVL(BONUS,0)) "����"
FROM 
    EMPLOYEE
JOIN JOB USING (JOB_CODE)
JOIN SAL_GRADE USING (SAL_LEVEL)
WHERE SALARY > MIN_SAL;

--9. �ѱ�(KO)�� �Ϻ�(JP)�� �ٹ��ϴ� �������� 
--�����, �μ���, ������, �������� ��ȸ�Ͻÿ�.
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
    NATIONAL_NAME IN ('�ѱ�', '�߱�');


--10. ���� �μ��� �ٹ��ϴ� �������� �����, �μ��ڵ�, �����̸��� ��ȸ�Ͻÿ�.
--self join ���

-- ���� �𸣰���...
SELECT
    EMP_NAME,
    DEPT_CODE
FROM
    EMPLOYEE E;
JOIN EMPLOYEE M ON E.DEPT_CODE = M.DEPT_CODE;

SELECT * FROM EMPLOYEE;


--11. ���ʽ�����Ʈ�� ���� ������ �߿��� �����ڵ尡 J4�� J7�� �������� �����, ���޸�, �޿��� ��ȸ�Ͻÿ�.
--��, join�� IN ����� ��
SELECT 
    EMP_NAME,
    JOB_NAME,
    SALARY
FROM
    EMPLOYEE
JOIN JOB USING(JOB_CODE)
WHERE BONUS IS NULL
AND JOB_CODE IN ('J4','J7');

--12. �������� ������ ����� ������ ���� ��ȸ�Ͻÿ�.
SELECT
    COUNT(*)-COUNT(ENT_DATE) AS "�������� ����",
    COUNT(ENT_DATE) AS "����� ����" 
FROM EMPLOYEE;










