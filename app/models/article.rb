class Article < ApplicationRecord
    
    belongs_to  :user
    has_many    :comments
    
    validates :title,   presence: true
    validates :content, presence: true
    validates :slug,    presence: true, uniqueness: { case_sensitive: true }
    
    scope :recent, -> {order(created_at: :desc)}
end
