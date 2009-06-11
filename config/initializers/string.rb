class String
  def remove_diacritic
    ActiveSupport::Multibyte::Chars.new(self).normalize(:kd).to_s.gsub(/[^\x00-\x7F]/, '')
  end
end