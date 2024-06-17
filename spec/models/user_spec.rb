require 'rails_helper'

RSpec.describe User, type: :model do
  it '有効なファクトリを持つこと' do
    expect(FactoryBot.build(:user)).to be_valid
  end
  it "is valid with a first name, last name, email, and password" do
    user = FactoryBot.build(:user)
    expect(user).to be_valid
  end

  it "名がなければ無効な状態であること" do
    user = FactoryBot.build(:user, first_name:nil)
    user.valid?
    expect(user.errors[:first_name]).to include("can't be blank")
  end
  it "姓がなければ無効な状態であること" do
    user = FactoryBot.build(:user, last_name: nil )
    user.valid?
    expect(user.errors[:last_name]).to include("can't be blank")
  end

  it "メールアドレスがなければ無効であること" do
    user = FactoryBot.build(:user,email:nil )
    user.valid?
    expect(user.errors[:email]).to include("can't be blank")
  end

  it "重複したメールアドレスなら無効な状態であること" do
    FactoryBot.create(:user, email:'hoge@example.com')
    user = FactoryBot.build(:user, first_name:"hoge", email:'hoge@example.com')
    user.valid?
    expect(user.errors[:email]).to include('has already been taken')
  end

  it "ユーザーのフルネームを⽂字列として返すこと" do
    user = FactoryBot.build(:user, first_name: 'john', last_name: 'Dope')
    expect(user.name).to eq "john Dope"
  end

  it "Projectが2つ作成されること" do
    user = FactoryBot.create(:user, :with_projects)
    expect(user.projects.length).to eq 2
  end
end
