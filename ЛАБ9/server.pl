use strict;
use warnings;
use utf8;
use CGI qw(:standard -utf8);
use HTTP::Server::Simple::CGI;

binmode STDOUT, ':encoding(UTF-8)';

{
    package MyServer;
    use base 'HTTP::Server::Simple::CGI';

    sub handle_request {
        my ($self, $cgi) = @_;

        my $path = $cgi->path_info();

        print "HTTP/1.0 200 OK\r\n";
        print "Content-type: text/html; charset=UTF-8\r\n\r\n";

        # ===== СТРАНИЦА ВВОДА =====
        if ($path eq "/" || $path eq "") {
            print <<HTML;
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Лабораторная</title>
</head>
<body>

<h2>Задание 1: Возведение в степень</h2>
<form method="GET" action="/power">
Введите a: <input type="text" name="a"><br><br>
Введите n: <input type="text" name="n"><br><br>
<input type="submit" value="Вычислить">
</form>

<hr>

<h2>Задание 2: Приветствие</h2>
<form method="GET" action="/hello">
Введите имя: <input type="text" name="name"><br><br>
Введите возраст: <input type="text" name="age"><br><br>
<input type="submit" value="Отправить">
</form>

</body>
</html>
HTML
        }

        # ===== СТРАНИЦА РЕЗУЛЬТАТА (ЗАДАНИЕ 1) =====
        elsif ($path eq "/power") {
            my $a = $cgi->param("a") // 0;
            my $n = $cgi->param("n") // 0;

            my $b = $a ** $n;

            print <<HTML;
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Результат</title>
</head>
<body>

<h2>Результат вычисления</h2>
<p>$a<sup>$n</sup> = <b>$b</b></p>

<br>
<a href="/">Назад</a>

</body>
</html>
HTML
        }

        # ===== СТРАНИЦА РЕЗУЛЬТАТА (ЗАДАНИЕ 2) =====
        elsif ($path eq "/hello") {
            my $name = $cgi->param("name") // '';
            my $age  = $cgi->param("age") // 0;

            my $text;

            if ($age <= 30) {
                $text = "Привет! $name.";
            }
            elsif ($age < 50) {
                $text = "Привет! $name. У Вас прекрасный возраст.";
            }
            else {
                $text = "Привет! $name. Вы старейшина.";
            }

            print <<HTML;
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Приветствие</title>
</head>
<body>

<h2>$text</h2>

<br>
<a href="/">Назад</a>

</body>
</html>
HTML
        }

        else {
            print "<h1>404</h1>";
        }
    }
}

my $server = MyServer->new(8080);
$server->run();