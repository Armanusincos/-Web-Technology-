use strict;
use warnings;
use utf8;
use CGI qw(:standard);
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

        if ($path eq "/" || $path eq "") {
            print <<HTML;
<html>
<head><meta charset="UTF-8"></head>
<body>

<h2>Подбор оттенков цвета</h2>

<form method="GET" action="/color">
Введите код цвета:
<input type="text" name="code" value="FF0000"><br><br>

Выберите цвет:
<select name="name">
<option value="red">Красный</option>
<option value="yellow">Жёлтый</option>
<option value="brown">Каштановый</option>
<option value="green">Зелёный</option>
<option value="blue">Синий</option>
</select>

<br><br>
<input type="submit" value="Выполнить">
</form>

</body>
</html>
HTML
        }

        elsif ($path eq "/color") {

            my $code = $cgi->param("code") // "000000";
            my $name = $cgi->param("name") // "black";

            my %colors = (
                red    => "Красный",
                yellow => "Жёлтый",
                brown  => "Каштановый",
                green  => "Зелёный",
                blue   => "Синий"
            );

            my $rus = $colors{$name};

            print <<HTML;
<html>
<head><meta charset="UTF-8"></head>
<body>

<h2>СРАВНЕНИЕ ЦВЕТОВ</h2>

<h1 style="color:#$code;">#$code</h1>

<h1 style="color:$name;">$rus</h1>

<br>
<a href="/">ВОЗВРАТ</a>

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