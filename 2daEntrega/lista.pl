#!/usr/bin/perl
use strict;
use warnings;
use CGI;
use DBI;


my $q = CGI->new;
print $q->header('xml/html;charset=UTF-8');

my $usuario = $q->param("owner");

if(defined($usuario)){
  if(checkLogin($usuario)){
    mostrar("title","Articles");
  }else{
    showLogin();
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

  my $sql = "SELECT * FROM Articles WHERE owner=? ";
  my $sth = $dbh->prepare($sql);
  $sth->execute($userQuery);
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
sub mostrar{
  my $quiero = $_[0];
  my $deTabla = $_[1];
  my @titles;
  my $user = 'alumno';
  my $password = 'pweb1';
  my $dsn = 'DBI:MariaDB:database=pweb1;host=localhost';
  my $dbh = DBI->connect($dsn, $user, $password) or die("No se pudo conectar!");

  my $sql = "SELECT $quiero FROM $deTabla WHERE owner=?";
  my $sth = $dbh->prepare($sql);
  $sth->execute($usuario);
  my @row; #=$sth->fetchrow_array;
  my $ind=0;
  while(@row = $sth->fetchrow_array){
   $titles[$ind]=$row[0]; 
   $ind++;
  }
  $sth->finish;
  $dbh->disconnect;
  print <<HTML;
    <?xml version="1.0" encoding="uft-8">
    <articles>
HTML
  for(my $i=0; $i<@titles; $i++){
    print <<HTML;
      <article>
        <owner>$usuario</owner>
        <title>$titles[$i]</title>
      </article>
HTML
  }
  print <<HTML;
    </articles>
HTML
}
sub showLogin{
  print <<"HTML";
    <?xml version="1.0" encoding="uft-8">
    <articles>
    </articles>
HTML
}
