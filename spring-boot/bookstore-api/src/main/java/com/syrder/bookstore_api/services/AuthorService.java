package com.syrder.bookstore_api.services;

import com.syrder.bookstore_api.domain.entities.AuthorEntity;

public interface AuthorService {
    AuthorEntity createAuthor(AuthorEntity authorEntity);
}
