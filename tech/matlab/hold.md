### hold on & hold off

**old on** 是当前轴及图形保持而不被刷新，准备接受此后将绘制

**hold off** 使当前轴及图形不在具备被刷新的性质

hold on 和 hold off，是相对使用的
前者的意思是，你在当前图的轴（坐标系）中画了一幅图，再画另一幅图时，原来的图还在，与新图共存，都看得到
后者表达的是，你在当前图的轴（坐标系）中画了一幅图，此时，状态是hold off，则再画另一幅图时，原来的图就看不到了，在轴上绘制的是新图，原图被替换了

```Matlab
>> t=(0:pi/100:pi)';
y1=sin(t)*[1,-1];
y2=sin(t).*sin(9*t);
t3=pi*(0:9)/9;
y3=sin(t3).*sin(9*t3);
plot(t,y1,'r:',t,y2,'-bo')
hold on
plot(t3,y3,'s','MarkerSize',10,'MarkerEdgeColor',[0,1,0],'MarkerFaceColor',[1,0.8,0]) 
axis([0,pi,-1,1])
hold off
```



图形

```Matlab
>> t=(0:pi/100:pi)';
y1=sin(t)*[1,-1];
y2=sin(t).*sin(9*t);
t3=pi*(0:9)/9;
y3=sin(t3).*sin(9*t3);
plot(t,y1,'r:',t,y2,'-bo')
plot(t3,y3,'s','MarkerSize',10,'MarkerEdgeColor',[0,1,0],'MarkerFaceColor',[1,0.8,0])
axis([0,pi,-1,1])
hold off
```

去掉hold on后的图形，只显示最后的一次数据

### 参考

[1] http://blog.sina.com.cn/s/blog_6d617a7f0101182f.html