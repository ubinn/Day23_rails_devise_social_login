## Day16_180703

```ruby
binn02:~/workspace $ ruby -v
ruby 2.4.0p0 (2016-12-24 revision 57164) [x86_64-linux]
binn02:~/workspace $ rails -v
bash: rails: command not found
binn02:~/workspace $ gem install rails -v 5.0.7
36 gems installed
binn02:~/workspace $ rails -v
Rails 5.0.7
binn02:~/workspace $ ls
README.md
binn02:~/workspace $ cd

binn02:~ $ rails _5.0.7_ new watcha_app
```

#### Watcha (영화 정보 저장)

- scaffold 완성
- user authenticate(devise)
- comment model
- image upload (local)

```ruby
binn02:~ $ cd watcha_app/
binn02:~/watcha_app $ rails g scaffold movies
```

*routes.rb* -> `  root 'movies#index' ` 추가

*Gemfile*

```ruby
# beautify
gem 'bootstrap', '~>4.1.1'
# authentication
gem 'devise'
# file upload
gem 'carrierwave'

group :development do 안에다 설치해야한다.
   gem 'rails_db' 
end
```

`bundle install` 해주기.

이때 kaminari 도 설치되는데 이게 pagenation을 해주는 gem이래.

```ruby
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5' # 무거운 레일즈 앱을 경량화 시킴.
하지만 문제가 많아서 안쓴다. 잘쓰면 좋은데 잘쓰기가 많이 어려움

```

*application.js*

```ruby
//= require jquery
//= require jquery_ujs
//= require popper
//= require bootstrap

------ 이 두줄 삭제
//= require turbolinks
//= require_tree . -> 하위에 있는 모든 파일은 application.에 연결시킴.

```

**turbolink 삭제**

1. gem
2. application.js
3. application.html.erb

**devise 설치**

https://github.com/plataformatec/devise

```ruby
binn02:~/watcha_app $ rails generate devise:install

#~/watcha_app/config/environments/development.rb에 다음 코드 추가
config.action_mailer.default_url_options = { host: 'localhost', port: 3000 } 

# apllication.html에 코드추가.
   <% flash.each do |k, v| %>
     <div class="alert alert-<%=k %>"><%= v %></div>
   <% end %>

binn02:~/watcha_app $ rails generate devise users
```

*~/watcha_app/db/migrate/20180703004504_create_movies.rb*

```ruby
class CreateMovies < ActiveRecord::Migration[5.0]
  def change
    create_table :movies do |t|
      t.string  :title
      t.string :genre
      t.string :directer
      t.string :actor
      
      t.references :user # t.integer :user_id 랑 같은형태
      
      t.text :description
      t.timestamps
    end
  end
end
```

- 로그인 하지 않은 사용자가 무비 등록하지 못하도록.

  - movies_controller에   `before_action :authenticate_user!, except: [:index, :show]`

- 이미지 업로더

  - `gem 'carrierwave'`

  - `rails generate uploader image`

  - *movie.rb* 에  `    mount_uploader :image_path, ImageUploader` 추가

  - ```ruby
    $ sudo apt-get update
    $ sudo apt-get install imagemagick
    
    gemfile에 gem 'mini_magick'추가 -> bundle install
    ```

  - ```ruby
    ~/watcha_app/app/uploaders/image_uploader.rb
    
    # include CarrierWave::RMagick
       include CarrierWave::MiniMagick 
    # Create different versions of your uploaded files:
       version :thumb do
         process resize_to_fit: [320, 180]
       end
    ```

  - *~/watcha_app/public/uploads/movie/image_path/1* 에 thumbnail과 함께 원본과 저장되는것 확인가능

#### JAVA SCRIPT

HTML -> CSS+HTML -> JS + CSS + HTML

​	    ->	예뻐진다.   -> 동적으로 변한다.

CSS Selector : class / id  / <input> 

JS : getElementsByClassName / getElementByID / getElementsByTagName

- **요소찾기 (JavaScript)**

  - getElement**s**ByClassName
  - getElement**s**ByTagName
  - getElementByID <- 먼저 발견된 한친구만 리턴. // id는 통틀어서 한개만 있어야해.
  - querySelector("*.btn*") <- 먼저 발견된 한 친구만 나온다.
  - querySelectorAll(".btn") <- 모든 .btn에 관련된 친구가 다나온다.

  : console에 있는 document에서 찾아야해

  > document.getElementsByClassName("btn");
  >
  > 1. HTMLCollection(3) [a.btn.btn-primary, a.btn.btn-primary, a.btn.btn-primary]
  >
  > 2. 1. 0:a.btn.btn-primary
  >    2. 1:a.btn.btn-primary
  >    3. 2:a.btn.btn-primary
  >    4. length:3
  >    5. __proto__:HTMLCollection

```ruby
<h1 id="title">Movies</h1>
<hr>
<div id="title" class="row">
```

> document.getElementById("title");
>
> `<h1 id="title">Movies</h1>`
>
> > 먼저 발견된 한개의 친구만 나온다. <- element 이기 때문에!

> var btn = document.getElementsByClassName("btn"); 
>
> undefined
>
> btn
> HTMLCollection(3) [a.btn.btn-primary, a.btn.btn-primary, a.btn.btn-primary]

```console
> console.log("hi")
VM3650:1 hi
undefined
> console.error("404 error")
VM3654:1 404 error
(anonymous) @ VM3654:1
undefined
> console.dir(btn);
VM3662:1 HTMLCollection(3)
undefined
```

var  : 변수 선언.

```console
var btns = document.getElementsByClassName("btn");

btns
HTMLCollection(3) [a.btn.btn-primary, a.btn.btn-primary, a.btn.btn-primary]

btns[0] > 태그만 나온다.
<a class="btn btn-primary" href="/movies/1">영화 정보보기</a>

console.dir(btns[0]) > 얘가 가지고 있는 모든 속성 보기 가능
VM3801:1 a.btn.btn-primary
```

- 이벤트를 감지해서 다른 행동(행위)이 발생하게끔하기 위해서 ! 사용한다.

  : 이벤트 감지 (이벤트 리스너) -> 행동 발생 ( 이벤트 핸들러 )

  - 요소.onClick = 어떤행동 이런식으로 이벤트를 등록한다.


```console
> btns[0].onmouseover = alert("하이");
undefined
> alert("하이");
undefined
> confirm("삭제하시겠습니까?");
false
> confirm("삭제하시겠습니까?");
true
prompt(" 이름을 입력하세요. ");
"꾸꾸까까"
```

- 이벤트 등록하는 방법

  => 요소.on이벤트이름 = function(매개변수){

  ​			... 내용

  ​			}

  - 요소
  - .on이벤트이름  => 이벤트 리스너
  -  function(매개변수){... 내용} => 이벤트 핸들러

- 기본적인 JS (front)

  - 마우스를 over하면 " 나 건들이지마!!! " 라는 alert()를 띄운다.

  - 마우스 over를 10회 이상하면 "아 진짜 건들이지 말라고" 라는 alert()를 띄운다.

    >- count
    >- msg

    ```console
    > var btn = document.getElementsByClassName("btn")[0];
    undefined
    > btn
    <a class="btn btn-primary" href="/movies/1">영화 정보보기</a>
    > var count = 0 ;
    undefined
    > var msg = " 나 건들이지 마!";
    undefined
    > btn.onmouseover = function(){
          count++ ;
          if (count > 3) msg = "아 진짜 짜증나니까 건들이지 말라고!";
          alert(msg);
      }
    ƒ (){
        count++ ;
        if (count > 3) msg = "아 진짜 짜증나니까 건들이지 말라고!";
        alert(msg);
    }
    
    console.dir(btn); 로 함수가 들어간것을 확인할수있다.
    ```

    

- 이벤트 동작시키기 

  *index.html.erb*

  ```ruby
    <script>
      var btn = document.getElementsByClassName("btn")[0];
      var count = 0;
      var msg = "나 건들이지마!" ; 
      btn.onmouseover = function(){
        count++;
        if(count > 3){
          msg="옆에있는 영화나 눌러줘...";
        }
        alert(msg);
      }
    </script>
  
  ```

  - addEventListener 

    addEventListener은 이벤트를 등록하는 가장 권장되는 방식이다. 이 방식을 이용하면 여러개의 이벤트 핸들러를 등록할 수 있다. **하나의 이벤트 대상에 복수의 동일 이벤트 타입 리스너를 등록**할 수 있다는 점이다. 

    ```console
    btn.addEventListener("mouseover", function(){ 
        alert(" 하위~" );
    });
    ```

    하면 console.dir(btn); 하위에 function이 적용된것이 보이지 않아.

  

- 함수만들기

  - 변수에 함수 저장하기 (함수 표현식) : 선언되기 이전에 사용 불가능.

  ```console
    var func = function() {
        alert("하이~"); 
        }
        
    func(); 로 실행
  ```

  - 함수에 이름을 주어 정의하기 (한수 선언식) : 선언되기 이전에도 사용할수있다.

  ```console
  function func1(){
      alert("하위2");
  }
  
  func1();
  ```

  - 이 두개의 차이

  ```ruby
    <script>
       func1(); // 선언되기 전에는 사용 불가능
       func2(); // 선언되기 전에도 사용 가능.
  
      var func1 = function(){
        alert("하위~");
      }
      function func2(){
        alert("하위~2");
          }
      
      var btn = document.getElementsByClassName("btn")[0];
      btn.addEventListener("mouseover", func2); <- 함수를 사용할때는 ()를 제거한다.
      var btn2 = document.getElementsByClassName("btn")[1];
      btn2.onmouseover = func1; <- 얘 또한 마찬가지로 함수이름만 사용해야한다!
    </script>
  ```

  > 즉, 먼저 선언되어 있던 함수를 이벤트 핸들러로 사용할 경우 함수 이름만 적어서 사용한다.
  >
  > 함수이름() <- 이 형태는 함수의 실행을 의미한다.

  - 익명함수

  ##### 간단과제

  버튼(요소)에 마우스를 오버(이벤트) 했더니 (이벤트 리스너) 그 위에 있던 글자(요소)들이 갑자기 이상한 글자로 변해버린다(이벤트 핸들러).

  ```ruby
  <script>
  	var btn =  document.getElementsByClassName("btn")[0];
      btn.addEventListener("mouseover", function(){
        var title = document.getElementsByClassName("card-title")[0];
        console.dir(title);
        title.innerText = "아기상어뚜루뚜뚜뚜"
      });
      btn.addEventListener("mouseout", function(){
        var title = document.getElementsByClassName("card-title")[0];
        title.innerHTML = "<strong>어바웃 타임<strong>"
      });
  </script>
  ```

  

##### 간단과제

버튼(요소)에 마우스를 오버하면(이벤트, 이벤트 리스너) 해당 버튼의 클래스가 btn btn-danger로 변함.(이벤트 핸들러)

```ruby
<script>
    var btn =  document.getElementsByClassName("btn")[0];
    btn.addEventListener("mouseover", function(){
      btn.setAttribute("class", "btn btn-danger disabled");
    });
    btn.addEventListener("mouseout", function(){
      btn.setAttribute("class", "btn btn-primary");
    })
</script>
```



#### JAVA SCRIPT

- 기본적인 JS설명(front)

- 이벤트 동작시키기 + jQuery + ajax

- 댓글달기 + 수정 + 삭제

- 좋아요 구현 + 별점

- infinity scroll ( pagenation gem 사용)






