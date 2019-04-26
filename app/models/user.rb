class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :boards
  has_many :links

  has_many :collaborations, foreign_key: "user_id"
  has_many :shared_boards, through: :collaborations, source: :board

  has_many :collabs, foreign_key: "collaboratee_id", class_name: "Collaboration"

  validates :nickname, presence: true
  validates :nickname, uniqueness: true

  mount_uploader :avatar, AvatarUploader
end
