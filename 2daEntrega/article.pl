#!/usr/bin/perl
use strict;
use warnings;
use CGI;
use DBI;


my $q = CGI->new;
print $q->header('xml/html;charset=UTF-8');

my $usuario = $q->param("owner");
my $titulo = $q->param("title");

if(defined($usuario) and defined($titulo)){
  if(checkLogin($usuario, $titulo)){
    my $texto=retornaEsto("text","Articles");
    successLogin($texto);
  }else{
    showLogin();
  }
}else{
  showLogin();
}
sub checkLogin{
  my $userQuery = $_[0];
  my $titu = $_[1];
  my $user = 'alumno';
  my $password = 'pweb1';
  my $dsn = 'DBI:MariaDB:database=pweb1;host=localhost';
  my $dbh = DBI->connect($dsn, $user, $password) or die("No se pudo conectar!");

  my $sql = "SELECT * FROM Articles WHERE owner=? AND title=?";
  my $sth = $dbh->prepare($sql);
  $sth->execute($userQuery, $titu);
  my @row = $sth->fetchrow_array;
  $sth->finish;
  $dbh->disconnect;
  return @row;
}
sub successLogin{
  my $user = 'alumno';
  my $password = 'pweb1';
  my $dsn = 'DBI:MariaDB:database=pweb1;host=localhost';
  my $dbh = DBI->connect($dsn, $user, $password) or die("No se pudo conectar!");

  my $sql = "SELECT * from Articles WHERE owner=?";
  my $sth = $dbh->prepare($sql);
  $sth->execute($usuario);
  $sth->finish;
  $dbh->disconnect;
}
sub retornaEsto{
  my $quiero = $_[0];
  my $deTabla = $_[1];
  my @titles;
  my $user = 'alumno';
  my $password = 'pweb1';
  my $dsn = 'DBI:MariaDB:database=pweb1;host=localhost';
  my $dbh = DBI->connect($dsn, $user, $password) or die("No se pudo conectar!");

  my $sql = "SELECT $quiero FROM $deTabla WHERE owner=? AND title=?";
  my $sth = $dbh->prepare($sql);
  $sth->execute($usuario, $titulo);
  my @row=$sth->fetchrow_array;
  $sth->finish;
  $dbh->disconnect;
  return $row[0];
}
sub successLogin{
  my $miText=$_[0];
  print <<"HTML";
    <?xml version="1.0" encoding="uft-8">
    <article>
      <owner>$usuario</owner>
      <title>$titulo</title>
      <text>$miText</text>
    </article>
HTML
}
#cuando no hay coincidencias
sub showLogin{
  print <<"HTML";
    <?xml version="1.0" encoding="uft-8">
    <articles>
    </articles>
HTML
}
