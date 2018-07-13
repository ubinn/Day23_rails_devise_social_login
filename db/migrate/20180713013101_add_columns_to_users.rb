class AddColumnsToUsers < ActiveRecord::Migration[5.0]
  def change
    #  add_column :DB명(복수), :컬럼명, :타입
    add_column :users, :provider,   :string # 이 정보를 어디서 받아왔냐를 담고있는 애
    add_column :users, :name,       :string
    add_column :users, :uid,        :string # 토큰! 얘는 인증받은 유저임을 알려주는 토큰
    
  end
end
