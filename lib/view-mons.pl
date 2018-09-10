################## データ表示 ##################
use strict;
#use warnings;
use utf8;
use open ":utf8";
use open ":std";
use HTML::Template;

### データ読み込み ###################################################################################
require $set::data_races;
require $set::data_items;

### テンプレート読み込み #############################################################################
my $SHEET;
$SHEET = HTML::Template->new( filename => $set::skin_mons, utf8 => 1,
  die_on_bad_params => 0, case_sensitive => 1, global_vars => 1);

$SHEET->param("BackupMode" => param('backup') ? 1 : 0);

### キャラクターデータ読み込み #######################################################################
my $id = param('id');
my $file = $main::file;

our %pc = ();
my $datafile = "${set::mons_dir}${file}/data.cgi";
   $datafile = "${set::mons_dir}${file}/backup/".param('backup').'.cgi' if param('backup');
open my $IN, '<', $datafile or error 'キャラクターシートがありません。';
$_ =~ s/(.*?)<>(.*?)\n/$pc{$1} = $2;/egi while <$IN>;
close($IN);

$SHEET->param("id" => $id);

### 置換 --------------------------------------------------
foreach (keys %pc) {
  $pc{$_} = tag_unescape($pc{$_},$pc{'oldSignConv'});
  if($_ =~ /^(?:skills|description)$/){
    $pc{$_} = tag_unescape_lines($pc{$_});
  }
}
$pc{'skills'} =~ s/<br>/\n/gi;
$pc{'skills'} =~ s/^●(.*?)$/<\/p><h3>●$1<\/h3><p>/gim;
$pc{'skills'} =~ s/^((?:[○◯〇△＞▶〆☆≫»□☑🗨]|&gt;&gt;)+)(.*?)([ 　]|$)/"<\/p><h5>".&text_convert_icon($1)."$2<\/h5><p>".$3;/egim;
$pc{'skills'} =~ s/\n+<\/p>/<\/p>/gi;
$pc{'skills'} =~ s/(^|<p(?:.*?)>|<hr(?:.*?)>)\n/$1/gi;
$pc{'skills'} = "<p>$pc{'skills'}</p>";
$pc{'skills'} =~ s/<p><\/p>//gi;
$pc{'skills'} =~ s/\n/<br>/gi;

### テンプレ用に変換 --------------------------------------------------
while (my ($key, $value) = each(%pc)){
  $SHEET->param("$key" => $value);
}

### 出力準備 #########################################################################################
### グループ --------------------------------------------------
if(!$pc{'group'}) {
  $pc{'group'} = $set::group_default;
  $SHEET->param(group => $set::group_default);
}
foreach (@set::groups){
  if($pc{'group'} eq @$_[0]){
    $SHEET->param(groupName => @$_[2]);
    last;
  }
}

### タグ --------------------------------------------------
my @tags;
foreach(split(/ /, $pc{'tags'})){
    push(@tags, {
      "URL"  => uri_escape_utf8($_),
      "TEXT" => $_,
    });
}
$SHEET->param(Tags => \@tags);

### ステータス --------------------------------------------------
my @status;
foreach (1 .. $pc{'statusNum'}){
  push(@status, {
    "STYLE"    => $pc{'status'.$_.'Style'},
    "ACCURACY" => $pc{'status'.$_.'Accuracy'}.' ('.$pc{'status'.$_.'AccuracyFix'}.')',
    "DAMAGE"   => $pc{'status'.$_.'Damage'},
    "EVASION"  => $pc{'status'.$_.'Evasion'}.' ('.$pc{'status'.$_.'EvasionFix'}.')',
    "DEFENSE"  => $pc{'status'.$_.'Defense'},
    "HP"       => $pc{'status'.$_.'Hp'},
    "MP"       => $pc{'status'.$_.'Mp'},
  } );
}
$SHEET->param(Status => \@status);

### 部位 --------------------------------------------------
$SHEET->param(partsOn => 1) if $pc{'partsNum'};

### 戦利品 --------------------------------------------------
my @loots;
foreach (1 .. $pc{'lootsNum'}){
  push(@loots, {
    "NUM"  => $pc{'loots'.$_.'Num'},
    "ITEM" => $pc{'loots'.$_.'Item'},
  } );
}
$SHEET->param(Loots => \@loots);

### バックアップ --------------------------------------------------
opendir(my $DIR,"${set::mons_dir}${file}/backup");
my @backlist = readdir($DIR);
closedir($DIR);
my @backup;
foreach (reverse sort @backlist) {
  if ($_ =~ s/\.cgi//) {
    my $url = $_;
    $_ =~ s/^([0-9]{4}-[0-9]{2}-[0-9]{2})-([0-9]{2})-([0-9]{2})$/$1 $2\:$3/;
    push(@backup, {
      "NOW"  => ($url eq param('backup') ? 1 : 0),
      "URL"  => $url,
      "DATE" => $_,
    });
  }
}
$SHEET->param(Backup => \@backup);

### パスワード要求 --------------------------------------------------
$SHEET->param(ReqdPassword => (!$pc{'protect'} || $pc{'protect'} eq 'password' ? 1 : 0) );

### タイトル --------------------------------------------------
$SHEET->param(title => $set::title);

### 画像 --------------------------------------------------
$pc{'imageUpdateTime'} = $pc{'updateTime'};
$pc{'imageUpdateTime'} =~ s/[\-\ \:]//g;
$SHEET->param("imageSrc" => "${set::mons_dir}${file}/image.$pc{'image'}?$pc{'imageUpdateTime'}");

### エラー --------------------------------------------------
$SHEET->param(error => $main::login_error);

### 出力 #############################################################################################
print "Content-Type: text/html\n\n";
print $SHEET->output;

1;