### kubectl create问题
国内由于GFW的存在，创建pod、rc时会停留在StartingContainer阶段，无法pull到镜像
### 解决方法
在阿里镜像站，网易蜂巢等国内镜像站上pull所需镜像，然后修改tag，再跑kubectl creat
