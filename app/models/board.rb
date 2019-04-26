class Board < ApplicationRecord

  acts_as_url :title

  include PgSearch
  multisearchable against: [:title, :description]

  after_save :reindex

  belongs_to :user

  has_many :links
  has_many :collaborations
  has_many :collaborators, class_name: "User", through: :collaborations
  has_many :collaborations, foreign_key: "collaborator_id"
  has_many :collabs, foreign_key: "collaboratee_id"

  validates :title, presence: true
  validates :url, uniqueness: true

  default_scope { order(title: "ASC") }
  scope :published, -> { where(published: true) }
  scope :ordered_by_title, -> { reorder(title: :asc) }

  def to_param
    id.to_s + "-" + url
  end

  private
  def reindex
    PgSearch::Multisearch.rebuild(Board)
  end

end
