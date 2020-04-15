require 'rails_helper'

RSpec.describe 'Posts index -', type: :feature do
  describe 'Registered user in a group' do
    before(:each) do
      group_1 = create(:group, name: 'Mod 1')
      group_2 = create(:group, name: 'Mod 2')
      user = create(:user, group: group_1)
      day_1 = create(:day, week: 1, day_of_week: 1, group: group_1)
      day_2 = create(:day, week: 1, day_of_week: 1, group: group_2)
      day_3 = create(:day, week: 1, day_of_week: 2, group: group_1)
      create(:post, day: day_1, user: user)
      create(:post, day: day_1, user: user)
      create(:post, day: day_1, user: user)
      create(:post, day: day_2)
      create(:post, day: day_3, user: user)
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
      allow_any_instance_of(ApplicationController).to receive(:day_today).and_return(day_1)

      visit posts_path
    end

    it 'sees a list of all posts belonging to that group' do
      expect(page).to_not have_link("Click to see post #{Post.fourth.id}'s info.")
      expect(page).to_not have_link("Click to see post #{Post.fifth.id}'s info.")
      expect(page).to have_link("Click to see post #{Post.first.id}'s info.")
      expect(page).to have_link("Click to see post #{Post.second.id}'s info.")
      expect(page).to have_link("Click to see post #{Post.third.id}'s info.")
      expect(page).to have_content(Post.first.body)
    end

    it "can click a link to see a post's show page" do
      click_link("Click to see post #{Post.first.id}'s info.")

      expect(current_path).to eq(post_path(Post.first.id))
    end
  end
end
