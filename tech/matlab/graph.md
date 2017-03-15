### stairs[1]

阶梯图

```matlab
X = linspace(0,4*pi,40);
Y = sin(X);

figure
stairs(Y)
```

### plot[3]

绘图

2D

```Matlab
x=0:0.35:7;
y=2*exp(-0.5*x);
subplot(2,2,1);bar(x,y,'g');
title('bar(x,y,''g'')');axis([0, 7, 0 ,2]);
subplot(2,2,2);fill(x,y,'r');
title('fill(x,y,''r'')');axis([0, 7, 0 ,2]);
subplot(2,2,3);stairs(x,y,'b');
title('stairs(x,y,''b'')');axis([0, 7, 0 ,2]);
subplot(2,2,4);stem(x,y,'k');
title('stem(x,y,''k'')');axis([0, 7, 0 ,2]);
```

3D

```Matlab
t=0:pi/50:2*pi;
x=8*cos(t);
y=4*sqrt(2)*sin(t);
z=-4*sqrt(2)*sin(t);
plot3(x,y,z,'p');
title('Line in 3-D Space');
text(0,0,0,'origin');
xlabel('X');ylabel('Y');zlabel('Z');grid;
```

### 线形[2]

| 线型     | 颜色   | 标记符号  |         |
| ------ | ---- | ----- | ------- |
| - 实线   | b蓝色  | .   点 | s 方块    |
| : 虚线   | g绿色  | o 圆圈  | d 菱形    |
| -. 点划线 | r红色  | × 叉号  | ∨朝下三角符号 |
| -- 双划线 | c青色  | + 加号  | ∧朝上三角符号 |
|        | m品红  | * 星号  | <朝左三角符号 |
|        | y黄色  |       | >朝右三角符号 |
|        | k黑色  |       | p 五角星   |
|        | w白色  |       | h 六角星   |

### 参考

[1] mathwork, http://cn.mathworks.com/help/matlab/ref/stairs.html

[2] wangchongjie, http://blog.csdn.net/wangcj625/article/details/6287735/

[3] mathwork, http://cn.mathworks.com/help/matlab/ref/graph.plot.html