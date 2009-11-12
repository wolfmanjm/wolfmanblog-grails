package com.e4net.hibernate.dialect;

import org.hibernate.dialect.PostgreSQLDialect;

public class PostgreSQL82Dialect extends PostgreSQLDialect {

	public PostgreSQL82Dialect() {
		
	}

	public boolean supportsInsertSelectIdentity() {
		return true;
	}
	
	public String appendIdentitySelectToInsert(String insertString) {
		return insertString + " RETURNING id";
	}
}
