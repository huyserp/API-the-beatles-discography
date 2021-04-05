class TrackPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def create?
    !user.nil?
  end

  def update?
    record.album.user == user
  end

  def destroy?
    update?
  end
end
