require 'rails_helper'

RSpec.describe Project, type: :model do
  describe 'validation' do
    it 'プロジェクトの名前がある場合は有効' do
      project = FactoryBot.build(:project)

      project.valid?
      expect(project).to be_valid
    end

    it 'プロジェクトの名前が無い場合は無効' do
      project = FactoryBot.build(:project, name: nil)

      project.valid?
      expect(project.errors[:name]).to include("can't be blank")
    end
  end

  it "ユーザー単位では重複したプロジェクト名を許可しないこと" do
    user = FactoryBot.create(:owner)

    # FactoryBot.create(:project, owner: user)
    user.projects.create(
      name: "Test Project",
      )

    # new_project = FactoryBot.build(:project, owner:user)
    new_project = user.projects.build(
      name: "Test Project",
      )

    new_project.valid?
    expect(new_project.errors[:name]).to include("has already been taken")
  end

  it "⼆⼈のユーザーが同じ名前を使うことは許可すること" do
    user = FactoryBot.create(:owner)

    user.projects.create(
      name: "Test Project",
      )

    other_user = FactoryBot.create(:owner, first_name:"Jane", last_name:"Tester")

    other_project = other_user.projects.build(
      name: "Test Project",
      )
    expect(other_project).to be_valid
  end

  it "たくさんのメモが作成されること" do
    project = FactoryBot.create(:project, :with_notes)
    expect(project.notes.length).to eq 5
  end

  # 遅延ステータス
  describe "late status" do
    # 締切⽇が過ぎていれば遅延していること
    it "is late when the due date is past today" do
      project = FactoryBot.create(:project, :due_yesterday)
      expect(project).to be_late
    end
    # 締切⽇が今⽇ならスケジュールどおりであること
    it "is on time when the due date is today" do
      project = FactoryBot.create(:project, :due_today)
      expect(project).to_not be_late
    end

    # 締切⽇が未来ならスケジュールどおりであること
    it "is on time when the due date is in the future" do
      project = FactoryBot.create(:project, :due_tomorrow)
      expect(project).to_not be_late
    end
  end
end
