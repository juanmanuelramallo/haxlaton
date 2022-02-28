# == Schema Information
#
# Table name: matches
#
#  id         :bigint           not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Match < ApplicationRecord
  has_one_attached :recording
end
