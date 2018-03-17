!#bin/bash
#容器启动
docker run -d \
# port 8888是用于jupyter界面的端口 port 4000 是用于预览生成的博客的端口
-p 8888:8888 -p 4000:4000 \
# 挂载容器1 : 本地(注意: 此时本地地址应该处于博客项目的文件夹里) 对应容器里的/opt/notebook位置
-v $PWD:/opt/notebook \
# 挂载ssh key, 注意自己的ssh key所在本地的位置, ubuntu一般位于~/.ssh
-v ~/.ssh:/boot/.ssh \
githubblog/jupyter_alpine:v2
