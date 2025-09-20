package com.syrder.bookstore_api.services;

import com.syrder.bookstore_api.domain.dto.BookDto;
import com.syrder.bookstore_api.domain.entities.BookEntity;

public interface BookService {

    BookEntity createBook(String isbn, BookEntity bookEntity);
}
