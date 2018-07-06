# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

genres = ["Horror", "Thriller", "Action", "Drama","Comedy", "Romance", "SF", "Adventure", "Fantasy"]

images = %w( http://img.khan.co.kr/news/2017/10/31/l_2017103101003415200280211.jpg 
             https://t1.daumcdn.net/thumb/R1280x0/?fname=http://t1.daumcdn.net/brunch/service/user/Ji8/image/XYQ6knUsDYi7uTEoOUWrT09K4bs.jpg
             http://imgmovie.naver.com/mdi/mi/0733/73372_P31_161237.jpg
             http://file.thisisgame.com/upload/tboard/user/2016/07/08/20160708061954_5657.jpg
             http://img.danawa.com/images/descFiles/4/402/3401557_1497838111988.jpeg
             https://i.pinimg.com/originals/df/70/70/df70702365aa41e2b6a6b778d1065d2d.jpg
             http://thumb.zumst.com/530x0/
             http://static.news.zumst.com/images/37/2015/04/28/63dd6dd32b8448c9a3b1e2fb495e1244.jpg
             http://img.insight.co.kr/static/2018/05/24/700/k3p442sg6754iibr1hlw.jpg
             http://www.typographyseoul.com/images/newsEdit/15030516593088077_TS.png )

User.create(email: "aa@aa.aa", password: "123123", password_confirmation: "123123")
30.times do
            Movie.create(title: Faker::LordOfTheRings.character, 
                        description: Faker::Lorem.paragraph, 
                        genre: genres.sample, 
                        director: Faker::HarryPotter.character, 
                        actor: Faker::FunnyName.two_word_name, 
                        remote_image_path_url: images.sample,
                        user_id: 1)
end



