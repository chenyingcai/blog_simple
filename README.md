# 使用hexo 来创建博客
---
######  This is my first step in GITHUB !
######  I will try to construct my first blog here !
###### 2018-03-17 14:24:31 星期六
---
## 第一步: 使用eipdev/alpine-jupyter-notebook
---
1. `docker pull eipdev/alpine-jupyter-notebook`
2.  订制自己的 **DockerFile**: dockerfile_githubblog_alpine_jupyter
```ruby
FROM eipdev/alpine-jupyter-notebook
MAINTAINER CHEN_Yingcai <chenyingcai.github.io>
RUN \
    apk --update --no-progress --no-cache add git openssh nodejs-npm \
    && rm -rf /var/cache/apk/*
RUN \
    npm install hexo-cli -g
EXPOSE 8888
WORKDIR /opt/notebook
ENTRYPOINT ["/sbin/tini", "--"]
CMD ["jupyter", "notebook", "--ip=0.0.0.0", "--port=8888", "--no-browser", "--allow-root"]
```
3. 构建容器
```bash
docker build -t githubblog/jupyter_alpine:v2 -f dockerfile_githubblog_alpine_jupyter .
```
4. 启动容器:
```bash
docker run -d -p 8888:8888 -p 4000:4000 -v $PWD:/opt/notebook githubblog/jupyter_alpine:v2
```

    这里申请了两个地址:localhost:8888(这个是jupyter的主页面) localhost:4000(这个是我们预览博客需要用的地址, 后面会提到)
---
##第二步: 创建一个博客
---
在localhost:8888 的页面中 选中terminal进入控制面板, 敲入下面的代码:
```bash
hexo init chenyingcai.github.io
```

这里我们需要一个模板, 我使用的是:*hexo-theme-Claudia(forked from Haojen/hexo-theme-Claudia)*
克隆这个模板到本地, 然后复制到我们当前的文件夹`chenyingcai.github.io`下的`theme`文件夹里面去
```bash
cd chenyingcai.github.io
git clone https://github.com/chenyingcai/hexo-theme-Claudia.git themes/Claudia
```

这时候在`themes `文件夹下就能够看见一个叫`Claudia`的文件夹, 这个就是我们需要的一个主题

---
##第三步: 修改_config.yml配置
---

1. 修改theme

   还记得我们在themes文件夹下此时只有两个文件夹一个是landscape一个是Claudia, 默认在主配置文件中使用的主题是landscape, 我们找到_config.yml中倒数第二行的# Extensions 下的theme:landscape.
   改为theme:Claudia
   这时候我们就应用了Claudia 主题了. 之后需要修改主题的配置在themes/Claudia/_config.yml的配置文件中做修改

2. 修改发布配置

   找到`# Development`改为:
   ```ruby
   # Development
			deploy:
					type: git
					  repo: 
								  git@github.com:chenyingcai/blog.git
```
---

##第四步: 生成
---

使用``hexo g ``进行生成任务, 之后任务会生成一个`public`文件夹
如果使用``hexo clean``则会删除这个`public`文件夹

---
##第五步: 发布预览
---
```bash
hexo s
```
还记得开放的`-p 4000:4000`端口吗, 在这一步就用到了这个端口, 我们可以在这预览博客.
打开[localhost:4000](localhost:4000)就能够预览我们的博客了

---

##第六步: 清理

---
```bash
hexo clean
```
---
