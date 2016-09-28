class Ability
  include CanCan::Ability

  def initialize(user, params)
    # Define abilities for the passed in user here. For example:
    #
    #   user ||= User.new # guest user (not logged in)
    #   if user.admin?
    #     can :manage, :all
    #   else
    #     can :read, :all
    #   end
    #
    # The first argument to `can` is the action you are giving the user 
    # permission to do.
    # If you pass :manage it will apply to every action. Other common actions
    # here are :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on. 
    # If you pass :all it will apply to every resource. Otherwise pass a Ruby
    # class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the
    # objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details:
    # https://github.com/ryanb/cancan/wiki/Defining-Abilities
    #
    can [:update, :images, :delete_image], Property if user.can_manage_property?(params[:id])
    can [:index, :show], User if user.superuser?
    can [:update], Contact if user.can_manage_contact?(params[:id])
    can [:update, :destroy], User if user.can_manage_user?(params[:id])

    #whitelist unauthorized endpoints
    can [:me], User
    can [:facets, :filtered_results, :show, :user], Property
    can [:show, :create, :update], Contact
    can [:authenticate], :licensing
    can [:create], :payment
  end
end
