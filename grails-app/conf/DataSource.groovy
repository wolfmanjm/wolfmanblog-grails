dataSource {
	pooled = true
	driverClassName = "org.hsqldb.jdbcDriver"
	username = "sa"
	password = ""
}
hibernate {
    cache.use_second_level_cache=true
    cache.use_query_cache=true
    cache.provider_class='com.opensymphony.oscache.hibernate.OSCacheProvider'
}
// environment specific settings
environments {
// 	development {
// 		dataSource {
// 			dbCreate = "update" // one of 'create', 'create-drop','update'
// 			url = "jdbc:hsqldb:file:devDB;shutdown=true"
// 		}
// 	}
	development {
		dataSource {
			dbCreate = "update" // one of 'create', 'create-drop','update'
			url = "jdbc:postgresql://localhost/wolfmanblog_dev"
                        driverClassName = "org.postgresql.Driver"
                        dialect = 'com.e4net.hibernate.dialect.PostgreSQL82Dialect'
                        logSql = true
                        username = "morris"
                        password = "test"
		}
	}
	test {
//		dataSource {
//			dbCreate = "create-drop"
//			url = "jdbc:hsqldb:mem:testDb"
//		}
		dataSource {
			dbCreate = "create-drop" // one of 'create', 'create-drop','update'
			url = "jdbc:postgresql://localhost/wolfmanblog_dev"
                        driverClassName = "org.postgresql.Driver"
                        dialect = 'com.e4net.hibernate.dialect.PostgreSQL82Dialect'
                        logSql = true
                        username = "morris"
                        password = "test"
		}

	}
	production {
		dataSource {
			dbCreate = "update"
			url = "jdbc:hsqldb:file:prodDb;shutdown=true"
		}
	}
}
