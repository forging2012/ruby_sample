# 以phusion/passenger-ruby22为基础
FROM phusion/passenger-ruby22

# 设置时区
RUN echo "Asia/Shanghai" > /etc/timezone
RUN dpkg-reconfigure -f noninteractive tzdata

#设置当前环境变量
ENV HOME /root

CMD ["/sbin/my_init"]

# 添加gemfile
WORKDIR /tmp
ADD ./Gemfile Gemfile
ADD ./Gemfile.lock Gemfile.lock
RUN bundle install

#关闭nginx
RUN rm -f /etc/service/nginx/down
#设置新的nginx虚拟主机
RUN rm /etc/nginx/sites-enabled/default
#添加nginx配置文件
ADD nginx.conf /etc/nginx/sites-enabled/webapp.conf
#添加环境文件
ADD nginx-env.conf /etc/nginx/main.d/nginx-env.conf
# 创建项目目录
RUN mkdir /home/app/webapp
# 将项目文件加入项目目录
ADD . /home/app/webapp

WORKDIR /home/app/webapp

# 清楚产生的缓存文件
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# 开放80端口
EXPOSE 80
