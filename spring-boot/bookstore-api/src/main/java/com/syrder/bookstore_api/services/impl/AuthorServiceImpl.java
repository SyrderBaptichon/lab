package com.syrder.bookstore_api.services.impl;

import com.syrder.bookstore_api.domain.entities.AuthorEntity;
import com.syrder.bookstore_api.repositories.AuthorRepository;
import com.syrder.bookstore_api.services.AuthorService;
import org.springframework.stereotype.Service;

@Service
public class AuthorServiceImpl  implements AuthorService {

    private AuthorRepository authorRepository;

    public AuthorServiceImpl(AuthorRepository authorRepository) {
        this.authorRepository = authorRepository;
    }

    @Override
    public AuthorEntity createAuthor(AuthorEntity authorEntity) {
        return authorRepository.save(authorEntity);
    }
}
