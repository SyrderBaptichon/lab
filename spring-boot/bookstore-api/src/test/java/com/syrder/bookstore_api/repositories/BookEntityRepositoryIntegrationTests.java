package com.syrder.bookstore_api.repositories;

import com.syrder.bookstore_api.TestDataUtil;
import com.syrder.bookstore_api.domain.entities.AuthorEntity;
import com.syrder.bookstore_api.domain.entities.BookEntity;
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
public class BookEntityRepositoryIntegrationTests {

    private BookRepository underTest;

    @Autowired
    public BookEntityRepositoryIntegrationTests(BookRepository underTest) {
        this.underTest = underTest;
    }

    @Test
    public void testThatBookCanBeCreatedAndRecalled() {
        AuthorEntity authorEntity = TestDataUtil.createTestAuthorA();

        BookEntity bookEntity = TestDataUtil.createTestBookEntityA(authorEntity);
        BookEntity savedBookEntity = underTest.save(bookEntity);

        Optional<BookEntity> result = underTest.findById(bookEntity.getIsbn());

        assertThat(result).isPresent();
        assertThat(result.get()).isEqualTo(savedBookEntity);
    }

    @Test
    public void testThatMultipleBooksCanBeCreateddAndRecalled() {
        AuthorEntity authorEntity = TestDataUtil.createTestAuthorA();

        BookEntity bookEntityA = TestDataUtil.createTestBookEntityA(authorEntity);
        BookEntity savedBookEntityA = underTest.save(bookEntityA);

        BookEntity bookEntityB = TestDataUtil.createTestBookB(authorEntity);
        BookEntity savedBookEntityB = underTest.save(bookEntityB);

        BookEntity bookEntityC = TestDataUtil.createTestBookC(authorEntity);
        BookEntity savedBookEntityC = underTest.save(bookEntityC);

        Iterable<BookEntity> result = underTest.findAll();
        assertThat(result)
                .hasSize(3)
                .containsExactly(savedBookEntityA, savedBookEntityB, savedBookEntityC);
    }

    @Test
    public void testThatBookCanBeUpdated() {
        AuthorEntity authorEntity = TestDataUtil.createTestAuthorA();

        BookEntity bookEntityA = TestDataUtil.createTestBookEntityA(authorEntity);
        BookEntity savedBookEntityA = underTest.save(bookEntityA);

        BookEntity bookEntityB = TestDataUtil.createTestBookB(authorEntity);
        BookEntity savedBookEntityB = underTest.save(bookEntityB);

        Optional<BookEntity> result = underTest.findById(bookEntityA.getIsbn());
        assertThat(result).isPresent();
        assertThat(result.get()).isEqualTo(savedBookEntityA);
    }

    @Test
    public void testThatBookCanBeDeleted() {
        AuthorEntity authorEntity = TestDataUtil.createTestAuthorA();

        BookEntity bookEntityA = TestDataUtil.createTestBookEntityA(authorEntity);
        underTest.save(bookEntityA);

        underTest.delete(bookEntityA);

        Optional<BookEntity> result = underTest.findById(bookEntityA.getIsbn());
        assertThat(result).isEmpty();
    }
}
