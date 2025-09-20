package com.syrder.bookstore_api.services.impl;

import com.syrder.bookstore_api.domain.entities.BookEntity;
import com.syrder.bookstore_api.repositories.BookRepository;
import com.syrder.bookstore_api.services.BookService;
import org.springframework.stereotype.Service;

@Service
public class BookServiceImpl implements BookService {

    private BookRepository bookRepository;

    public BookServiceImpl(BookRepository bookRepository) {
        this.bookRepository = bookRepository;
    }

    @Override
    public BookEntity createBook(String isbn, BookEntity bookEntity) {
        bookEntity.setIsbn(isbn);
        return bookRepository.save(bookEntity);
    }
}
