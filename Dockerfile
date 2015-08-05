# 以phusion/passenger-ruby22为基础
FROM phusion/passenger-ruby22

# 设置时区
RUN echo "Asia/Shanghai" > /etc/timezone
RUN dpkg-reconfigure -f noninteractive tzdata

#设置当前环境变量
ENV HOME /root
#设置rails环境为生产环境
ENV RAILS_ENV production

CMD ["/sbin/my_init"]

# 缓存gem，如果Gemfil没有改变将不会从源直接下载
WORKDIR /tmp
ADD ./Gemfile Gemfile
ADD ./Gemfile.lock Gemfile.lock
RUN bundle install

#启动nginx
RUN rm -f /etc/service/nginx/down
#配置nginx
RUN rm /etc/nginx/sites-enabled/default
ADD nginx.conf /etc/nginx/sites-enabled/webapp.conf

#添加环境文件
ADD nginx-env.conf /etc/nginx/main.d/nginx-env.conf
#增加初始化运行脚本
RUN mkdir -p /etc/my_init.d
#Migrate
ADD migrate.sh /etc/my_init.d/migrate.sh

# 创建项目目录
RUN mkdir /home/app/webapp
# 将项目文件加入项目目录
ADD . /home/app/webapp

WORKDIR /home/app/webapp
# 如果你的rails应用不是前后端分离就应该加上这句
RUN rake assets:precompile

# 清楚产生的缓存文件
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
# 开放80端口
EXPOSE 80
