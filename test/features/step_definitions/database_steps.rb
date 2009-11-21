#
# Direct database manipulation, used for setting up database for tests
#
Given 'The database table $table is truncated' do |t|
  @db.truncate(t)
end

# we collect the parameters for each table and apply them at one time
Given 'The database contains:' do |data|
  tables= {}
  data.hashes.each do |h| 
    tab= h['table'].to_sym
    col= h['column'].to_sym
    val= h['value']
    tables[tab] ||= {}
    tables[tab].merge!(col => val)
  end

  tables.each { |k,v|
    puts "Setting database table #{k} with #{v.inspect}"
  }
end
