class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user (not logged in)

    if user.admin?
      can :manage, :all
    elsif user.id.present?
      can :create, [Order, Rank]
      can :read, Order
      can :read, Product
      can :update, User, id: user.id
      can :update, Rank
    else
      can :read, Product
      can :create, User
      cannot :create, [Order, Rank]
    end
  end
end
