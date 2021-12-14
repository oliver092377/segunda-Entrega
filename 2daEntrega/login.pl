#!/usr/bin/perl
use strict;
use warnings;
use CGI;
use DBI;


my $q = CGI->new;
print $q->header('text/xml;charset=UTF-8');

my $usuario = $q->param('user');
my $contra = $q->param('password');

if(defined($usuario) and defined($contra)){
  if(checkLogin($usuario, $contra)){
    my $nombre=retornaEsto("firstName", "Users");
    my $apellido=retornaEsto("lastName", "Users");
    successLogin($nombre, $apellido);
  }else{
    showLogin();
  }
}else{
  print "sdsf";
}
sub checkLogin{
  my $userQuery = $_[0];
  my $passwordQuery = $_[1];

  my $user = 'alumno';
  my $password = 'pweb1';
  my $dsn = 'DBI:MariaDB:database=pweb1;host=localhost';
  my $dbh = DBI->connect($dsn, $user, $password) or die("No se pudo conectar!");

  my $sql = "SELECT username FROM login WHERE username=? AND passwd=?";
  my $sth = $dbh->prepare($sql);
  $sth->execute($userQuery, $passwordQuery);
  my @row = $sth->fetchrow_array;
  $sth->finish;
  $dbh->disconnect;
  return @row;
}

sub successLogin{
  my $first=$_[0];
  my $last=$_[1];
  print <<"HTML";
    <?xml version="1.0" encoding="uft-8">
    <user>
      <owner>$usuario</owner>
      <firstName>$first</firstName>
      <lastName>$last</lastName>
    </user>
HTML
}
sub showLogin{
  print <<"HTML";
    <?xml version="1.0" encoding="uft-8">
    <user>

    </user>
HTML
}
sub retornaEsto{
  my $quiero = $_[0];
  my $deTabla = $_[1];

  my $user = 'alumno';
  my $password = 'pweb1';
  my $dsn = 'DBI:MariaDB:database=pweb1;host=localhost';
  my $dbh = DBI->connect($dsn, $user, $password) or die("No se pudo conectar!");

  my $sql = "SELECT $quiero FROM $deTabla WHERE userName=?";
  my $sth = $dbh->prepare($sql);
  $sth->execute($usuario);
  my @row = $sth->fetchrow_array;
  $sth->finish;
  $dbh->disconnect;
  return $row[0];
}
