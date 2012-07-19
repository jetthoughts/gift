#
# If a field is nullable and if user hits spacebar a few times and submits
# the form then ActiveRecord would have the value as empty spaces.
#
# Following fix would remove all leading and trailing white spaces from a string value.
# And if the value is empty space then it will be set to nil.
#
# It would result in value being saved as NULL if user passed only a few white spaces.
#
module ActiveRecord
  class Base
    before_validation do |record|
      record.attributes.each do |attr, value|
        record[attr] = value.blank? ? nil : value.strip if value.respond_to?(:strip)
      end
    end
  end
end
