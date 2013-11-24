require_relative '../../Core/DataAccess/file_access'


class MemoryFlatFileHybrid
  include FileAccess

  attr_accessor :record_location

  def initialize
    @records = {}
    @index = {}
    @record_location = 'FlatFiles/'
  end

  def save_record record
    id = record[:id]
    keywords = record[:keywords]

    #add to index
    keywords.each {|k|add_to_index k,id}

    #don't need to save the aggregate keywords in each record again.
    record.delete(:keywords)

    #do we already have the id on file
    record_collection = pull_records_by id
    record_collection.push record
    save_records_by id, record_collection
  end

  def pull_index_partition keyword
    l = keyword.downcase.each_char.first
    if ('a'..'z').include? l
      i = @index[l]|| load_index(l)
    else
      i = @index['other']|| load_index('other')
    end
    i
  end

  def pull_ids_for keyword
    index = pull_index_partition keyword
    index[keyword] || []
  end

  def pull_records_by id
    l = id.downcase.each_char.first
    p = @records[l]|| load_records(l)
    p[id]||[]
  end

  def save_records_by id, records
    l = id.downcase.each_char.first
    p = @records[l]|| load_records(l)
    p[id] = records
  end

  def add_to_index keyword, id
    index = pull_index_partition keyword
    ids_for_keyword = index[keyword] || []
    ids_for_keyword.push id unless ids_for_keyword.include? id
    index[keyword]=ids_for_keyword
  end

  def snapshot_data
    index_keys = @index.keys
    index_keys.each {|k|save_to_file index_partition_filename(k), @index[k]}
    record_keys = @records.keys
    record_keys.each {|k|save_to_file record_partition_filename(k), @records[k]}
  end

  def record_partition_filename letter
    make_file_name __FILE__,@record_location+letter+'_record.index'
  end
  def index_partition_filename letter
    make_file_name __FILE__,@record_location+letter+'_keyword.index'
  end

  def load_index letter
    @index[letter] = (load_from_file index_partition_filename(letter)) || {}
    @index[letter]
  end

  def load_records letter
    @records[letter] = (load_from_file record_partition_filename letter) || {}
    @records[letter]
  end

  def purge_old_data
    index_keys = @index.keys
    index_keys.each {|k|@index[k]={}}
    record_keys = @records.keys
    record_keys.each {|k|@records[k]={}}
    snapshot_data
  end

end