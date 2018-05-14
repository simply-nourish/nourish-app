# /app/models/serialziers/measure_serializer.rb
# (unit of) Measure model serializer

class MeasureSerializer < ActiveModel::Serializer
  attributes :id, :name
end
