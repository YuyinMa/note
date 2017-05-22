原作者：skalaouzis, https://github.com/skalaouzis

### 问题描述

原地址：http://tracer.lcc.uma.es/problems/psp/index.html

1. The Project Scheduling Problem (PSP) consists in deciding **who does what** during the software project lifetime. 
2. It is related to the Resource-Constrained Project Scheduling (RCPS), an existing problem very popular in the literature. 
3. However, the problem defined here includes the concept of employee with **salary and personal skills, also able of performing several tasks** in a normal working day.

### 参数

The resources considered are people with a set of skills, a salary, and a maximum dedication to the project.

**员工**

each person (employee) is denoted with $e_i$ where *i* goes from *1* to *E* (the number of employees). 

**技能**

Let *SK* be the set of skills, and $s_i$ the *i*-th skill for *i* varying from *1* to *S=|SK|*. The skills of the employee  $e_i$ will be denoted with $e_i^{sk}$  that is a subset of *SK*, the monthly salary with $e_i^{sa}$, and the maximum dedication to the project with $e_i^{md}$. The salary and the maximum dedication are both real numbers. The former is expressed in fictitious currency units, while the latter is the ratio between the amount of hours dedicated to the project and the full working day length of the employee. For example, a maximum dedication of *0.75* means that the employee spends at most *75%* of its working day to tasks of the project. A dedication greater than *1.0* means that the employee works overtime, a quite real world feature included in our problem definition.

**任务**

The tasks are denoted with $t_i$ for *i* from *1* to *T* (the number of tasks). Each task $t_i$ has a set of required skills associated to it that we denote with $t_i^{sk}$ and an effort $t_i^{ef}$ expressed in **person-per-month** (PM). The tasks must be performed according to a Task Precedence Graph (TPG). The TPG indicates what tasks must be completed before the beginning of a new task. The TPG is an acyclic directed graph *G(V,A)* with a vertex set *V={t1, t2, ..., tT}* and an arc set *A* where $(t_i,j_j)$ belongs to *A* if the task $t_i$ must be completed, with no other intervening tasks, before task  can $t_i$ start.

### 目标

Our objectives are to minimize the cost, the duration of the project, and the overtime of the employees. 

The constraints are that each task must be performed by at least one person and the set of required skills of a task must be included in the union of the skills of the employees performing the task. 

The number of skills measures the degree of specialization of the knowledge. That is, with a larger number of skills the knowledge needed to perform the whole software project is divided into a greater number of portions than if it needs a reduced number of skills. Two examples could be developing a software for controlling a plain (large variety of skill needed) versus programming salary sheets for the administration of a company.

Once we know the elements of a problem instance, let us proceed to describe the elements of a solution to the problem. A solution can be represented with a matrix $X=(x_{ij})$ of size *E*x*T*. The element $x_{ij}$ is the dedication degree of the employee $e_i$ to the task $t_j$. If the employee $e_i$ performs the task  with $t_j$ a *0.5* dedication degree he/she spends half of his/her working day in the task. If an employee does not perform a task he/she will have a dedication degree of *0* to that task. This information helps to compute the duration of each task and, indeed, the start and end time of each one, i.e., the time schedule of the tasks. From this schedule we can compute the duration of the project. The cost can be calculated after the duration of the tasks accounting also for the dedication and salary of the employees. Finally, the overtime of each employee can be calculated using the time schedule of the tasks and the dedication matrix $X$ .