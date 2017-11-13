1. 取整函数 $\lfloor x \rfloor$ , $\lceil x \rceil$ 满足 $x-1 < \lfloor x \rfloor \le x \le \lceil x \rceil < x+1$ 。设 $a, b, n$ 为正整数，证明以下等式
   * $\lfloor \frac{n}{2}\rfloor + \lceil\frac{2}{2}\rceil = n$
   * $\lceil \frac{\lceil \frac{x}{a} \rceil}{b} \rceil = \lceil \frac{c}{ab} \rceil$

2. 算法的时间复杂度 $T(n) = T(\frac{n}{10}) + T(\frac{9n}{10}) + cn (c>0)$。先用递归树（或直接展开）推导出 $T(n)$ 的渐进确界（Tight Bound）$\Theta$ （10分），然后用归纳法证明其正确性。

3. （找零钱问题）有 $n$ 种执笔价钱分别为 $V_1, V_2,K,V_n$ ，其中 $V_1 = 1$ 且 $V_1<V_2<A<V_n$ 。当需要找的零钱总额为 $y$ 时，所付纸币的最少数量为 $f$ 。 $f$ 可用动态规划算法求解，给出 $f$ 的递推公式 $F_k(y)$ （15分），其中 $k$ 表示 $V_1, K, V_k$ ；同样，$f$ 的近似解也可以用贪心算法求得，给出其递推方程式 $G_k(y)$ 。（5分）

4. 在上述找零钱的问题中，假设 $\forall z > 0: F_k(z) = G(z)​$ 。证明 $F_{k+1} = G_{k+1}(y)​$ 成立的充分必要条件为 $G_{k+1}(y) \le G_k(y)​$。（15分）

5. （问题的描述）给定 $n$ 个整数排列 $A[1,…,n]$ 和一个整数 $b$ ，算出是否存在 $i,j\in\{1, …,n\}(i\ne j)$ ，满足 $b = A[i]+A[j]$ （$i$ 和 $j$ 的具体值可以不要）。

   判断上述问题是否存在复杂度为 $O(nlogn)$ 的算法 （5分），如果存在，描述其计算过程（可结合其他算法），并分析复杂度，如果无说明其理由（10分）















