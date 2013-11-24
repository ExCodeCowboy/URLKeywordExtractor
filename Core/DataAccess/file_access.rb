module FileAccess
  def make_file_name class_path, filename
    File.join(File.expand_path(File.dirname(class_path)),filename)
  end

  def load_from_file filename
    object = nil
    if File.exist? filename
      object = File.open(filename, "rb") {|f| Marshal.load(f)}
    end
    return object
  end

  def save_to_file filename, object
    File.open(filename, "wb") {|io| Marshal.dump(object, io)}
  end

end