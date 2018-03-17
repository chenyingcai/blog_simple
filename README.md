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

## 第二步: 创建一个博客

---

在localhost:8888 的页面中 选中terminal进入控制面板, 敲入下面的代码:
```bash
hexo init chenyingcai.github.io
```

这里我们需要一个模板, 我使用的是:[hexo-theme-Claudia](https://github.com/Haojen/hexo-theme-Claudia)(forked from [Haojen Ma](https://github.com/Haojen))
克隆这个模板到本地, 然后复制到我们当前的文件夹`chenyingcai.github.io`下的`themes`文件夹里面去

```bash
cd chenyingcai.github.io
git clone https://github.com/chenyingcai/hexo-theme-Claudia.git themes/Claudia
```

这时候在`themes `文件夹下就能够看见一个叫`Claudia`的文件夹, 这个就是我们需要的一个主题

---

## 第三步: 修改_config.yml配置

---

1. 修改theme

   还记得我们在themes文件夹下此时只有两个文件夹一个是`landscape`一个是`Claudia`, 默认在主配置文件中使用的主题是`landscape`, 我们找到`_config.yml`中倒数第二行的`# Extensions `下的`theme:landscape`.
   改为`theme:Claudia`
   这时候我们就应用了Claudia 主题了. 之后需要修改主题的配置在`themes/Claudia/_config.yml`的配置文件中做修改

2. 修改发布配置

    找到`# Development`改为:
    ```python
    # Development
        deploy:
	    type: git
            repo: 
                https://github.com/chenyingcai/chenyingcai.github.io.git

   ```

---

## 第四步: 生成

---

使用``hexo g ``进行生成任务, 之后任务会生成一个`public`文件夹
如果使用``hexo clean``则会删除这个`public`文件夹

---

## 第五步: 发布预览

---


```bash
hexo s
```

还记得开放的`-p 4000:4000`端口吗, 在这一步就用到了这个端口, 我们可以在这预览博客.
打开[localhost:4000](localhost:4000)就能够预览我们的博客了

---

## 第六步: 部署

```
hexo d
```

这时候就部署了, 我们直接输入chenyingcai.github.io, 就能看到我们的博客了, 但是问题来了, 这里回忆一下，我们在之前的**主配置文件** `_config` 中的 `# Development` 项中写入的地址是 https://chenyingcai/chenyingcai.github.io.git .一旦我们完成了以上的部署之后, 在我们的github中的repo`chenyingcai.github.git` 将全部修改为我们的博客这一个静态网页所需要的一系列支持性文件, 我们之前hexo的项目都将会被删除，但本地还保留着我们之前努力的成果，所以为了之后连续性的工作，我们需要另外创建一个项目, 或者说在github上另外闯将一个repo, 并且repo的名字应该尽量避免与 `chenyingcai.github.io` 重复，于是我们进行以下操作，保留我们之前的劳动成果并为之后的持续开发维护好先前的基础

```
git remote remove origin # 删除远程关联
git remote add origin https://github.com/chenyingcai/blog.git # 关联一个新的git项目
git add .
git commit -m "save our previous hard-works"
git push -u origin master # 上传
git status

```

## 第七步: 清理

---

```bash
hexo clean
```

---


## 常见问题

---

1. 在jupyter 的terminal 中操作时 push 项目容易出现无法使用ssh传输的情况, 也就是说我们这时候不能将 本地 通过 git@github.com 关联到远程
这个时候我们就要通过网站 https://github.com/{在github上的用户名}/{repo(项目)名称}.git 进行关联.
先解除remote关联

```bash
git remote remove origin
```

然后重新关联

```bash
git remote add origin https://github.com/{在github上的用户名}/{repo(项目)名称}.git
```

之后在``git status``没有问题后, ``git push -u origin master`` 上传到对应项目的远程库(origin, 这里origin代表对应项目的远程库)的master分支(一般在github上**默认**每一个项目的分支为master)

---

## 修复

---

1. 2018-03-17 22:43:13 星期六(Paris)
* 之前使用容器`githubblog/jupyter_alpine:v2` 发现无法使用hexo, 在位置`/opt/notebook`输入`hexo -v`出现错误

```
Error Local hexo not found in /opt/notebook
Error Try running: 'npm install hexo --save
```

之后在位置`opt/notebook`中输入`npm install`, 然后位置`opt/notebook`生成`note_modules`文件夹和文件`package.json`. 输入`hexo -v` , 问题解决.


所以我们应该修改dockerfile_githubblog_alpine_jupyter的第7行. 将以下: 

```
RUN \
    npm install hexo-cli -g
```

改为:

```
RUN \
    && npm install hexo-cli -g \
    && npm install hexo-deployer-git --save \
    && cd opt/notebook \
    && npm install
```
---
