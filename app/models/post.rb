class Post < ApplicationRecord
  validates_presence_of :body
  validates_presence_of :tone

  has_many :reactions
  belongs_to :day
  belongs_to :user

  def reaction_by_user(user, category)
    reactions.find_by(user: user, category: category)
  end

  def add_reaction(user, category)
    reaction = Reaction.new(user: user, category: category)
    reactions << reaction
    destroy_opposite_reaction(user, reaction)
  end

  private

    def destroy_opposite_reaction(user, reaction)
      opposite = reactions.find_by(category: reaction.opposite, user: user)
      reactions.destroy(opposite) if opposite
    end
end
