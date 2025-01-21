class Task < ApplicationRecord
    belongs_to :user
    validates :title, presence: true
    validates :due_date, presence: true
    validate :valid_due_date
    enum status: { pending: 0, in_progress: 1, completed: 2 }

    private

    def valid_due_date
        if due_date.present? && due_date <= Date.today
            errors.add(:due_date, "is not valid!")
        end
    end
end
