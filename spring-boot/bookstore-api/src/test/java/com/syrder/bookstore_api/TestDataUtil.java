package com.syrder.bookstore_api;

import com.syrder.bookstore_api.domain.Author;

public class TestDataUtil {
    private TestDataUtil() {}

    public static Author createTestAuthorA() {
        return Author.builder()
                .id(1L)
                .name("Abigail Rose")
                .age(80)
                .build();
    }

    public static Author createTestAuthorB() {
        return Author.builder()
                .id(2L)
                .name("Thomas Cronin")
                .age(50)
                .build();
    }

    public static Author createTestAuthorC() {
        return Author.builder()
                .id(3L)
                .name("John Smith")
                .age(40)
                .build();
    }

}
