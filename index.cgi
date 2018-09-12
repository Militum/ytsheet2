#!/usr/local/bin/perl
####################################
##     ゆとシートⅡ for SW2.5     ##
##                version1.00     ##
##          by ゆとらいず工房     ##
##    https://yutorize.2-d.jp     ##
####################################
use strict;
use warnings;
use utf8;
use open ":utf8";
use open ":std";
use CGI::Carp qw(fatalsToBrowser);
use CGI qw/:all/;
use CGI::Cookie;
use Encode qw/encode decode/;
use Fcntl;

### バージョン #######################################################################################

our $ver = "1.00";

### 設定読込 #########################################################################################

require './lib/config-default.pl';
require './config.cgi';

### 各処理へ移動 #####################################################################################

my $mode = param('mode');

if($mode eq 'register'){
  if(param('id'))    { require $set::lib_register; }    #登録処理
  else               { require $set::lib_form; }        #新規登録フォーム
}
elsif($mode eq 'option'){
  if(param('name'))  { require $set::lib_register; }    #オプション変更処理
  else               { require $set::lib_form; }        #オプションフォーム
}
elsif($mode eq 'passchange'){
  require $set::lib_register;    #パスワード変更処理
}
elsif($mode eq 'login')   {
  if(param('id')) { &log_in(param('id'),param('password')); }  #ログイン
  else            { require $set::lib_form; }                  #ログインフォーム
}
elsif($mode eq 'reminder')   {
  if(param('id'))   { require $set::lib_reminder; }  #メール送信
  else              { require $set::lib_form; }      #リマインダフォーム
}
elsif($mode eq 'reset')   {
  if(param('password')) { require $set::lib_reminder; }  #パスリセット処理
  else                  { require $set::lib_form; }  #パスリセットフォーム
}
elsif($mode eq 'logout')     { &log_out; }   #ログアウト
elsif($mode eq 'option')     { require $set::lib_form; }   #オプション
elsif($mode eq 'blanksheet') { require $set::lib_edit; }   #ブランクシート
elsif($mode eq 'edit')       { require $set::lib_edit; }   #編集
elsif($mode eq 'copy')       { require $set::lib_edit; }   #コピー
elsif($mode eq 'make')       { require $set::lib_save; }   #新規作成
elsif($mode eq 'save')       { require $set::lib_save; }   #更新
elsif($mode eq 'delete')     { require $set::lib_delete; } #削除
elsif($mode eq 'json')       { require $set::lib_json; }   #外部アプリ連携
elsif(param('id')) { require $set::lib_view; }   #シート表示
else {
  if(param('type') eq 'm'){ require $set::lib_list_mons; }
  else                  { require $set::lib_list; }
}   #一覧表示

### サブルーチン #####################################################################################

### ファイル名取得／パスorアカウント必要時 --------------------------------------------------
sub getfile {
  open (my $FH, '<', $set::passfile) or die;
  while (<$FH>) {
    my ($id, $pass, $file, $type) = (split /<>/, $_)[0..3];
    if(
      $_[0] eq $id && (
           (!$pass) # パス不要
        || (&c_crypt($_[1], $pass)) # パス一致
        || ($pass eq "[$_[2]]") # アカウント一致
        || ($set::masterkey && $_[1] eq $set::masterkey) # 管理パス一致
        || ($set::masterid && $_[2] eq $set::masterid) # 管理アカウント一致
      )
    ) {
      close($FH);
      return ($id, $pass, $file, $type);
    }
  }
  close($FH);
  return 0;
}
### ファイル名取得／パスorアカウント不要時 --------------------------------------------------
sub getfile_open {
  open (my $FH, '<', $set::passfile) or die;
  while (<$FH>) {
    my ($id, $file, $type) = (split /<>/, $_)[0,2,3];
    if($_[0] eq $id) {
      close($FH);
      return ($file,$type);
    }
  }
  close($FH);
  return 0;
}


### プレイヤー名取得 --------------------------------------------------
sub getplayername {
  my $login_id = shift;
  open (my $FH, '<', $set::userfile);
    while (<$FH>) {
      my ($id, $name, $mail) = (split /<>/, $_)[0,2,3];
      if($id eq $login_id) {
        close($FH);
        return ($name,$mail);
      }
    }
  close($FH);
  return '';
}

### 暗号化 --------------------------------------------------
sub e_crypt {
  my $plain = shift;
  my $s;
  my @salt = ('0'..'9','A'..'Z','a'..'z','.','/');
  1 while (length($s .= $salt[rand(@salt)]) < 8);
  return crypt($plain,index(crypt('a','$1$a$'),'$1$a$') == 0 ? '$1$'.$s.'$' : $s);
}

sub c_crypt {
  my($plain,$crypt) = @_;
  return ($plain ne '' && $crypt ne '' && crypt($plain,$crypt) eq $crypt);
}

### 最大値取得 --------------------------------------------------
sub max {
  (sort {$b <=> $a} @_)[0];
}

### 安全にevalする --------------------------------------------------
sub s_eval {
  my $i = shift;
  if($i =~ /[^0-9\+\-\*\/\%\(\) ]/){ $i = 0; }
  return eval($i);
}

### ログイン --------------------------------------------------
sub log_in {
  my $key = key_get($_[0],$_[1]);
  if($key){
    my $flag = 0;
    my $mask = umask 0;
    sysopen (my $FH, $set::login_users, O_RDWR | O_CREAT, 0666);
      my @list = <$FH>;
      flock($FH, 2);
      seek($FH, 0, 0);
      foreach (@list){
        my @line = (split/<>/, $_);
        if (time - $line[2] < 60*60*24*365){
          print $FH $_;
        }
      }
      print $FH "$_[0]<>$key<>".time."<>\n";
      truncate($FH, tell($FH));
    close ($FH);
    print &cookie_set('ytsheet2.5',$_[0],$key,'+365d');
  }
  else { error('ログインできませんでした'); }
  print "Location: ./\n\n";
}

### キー取得 --------------------------------------------------
sub key_get {
  my $in_id  = $_[0];
  my $in_pass= $_[1];
  open (my $FH, '<', $set::userfile);
  while (<$FH>) {
    my ($id, $pass) = (split /<>/, $_)[0,1];
    if ($in_id eq $id && (&c_crypt($in_pass, $pass))) {
      close($FH);
      my $s;
      my @salt = ('0'..'9','A'..'Z','a'..'z','.','/');
      1 while (length($s .= $salt[rand(@salt)] ) < 12);
      return $s;
    }
  }
  close($FH);
  return 0;
}

### ログアウト --------------------------------------------------
sub log_out {
  my ($id, $key) = &cookie_get;
  my $key  = param('key');
  open (my $FH, '+<', $set::login_users);
  my @list = <$FH>;
  flock($FH, 2);
  seek($FH, 0, 0);
  foreach (@list){
    my @line = (split/<>/, $_);
    if($id eq $line[0] && $key eq $line[1]){
    }
    else {
      print $FH $_;
    }
  }
  truncate($FH, tell($FH));
  close($FH);
  print &cookie_set('ytsheet2.5',$id,$key,'Thu, 1-Jan-1970 00:00:00 GMT');
  
  print "Location: ./\n\n";
}
### ログインチェック --------------------------------------------------
sub check {
  my ($in_id, $in_key) = &cookie_get;
  return 0 if !$in_id || !$in_key;
  open (my $FH, $set::login_users) or 0;
  while (<$FH>){
    my @line = (split/<>/, $_);
    if ($in_id eq $line[0] && $in_key eq $line[1] && time - $line[2] < 86400*365) {
      close($FH);
      return ($in_id);
    }
  }
  close($FH);
  return 0;
}

### Cookieセット --------------------------------------------------
sub cookie_set {
  my $value   = "$_[1]<>$_[2]";
  my $cookie = new CGI::Cookie(
    -name    => $_[0] ,
    -value   => $value ,
    -expires => $_[3] ,
  );
  return ("Set-Cookie: $cookie\n");
}

### Cookieゲット --------------------------------------------------
sub cookie_get {
  my %cookies = fetch CGI::Cookie;
  my $value   = $cookies{'ytsheet2.5'}->value if(exists $cookies{'ytsheet2.5'});
  my @return = split(/<>/, $value);
  return @return;
}

### ランダムID生成 --------------------------------------------------
sub random_id {
  my @char = (0..9,'a'..'z','A'..'Z');
  my $s;
  1 while (length($s .= $char[rand(@char)]) < $_[0]);
  return $s;
}

### トークンチェック --------------------------------------------------
sub token_check {
  my $in_token = shift;
  my $flag = 0;
  open (my $FH, '+<', $set::tokenfile);
  my @list = <$FH>;
  flock($FH, 2);
  seek($FH, 0, 0);
  foreach (@list){
    my ($token, $time) = (split/<>/, $_);
    if   ($token eq $in_token && $time >= time){ $flag = 1; }
    elsif($time < time) {  }
    else { print $FH $_; }
  }
  truncate($FH, tell($FH));
  close($FH);
  
  return $flag;
}

### メール送信 --------------------------------------------------
sub sendmail{
  my $from    = encode('MIME-Header-ISO_2022_JP', "ゆとシート for SW2.5 <$set::admimail>");
  my $to      = encode('MIME-Header-ISO_2022_JP', shift);
  my $subject = encode('MIME-Header-ISO_2022_JP', shift);
  my $message = encode('iso-2022-jp', shift);

  open (my $MA, "|$set::sendmail -t") or &error("sendmailの起動に失敗しました。");
  print $MA "To: $to\n";
  print $MA "From: $from\n";
  print $MA "Subject: $subject\n";
  print $MA "Content-Transfer-Encoding: 7bit\n";
  print $MA "Content-Type: text/plain; charset=iso-2022-jp\n\n";
  print $MA $message;
  close($MA);
}

### URIエスケープ --------------------------------------------------
sub uri_escape_utf8 {
  my($tmp) = @_;
  $tmp = Encode::encode('utf8',$tmp);
  $tmp =~ s/([^\w])/'%'.unpack("H2", $1)/ego;
  $tmp =~ tr/ /+/;
  $tmp = Encode::decode('utf8',$tmp);
  return($tmp);
}

### 案内画面 --------------------------------------------------
sub info {
  our $header = shift;
  our $message = shift;
  require $set::lib_info;
  exit;
}

### エラー画面 --------------------------------------------------
sub error {
  our $header = 'エラー';
  our $message = shift;
  require $set::lib_info;
  exit;
}
