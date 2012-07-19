# this is neeed to make attach_picture work
class FilelessIO < StringIO
  attr_accessor :original_filename
end
