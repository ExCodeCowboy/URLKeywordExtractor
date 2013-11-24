require_relative '../../Core/DataAccess/file_access'

class MemoryFlatFileHybrid
  include FileAccess

  def initialize
    @index_file_name = make_file_name __FILE__,'FlatFiles/keyword.index'
    @records_file_name = make_file_name __FILE__,'FlatFiles/records.index'

    @record_location = 'FlatFiles/'
    load_index
    load_records
  end

  def save_record record
    p record
    id = record[:id]
    keywords = record[:keywords]

    #add to index
    keywords.each {|k|add_to_index k,id}

    #don't need to save the aggregate keywords in each record again.
    record.delete(:keywords)

    #do we already have the id on file
    record_collection = pull_records_by id
    record_collection.push record
    @records[id] = record_collection

  end

  def pull_ids_for keyword
    @index[keyword]||[]
  end

  def pull_records_by id
    @records[id] || []
  end

  def add_to_index keyword, id
    ids_for_keyword = @index[keyword] || []
    ids_for_keyword.push id unless ids_for_keyword.include? id
    @index[keyword]=ids_for_keyword
  end

  def snapshot_data
    save_to_file @index_file_name, @index
    save_to_file @records_file_name, @records
  end

  def load_index
    @index = (load_from_file @index_file_name) || {}
  end

  def load_records
    @records = (load_from_file @records_file_name) || {}
  end

  def purge id
    @records.delete(id)
  end

  def purge_old_data
    save_to_file @index_file_name,{}
    save_to_file @records_file_name, {}
    load_index
    load_records
  end

  def id_filename id
    make_file_name(__FILE__, @record_location+id+".record")
  end

end