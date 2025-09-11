package com.syrder.bookstore_api.repositories;

import com.syrder.bookstore_api.TestDataUtil;
import com.syrder.bookstore_api.domain.Author;
import com.syrder.bookstore_api.domain.Book;
import org.assertj.core.api.Assertions;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.annotation.DirtiesContext;
import org.springframework.test.context.junit.jupiter.SpringExtension;

import java.util.Optional;

import static org.assertj.core.api.Assertions.assertThat;

@SpringBootTest
@ExtendWith(SpringExtension.class)
@DirtiesContext(classMode = DirtiesContext.ClassMode.AFTER_EACH_TEST_METHOD)
public class BookRepositoryIntegrationTests {

    private BookRepository underTest;

    @Autowired
    public BookRepositoryIntegrationTests(BookRepository underTest) {
        this.underTest = underTest;
    }

    @Test
    public void testThatBookCanBeCreatedAndRecalled() {
        Author author = TestDataUtil.createTestAuthorA();

        Book book = TestDataUtil.createTestBookA(author);
        Book savedBook = underTest.save(book);

        Optional<Book> result = underTest.findById(book.getIsbn());

        assertThat(result).isPresent();
        assertThat(result.get()).isEqualTo(savedBook);
    }

    @Test
    public void testThatMultipleBooksCanBeCreateddAndRecalled() {
        Author author = TestDataUtil.createTestAuthorA();

        Book bookA = TestDataUtil.createTestBookA(author);
        Book savedBookA = underTest.save(bookA);

        Book bookB = TestDataUtil.createTestBookB(author);
        Book savedBookB = underTest.save(bookB);

        Book bookC = TestDataUtil.createTestBookC(author);
        Book savedBookC = underTest.save(bookC);

        Iterable<Book> result = underTest.findAll();
        assertThat(result)
                .hasSize(3)
                .containsExactly(savedBookA,savedBookB,savedBookC);
    }

    @Test
    public void testThatBookCanBeUpdated() {
        Author author = TestDataUtil.createTestAuthorA();

        Book bookA = TestDataUtil.createTestBookA(author);
        Book savedBookA = underTest.save(bookA);

        Book bookB = TestDataUtil.createTestBookB(author);
        Book savedBookB = underTest.save(bookB);

        Optional<Book> result = underTest.findById(bookA.getIsbn());
        assertThat(result).isPresent();
        assertThat(result.get()).isEqualTo(savedBookA);
    }

    @Test
    public void testThatBookCanBeDeleted() {
        Author author = TestDataUtil.createTestAuthorA();

        Book bookA = TestDataUtil.createTestBookA(author);
        underTest.save(bookA);

        underTest.delete(bookA);

        Optional<Book> result = underTest.findById(bookA.getIsbn());
        assertThat(result).isEmpty();
    }
}
