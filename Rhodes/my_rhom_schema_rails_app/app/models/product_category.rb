class ProductCategory < ActiveRecord::Base

  belongs_to :brand
  has_many :items
end
