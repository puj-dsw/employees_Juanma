docker run -d ^
    --name mysql-employees ^
    -p 3307:3306 ^
    -p 33070:33060 ^
    -e MYSQL_ROOT_PASSWORD=secret ^
    -v "%cd%\scripts":/scripts ^
    mysql-employees