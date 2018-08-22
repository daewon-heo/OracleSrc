-- day3

-- ���� ������ �Լ�

-- ABS() : �־��� �÷����̳� ���� �����͸� ���밪���� �����ϴ� �Լ�
SELECT ABS(10), ABS(-10)
FROM DUAL;

-- MOD(�÷��� | ���ڵ�����, ��������) : �־��� �÷��̳� ���� ���� �������� ��ȯ
SELECT MOD(10, 3), MOD(10, 2), MOD(10,5)
FROM DUAL;

-- 1. �ǽ�
-- EMPLOYEE ���̺��� �Ի��� ����� Ȧ�� ���� ��������
-- ���, �����, �Ի����� ��ȸ�Ͻÿ�
SELECT EMP_ID, EMP_NAME , HIRE_DATE, TO_CHAR(HIRE_DATE, 'MM')
FROM EMPLOYEE
WHERE MOD(EXTRACT(MONTH FROM HIRE_DATE), 2) = 1;

-- ǥ���� : �÷��� | ���ڵ����� | ���� ������
-- ROUND(ǥ����) : ������ �ڸ����� �°� �ݿø��ϴ� �Լ�
SELECT ROUND(123.456, 0),
        ROUND(123.456, 1),  -- �Ҽ��� ��°�ڸ����� �ݿø��� ����
        ROUND(123.456, 2),  -- �Ҽ��� ��°�ڸ����� �ݿø��� ����
        ROUND(123.456, -2),  -- ������ ��� 10�� �������� ���� 10�� �ڸ��ݿø�
        ROUND(123.456, -1)  -- ������ ��� 10�� �������� ���� 10�� �ڸ��ݿø�
FROM DUAL;

-- CEIL(ǥ����) : �Ҽ��� ù°�ڸ����� �ø��ϴ� �Լ�
SELECT CEIL(123.456) FROM DUAL;

-- FLOOR(ǥ����) : �Ҽ��� ���� �ڸ��� �����ϴ� �Լ�
SELECT FLOOR(123.456) FROM DUAL;

-- TRUNC(ǥ����, �ڸ���) : ������ ��ġ���� ����(����)�ϴ� �Լ�
SELECT TRUNC(123.456, 0),
        TRUNC(123.456, 1),
        TRUNC(123.456, 2),
        TRUNC(123.456, -2),
        TRUNC(123.456, -1)
FROM DUAL;

-----------------------------

-- ��¥ ������ �Լ�
-- SYSTADET, MOTHS_BETWEEN, ADD_MONTH
-- NEXT_DAY, LAST_DAY, EXTRACT

-- ���� ��¥�� �ҷ����� �Լ�
-- SYSDATE : ���� ��¥�� �ҷ����� �Լ�
-- SYSTIMESTAMP : ���� ��¥�� �ð��� ��� �������� �Լ�
SELECT SYSDATE FROM DUAL;

SELECT SYSDATE, SYSTIMESTAMP FROM DUAL;

-- MONTH_BETWEEN(��¥1, ��¥2) : 
-- �� ��¥ ������ ���� ���� ����ϴ� �Լ�
SELECT EMP_NAME,
        HIRE_DATE,
        TRUNC(MONTHS_BETWEEN(SYSDATE, HIRE_DATE))
FROM EMPLOYEE;

-- ADD MONTHS(Ư�� ��¥, ������ ���� ��)
-- ������ ���� ���� ��¥�� ����Ͽ� ��ȯ�ϴ� �Լ�
SELECT EMP_NAME,
        HIRE_DATE,
        ADD_MONTHS(HIRE_DATE, 6)
FROM EMPLOYEE;

-- NEXT_DAY(��¥, ���ϸ�) : ���� ����� ������ ����Ͽ� ��ȯ�ϴ� �Լ�

SELECT NEXT_DAY(SYSDATE, '�����') FROM DUAL;
SELECT NEXT_DAY(SYSDATE, '��') FROM DUAL;

-- ������ ���ڷ� ������ ���� �ִ� 1:�Ͽ��� ~ 7:�����
SELECT NEXT_DAY(SYSDATE, 7) FROM DUAL;
SELECT NEXT_DAY(SYSDATE, 'SATURDAY') FROM DUAL;

-- ���� ������ ������ ������ ���̽� ���� Ȯ���ϱ�
-- ������ ��ųʸ� : 
-- ������ ������ ���̽��� DBMS�� ���� ��������
-- ���̺� ���·� �����ϴµ� 
-- �̸� ������ ����(������ ��ųʸ�)��� �Ѵ�.
-- �⺻������ �ý����� �����ڸ� ������ ������ �� �ִ�.
-- ��, ����� ������ ���õ� ������ ����ڰ� ������ ���ȿ�
-- �ӽ÷� ������ �� ������,
-- ������ ���� ������ �� ������ �ʱ�ȭ �Ǿ�
-- �������� ��� ������ ���� ������ �ݿ� ���� �ʴ´�.
SELECT * FROM V$NLS_PARAMETERS;

-- ALTER SESSION SET NLS_LANGUAGE = AMERICAN;
ALTER SESSION SET NLS_LANGUAGE = KOREAN;

-- LAST_DAY(��¥) : �ش� ��¥�� ������ ���ڸ� ��ȯ�ϴ� �Լ�
SELECT LAST_DAY(SYSDATE) FROM DUAL;

-- 2. �ǽ�
-- EMPLOYEE ���̺��� ��� ������ ��ȸ�ϵ�
-- �ٹ� ����� 20�� �̻��� ������� 
-- ���, �����, �μ��ڵ�, �Ի�����  ��ȸ�Ͻÿ�
SELECT 
    EMP_ID, 
    EMP_NAME, 
    DEPT_CODE, 
    HIRE_DATE
    
FROM EMPLOYEE
-- WHERE MONTHS_BETWEEN(SYSDATE,HIRE_DATE)/12 > 20;
-- WHERE (SYSDATE-HIRE_DATE)/365 > 20;
WHERE ADD_MONTHS(HIRE_DATE, 240) < SYSDATE;

-- ��¥���� ���� �ֱ� ��¥�� ���� ���� �� ū ������ �Ǵ��ϸ�
-- ��¥�� ������  +, - �� �����ϴ�.
        
-- EXTRACT(��|��|�� FROM ��¥) : ��¥�κ��� ��|��|���� ������ �����ϴ� �Լ�
SELECT 
    EXTRACT(YEAR FROM SYSDATE),
    EXTRACT(MONTH FROM SYSDATE),
    EXTRACT(DAY FROM SYSDATE)
FROM 
    DUAL;
    
-- 3. �ǽ�
-- EMPLOYEE ���̺��� �� ��������
-- ���, �����, �Ի���, �ٹ������ ��ȸ �Ͻÿ�.

-- EXTRACT()
SELECT 
    EMP_ID, 
    EMP_NAME, 
    EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM HIRE_DATE) AS �ٹ����
FROM EMPLOYEE;

-- MONTH_BETWEEN()
SELECT 
    EMP_ID, 
    EMP_NAME, 
    FLOOR(MONTHS_BETWEEN(SYSDATE, HIRE_DATE)/12) AS �ٹ����
FROM EMPLOYEE;

-----------------------------------------------------

-- ����ȯ �Լ� --
-- TO_CHAR(��¥ | ����, '����') : 
-- ��¥�� ���� �����͸� Ư�� ���˿� �°� ��ȯ�ϴ� �Լ�

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


-- 4. �ǽ�
-- EMPLOYEE ���̺��� ��� ��������
-- ���, �����, �޿�, ������ ��ȸ�ϵ�
-- �޿��� \50,000,000�� �������� ����Ͻÿ�
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
--    TO_CHAR(SYSDATE, 'YEAR, Q') || '�б�'
    TO_CHAR(SYSDATE, 'YEAR, Q"�б�"'),
    TO_CHAR(SYSDATE, 'YYYY, Q"�б�"')
FROM DUAL;

-- ���� ��¥�� ���� 4�ڸ��� 2�ڸ� �⵵ ���� ����
-- Y / R
SELECT 
    TO_CHAR(SYSDATE, 'YYYY'),
    TO_CHAR(SYSDATE, 'RRRR'),
    TO_CHAR(SYSDATE, 'YY'),
    TO_CHAR(SYSDATE, 'RR')
FROM DUAL;

-- YY�� RR�� ����
-- 4�ڸ��� �⵵�� �߰��� ��� ������ ������
-- 2�ڸ��� �����͸� �⵵�� �߰��� ��� �ݵ�� ����ؾ� ��
-- ���� ������������
-- YY�� ���� ����(2000���)��  �������� �����ϰ�
-- RR�� �ݼ���(50���)�� �������� �����Ѵ�.

-- ���ش� �ݼ��� �������� 50�⺸�� �����Ƿ�,
-- ���ڸ��� �⵵�� �� �ڸ��� �ٲ� ��
-- �ٲ� �⵵ 50�̸��̸� ������(2000)�� �����ϰ�,
-- 50�̻��̸� ������(1900)�� �����Ѵ�.

-- ����, ���� �⵵�� 50�� �̻��� ���
-- �ٲ� �⵵�� 50 �̸��̸� ���� ���⸦ �����ϰ�(2100)
-- 50�̻��̸� �����⸦ �����Ѵ�. (2000)


SELECT
    TO_CHAR(TO_DATE(49, 'YY'), 'YYYY'),
    TO_CHAR(TO_DATE(49, 'RR'), 'RRRR'),
    TO_CHAR(TO_DATE(51, 'YY'), 'YYYY'),
    TO_CHAR(TO_DATE(51, 'RR'), 'RRRR')
FROM DUAL;

-- ���� ��¥���� ���ڸ� ó���ϱ�
SELECT 
    TO_CHAR(SYSDATE, '"1�� ����" DDD'),
    TO_CHAR(SYSDATE, '"1�� ����" DD'),
    TO_CHAR(SYSDATE, '"1�� ����" D')
FROM DUAL;

-- 5. �ǽ�
-- EMPLOYEE ���̺��� ������, �Ի����� ��ȸ�ϵ�
-- 0000�� 00�� 00�� (0����) �������� ��ȸ�Ͽ� ����Ͻÿ�
SELECT
    EMP_NAME,
    TO_CHAR(HIRE_DATE, 'YYYY"��" MM"��" DD"��" "("DAY")"') AS �Ի�⵵
FROM EMPLOYEE;

-- TO_DATE(���� | ���� ������, '���� ����')
-- : Ư�� ���� ��¥�� ���� ������ ���� �о �ٲ��ִ� �Լ�

SELECT 
    TO_DATE(20000101, 'YYYYMMDD')
FROM DUAL;

SELECT
    TO_CHAR(TO_DATE('20101010', 'YYYYMMDD'), 'YEAR, MON')
FROM DUAL;

-- TO_NUMBER(���ڵ�����, ��������) : ���� �����͸� ���ڷ� �������ִ� �Լ�
SELECT TO_NUMBER('123456') FROM DUAL;

-- ���� �����Ϳ� �ٸ� �����ʹ� �⺻������ ��Ģ������ ������ �� ����.
SELECT '123' || '123ABC' FROM DUAL;

SELECT '123' + '456' FROM DUAL;

-----------------------------------------------

-- ���� �Լ�

-- DECODE(ǥ����, ���1, ��1[, ���2, ��2 ...],  �⺻��)
SELECT
    EMP_NAME,
    EMP_NO,
    DECODE(SUBSTR(EMP_NO,8,1), '1', '����', '2', '����')
FROM EMPLOYEE;

-- CASE
--  WHEN ���ǽ�1 THEN ���1
--  WHEN ���ǽ�2 THEN ���2
--  ELSE �⺻��
--  END

SELECT 
    EMP_NAME,
    EMP_NO,
    CASE
        WHEN SUBSTR(EMP_NO,8,1) IN (1,3) THEN '����'
        WHEN SUBSTR(EMP_NO,8,1) IN (2,4) THEN '����'
        ELSE '�ܰ���'
    END AS ����
FROM EMPLOYEE;

-- 6. �ǽ�
-- EMPLOYEE ���̺���
-- ������ ���� ������ ���̴�.
-- ������ �ش��ϴ� �������� �������� ������ �޿��� �λ��ϰ��� �Ѵ�.
-- �����ڵ尡 J5�� �������� �޿��� 20%,
-- �����ڵ尡 J6�� �������� �޿��� 15%,
-- �����ڵ尡 J7�� �������� �޿��� 10%,
-- �� �� �������� �޿��� 5%�� �λ��Ϸ��� �� ��
-- EMPLOYEE ���̺��� �ش� ������ �����ϴ� �������� 
-- ���, �����, �����ڵ�, �λ�� �޿� ������ ��ȸ�Ͽ� ����Ͻÿ�
SELECT
    EMP_ID AS "���",
    EMP_NAME AS "�����",
    JOB_CODE AS "�����ڵ�",
    TO_CHAR(SALARY, 'L999,999,999') AS "�� �޿�",
    TO_CHAR(
        CASE
            WHEN JOB_CODE ='J5' THEN SALARY*1.2
            WHEN JOB_CODE ='J6' THEN SALARY*1.15
            WHEN JOB_CODE ='J7' THEN SALARY*1.1
            ELSE SALARY+SALARY*0.05
        END, 
    'L999,999,999') AS "�λ�� �޿�"
FROM EMPLOYEE;


--�Լ� ��������
--
--1. ������� �ֹι�ȣ�� ��ȸ��
--  ��, �ֹι�ȣ 9��° �ڸ����� �������� '*'���ڷ� ä��
--  �� : ȫ�浿 771120-1******
SELECT
    EMP_NAME,
    RPAD(SUBSTR(EMP_NO,1,8),14,'*')
FROM EMPLOYEE;


--2. ������, �����ڵ�, ����(��) ��ȸ
--  ��, ������ ��57,000,000 ���� ǥ�õǰ� ��
--     ������ ���ʽ�����Ʈ�� ����� 1��ġ �޿���
SELECT 
    EMP_NAME,
    JOB_CODE,
    TO_CHAR( (SALARY+ SALARY*NVL(BONUS, 0))*12,'L99,999,999,999') AS ����
FROM EMPLOYEE;
SELECT * FROM EMPLOYEE;


--3. �μ��ڵ尡 D5, D9�� ������ �߿��� 2004�⵵�� �Ի��� ������ 
--   �� ��ȸ��.
--   ��� ����� �μ��ڵ� �Ի���
SELECT 
    EMP_ID,
    EMP_NAME,
    DEPT_CODE,
    HIRE_DATE
FROM EMPLOYEE
WHERE 
    DEPT_CODE IN ('D5','D9')
    AND EXTRACT(YEAR FROM HIRE_DATE) = '2004';


--4. ������, �Ի���, �Ի��� ���� �ٹ��ϼ� ��ȸ
--   ��, �ָ��� ������
SELECT
    EMP_NAME,
    HIRE_DATE,
    LAST_DAY(HIRE_DATE) - HIRE_DATE AS "�Ի�� �ٹ� �ϼ�"
FROM EMPLOYEE;
    


--5. ������, �μ��ڵ�, �������, ����(��) ��ȸ
--   ��, ��������� �ֹι�ȣ���� �����ؼ�, 
--   ������ ������ �����Ϸ� ��µǰ� ��.
--   ���̴� �ֹι�ȣ���� �����ؼ� ��¥�����ͷ� ��ȯ�� ����, �����
SELECT
    EMP_NAME AS "������",
    DEPT_CODE AS "�μ��ڵ�",
   TO_CHAR(TO_DATE(SUBSTR(EMP_NO,1,6)), 'YY"��" MM "��" DD"��"') AS "�������",
   FLOOR(MONTHS_BETWEEN(SYSDATE,TO_DATE(SUBSTR(EMP_NO,1,6)))/12) AS "����(��)"
FROM EMPLOYEE
WHERE EMP_ID NOT IN (201,200,214);
    

--6. �������� �Ի��Ϸ� ���� �⵵�� ������, �� �⵵�� �Ի��ο����� ���Ͻÿ�.
--  �Ʒ��� �⵵�� �Ի��� �ο����� ��ȸ�Ͻÿ�.
--  => to_char, decode, sum ���
--
--	-------------------------------------------------------------
--	��ü������   2001��   2002��   2003��   2004��
--	-------------------------------------------------------------
SELECT 
    SUM(COUNT(SUBSTR(HIRE_DATE, 1, 2))) AS "��ü������",
   SUM(COUNT(DECODE(SUBSTR(HIRE_DATE, 1, 2), 01, '2001��'))) AS "2001��",
   SUM(COUNT(DECODE(SUBSTR(HIRE_DATE, 1, 2), 02, '2002��'))) AS "2002��",
   SUM(COUNT(DECODE(SUBSTR(HIRE_DATE, 1, 2), 03, '2003��'))) AS "2003��",
   SUM(COUNT(DECODE(SUBSTR(HIRE_DATE, 1, 2), 04, '2004��'))) AS "2004��"
FROM EMPLOYEE
GROUP BY SUBSTR(HIRE_DATE, 1, 2);

SELECT SUBSTR(HIRE_DATE, 1, 2) FROM EMPLOYEE;


--7.  �μ��ڵ尡 D5�̸� �ѹ���, D6�̸� ��ȹ��, D9�̸� �����η� ó���Ͻÿ�.
--   ��, �μ��ڵ尡 D5, D6, D9 �� ������ ������ ��ȸ��
--  => case ���
--   �μ��ڵ� ���� �������� ������.
SELECT
    EMP_NAME,
    CASE 
        WHEN DEPT_CODE = 'D5' THEN '�ѹ���'
        WHEN DEPT_CODE = 'D6' THEN '��ȹ��'
        WHEN DEPT_CODE = 'D9' THEN '������'
    END �μ���
FROM EMPLOYEE
WHERE 
    DEPT_CODE IN ('D5','D6','D9')
ORDER BY DEPT_CODE ASC;

----------------------------------------------------------------------------

-- ORDER BY ����
-- ��ȸ�� ���� ������� Ư�� ���ؿ� ���� ��������, ������������ ����
SELECT EMP_ID, EMP_NAME, DEPT_CODE, JOB_CODE, SALARY
FROM EMPLOYEE
-- ORDER BY EMP_ID;
-- ORDER BY EMP_NAME;
-- ORDER BY DEPT_CODE DESC;
ORDER BY 4;

/*
    -- SELECT ���� ���� ����
    5 : SELECT �÷��� AS ��Ī, ����, �Լ���
    1 : FROM ���̺��
    2 : WHERE ����
    3 : GROUP BY �׷��� ���� �÷���
    4 : HAVING �׷쿡 ���� �Լ���, ���ǽ�
    6 : ORDER BY �÷��� | ��Ī | �÷� ���� [ASC | DESC] [, �÷��� ...]
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


-- GROUP BY ���� --
---- Ư�� �÷��̳�, ������ �ϳ��� �׷����� ����
---- �� ���̺� ���� �ұ׷� ���� ��ȸ�� �����ϴ� ����
SELECT DEPT_CODE, AVG(SALARY)
FROM EMPLOYEE
GROUP BY DEPT_CODE;

-- 7. �ǽ�
-- EMPLOYEE ���̺���
-- �μ��� �� �ο�, �޿� �հ� , �޿� ���, �ִ� �޿�, �ּ� �޿���
-- ��ȸ�Ͽ� ����Ͻÿ�.
-- ��, ��� ���� �����ʹ� ������ �����ͷ� ó���Ͻÿ�
SELECT 
    DEPT_CODE,
    COUNT(*) AS "���ο�",
    FLOOR(SUM(SALARY)) AS "�޿��հ�",
    FLOOR(AVG(SALARY)) AS "�޿����",
    FLOOR(MAX(SALARY)) AS "�ִ�޿�",
    FLOOR(SUM(SALARY)) AS "�ּұ޿�"
FROM EMPLOYEE
GROUP BY
    DEPT_CODE;
    
-- 8. �ǽ� 2
-- EMPLOYEE ���̺���
-- �����ڵ�, ���ʽ��� �޴� ����� ���� ��ȸ�ϰ�
-- �����ڵ� ������ �������� �����Ͽ� ����ϼ���
SELECT 
     JOB_CODE,COUNT(BONUS)
FROM EMPLOYEE
GROUP BY JOB_CODE
ORDER BY JOB_CODE;

-- 9. �ǽ�
-- EMPLOYEE ���̺���
-- ���� ������ ���� ������ ���� ��ȸ�Ͻÿ�

SELECT 
    DECODE(SUBSTR(EMP_NO, 8, 1), 1, '����', 2, '����') AS ����,
    COUNT(*) ������
FROM EMPLOYEE
GROUP BY SUBSTR(EMP_NO, 8, 1);

-- HAVING ����
-- GROUP BY �� �� �ұ׷쿡 ���� ������ �����ϰ��� �� ��
-- �׷� �Լ��� �Բ� ����ϴ� ���� ����
SELECT 
    DEPT_CODE,
    FLOOR(AVG(SALARY)) ��ձ޿�
FROM EMPLOYEE
GROUP BY DEPT_CODE
HAVING AVG(SALARY) > 3000000;

-- 10. �ǽ�
-- �μ��� �׷��� �޿� �հ� �� 900������ �ʰ��ϴ�
-- �μ��� �ڵ�� �޿� �հ踦 ��ȸ�Ͻÿ�
SELECT 
    DEPT_CODE,
    TO_CHAR(SUM(SALARY),'L99,999,999')
FROM EMPLOYEE
GROUP BY 
    DEPT_CODE
HAVING SUM(SALARY) > 9000000
ORDER BY 
    DEPT_CODE;
    
    
-- 11. �ǽ�
-- �޿��� �հ谡 ���� ���� �μ��� ã��,
-- �ش� �μ��� �μ� �ڵ�� �޿� �հ踦 ���Ͻÿ�,
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
    
    
-- ���� �Լ� --


-- ROLLUP : Ư�� �׷캰 �߰� ���� �� �� ���踦 �����ϴ� �Լ�
-- GROUP BY ���������� ����Ѵ�.
-- �׷� ���� ���� ���鿡 ���ؼ� �� ���� ���� �ڵ����� ����� �ش�.

-- ���� �� �޿� �հ�
SELECT JOB_CODE ����,
        SUM(SALARY) �޿��հ�
FROM EMPLOYEE
GROUP BY ROLLUP(JOB_CODE)
ORDER BY 1;


-- CUBE : Ư�� �׷캰 �ڵ� ���踦 �����ϴ� �Լ�
-- GROUP BY ���������� ����ϸ�,
-- ������ �Ұ� �� �� �հ踦 �ڵ����� ���� ���ش�.
SELECT JOB_CODE ����,
        SUM(SALARY) �޿��հ�
FROM EMPLOYEE
GROUP BY CUBE(JOB_CODE)
ORDER BY 1;

-- ROLLUP �� CUBE�� ��������� �ٸ�����
-- �� ���� �÷��� ���� �׷� ���踦 ����� ������
-- ������ ����� ���´�.

-- ���� �׷� �����ϱ�
-- ROLLUP�� ����� ���
-- ���ڷ� ������ �÷� �׷� �� ���� ���� ������
-- �׷캰 ����� �� �հ踦 �������� �����Ѵ�.
SELECT DEPT_CODE, JOB_CODE, SUM(SALARY)
FROM EMPLOYEE
GROUP BY ROLLUP(DEPT_CODE, JOB_CODE)
ORDER BY 1, 2;

-- �׷����� ������ ��� �׷쿡 ���� ���踦 ����Ͽ� �� �׷찣 ����,
-- ��ü ���踦 ���� �����ϴ� �Լ�
SELECT DEPT_CODE, JOB_CODE, SUM(SALARY)
FROM EMPLOYEE
GROUP BY CUBE(DEPT_CODE, JOB_CODE)
ORDER BY 1, 2;

-- GROUPING(�÷���)
-- �ش� �÷��� ���� �ڵ� ����� �÷� ������
-- Ȯ���ϱ� ���� �Լ�
-- �÷��� ���� �ڵ����� ������� ���̸� 1,
-- ���� �ִ� �÷��� ���̸� 0


SELECT DEPT_CODE, JOB_CODE, SUM(SALARY),
    GROUPING(DEPT_CODE) "�μ��� �ڵ� ���� ����",
    GROUPING(JOB_CODE) "���޺� �ڵ� ���� ����"
FROM EMPLOYEE
GROUP BY ROLLUP(DEPT_CODE, JOB_CODE)
ORDER BY 1,2;
    
-- GROUPING ���� --

-- �� �÷��� ����� �ڵ� ����� ������� Ȯ���ϴ� SQL
SELECT 
    DEPT_CODE, JOB_CODE, SUM(SALARY),
    CASE
        WHEN GROUPING(DEPT_CODE) = 0
        AND GROUPING(JOB_CODE) = 1
            THEN '�μ��� �հ�'
        WHEN GROUPING(DEPT_CODE) = 1
        AND GROUPING(JOB_CODE) = 0
            THEN '���޺� �հ�'
        WHEN GROUPING(DEPT_CODE) = 0
        AND GROUPING(JOB_CODE) = 0
            THEN '�׷캰 �հ�'
        ELSE
            '��ü �հ�'
    END AS ����
FROM EMPLOYEE
GROUP BY CUBE(DEPT_CODE, JOB_CODE)
ORDER BY 1, 2;
        
