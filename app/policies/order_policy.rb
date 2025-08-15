class OrderPolicy < ApplicationPolicy
    def show?
      user == record.user || user.admin?
    end

    def create?
        user.present?  # Any logged-in user can create an order
      end

      def update?
        user == record.user && record.status == "cart" || user.admin?  # Owner can update if in cart; admin always
      end

      def destroy?
        user.admin?  # Only admins can delete orders
      end

      def checkout?
        update?  # Reuse update? logic for checkout
      end

      def complete?
        update?  # Similar
      end

      # Scope for collections (e.g., index)
      class Scope < Scope
        def resolve
          if user.admin?
            scope.all  # Admins see all orders
          else
            scope.where(user: user)  # Users see only their own
          end
        end
      end
end
