-- Таблица уроков
CREATE TABLE lessons (
                         id SERIAL PRIMARY KEY,
                         title VARCHAR(100) NOT NULL,
                         content TEXT NOT NULL,
                         video_link VARCHAR(255),
                         position INT NOT NULL, -- Позиция урока в курсе
                         created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                         updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                         course_id INT NOT NULL,
                         is_deleted BOOLEAN DEFAULT FALSE,
                         FOREIGN KEY (course_id) REFERENCES courses(id) ON DELETE CASCADE
);

INSERT INTO lessons (title, content, video_link, position, created_at, updated_at, course_id, is_deleted) VALUES
                                                                                                              ('Урок 1: Основы Python', 'Изучаем синтаксис и базовые конструкции языка.', 'https://example.com/video1', 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 1, FALSE),
                                                                                                              ('Урок 2: Функции в Python', 'Изучаем создание и использование функций.', 'https://example.com/video2', 2, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 1, FALSE);


-- Таблица курсов
CREATE TABLE courses (
                         id SERIAL PRIMARY KEY,
                         title VARCHAR(100) NOT NULL,
                         description TEXT NOT NULL,
                         created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                         updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                         is_deleted BOOLEAN DEFAULT FALSE
);

INSERT INTO courses (title, description, created_at, updated_at, is_deleted) VALUES
                                                                                 ('Курс по Python', 'Изучите основы программирования на Python', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, FALSE),
                                                                                 ('Курс по Java', 'Углублённое изучение Java для разработки приложений', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, FALSE);


-- Таблица модулей
CREATE TABLE modules (
                         id SERIAL PRIMARY KEY,
                         title VARCHAR(100) NOT NULL,
                         description TEXT NOT NULL,
                         created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                         updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                         is_deleted BOOLEAN DEFAULT FALSE
);

INSERT INTO modules (title, description, created_at, updated_at, is_deleted) VALUES
                                                                                 ('Модуль 1: Введение', 'Введение в язык Python', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, FALSE),
                                                                                 ('Модуль 2: Углублённый Python', 'Работа с библиотеками и фреймворками', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, FALSE);


-- Таблица программ
CREATE TABLE programs (
                          id SERIAL PRIMARY KEY,
                          title VARCHAR(100) NOT NULL,
                          price DECIMAL(10, 2) NOT NULL,
                          program_type VARCHAR(50) NOT NULL, -- интенсив, профессия и т.д.
                          created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                          updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                          is_deleted BOOLEAN DEFAULT FALSE
);

INSERT INTO programs (title, price, program_type, created_at, updated_at, is_deleted) VALUES
                                                                                          ('Интенсив по Python', 15000.00, 'интенсив', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, FALSE),
                                                                                          ('Курс по Java', 12000.00, 'профессия', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, FALSE);


-- Связующая таблица для модулей и уроков (многие-ко-многим)
CREATE TABLE lesson_module (
                               lesson_id INT NOT NULL,
                               module_id INT NOT NULL,
                               PRIMARY KEY (lesson_id, module_id),
                               FOREIGN KEY (lesson_id) REFERENCES lessons(id) ON DELETE CASCADE,
                               FOREIGN KEY (module_id) REFERENCES modules(id) ON DELETE CASCADE
);

INSERT INTO lesson_module (lesson_id, module_id) VALUES
                                                     (1, 1),
                                                     (2, 2);


-- Связующая таблица для курсов и модулей (многие-ко-многим)
CREATE TABLE course_module (
                               course_id INT NOT NULL,
                               module_id INT NOT NULL,
                               PRIMARY KEY (course_id, module_id),
                               FOREIGN KEY (course_id) REFERENCES courses(id) ON DELETE CASCADE,
                               FOREIGN KEY (module_id) REFERENCES modules(id) ON DELETE CASCADE
);

INSERT INTO course_module (course_id, module_id) VALUES
                                                     (1, 1),
                                                     (2, 2);


-- Связующая таблица для программ и модулей (многие-ко-многим)
CREATE TABLE program_module (
                                program_id INT NOT NULL,
                                module_id INT NOT NULL,
                                PRIMARY KEY (program_id, module_id),
                                FOREIGN KEY (program_id) REFERENCES programs(id) ON DELETE CASCADE,
                                FOREIGN KEY (module_id) REFERENCES modules(id) ON DELETE CASCADE
);

INSERT INTO program_module (program_id, module_id) VALUES
                                                       (1, 1),
                                                       (2, 2);


-- Таблица пользователей
CREATE TABLE users (
                       id SERIAL PRIMARY KEY,
                       username VARCHAR(100) NOT NULL,
                       email VARCHAR(100) NOT NULL UNIQUE,
                       password_hash VARCHAR(255) NOT NULL,
                       teaching_group_id INT NOT NULL,
                       role VARCHAR(20) NOT NULL CHECK (role IN ('student', 'teacher', 'admin')), -- Роли пользователя
                       created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                       updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                       FOREIGN KEY (teaching_group_id) REFERENCES teaching_groups(id) ON DELETE CASCADE
);

INSERT INTO users (username, email, password_hash, teaching_group_id, role, created_at, updated_at) VALUES
                                                                                                        ('student1', 'student1@example.com', 'hashed_password1', 1, 'student', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
                                                                                                        ('teacher1', 'teacher1@example.com', 'hashed_password2', 1, 'teacher', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
                                                                                                        ('admin1', 'admin1@example.com', 'hashed_password3', 1, 'admin', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);


-- Таблица учебных групп
CREATE TABLE teaching_groups (
                                 id SERIAL PRIMARY KEY,
                                 slug VARCHAR(100) NOT NULL UNIQUE,
                                 created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                                 updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO teaching_groups (slug, created_at, updated_at) VALUES
                                                               ('group_a', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
                                                               ('group_b', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
                                                               ('group_c', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);


-- Таблица подписок
CREATE TABLE enrollments (
                             id SERIAL PRIMARY KEY,
                             user_id INT NOT NULL,
                             program_id INT NOT NULL,
                             status VARCHAR(20) NOT NULL CHECK (status IN ('active', 'pending', 'cancelled', 'completed')), -- Статус подписки
                             created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                             updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                             FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
                             FOREIGN KEY (program_id) REFERENCES programs(id) ON DELETE CASCADE
);

INSERT INTO enrollments (user_id, program_id, status, created_at, updated_at) VALUES
                                                                                  (1, 1, 'active', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
                                                                                  (2, 2, 'pending', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);


-- Таблица оплат
CREATE TABLE payments (
                          id SERIAL PRIMARY KEY,
                          enrollment_id INT NOT NULL,
                          amount DECIMAL(10, 2) NOT NULL,
                          status VARCHAR(20) NOT NULL CHECK (status IN ('pending', 'paid', 'failed', 'refunded')), -- Статус оплаты
                          payment_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                          created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                          updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                          FOREIGN KEY (enrollment_id) REFERENCES enrollments(id) ON DELETE CASCADE
);

INSERT INTO payments (enrollment_id, amount, status, created_at, updated_at) VALUES
                                                                                 (1, 15000.00, 'paid', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
                                                                                 (2, 12000.00, 'pending', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);


-- Таблица прогресса по программам
CREATE TABLE program_completions (
                                     id SERIAL PRIMARY KEY,
                                     user_id INT NOT NULL,
                                     program_id INT NOT NULL,
                                     status VARCHAR(20) NOT NULL CHECK (status IN ('active', 'completed', 'pending', 'cancelled')), -- Статус прохождения программы
                                     start_date TIMESTAMP,
                                     end_date TIMESTAMP,
                                     created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                                     updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                                     FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
                                     FOREIGN KEY (program_id) REFERENCES programs(id) ON DELETE CASCADE
);

INSERT INTO program_completions (user_id, program_id, status, start_date, end_date, created_at, updated_at) VALUES
                                                                                                                (1, 1, 'active', CURRENT_TIMESTAMP, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
                                                                                                                (2, 2, 'pending', CURRENT_TIMESTAMP, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);


-- Таблица сертификатов
CREATE TABLE certificates (
                              id SERIAL PRIMARY KEY,
                              user_id INT NOT NULL,
                              program_id INT NOT NULL,
                              certificate_url VARCHAR(255) NOT NULL,
                              issued_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                              created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                              updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                              FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
                              FOREIGN KEY (program_id) REFERENCES programs(id) ON DELETE CASCADE
);

INSERT INTO certificates (user_id, program_id, certificate_url, issued_date, created_at, updated_at) VALUES
    (1, 1, 'https://example.com/certificate1.pdf', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);


-- Таблица тестов
CREATE TABLE quizzes (
                         id SERIAL PRIMARY KEY,
                         lesson_id INT NOT NULL,
                         title VARCHAR(255) NOT NULL,
                         content TEXT NOT NULL,
                         created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                         updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                         FOREIGN KEY (lesson_id) REFERENCES lessons(id) ON DELETE CASCADE
);

INSERT INTO quizzes (lesson_id, title, content, created_at, updated_at) VALUES
    (1, 'Тест по основам Python', 'Тест на проверку знаний по основам Python', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);


-- Таблица практических заданий
CREATE TABLE exercises (
                           id SERIAL PRIMARY KEY,
                           lesson_id INT NOT NULL,
                           title VARCHAR(255) NOT NULL,
                           url VARCHAR(255) NOT NULL,
                           created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                           updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                           FOREIGN KEY (lesson_id) REFERENCES lessons(id) ON DELETE CASCADE
);

INSERT INTO exercises (lesson_id, title, url, created_at, updated_at) VALUES
    (1, 'Практическое задание 1', 'https://example.com/exercise1', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);


-- Таблица обсуждений
CREATE TABLE discussions (
                             id SERIAL PRIMARY KEY,
                             lesson_id INT NOT NULL,
                             content TEXT NOT NULL,
                             created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                             updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                             parent_id INT REFERENCES discussions(id) ON DELETE CASCADE,
                             FOREIGN KEY (lesson_id) REFERENCES lessons(id) ON DELETE CASCADE
);

INSERT INTO discussions (lesson_id, content, created_at, updated_at, parent_id) VALUES
    (1, 'Обсуждение урока 1', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, NULL);


-- Таблица блога
CREATE TABLE blog (
                      id SERIAL PRIMARY KEY,
                      student_id INT NOT NULL,
                      title VARCHAR(255) NOT NULL,
                      content TEXT NOT NULL,
                      status VARCHAR(50) CHECK (status IN ('created', 'in moderation', 'published', 'archived')) NOT NULL,
                      created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                      updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                      FOREIGN KEY (student_id) REFERENCES users(id) ON DELETE CASCADE
);

INSERT INTO blog (student_id, title, content, status, created_at, updated_at) VALUES
    (1, 'Мой опыт обучения Python', 'Я учился Python в течение 3 месяцев и это было удивительно!', 'published', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
