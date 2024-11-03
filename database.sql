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

-- Таблица модулей
CREATE TABLE modules (
                         id SERIAL PRIMARY KEY,
                         title VARCHAR(100) NOT NULL,
                         description TEXT NOT NULL,
                         created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                         updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                         is_deleted BOOLEAN DEFAULT FALSE
);

-- Таблица курсов
CREATE TABLE courses (
                         id SERIAL PRIMARY KEY,
                         title VARCHAR(100) NOT NULL,
                         description TEXT NOT NULL,
                         created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                         updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                         is_deleted BOOLEAN DEFAULT FALSE
);

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

-- Связующая таблица для курсов и модулей (многие-ко-многим)
CREATE TABLE course_module (
                               course_id INT NOT NULL,
                               module_id INT NOT NULL,
                               PRIMARY KEY (course_id, module_id),
                               FOREIGN KEY (course_id) REFERENCES courses(id) ON DELETE CASCADE,
                               FOREIGN KEY (module_id) REFERENCES modules(id) ON DELETE CASCADE
);

-- Связующая таблица для программ и модулей (многие-ко-многим)
CREATE TABLE program_module (
                                program_id INT NOT NULL,
                                module_id INT NOT NULL,
                                PRIMARY KEY (program_id, module_id),
                                FOREIGN KEY (program_id) REFERENCES programs(id) ON DELETE CASCADE,
                                FOREIGN KEY (module_id) REFERENCES modules(id) ON DELETE CASCADE
);

-- Связующая таблица для модулей и уроков (многие-ко-многим)
CREATE TABLE lesson_module (
                               lesson_id INT NOT NULL,
                               module_id INT NOT NULL,
                               PRIMARY KEY (lesson_id, module_id),
                               FOREIGN KEY (lesson_id) REFERENCES lessons(id) ON DELETE CASCADE,
                               FOREIGN KEY (module_id) REFERENCES modules(id) ON DELETE CASCADE
);

-- Таблица учебных групп
CREATE TABLE teaching_groups (
                                 id SERIAL PRIMARY KEY,
                                 slug VARCHAR(100) NOT NULL UNIQUE,
                                 created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                                 updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

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