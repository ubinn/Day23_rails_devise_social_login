## Day17_180704



- jQuery (요소 선택자, 이벤트 리스너)
  - jQuery는 jQuery CDN으로 가져와야하는거지만, rails에서는 jQuery가 내장되어 있다.
  - 하지만, rails 5.1버전 이상으로 사용하게 되면 어중간하게 설치가 되어있기때문에 다시 확인해야한다.
  - `<%= link_to '로그아웃', user_session_destroy_path ,method: 'destroy', data: {confirm: "삭제하시겠습니까?"} %>` 여기에서 `data: {confirm: "삭제하시겠습니까?"} ` 이 부분.
  - 

```javascript
> $
ƒ ( selector, context ) {
		// The jQuery object is actually just the init constructor 'enhanced'
		// Need init if jQuery is called (just allow error to be thrown if not included)
		return new jQuery…
    
>$("css 선택자")
jQuery.fn.init [prevObject: jQuery.fn.init(1), context: document, selector: "css 선택자"]		

>$(".btn") <= elementsByClassName
jQuery.fn.init(3) [a.btn.btn-primary, a.btn.btn-primary, a.btn.btn-primary, prevObject: jQuery.fn.init(1), context: document, selector: ".btn"]

>$('button') <- HTML tag를 가져온다.

> $('#title') <- 아이디는 유일하게 있어야하기때문에 아이디가 중복이라도 결과값은 한개만 나온다.
jQuery.fn.init [h1#title, context: document, selector: "#title"]


```

jQuery를 사용한 이벤트 적용 방식


```javascript
$('.btn').mouseover(function() {
    console.log("건들이지마이야이야~");
});

$('.btn').on('mouseover', function() {
    console.log("건들이지 말랬지 ㅡㅡ");
});
```

> 두번째 방식을 가장 많이 쓰는데 이벤트를 늘려갈수있기 때문에! 많이 사용한다.



- 마우스가 버튼위에 올라갔을때, 버튼에 있는 btn-primary클래스를 삭제하고, btn-danger 클래스를 준다. 버튼에서 마우스가 내려왔을 때, 다시 btn-danger 클래스를 삭제하고 btn-primary 클래스를 추가한다.
  - 여러개의 이벤트 등록하기
  - 요소에 class를 넣고 빼는 jQuery Function을 찾기. => .addClass / .removeClass || 이둘을 합쳐져 있는게 .toogleClass

```javascript
btn.on('mouseenter mouseout', function() {
    //두개의 이벤트 리스너, 한개의 이벤트 핸들러
    
    
btn.on('mouseenter mouseout', function() {
    btn.removeClass("btn-primary").addClass("btn-danger");
})
    // 이렇게 하면 btn-danger 로 변하고 끝. 근데 계속 변화시키고싶으니까 danger이 있을때 다시 primary로 바꿔주면 되겠지
    // .hasClass()로 해당 클래스를 찾아주자

    
    
btn.on('mouseenter mouseout', function(){
    if (btn.hasClass('btn-danger')) {btn.removeClass('btn-danger').addClass('btn-primary');} else { btn.removeClass('btn-primary').addClass('btn-danger'); }});
    
    
    btn.on('mouseenter mouseout', function(){
    $(this).toggleClass('btn-danger').toggleClass('btn-primary');
});
```

> $(this) : 이벤트가 발생한 바로 그 대상을 지칭.
>
> console.dir(this); -> 바로 html요소가 뜬다.
> console.dir($(this)); -> jQuery 요소! jQuery메소드를 사용할땐 이렇게 jQuery로 감싸주어야 한다.

> toggle : 있으면 빠지고, 없으면 넣어주니까



- 버튼에 마우스가 오버되었을때, 상단에 있는 이미지의 속성에 style 속성과 `width: 100px;`의 속성값을 부여한다.

```javascript
btn.on('mouseover',function() {
    $('img').attr('style', 'width: 100px;'); }); 
// 속성값 부여

$('img').attr('style');
 "width: 100px;"
// 속성값 가져오기 (1개만.)
```



- 텍스트 바꾸기 .text()

  - return <- 인자가 있는경우
  - set <- 인자가 없는경우에는 들어있는 innertext속성을 꺼내온다.

  > $(this).siblings().find("card-title").text("...")



- 버튼(요소)에 마우스가 오버(이벤트)됬을 때(이벤트 리스너), 이벤트가 발생한 버튼($(this))과 같은 수준(같은 부모를 갖는: siblings())이 아닌 상위 수준(parent()) 에 있는  요소 중에서 `.card-title`의 속성을 가진 친구를 찾아(find()) 텍스트를 변경(text())시킨다.

```javascript
btn.on('mouseover', function() {
   $(this).parent().find('.card-title').text("건들이는거 노노");
});

// find()는 하위수준에서 찾기 때문에 siblings가 아닌 parent()를 사용하여 상위수준으로 올려서 찾아야한다.
```



### 놀리기 텍스트 변환기(얼레리 꼴레리)

*index.html*

```html
<textarea id="input" placeholder="변환텍스트를 입력해주세요"></textarea>
<button class="translate">바꿔줘</button>
<h3></h3>
```

- input에 들어있는 text중에서 '관리' -> '고나리' 로, '확인' -> '호가인' 로 '훤하다' -> '허누하다' 의 방식으로 텍스를 오타로 바꾸는 이벤트핸들러 작성하기
  - ㅎ ㅜ ㅓ ㄴ 에서 두번째꺼랑 세번째꺼 바꿔주면 된다.
  - 1. 분해한 글자의 4번째요소가 있는지
    2.  2번째 3번째 요소가 모음인지
  - 분리 -> 순서바꾸기 -> 합치기

- https://github.com/e-/Hangul.js 에서 라이브러리를 받아서 자음과 모음을 분리하고 다시 단어로 합치는 기능을 살펴보기.
- `String.split('')`: `''`안에 있는것을 기준으로 문자열을 잘라준다. (return type: 배열)
- `.map(function(el){ })` : 배열을 순회하면서 하나의 요소마다 function을 실행시킴 (el : 순회하는 각 요소 ( 가변수 ), return type : 새로운 배열)
- `Array.join('')` : 배열에 들어있는 내용들을 `''`안에 있는 내용을 기준으로 합쳐준다.



#### 진행

1. 아톰을 킨다.
2. html양식을 완료한다 
3. Hangual.js을 그 폴더에 넣는다.
4. jQuery CDN을 설치한다

```html

<html>
  <head>
    <meta charset="utf-8">
    <title>얼레리 꼴레리</title>
    <script src="https://code.jquery.com/jquery-3.3.1.js" integrity="sha256-2Kok7MbOyxpgUVvAk/HJ2jigOSYS2auK4Pfzbm7uH60=" crossorigin="anonymous"></script>
  </head>
  <body>
    <h1> 놀리기 변환 </h1>
    <textarea id="input" placeholder="변환텍스트를 입력해주세요"></textarea><br/>
    <button class="translate">바꿔줘</button>
    <h3></h3>
    <script src="./hangul.js" type="text/javascript"></script>
    <script type="text/javascript">
      
    </script>
  </body>
</html>
```

> ​    <script scr="./translate.js" type="text/javascript"></script> 하면 스크립트 내용을 따로 뺄수있다.



5. textarea에 있는 내용물을 가지고 오는 코드

`    $('#input').val();` : 인자가 없을때는 내용물을 꺼내고, 인자가 있을때는 내용물을 인자값으로 집어넣고.

6. 버튼에 이벤트리스너(click)를 달아주고, 핸들러에는 1번에서 작성한 코드를 넣는다.

```html
    <script type="text/javascript">
      $('.translate').on('click', function() {
        var input = $('#input').val();
        console.log(input); 
      })
    </script>
```

7. 6번 코드의 결과물을 한글자씩 분해해서 배열로 만들어준다.

`console.log(Hangul.disassemble(input));`

8. 분해한 글자의 4번째요소가 있는지 && 2번째 3번째 요소가 모음인지
9. 2번째 3번재 모음의위치를 바꾸어준다.
10. 결과물로 나온 배열을 문자열로 이어준다(join 사용)

*translate.js*

```javascript
function translate(str){
  return str.split('').map(function(el){ //map : 하나씩 돌아가면서 조작
    // el. 을 가지고 조작합니다
    var d = Hangul.disassemble(el);
    console.log(d)
    if(d[3] && Hangul.isVowel(d[1]) && Hangul.isVowel(d[2])){
    var temp = d[2];
    d[2] = d[3];
    d[3] = temp;

    }
      return Hangul.assemble(d);
    }).join('');
}

```

11. 결과물을 출력해줄 요소를 찾는다. 
12. 요소에 결과물을 출력한다. -> 다음 결과물을 h2태그에 배치한다.

```html
<script src="./translate.js"></script>
<script type="text/javascript">
      $('.translate').on('click', function() {
        var input = $('#input').val();
	    var result = translate(input);
        $('h3').text(result);
        console.log(result);
      })
</script>
```



### Ajax

translate.js 에 있는 Function을 사용해보았다. 그렇다면 서버에 있는 액션은 어떻게 사용해야할까?

client < - > server (-> res 즉, 응답방식이 HTML이였을땐 화면전환이 있었다.) rails는 임의로 정해주지 않는한 req 와 res 의 파일은 같은 형식을 띈다. 즉, javascript로 응답을 보내면 페이지 전환이 있는것이 아니라, 어떠한 액션! 을 넣어주는것. 화면전환없이 서버에 요청을 보내고, 응답을 받을수있기 때문에 많이 사용한다.

즉, 서버에 요청을 javascript 타입으로 보내는것이 AJAX라고 할수있다.

>  rails 에서는 어느 메소드(액션)으로 보낼지 (=> routes )
>
> Ajax 에서 어디로 어떻게 보낼지 (=> url , Http method)

```javascript
$.ajax({
    url: 어느주소로 요청을 보낼지,
    method: 어떠한 HTTP method로 요청을 보낼지,
    data: {
    k: v 어떤 값을 함께 보낼지 (k,v로 구성),
   	// 서버에서는 params[k] => v
    
	}
}
```





- 좋아요 옵션 만들기
- 유저와 영화의 좋아요관계는 다대다 이므로 => 
  1. 모델생성

`binn02:~/watcha_app (master) $ rails g model like`

*~/watcha_app/db/migrate/20180704061215_create_likes.rb.rb*

```ruby
      t.integer :user_id
      t.integer :movie_id
```

2. 관계설정

*like.rb*

```ruby
    belongs_to :user
    belongs_to :movie
```

`movie.rb` 와` user.rb` 에서는 `has_many :likes` 랑     `has_many :users, through: :likes`해야하는데 이미 유저랑 무비가 다대다니까 중복이되쟈나

<< 해결방법 >>

1. 작성자이름만 movie가 갖게하여 다대다를 끊어주는거
2. 다대다 관계를 느슨하게 > movie.likes.count 로 세어주기만 하는 방법이 있어



1번 방법을 사용하였다.

*user.rb*

```ruby
  has_many :likes
  has_many :movies, through: :likes
```

*movie.rb*

```ruby
    has_many :likes
    has_many :users, through: :likes
```



script는 동적으로 불러와진다. 특정 버튼에 이벤트를 넣을때,  페이지가 완전히 다 로딩되었는지 알려주는 코드가 필요하다.

*show.html.erb*

```ruby
...
    
<script>
    $(document).on('ready',function(){
        
    });
</script>

```

> 문서가 다 로드됬을때 이벤트를 사용하겠다.	

1. 좋아요 버튼을 눌렀을때

```ruby
<script>
    $(document).on('ready',function(){
        $('.like').on('click', function(){
            
        })
    });
</script>
```



2. 서버에 요청을 보낸다. (현재 유저와 현재 보고있는 이 영화가 좋다고 하는 요청)

```ruby
<script>
    $(document).on('ready',function(){
        $('.like').on('click', function(){
            console.log("like~!") // 확인용
            $.ajax({
               url: '/likes' 
            });
        })
    });
</script>

```

*routes.rb* 에  ` get '/likes' => 'movies#like_movie'` 해주면 이런 에러가 뜬다

AbstractController::ActionNotFound (The action 'like_movie' could not be found for MoviesController): 

*movie_controller* 에 `   def like_movie end` 써준다. 이거와 같은이름의 `like_movie.js` 에서 alert하면 저 def가 실행될때 자동으로 같은이름의 자바스크립트도 읽을수있다.

하지만, 로그인하지않고 좋아요버튼을 누르면 401에러가 뜬다. -> 해결하기 위해서 filter를 설정

*movie_controller* 에서 `  before_action :js_authenticate_user!, only: [:like_movie]` 쓰기위해서!! *application_controller* 에서 `s_authenticate_user!` 를 설정했다.

1. 서버가 할 일
2. 응답이 오면 좋아요 버튼의 텍스트를 좋아요 취소로 바꾸고 `btn-info` -> `btn-warning text-whitle`로 바꿔준다.

```javascript
alert("좋아요 설정되쩡!");


//좋아요가 취소된 경우
// 좋아요 취소버튼 -> 좋아요 버튼으로 바꿔준다.
if (<%= @like.frozen? %>) {
$('.like').text("좋아요").toggleClass("btn-info btn-warning text-white");


}else{
//좋아요가 새로눌린 경우
// 좋아요 버튼 -> 좋아요 취소버튼으루~!~!

$('.like').text("좋아요 취소").toggleClass("btn-info btn-warning text-white");
}
```



