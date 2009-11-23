dataSource {
	pooled = true
	driverClassName = "org.postgresql.Driver"
	dialect = 'com.e4net.hibernate.dialect.PostgreSQL82Dialect'
	username = "morris"
	password = "test"
}
hibernate {
    cache.use_second_level_cache=true
    cache.use_query_cache=true
    cache.provider_class='com.opensymphony.oscache.hibernate.OSCacheProvider'
}
// environment specific settings
environments {
	development {
		dataSource {
			dbCreate = "" // one of 'create', 'create-drop','update'
			url = "jdbc:postgresql://localhost/wolfmanblog_dev"
                        logSql = true
		}
	}
	test {
		dataSource {
			dbCreate = "" // one of 'create', 'create-drop','update'
			url = "jdbc:postgresql://localhost/wolfmanblog_test"
                        logSql = true
		}

	}
	production {
		dataSource {
			dbCreate = "" // one of 'create', 'create-drop','update'
			url = "jdbc:postgresql://localhost/wolfmanblog_production"
                        logSql = false
		}
	}
}
