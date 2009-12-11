#
# Helper class to manipulate database directly
# updated to use Grails version of blog database
#
class DBHelper
  DATABASE = 'wolfmanblog'
  Tables = [:posts, :comments, :tags, :categories, :posts_categories, :posts_tags, :users, :statics]

  attr_reader :db
  
  # setup database access
  def initialize(target=nil, debug=nil)
    if target.nil?
      @@target= ENV['testtarget'].nil? ? "test" : ENV['testtarget']
    else
      @@target= target
    end
    dburl= case @@target
           when 'test'
             "postgres://morris:test@localhost:5432/#{DATABASE}_test"
           when 'dev'
             "postgres://morris:test@localhost:5432/#{DATABASE}_dev"
           else
             raise 'Bad target must be one of test or dev'
           end

    @db= Sequel.connect(dburl)
    dblog= Logger.new($stdout)
    dblog.level= debug ? Logger::INFO : Logger::WARN
    @db.logger= dblog
  end

  def close
    @db.disconnect
  end

  def clean
    tables= Tables.collect {|t| t.to_s}
    @db.execute("TRUNCATE #{tables.join(',')} CASCADE")
    @db.execute("ALTER SEQUENCE posts_id_seq RESTART WITH 1")
  end

  def truncate(*table)
    tables= table.collect {|t| t.to_s}
    @db.execute("TRUNCATE #{tables.join(',')} CASCADE")
  end

  def add_user(name, password, salt)
    @db[:users] << {:name => name, :crypted_password => password, :date_created => Time.now.iso8601, :salt => salt, :version => 0}
  end

  def add_post(h)
    @db[:posts].insert(h.merge(:date_created => Time.now.iso8601, :last_updated => Time.now.iso8601, :guid => "guid:#{rand(1000000)}", :version => 0))
  end

  def add_comment(postid, comment, by)
    @db[:comments].insert(:post_id => postid, :body => comment, :name => by, :date_created => Time.now.iso8601, :last_updated => Time.now.iso8601, :version => 0)
  end

  def tag_post(postid, tag)
    r= @db[:tags].filter(:name => tag).first
    id= r.nil? ? @db[:tags].insert(:name => tag, :version => 0) : r[:id]
    @db[:posts_tags] << {:post_id => postid, :tag_id => id}
  end

  def categorize_post(postid, cat)
    r= @db[:categories].filter(:name => cat).first
    id= r.nil? ? @db[:categories].insert(:name => cat, :version => 0) : r[:id]
    @db[:posts_categories] << {:post_id => postid, :category_id => id}
  end
end
