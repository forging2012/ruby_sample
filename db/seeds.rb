# create!跟create方法功能一样 只不过这个方法会抛出异常 在测试中有利于调试】
User.create!(
  name: 'fugeng',
  email: '223328084@qq.com',
  password: '63292590',
  password_confirmation: '63292590',
  admin: true,
  activated: true,
  activated_at: Time.zone.now
)

99.times do |n|
    name = Faker::Name.name
    email = "example-#{n+1}@railstutorial.org"
    User.create!(
      name: name,
      email: email,
      password: 'password',
      password_confirmation: 'password',
      activated: true,
      activated_at: Time.zone.now
    )
  end

 users = User.order(:created_at).take(6) 

 50.times do
  content = Faker::Lorem.sentence(5)
   users.each { |user| user.microposts.create!(content: content) }
 end