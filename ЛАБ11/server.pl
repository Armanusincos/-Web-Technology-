use strict;
use warnings;
use utf8;
use CGI;
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
<!DOCTYPE html>
<html>
<head><meta charset="UTF-8"></head>
<body>

<h2>Введите данные</h2>

<form method="GET" action="/method1">
ФИО: <input name="FIO"><br>
Город: <input name="Gor"><br>
Телефон: <input name="Tel"><br>
<input type="submit" value="Способ 1">
</form>

<br>

<form method="GET" action="/method2">
ФИО: <input name="FIO"><br>
Город: <input name="Gor"><br>
Телефон: <input name="Tel"><br>
<input type="submit" value="Способ 2">
</form>

<br>

<form method="GET" action="/method3">
ФИО: <input name="FIO"><br>
Город: <input name="Gor"><br>
Телефон: <input name="Tel"><br>
<input type="submit" value="Способ 3">
</form>

<br>

<form method="GET" action="/method4">
ФИО: <input name="FIO"><br>
Город: <input name="Gor"><br>
Телефон: <input name="Tel"><br>
<input type="submit" value="Способ 4">
</form>

</body>
</html>
HTML
        }

        elsif ($path eq "/method1") {
            my $FIO = $cgi->param("FIO");
            my $Gor = $cgi->param("Gor");
            my $Tel = $cgi->param("Tel");

            show($FIO, $Gor, $Tel);
        }

        elsif ($path eq "/method2") {
            my ($FIO, $Gor, $Tel);
            my @names = $cgi->param;

            foreach my $elem (@names) {
                my $value = $cgi->param($elem);
                eval("\$$elem='$value'");
            }

            show($FIO, $Gor, $Tel);
        }

        elsif ($path eq "/method3") {
            my $FIO = $cgi->param("FIO");
            my $Gor = $cgi->param("Gor");
            my $Tel = $cgi->param("Tel");

            show($FIO, $Gor, $Tel);
        }

        elsif ($path eq "/method4") {
            my ($FIO, $Gor, $Tel);
            my @names = $cgi->param;

            foreach my $elem (@names) {
                my $value = $cgi->param($elem);
                eval("\$$elem='$value'");
            }

            show($FIO, $Gor, $Tel);
        }

        else {
            print "<h1>404</h1>";
        }
    }

    sub show {
        my ($FIO, $Gor, $Tel) = @_;

        print <<HTML;
<!DOCTYPE html>
<html>
<head><meta charset="UTF-8"></head>
<body>

<h2>Результат</h2>

ФИО: $FIO<br>
Город: $Gor<br>
Телефон: $Tel<br>

<br>
<a href="/">Назад</a>

</body>
</html>
HTML
    }
}

my $server = MyServer->new(8080);
$server->run();