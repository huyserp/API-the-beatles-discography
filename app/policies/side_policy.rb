class SidePolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def create?
    !user.nil?
  end

  def destroy?
    record.album.user == user
  end
end
