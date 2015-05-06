# create!跟create方法功能一样 只不过这个方法会抛出异常 在测试中有利于调试】
User.create!(
  name: 'fugeng',
  email: '223328084@qq.com',
  password: '63292590',
  password_confirmation: '63292590'
)

99.times do |n|
    name = Faker::Name.name
    email = "example-#{n+1}@railstutorial.org"
    User.create!(
      name: name,
      email: email,
      password: 'password',
      password_confirmation: 'password'
    )
  end