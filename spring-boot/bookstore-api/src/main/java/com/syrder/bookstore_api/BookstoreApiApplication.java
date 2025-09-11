package com.syrder.bookstore_api;

import lombok.extern.java.Log;
import org.springframework.boot.CommandLineRunner;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.jdbc.core.JdbcTemplate;

import javax.sql.DataSource;

@SpringBootApplication
public class BookstoreApiApplication {

    public static void main(String[] args) {
		SpringApplication.run(BookstoreApiApplication.class, args);
	}
}
