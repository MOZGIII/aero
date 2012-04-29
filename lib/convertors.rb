# coding: UTF-8
module Convertors
  def Convertors.controller_file_to_class_name(file)
    File.basename(file)[0..-14].split(/_/).map{ |i| i.capitalize }.join
  end

  def Convertors.controller_file_to_full_class_name(file)
    File.basename(file)[0..-4].split(/_/).map{ |i| i.capitalize }.join
  end

  def Convertors.controller_file_to_dir(file)
    File.basename(file)[0..-14]
  end

  def Convertors.full_class_name_to_dir(class_name)
    Convertors.class_name_to_controller_dir(File.basename(class_name.to_s)[0..-11])
  end

  def Convertors.class_name_to_controller_file(class_name)
    class_name.to_s.gsub(/(\W)/, '_\1').downcase + '_controller.rb'
  end

  def Convertors.class_name_to_controller_dir(class_name)
    class_name.to_s.gsub(/(\W)/, '_\1').downcase
  end
end
