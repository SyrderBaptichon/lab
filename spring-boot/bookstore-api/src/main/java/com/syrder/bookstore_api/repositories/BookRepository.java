package com.syrder.bookstore_api.repositories;

import com.syrder.bookstore_api.domain.Book;
import org.springframework.data.repository.CrudRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface BookRepository extends CrudRepository<Book, String> {
}
