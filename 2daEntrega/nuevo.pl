#!/usr/bin/perl
use strict;
use warnings;
use CGI;
use DBI;

my $q = CGI->new;
print $q->header('text/xml;charset=UTF-8');

my $usuario = $q->param("owner");
my $titulo = $q->param("title");
my $texto = $q->param("text");

if(defined($usuario) and defined($titulo) and defined($texto)){
  if(checkLogin($usuario)){
    registrar();
    my $title=retornaEsto("title", "Articles");
    my $text=retornaEsto("text", "Articles");
    mostrar($title, $text);
  }else{
    showLogin('Usuario o contraseña equivocados, vuela a intentarlo');
  }
}else{
  showLogin();
}
sub checkLogin{
  my $userQuery = $_[0];

  my $user = 'alumno';
  my $password = 'pweb1';
  my $dsn = 'DBI:MariaDB:database=pweb1;host=localhost';
  my $dbh = DBI->connect($dsn, $user, $password) or die("No se pudo conectar!");

  my $sql = "SELECT userName FROM Users WHERE userName=? ";
  my $sth = $dbh->prepare($sql);
  $sth->execute($userQuery);
  my @row = $sth->fetchrow_array;
  $sth->finish;
  $dbh->disconnect;
  return @row;
}
sub registrar{
  my $user = 'alumno';
  my $password = 'pweb1';
  my $dsn = 'DBI:MariaDB:database=pweb1;host=localhost';
  my $dbh = DBI->connect($dsn, $user, $password) or die("No se pudo conectar!");
  my $sql = "INSERT INTO Articles VALUES ('$titulo','$usuario','$texto')";
  my $sth = $dbh->prepare($sql);
  $sth->execute();
  $sth->finish;
  $dbh->disconnect;
}
sub retornaEsto{
  my $quiero = $_[0];
  my $deTabla = $_[1];

  my $user = 'alumno';
  my $password = 'pweb1';
  my $dsn = 'DBI:MariaDB:database=pweb1;host=localhost';
  my $dbh = DBI->connect($dsn, $user, $password) or die("No se pudo conectar!");
  my $sql = "SELECT $quiero FROM $deTabla WHERE owner='$usuario' AND title='$titulo'";
  my $sth = $dbh->prepare($sql);
  $sth->execute();
  my @row = $sth->fetchrow_array;
  $sth->finish;
  $dbh->disconnect;
  return $row[0];
}
sub mostrar{
  my $titu=$_[0];
  my $tex=$_[1];
  print <<"HTML";
    <?xml version="1.0" encoding="uft-8">
    <article>
      <title>$titu</title>
      <text>$tex</text>
    </article>
HTML
}
sub showLogin{
  print <<"HTML";
    <?xml version="1.0" encoding="uft-8">
    <user>

    </user>
HTML
}
