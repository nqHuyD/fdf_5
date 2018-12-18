class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user (not logged in)
    if user.admin?
      can :manage, :all
    elsif user.id.present?
      can :create, [Order, Rank]
      can :update, Rank
      can :read, Product
    end
  end
end
