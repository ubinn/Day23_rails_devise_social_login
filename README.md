## Day23_180713

### devise gem을 이용한 소셜로그인

- 구글로그인

		https://github.com/zquestz/omniauth-google-oauth2

 1. gem 설치 `gem 'omniauth-google-oauth2'`

	2. '[https://console.developers.google.com](https://console.developers.google.com/)'  가서 API 생성

	3.  OAuth 2.0 클라이언트 ID 다운받기

	4. *devise.rb* 에OmniAuth 부분에 `   config.omniauth :google_oauth2, ENV['GOOGLE_CLIENT_ID'], ENV['GOOGLE_CLIENT_SECRET'], {}` 추가 

	5. *application.yml* 에다가 피가로로 구글클라이언트아이디랑 시크릿키 입력

	6. *devise.rb* 에 

    ```ruby
      config.omniauth :google_oauth2, ENV['GOOGLE_CLIENT_ID'], ENV['GOOGLE_CLIENT_SECRET'], 
      {
        scope: 'email',
        prompt: 'select_account'
      }
    ```

	7. devise model에 custom_column 추가하기 : `rails g migration add_columns_to_users`

	8. *~/watcha_app/db/migrate/20180713013101_add_columns_to_users.rb*

    ```ruby
    class AddColumnsToUsers < ActiveRecord::Migration[5.0]
      def change
        #  add_column :DB명(복수), :컬럼명, :타입
        add_column :users, :provider,   :string # 이 정보를 어디서 받아왔냐를 담고있는 애
        add_column :users, :name,       :string
        add_column :users, :uid,        :string # 토큰! 얘는 인증받은 유저임을 알려주는 토큰
    
      end
    end
    
    ```

	9. `rake db:migrate`

	10. *user.rb* 에 

     ```ruby
       devise :database_authenticatable, :registerable,
              :recoverable, :rememberable, :trackable, :validatable, :omniauthable, omniauth_providers: [:google_oauth2]
     ```

     > `:omniauthable, omniauth_providers: [:google_oauth2]` 을 추가.
     >
     >

	11. routes.rb 설정

     ```ruby
     Rails.application.routes.draw do
       mount RailsAdmin::Engine => '/ahctaw', as: 'rails_admin'
       devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }
       root 'movies#index'
       
     ```

     >  `devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }` 붙여넣기

	12. 여기까지 했으면 로그인창에서 버튼하나생기고, 구글창으로는 넘어가는게 보입니다. (로그인을 실제로는 할수는없지만)

     > **Error: redirect_uri_mismatch**  페이지로 넘어가욤.

     - call back uri 설정이랑
     - callbacks controller  셋업

	13. **Error: redirect_uri_mismatch** 에 있는callback uri를  구글 APIs 의 서비스에 callback uri를 넣어준다.

     > https://my-second-rails-app-binn02.c9users.io/users/auth/google_oauth2/callback 

	14. 그러고 나서 다시 나의 페이지의 구글로그인으로 들어가보면 계정선택하는 페이지로 잘 연결되는것을볼수있다.

     하지만 클릭하면 라우팅에러

     > Started GET "/users/auth/google_oauth2" 이 패스를 지정해준 라우팅이 없어서 에러뿜뿜

	15.  https://github.com/plataformatec/devise 에서 보고, `rails g devise:controllers users` 해주면 다음과 같은 controller들이 생성

     >       create  app/controllers/users/confirmations_controller.rb
     >       create  app/controllers/users/passwords_controller.rb
     >       create  app/controllers/users/registrations_controller.rb
     >       create  app/controllers/users/sessions_controller.rb
     >       create  app/controllers/users/unlocks_controller.rb
     >       create  app/controllers/users/omniauth_callbacks_controller.rb

> ~/watcha_app/app/controllers/users 밑에 controller가 생성된것을 볼수있죠

16. *~/watcha_app/app/controllers/users/omniauth_callbacks_controller.rb*에 

    ```ruby
    
        def google_oauth2
          # You need to implement the method below in your model (e.g. app/models/user.rb)
          p request.env['omniauth_auth']
          @user = User.from_omniauth(request.env['omniauth.auth'])
          if @user.persisted?
            flash[:notice] = I18n.t 'devise.omniauth_callbacks.success', kind: 'Google'
            sign_in_and_redirect @user, event: :authentication
          else
            session['devise.google_data'] = request.env['omniauth.auth'].except(:extra) # Removing extra as it can overflow some session stores
            redirect_to new_user_registration_url, alert: @user.errors.full_messages.join("\n")
          end
        end
        
    ```

    > 선언

17. user.rb 에 다음과 같이 클래스메소드 선언.

```ruby
def self.from_omniauth(access_token)
    data = access_token.info
    user = User.where(email: data['email']).first
        # Uncomment the section below if you want users to be created if they don't exist
     unless user
    #     user = User.create(name: data['name'],
    #        email: data['email'],
    #        password: Devise.friendly_token[0,20]
    #     )
    # end
    user
  end
```

> 우리는 구글이메일로 로그인한 유저의 아이디를 만들어주지않았으므로, 저 주석은 해제하고, 우리의 양식에 맞게 몇개를 더 추가해주자

```ruby
 def self.from_omniauth(access_token)
    data = access_token.info
    user = User.where(email: data['email']).first
        # Uncomment the section below if you want users to be created if they don't exist
    unless user
        user = User.create(name: data['name'],
            email: data['email'],
            password: Devise.friendly_token[0,20],
            provider: access_token.provider,
            uid: access_token.uid
        )
    end
    user
  end
```

> 토큰의 provider와 uid까지 저장을 시키쟈

```ruby
SQL (0.4ms)  INSERT INTO "users" ("email", "encrypted_password", "created_at", "updated_at", "provider", "uid") VALUES (?, ?, ?, ?, ?, ?)  [["email", "rmhg5140@naver.com"], ["encrypted_password", "$2a$11$ussFyqDWkDyAGOYt2MHWAu7xjqwGLbX5lgC/blH2MBSv.TdqY1pHa"], ["created_at", "2018-07-13 02:37:03.837486"], ["updated_at", "2018-07-13 02:37:03.837486"], ["provider", "google_oauth2"], ["uid", "110443456264759351970"]]
   (7.5ms)  commit transaction
   (0.1ms)  begin transaction
  SQL (1.0ms)  UPDATE "users" SET "sign_in_count" = ?, "current_sign_in_at" = ?, "last_sign_in_at" = ?, "current_sign_in_ip" = ?, "last_sign_in_ip" = ?, "updated_at" = ? WHERE "users"."id" = ?  [["sign_in_count", 1], ["current_sign_in_at", "2018-07-13 02:37:03.848877"], ["last_sign_in_at", "2018-07-13 02:37:03.848877"], ["current_sign_in_ip", "222.107.238.15"], ["last_sign_in_ip", "222.107.238.15"], ["updated_at", "2018-07-13 02:37:03.850782"], ["id", 2]]
   (17.9ms)  commit transaction
```

> 다음과 같이 유저가 저장된것을 볼수있다.



- 카카오톡 로그인

1. https://developers.kakao.com/apps/212041/settings/user 에서 앱 프로젝트 하나 만들고, 개요에서 사용자관리에서 동의로 바꿔준다.

2. 플랫폼 만들고, 사이트 도메인해주고, 리다이렉트 패스에다가 콜팩을 받는 url를 써줘야한다.

3.  devise_scope 사용해서 콜백uri만들기

   *routes.rb*

   ```ruby
     devise_scope :user do
       get 'users/auth/kakao', to: 'users/omniauth_callbacks#kakao'
       get '/users/auth/kakao/callback', to: 'users/omniauth_callbacks#kakao_auth'
     end
   ```

4. 카카오톡 홈페이지로 다시 돌아와서 플랫폼의 redirect path 에 `/users/auth/kakao/callback` 을 작성해준다.

5. https://developers.kakao.com/docs/restapi/tool 카카오톡 개발가이드의 REST API도구에서 계정로그인

   > 한번에 인증되는 구글과는 달리, 두번받아야 사용자이메일을받을수있어

6. *application.yml* 에서 `KAKAO_REST_API_KEY` 추가하기

7. `rails g devise:views`

8. *~/watcha_app/app/views/devise/sessions/new.html.erb* 에서 카카오톡 로그인버튼 넣어주자

   ```ruby
   <%= link_to 'Sign in with kakao','users_auth_kakao_path' -%><br/>
    <!---%> ㅎㅏ면 줄바꿈이 된다-->
   ```

9. *~/watcha_app/app/controllers/users/omniauth_callbacks_controller.rb*

   ```ruby
    def kakao
         redirect_to "https://kauth.kakao.com/oauth/authorize?client_id=#{ENV['KAKAO_REST_API_KEY']}&redirect_uri=https://my-second-rails-app-binn02.c9users.io/users/auth/kakao/callback&response_type=code"
       end 
   ```

10. *~/watcha_app/app/controllers/users/omniauth_callbacks_controller.rb*

    ```ruby
    def kakao_auth
          code = params[:code]
          base_url = "https://kauth.kakao.com/oauth/token"
          base_response = RestClient.post(base_url, {grant_type: 'authorization_code',
                                                     client_id: ENV['KAKAO_REST_API_KEY'],
                                                     redirect_uri: 'https://my-second-rails-app-binn02.c9users.io/users/auth/kakao/callback',
                                                     code: code})
          puts base_response
          res = JSON.parse(base_response)
          access_token = res["access_token"]
        end
    ```

    > base_response에서 받은 access_token을꺼내야해

11. https://developers.kakao.com/docs/restapi/tool 개발가이드의 REST API도구중 사용자정보요청에서

    ```ruby
        def kakao_auth
          code = params[:code]
          base_url = "https://kauth.kakao.com/oauth/token"
          base_response = RestClient.post(base_url, {grant_type: 'authorization_code',
                                                     client_id: ENV['KAKAO_REST_API_KEY'],
                                                     redirect_uri: 'https://my-second-rails-app-binn02.c9users.io/users/auth/kakao/callback',
                                                     code: code})
          puts base_response
          res = JSON.parse(base_response)
          access_token = res["access_token"]
          info_url = "https://kapi.kakao.com/v2/user/me"
          info_response = RestClient.get(info_url, Authorization: "Bearer #{access_token}")
          @user = User.from_omniauth_kakao(JSON.parse(info_response))
        end
    ```

    12. *user.rb*

        ```ruby
          def self.from_omniauth(access_token)
            data = access_token.info
            user = User.where(email: data['email']).first
                # Uncomment the section below if you want users to be created if they don't exist
            unless user
                user = User.create(name: data['name'],
                    email: data['email'],
                    password: Devise.friendly_token[0,20],
                    provider: access_token.provider,
                    uid: access_token.uid
                )
            end
            user
          end
        ```

    13.  *omniauth_callbacks_controller.rb* 에서 def kakao_auth 에 

        ```ruby
              if @user.persisted?
                flash[:notice] = "카카오 로그인에 성공했습니다."
                sign_in_and_redirect @user, event: :authentication
              else
                flash[:notice] = "카카오 로그인에 실패했습니다. 다시 시도해주세요."
                redirect_to new_user_session_path
              end
              
        ```


    ​    
