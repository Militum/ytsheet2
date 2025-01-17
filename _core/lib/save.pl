################## データ保存 ##################
use strict;
#use warnings;
use utf8;
use open ":utf8";

our $LOGIN_ID = check;

our $mode = $::in{'mode'};
our $pass = $::in{'pass'};
our $new_id;

our $make_error;

## 新規作成時処理
if ($mode eq 'make'){
  ##ログインチェック
  if($set::user_reqd && !$LOGIN_ID) {
    $make_error .= 'エラー：ログインしていません。<br>';
  }

  ## 二重投稿チェック
  my $_token = $::in{'_token'};
  if(!token_check($_token)){
    my @query;
    push(@query, 'mode=mylist') if $::in{'protect'} eq 'account';
    push(@query, 'type='.$::in{'type'}) if $::in{'type'};
    $make_error .= 'エラー：セッションの有効期限が切れたか、二重投稿です。（⇒<a href="./'
                   .(@query ? '?'.join('&',@query) : '')
                   .'">投稿されているか確認する</a>';
  }
  
  ## 登録キーチェック
  if(!$set::user_reqd && $set::registerkey && $set::registerkey ne $::in{'registerkey'}){
    $make_error .= '記入エラー：登録キーが一致しません。<br>';
  }
  
  ## ID生成
  if($set::id_type && $LOGIN_ID){
    my $type = ($::in{'type'} eq 'm') ? 'm' : ($::in{'type'} eq 'i') ? 'i' : '';
    my $i = 1;
    $new_id = $LOGIN_ID.'-'.$type.sprintf("%03d",$i);
    # 重複チェック
    while (overlap_check($new_id)) {
      $i++;
      $new_id = $LOGIN_ID.'-'.$type.sprintf("%03d",$i);
    }
  }
  else {
    $new_id = random_id(6);
    # 重複チェック
    while (overlap_check($new_id)) {
      $new_id = random_id(6);
    }
  }
}

## パスワードチェック
if($::in{'protect'} eq 'password'){
  if ($pass eq ''){ $make_error .= '記入エラー：パスワードが入力されていません。<br>'; }
  else {
    if ($pass =~ /[^0-9A-Za-z\.\-\/]/) { $make_error .= '記入エラー：パスワードに使える文字は、半角の英数字とピリオド、ハイフン、スラッシュだけです。'; }
  }
}

## 重複チェックサブルーチン
sub overlap_check {
  my $id = shift;
  my $flag;
  open (my $FH, '<', $set::passfile);
  while (<$FH>){ 
    if ($_ =~ /^$id<>/){ $flag = 1; }
  }
  close ($FH);
  return $flag;
}

if ($make_error) { require $set::lib_edit; exit; } # エラーなら編集画面に戻す

### データ処理 #################################################################################
my %pc;
for (param()){ $pc{$_} = decode('utf8', param($_)) if $_ !~ /^(?:imageFile|imageCompressed)$/ }
if($main::new_id){ $pc{'id'} = $main::new_id; }
## 現在時刻
our $now = time;
## 最終更新
$pc{'updateTime'} = time_convert($now);

## ファイル名取得
our $file;
if($mode eq 'make'){
  $pc{'birthTime'} = $file = $now;
}
elsif($mode eq 'save'){
  (undef, undef, $file, undef) = getfile($pc{'id'},$pc{'pass'},$LOGIN_ID);
  if(!$file){ error('編集権限がありません。'); }
}

my $data_dir; my $listfile; our $newline;
if   ($::in{'type'} eq 'm'){ require $set::lib_calc_mons; $data_dir = $set::mons_dir; $listfile = $set::monslist; }
elsif($::in{'type'} eq 'i'){ require $set::lib_calc_item; $data_dir = $set::item_dir; $listfile = $set::itemlist; }
else                       { require $set::lib_calc_char; $data_dir = $set::char_dir; $listfile = $set::listfile; }

## データ計算
%pc = data_calc(\%pc);

### エスケープ --------------------------------------------------
foreach (keys %pc) {
  $pc{$_} =~ s/&/&amp;/g;
  $pc{$_} =~ s/"/&quot;/g;
  $pc{$_} =~ s/</&lt;/g;
  $pc{$_} =~ s/>/&gt;/g;
  $pc{$_} =~ s/\r//g;
  $pc{$_} =~ s/\n//g;
}

## タグ：全角スペース・英数を半角に変換 --------------------------------------------------
$pc{'tags'} =~ tr/　/ /;
$pc{'tags'} =~ tr/０-９Ａ-Ｚａ-ｚ/0-9A-Za-z/;
$pc{'tags'} =~ tr/＋－＊／．，＿/\+\-\*\/\.,_/;
$pc{'tags'} =~ tr/ / /s;

### 画像アップロード --------------------------------------------------
my $oldext;
if($pc{'imageDelete'}){
  $oldext = $pc{'image'};
  $pc{'image'} = '';
}
use MIME::Base64;
my $imagedata; my $imageflag;
if($::in{'imageCompressed'} || $::in{'imageFile'}){
  my $mime;
  # 縮小済み
  if($::in{'imageCompressed'}){
    $imagedata = decode_base64( (split ',', $::in{'imageCompressed'})[1] );
    $mime = $::in{'imageCompressedType'};
  }
  # オリジナル
  elsif($::in{'imageFile'}){
    my $imagefile = $::in{'imageFile'}; # ファイル名の取得
    $mime = uploadInfo($imagefile)->{'Content-Type'}; # MIMEタイプの取得
    
    # ファイルの受け取り
    my $buffer;
    while(my $bytesread = read($imagefile, $buffer, 2048)) {
      $imagedata .= $buffer;
    }
  }
  # サイズチェック
  my $max_size = ( $set::image_maxsize ? $set::image_maxsize : 1024 * 1024 );
  if (length($imagedata) <= $max_size){ $imageflag = 1; }

  # MIME-type -> 拡張子
  my $ext; 
  if    ($mime eq "image/gif")   { $ext ="gif"; } #GIF
  elsif ($mime eq "image/jpeg")  { $ext ="jpg"; } #JPG
  elsif ($mime eq "image/pjpeg") { $ext ="jpg"; } #JPG
  elsif ($mime eq "image/png")   { $ext ="png"; } #PNG
  elsif ($mime eq "image/x-png") { $ext ="png"; } #PNG
  elsif ($mime eq "image/webp")  { $ext ="webp"; } #WebP

  # 通して良しなら
  if($imageflag && $ext){
    $oldext = $pc{'image'} || $oldext;
    $pc{'image'} = $ext;
    $pc{'imageUpdate'} = time;
  }
}


### 保存 #############################################################################################
my $mask = umask 0;
### 個別データ保存 --------------------------------------------------
delete $pc{'ver'};
delete $pc{'pass'};
delete $pc{'_token'};
delete $pc{'registerkey'};
$pc{'IP'} = $ENV{'REMOTE_ADDR'};
### passfile --------------------------------------------------
if (!-d $set::data_dir){ mkdir $set::data_dir or error("データディレクトリ($set::data_dir)の作成に失敗しました。"); }
if (!-d $data_dir){ mkdir $data_dir or error("データディレクトリ($data_dir)の作成に失敗しました。"); }
if ($LOGIN_ID && !-d "${data_dir}_${LOGIN_ID}"){ mkdir "${data_dir}_${LOGIN_ID}" or error("データディレクトリの作成に失敗しました。"); }
my $user_dir;
## 新規
if($mode eq 'make'){
  $user_dir = passfile_write_make($pc{'id'},$pass,$LOGIN_ID,$pc{'protect'},$now,$data_dir);
}
## 更新
elsif($mode eq 'save'){
  if($pc{'protect'} ne $pc{'protectOld'}
    || ($imageflag && $pc{'image'})
    || ($set::masterid && $LOGIN_ID eq $set::masterid)
    || ($set::masterkey && $pass eq $set::masterkey)
  ){
    $user_dir = passfile_write_save($pc{'id'},$pass,$LOGIN_ID,$pc{'protect'},$data_dir);
  }
  else {
    $user_dir = ($pc{'protect'} eq 'account' && $LOGIN_ID) ? '_'.$LOGIN_ID.'/' : '';
  }
  data_save('save', $data_dir, $file, $pc{'protect'}, $user_dir);
}
### 一覧データ更新 --------------------------------------------------
list_save($listfile, $newline);

### 画像アップ更新 --------------------------------------------------
if($pc{'imageDelete'}){
  unlink "${data_dir}${user_dir}${file}/image.$pc{'image'}"; # ファイルを削除
}
if($imageflag && $pc{'image'}){
  unlink "${data_dir}${user_dir}${file}/image.$oldext"; # 前のファイルを削除
  open(my $IMG, ">", "${data_dir}${user_dir}${file}/image.$pc{'image'}");
  binmode($IMG);
  print $IMG $imagedata;
  close($IMG);
}



### 保存後処理 ######################################################################################
### キャラシートへ移動／編集画面に戻る --------------------------------------------------
if($mode eq 'make'){
  print "Location: ./?id=${new_id}\n\n"
}
else {
  require $set::lib_edit;
}




### サブルーチン ###################################################################################
use File::Copy qw/copy move/;

sub time_convert {
  my ($min,$hour,$day,$mon,$year) = (localtime($_[0]))[1..5];
  $year += 1900; $mon++;
  return sprintf("%04d-%02d-%02d %02d:%02d",$year,$mon,$day,$hour,$min);
}

sub data_save {
  my $mode = shift;
  my $dir  = shift;
  my $file = shift;
  my $protect = shift;
  my $user_dir = shift;

  if($protect eq 'account' && $user_dir){
    if (!-d "${dir}${user_dir}${file}"){
      if($mode eq 'save' && -d "${dir}${file}"){ #v1.14のコンバート処理
        move("${dir}${file}", "${dir}${user_dir}${file}");
      }
      else {
        mkdir "${dir}${user_dir}${file}" or error("データファイルの作成に失敗しました。");
      }
    }
    $dir .= $user_dir;
  }
  elsif(!-d "${dir}${file}") {
    mkdir "${dir}${file}" or error("データファイルの作成に失敗しました。");
  }

  if($mode eq 'save'){
    if (!-d "${dir}${file}/backup/"){ mkdir "${dir}${file}/backup/"; }

    my $modtime = (stat("${dir}${file}/data.cgi"))[9];
    my ($min, $hour, $day, $mon, $year) = (localtime($modtime))[1..5];
    $year += 1900; $mon++;
    my $update_date = sprintf("%04d-%02d-%02d-%02d-%02d",$year,$mon,$day,$hour,$min);
    copy("${dir}${file}/data.cgi", "${dir}${file}/backup/${update_date}.cgi");
  }

  sysopen (my $DD, "${dir}${file}/data.cgi", O_WRONLY | O_TRUNC | O_CREAT, 0666);
    print $DD "ver<>".$main::ver."\n";
    foreach (sort keys %pc){
      if($pc{$_} ne "") { print $DD "$_<>".$pc{$_}."\n"; }
    }
  close($DD);
}

sub passfile_write_make {
  my ($id, $pass ,$LOGIN_ID, $protect, $now, $data_dir) = @_;
  sysopen (my $FH, $set::passfile, O_RDWR | O_APPEND | O_CREAT, 0666);
  flock($FH, 2);
  my @list = <$FH>;
  foreach (@list){
    my @data = split /<>/;
    if ($data[2] eq $now){
      close($FH);
      $make_error = '新規作成が衝突しました。再度保存してください。';
      require $set::lib_edit; exit;
    }
  }
  my $passwrite; my $user_dir;
  if   ($protect eq 'account'&& $LOGIN_ID) { $passwrite = '['.$LOGIN_ID.']'; $user_dir = '_'.$LOGIN_ID.'/'; }
  elsif($protect eq 'password')            { $passwrite = e_crypt($pass); }
  data_save('make', $data_dir, $file, $protect, $user_dir);
  print $FH "$id<>$passwrite<>$now<>".$::in{'type'}."<>\n";
  close($FH);
  return $user_dir;
}

sub passfile_write_save {
  my ($id, $pass ,$LOGIN_ID, $protect, $dir) = @_;
  my $move; my $old_dir; my $new_dir; my $file;
  sysopen (my $FH, $set::passfile, O_RDWR);
  flock($FH, 2);
  my @list = <$FH>;
  seek($FH, 0, 0);
  foreach (@list){
    my @data = split /<>/;
    if ($data[0] eq $id){
      $file = $data[2];
      my $passwrite = $data[1];
      if($passwrite =~ /^\[(.+?)\]$/){ $old_dir = '_'.$1.'/'; }
      if   ($protect eq 'account')  {
        if($passwrite !~ /^\[.+?\]$/) {
          $passwrite = '['.$LOGIN_ID.']';
          $move = 1;
          $new_dir = '_'.$LOGIN_ID.'/';
        }
      }
      elsif($protect eq 'password') {
        if(!$passwrite || $passwrite =~ /^\[.+?\]$/) { $passwrite = e_crypt($pass); }
        if($old_dir) { $move = 1; }
      }
      elsif($protect eq 'none') {
        $passwrite = '';
        if($old_dir) { $move = 1; }
      }
      print $FH "$data[0]<>$passwrite<>$data[2]<>$data[3]<>\n";
    }else{
      print $FH $_;
    }
  }
  truncate($FH, tell($FH));
  close($FH);

  if($move){
    if(!-d "${dir}${new_dir}"){ mkdir "${dir}${new_dir}" or error("データディレクトリの作成に失敗しました。"); }
    move("${data_dir}${old_dir}${file}", "${data_dir}${new_dir}${file}");
    return $new_dir;
  }
  else {
    return $old_dir;
  }
}

sub list_save {
  my $listfile = shift;
  my $newline  = shift;
  sysopen (my $FH, $listfile, O_RDWR | O_CREAT, 0666);
  flock($FH, 2);
  my @list = sort { (split(/<>/,$b))[3] cmp (split(/<>/,$a))[3] } <$FH>;
  seek($FH, 0, 0);
  print $FH "$newline\n";
  foreach (@list){
    chomp $_;
    my( $id, undef ) = split /<>/;
    if ($id && $id ne $pc{'id'}){
      print $FH $_,"\n";
    }
  }
  truncate($FH, tell($FH));
  close($FH);
}


1;