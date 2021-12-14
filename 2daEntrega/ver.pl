#!/usr/bin/perl
use strict;
use warnings;
use CGI;
use DBI;


my $q = CGI->new;
print $q->header('text/html;charset=UTF-8');

my $usuario = $q->param("owner");
my $titulo = $q->param("title");

if(defined($usuario) and defined($titulo)){
  if(checkLogin($usuario, $titulo)){
    mostrar("text", "Articles");
  }else{
    showLogin('Usuario o contraseña equivocados, vuela a intentarlo');
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
sub mostrar{
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
  while(my @row = $sth->fetchrow_array){
  my $longitud=length($row[0]);
  # print "<h1>longitud: $longitud</h1>";
  my $count=0;
  my $count2=1;
  my $ind=1;
  my @arr;
  while($count<$longitud){
    my $sub=substr($row[0],$count,1);
    if ($sub =~ /[#*~`]/){
      if($arr[$count2-1]==$count-$ind){
        $arr[$count2]=$arr[$count2-1];
        $ind++;
      }
      else{
         $arr[$count2]=$count;
         $ind=1;
      }
      $count2++;
    }
    # print "<h1>sub: $sub</h1>";
    $count++;
  }
  my @trozos;
  my $i=1;
  if(@arr%2==0){
     for(my $a=0;$a<@arr-1;$a++){
       unless($arr[$i]==$arr[$i-1]){
         $trozos[$i-1]=substr($row[0],$arr[$i-1],$arr[$i]-$arr[$i-1]);
       }
       $i++;
   }
   $trozos[@trozos]=substr($row[0], $arr[@arr-1], length($row[0])- $arr[@arr-1]);
  }
  else{
     for(my $a=0;$a<@arr-1;$a++){
       unless($arr[$i]==$arr[$i-1]){
         $trozos[$i-1]=substr($row[0],$arr[$i-1],$arr[$i]-$arr[$i-1]);
       }
       $i++;
   }
   $trozos[@trozos]=substr($row[0], $arr[@arr-1], length($row[0])- $arr[@arr-1]);
  }
  my $numero=@arr;
  my $numero2=@trozos;
  # print "<h1>arr: $numero</h1>"; 
  for(my $i=0;$i<@arr;$i++){
    #print "<h1>arr de $i: $arr[$i]</h1>";
  }
  #print "<h1>trozos: $numero2</h1>"; 
  for(my $i=0;$i<@trozos;$i++){
    # print "<h1>trozos de $i: $trozos[$i]</h1>";
  }
  for(my $i=0;$i<@trozos;$i++){
    if($trozos[$i] =~  /^#([a-zA-Z ]+)/){
      my $h1=substr($trozos[$i], 1, length($trozos[$i])- 1);
      print "<h1>$h1</h1>";
    }
    elsif($trozos[$i] =~ /^##([a-zA-Z ]+)/ ){
      my $h2=substr($trozos[$i], 2, length($trozos[$i])- 2);
      print "<h2>$h2</h2>";
    }
    elsif($trozos[$i] =~ /^###([a-zA-Z ]+)/ ){
      my $h3=substr($trozos[$i], 3, length($trozos[$i])- 3);
      print "<h3>$h3</h3>";
    }
    elsif($trozos[$i] =~ /^####([a-zA-Z ]+)/ ){
      my $h4=substr($trozos[$i], 4, length($trozos[$i])- 4);
      print "<h4>$h4</h4>";
    }
    elsif($trozos[$i] =~ /^#####([a-zA-Z ]+)/ ){
      my $h5=substr($trozos[$i], 5, length($trozos[$i])- 5);
      print "<h5>$h5</h5>";
    }
    elsif($trozos[$i] =~ /^######([a-zA-Z ]+)/ ){
      my $h6=substr($trozos[$i], 6, length($trozos[$i])- 6);
      print "<h6>$h6</h6>";
    }
    elsif($trozos[$i] =~ /^\*\*([a-zA-Z ]+)/ ){
      my $bold=substr($trozos[$i], 2, length($trozos[$i])- 2);
      my $cualquiera=$1;
      print "<p><strong>$cualquiera</p></strong>";
    }
    elsif($trozos[$i] =~ /^\*([a-zA-Z ]+)/ ){
      my $bold=substr($trozos[$i], 1, length($trozos[$i])- 1);
      print "<p><em>$bold</p></em>";
    }
    elsif($trozos[$i] =~ /^\~\~([a-zA-Z ]+)/ ){
      my $bold=substr($trozos[$i], 2, length($trozos[$i])- 2);
      print "<p>$bold</p>";
    }
    elsif($trozos[$i] =~ /^\*\*([a-zA-Z ]+)_([a-zA-Z ]+)_([a-zA-Z ]+)/){
      #my $bold=substr($trozos[$i], 2, length($trozos[$i])- 2);
      my $normal=$1;
      my $negrita=$2;
      my $normal2=$3;
      print "<p><strong>$normal<em>$negrita</em>$normal2</p></strong>";
    }
    elsif($trozos[$i] =~ /^\*\*\*([a-zA-Z ]+)/ ){
      my $bold=substr($trozos[$i], 3, length($trozos[$i])- 3);
      print "<p><strong><em>$bold</p></strong></em>";
    }
    elsif($trozos[$i] =~ /^```/ ){
      my $longitud=length($trozos[$i]);
      my $count=0;
      my $count2=0;
      my @arreglo;
      while($count<$longitud){
        my $sub=substr($trozos[$i],$count,1);
        if ($sub =~ /([a-zA-Z ])/){
          $arreglo[$count2]=$arreglo[$count2]+1;
        }
        else{
          $count2++;
        }
        $count++;
        }
        my @final;
        my $ra=0;
        my $poco=0;
        my $cadena="";
        for(my $y=0;$y<@arreglo;$y++){
          if(!$arreglo[$y] eq ""){
            $cadena=$cadena.substr($trozos[$i],$y+$ra-$poco, $arreglo[$y]+2)."<br>";
            $ra=$ra+$y;
            $poco++;
          }
        }
        print "<p><code>$cadena</code></p>";
      }
    }
    $sth->finish;
    $dbh->disconnect;
  }
}
