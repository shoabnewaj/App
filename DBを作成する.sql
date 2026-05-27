-- Spring教材用のDBを作成する

-- Spring教材用のDBがなければ作成する
CREATE DATABASE IF NOT EXISTS users_ms_ex;

-- users_ms_springを使用する
USE users_ms_ex;

-- もしもusersテーブルがあれば削除する
DROP TABLE IF EXISTS users;

-- usersテーブルを作成する
CREATE TABLE users (
    id    INT          AUTO_INCREMENT PRIMARY KEY,
    email VARCHAR(100) NOT NULL UNIQUE,
    pass  VARCHAR(512) NOT NULL,
    name  VARCHAR(100) NOT NULL,
    user_img varchar(100) UNIQUE DEFAULT NULL
);

-- usersテーブルに検証用のデータを挿入する
INSERT INTO users(email, pass, name, user_img)
VALUES
('minato@xxx.jp',	'1234', '湊 雄輔',    null),
('asaka@xxx.jp',	'1234', '朝香 あゆみ',null),
('sugawara@xxx.jp',	'1234', '菅原 拓真',  null);




-- サーバー内のDATABASEを一覧する
SHOW DATABASES;

-- usersテーブルを確認する
SELECT * FROM users;

