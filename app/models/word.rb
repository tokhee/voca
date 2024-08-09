# frozen_string_literal: true
class Word < ApplicationRecord

  has_many :taggings
  has_many :tags, through: :taggings
  accepts_nested_attributes_for :tags

  belongs_to :user
  has_many :similars, dependent: :destroy
  accepts_nested_attributes_for :similars, allow_destroy: true


  has_and_belongs_to_many :tags, optional: true, dependent: :destroy
  has_many :questions
  validates :title, presence: true
  validates :mean, presence: true


end
