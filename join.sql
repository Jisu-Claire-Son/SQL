----------
-- JOIN
----------

DESC employees;
DESC departments;

-- 두 테이블로부터 모든 데이터를 불러올 경우
-- CROSS JOIN : 카티전 프로덕트
-- 두 테이블의 조합 가능한 모든 레코드의 쌍
SELECT employees.employee_id, employees.department_id,
    departments.department_id, departments.department_name
FROM employees, departments
ORDER BY employees.employee_id;

-- 일반적으로는 이런 결과를 원하지 않을 것
-- 첫 번째 테이블의 department_id 정보와 두 번째 테이블의 department_id를 일치
SELECT employees.employee_id, employees.first_name, employees.department_id,
    departments.department_id, departments.department_name
FROM employees, departments
WHERE employees.department_id = departments.department_id; -- 두 테이블의 연결 정보 조건을 부여
-- INNER JOIN, Equi JOIN

-- 컬럼명의 모호성을 피하기 위해 테이블명.컬럼명
--  테이블에 별명(alias)를 붙여주면 편리
SELECT employee_id, first_name, --  컬럼 명이 소속이 명확하면 테이블 명은 명시하지 않아도 된다
    emp.department_id,
    dept.department_id, 
    department_name
FROM employees emp, departments dept    -- 별칭을 부여한 테이블의 목록
WHERE emp.department_id = dept.department_id;

----------
-- INNER JOIN: Simple Join
----------
SELECT * FROM employees; -- 107

SELECT first_name,
    emp.department_id,
    dept.department_id,
    department_name
FROM employees emp, departments dept -- 테이블 별칭
WHERE emp.department_id = dept.department_id;  -- 106

-- JOIN되지 않은 사원은 누구인가?
-- 부서에 배속되지 않은 사원
SELECT first_name, department_id
FROM employees
WHERE department_id is null;

SELECT first_name,
    department_id,
    department_name
FROM employees JOIN departments
                USING (department_id);  -- JOIN할 컬럼을 명시
                
-- JOIN ON
SELECT first_name,
    emp.department_id,
    department_name
FROM employees emp JOIN departments dept
                ON (emp.department_id = dept.department_id); -- ON -> JOIN문의 WHERE 절

-- Natural Join
-- 두 테이블에 조인을 할 수 있는 공통 필드가 있을 경우(공통 필드가 명확할 때)
SELECT first_name, department_id, department_name
FROM employees NATURAL JOIN departments;

----------
-- Theta JOIN
----------
-- 임의의 조건을 사용하되 JOIN 조건이 = 조건이 아닌 경우의 조인
SELECT * FROM jobs WHERE job_id='AD_ASST';  -- min: 3000, max: 6000
SELECT first_name, salary FROM employees emp, jobs j
WHERE j.job_id='AD_ASST' AND
    salary BETWEEN j.min_salary AND j.max_salary;

----------
-- OUTER JOIN
----------
/*
조건 만족하는 짝이 없는 튜플도 NULL을 포함해서 출력에 참여시키는 JOIN
모든 레코드를 출력할 테이블의 위치에 따라서 LEFT, RIGHT, FULL OUTER JOIN으로 구분
ORACLE의 경우, null이 출력되는 조건쪽에 (+)
*/
-- INNER JOIN 참고 - 106
-- LEFT OUTER JOIN: ORACLE ver
SELECT first_name,
    emp.department_id,
    dept.department_id,
    department_name
FROM employees emp, departments dept
WHERE emp.department_id = dept.department_id (+); -- LEFT OUTER JOIN

-- LEFT OUTER JOIN: ANSI SQL
SELECT first_name,
    emp.department_id,
    dept.department_id,
    department_name
FROM employees emp LEFT OUTER JOIN departments dept --  emp 테이블의 모든 레코드는 출력에 참여
                    ON emp.department_id = dept.department_id;
                    
-- RIGHT OUTER JOIN: Oracle
SELECT first_name,
    emp.department_id,
    dept.department_id,
    department_name
FROM employees emp, departments dept
WHERE emp.department_id (+) = dept.department_id; -- departments 테이블의 모든 결과를 출력

-- RIGHT OUTER JOIN: ANSI SQL
SELECT first_name,
    emp.department_id,
    dept.department_id,
    department_name
FROM employees emp RIGHT OUTER JOIN departments dept
                    ON emp.department_id = dept.department_id;
                    
-- FULL OUTER JOIN: 양쪽 테이블 모두 출력에 참여
/*
SELECT first_name,
    emp.department_id,
    dept.department_id,
    department_name
FROM employees emp, departments dept
WHERE emp.department_id (+) = dept.department_id (+);  -- FULL OUTER JOIN은 불가
*/

SELECT first_name,
    emp.department_id,
    dept.department_id,
    department_name
FROM employees emp FULL OUTER JOIN departments dept
                    ON emp.department_id = dept.department_id;
                    
-- SELF JOIN: 자신의 FK가 자신의 PK를 참조하는 방식의 JOIN
--  자신을 두 번 호출하므로 alias 사용할 수밖에 없는 JOIN
SELECT emp.employee_id, emp.first_name, --  사원정보
    emp.manager_id,
    man.first_name
FROM employees emp, employees man
WHERE emp.manager_id = man.employee_id;

-- ANSI SQL
SELECT emp.employee_id, emp.first_name,
    emp.manager_id,
    man.first_name
FROM employees emp JOIN employees man
                    ON emp.manager_id = man.employee_id;
                    
----------------
--  Aggregation(집계)
----------------
--  여러 개의 값을 집계하여 하나의 결과값을 산출

--  count ; 갯수 세기 함수
--  employees 테이블은 몇 개의 레코드를 가지고 있는가?
SELECT COUNT(*) FROM employees; -- *는 전체 레코드 카운트를 집계 (내부 값이 null이 있어도 집계)
SELECT COUNT(commission_pct) FROM employees; -- 특정 칼럼을 명시하면 null인 것은 집계에서 제외
SELECT COUNT(*) FROM employees WHERE commission_pct is not null; -- 위의 것과 같은 의미

--  합계 함수 : SUM
--  급여의 총 합?
SELECT SUM(salary) FROM employees;

--  평균 함수: AVG
--  평균 급여 산정
SELECT AVG(salary) FROM employees;

--  사원들이 받는 평균 커미션 비율
SELECT AVG(commission_pct) FROM employees;  --  null 데이터는 집계에서 배제
SELECT AVG(nvl(commission_pct, 0)) FROM employees;

--  null이 포함된 집계는 null값을 포함할 것인지 아닌지를 결정하고 집계

--  salary의 최솟값, 최댓값, 평균값, 중앙값
SELECT MIN(salary), MAX(salary), AVG(salary), MEDIAN(salary)
FROM employees;

--  흔히 범하는 오류
--  부서의 아이디, 급여 평균을 출력하고자
SELECT department_id, AVG(salary) FROM employees;   --  error

--  만약에 부서별 평균 연봉을 구하려면?
--  부서별 Group을 지어준 데이터를 대상으로 집계 함수를 수행
SELECT  department_id, ROUND(AVG(salary), 2)
FROM employees
GROUP BY department_id
ORDER BY department_id;

--  집계 함수를 사용한 SELECT 컬럼 목록에는
--  집계에 참여한 필드,집계함수만 올 수 있다

--  부서별 평균 급여를 내림차순으로 출력
SELECT department_id, ROUND(AVG(salary), 2) sal_avg
FROM employees
GROUP BY department_id
ORDER BY sal_avg DESC;

--  부서별 평균 급여를 산출 평균 급여가 2000이상인 부서를 출력
SELECT department_id, AVG(salary)
FROM employees
WHERE AVG(salary) >= 20000  --  이 시점에서는 AVG(salary)가 수행되지 않은 상태 -> 없다
GROUP BY department_id;
--  Error : 집계 작업이 일어나기 전에 WHERE 절이 실행되기 때문

SELECT department_id, AVG(salary)
FROM employees
GROUP BY department_id --   그룹핑
    HAVING AVG(salary) >= 7000 --   Having: Group by에 조건을 부여할 때 사용
ORDER BY department_id;