#################### データ ####################
use strict;
use utf8;

package data;

# [習得できる最小Lv,'名前','概要']
our @craft_enhance = (
  [1,'アンチボディ',''],
  [1,'オウルビジョン',''],
  [1,'ガゼルフット',''],
  [1,'キャッツアイ',''],
  [1,'スケイルレギンス',''],
  [1,'ストロングブラッド',''],
  [1,'チックチック',''],
  [1,'ドラゴンテイル',''],
  [1,'ビートルスキン',''],
  [1,'マッスルベアー',''],
  [1,'メディテーション',''],
  [1,'ラビットイヤー',''],
  [5,'ケンタウロスレッグ',''],
  [5,'シェイプアニマル',''],
  [5,'ジャイアントアーム',''],
  [5,'スフィンクスノレッジ',''],
  [5,'デーモンフィンガー',''],
  [5,'ファイアブレス',''],
  [5,'リカバリィ',''],
  [5,'ワイドウィング',''],
  [10,'カメレオンカムフラージュ',''],
  [10,'クラーケンスタビリティ',''],
  [10,'ジィプロフェシー',''],
  [10,'ストライダーウォーク',''],
  [10,'スパイダーウェブ',''],
  [10,'タイタンフット',''],
  [10,'トロールバイタル',''],
  [10,'バルーンシードショット',''],
  [10,'フェンリルバイト',''],
  [10,'ヘルシーボディ',''],
);

our @craft_song = (
  [1,'アーリーバード',''],
  [1,'アンビエント',''],
  [1,'サモン・スモールアニマル',''],
  [1,'サモン・フィッシュ',''],
  [1,'ノイズ',''],
  [1,'バラード',''],
  [1,'モラル',''],
  [1,'レクイエム',''],
  [1,'レジスタンス',''],
  [5,'アトリビュート',''],
  [5,'キュアリオスティ',''],
  [5,'チャーミング',''],
  [5,'トランス',''],
  [5,'ノスタルジィ',''],
  [5,'ブレイク',''],
  [5,'ラブソング',''],
  [5,'ララバイ',''],
  [10,'クラップ',''],
  [10,'コーラス',''],
  [10,'ダル',''],
  [10,'ダンス',''],
  [10,'フォール',''],
  [10,'リダクション',''],
  [10,'レイジィ',''],
  [1,'終律：春の強風',''],
  [1,'終律：夏の生命',''],
  [1,'終律：秋の実り',''],
  [1,'終律：冬の寒風',''],
  [5,'終律：獣の咆吼',''],
  [5,'終律：草原の息吹',''],
  [5,'終律：華の宴',''],
  [5,'終律：蛇穴の苦鳴',''],
  [10,'終律：火竜の舞',''],
  [10,'終律：水竜の轟',''],
  [10,'終律：蒼月の光',''],
  [10,'終律：白日の暖',''],
);

our @craft_riding = (
  [1,'威嚇',''],
  [1,'以心伝心',''],
  [1,'遠隔指示',''],
  [1,'探索指令',''],
  [1,'騎獣強化',''],
  [1,'騎獣の献身',''],
  [1,'攻撃阻害',''],
  [1,'高所攻撃',''],
  [1,'タンデム',''],
  [1,'チャージ',''],
  [1,'魔法指示',''],
  [1,'ＨＰ強化',''],
  [5,'限界駆動',''],
  [5,'獅子奮迅',''],
  [5,'姿勢堅持',''],
  [5,'人馬一体',''],
  [5,'超高所攻撃',''],
  [5,'特殊能力解放',''],
  [5,'トランプル',''],
  [5,'魔法指示回数増加',''],
  [5,'ＨＰ超強化',''],
  [10,'騎獣超強化',''],
  [10,'騎乗指揮',''],
  [10,'極高所攻撃',''],
  [10,'瞬時魔法指示',''],
  [10,'スーパーチャージ',''],
  [10,'超過駆動',''],
  [10,'超攻撃阻害',''],
  [10,'特殊能力完全解放',''],
  [10,'八面六臂',''],
  [10,'バランス',''],
);

our @craft_alchemy = (
  [1,'インスタントウェポン',''],
  [1,'ヴォーパルウェポン',''],
  [1,'クラッシュファング',''],
  [1,'クリティカルレイ',''],
  [1,'バークメイル',''],
  [1,'パラライズミスト',''],
  [1,'ポイズンニードル',''],
  [1,'ミラージュデイズ',''],
  [1,'ヒールスプレー',''],
  [5,'アーマーラスト',''],
  [5,'アンロックニードル',''],
  [5,'イニシアティブブースト',''],
  [5,'エンサイクロペディア',''],
  [5,'ディスペルニードル',''],
  [5,'バインドアビリティ',''],
  [5,'ビビッドリキッド',''],
  [5,'マナスプラウト',''],
  [5,'マナダウン',''],
  [5,'リーンフォース',''],
  [10,'クレイフィールド',''],
  [10,'コンバインマテリアル',''],
  [10,'スラッシュフィールド',''],
  [10,'デラックスマテリアル',''],
  [10,'バリアフィールド',''],
  [10,'フレイムフィールド',''],
  [10,'レストフィールド',''],
);

our @craft_command = (
  [1,'神速の構え',''],
  [1,'堅陣の構え',''],
  [1,'怒濤の攻陣Ⅰ',''],
  [1,'怒濤の攻陣Ⅱ：烈火',''],
  [1,'怒濤の攻陣Ⅱ：旋風',''],
  [1,'流麗なる俊陣Ⅰ',''],
  [1,'流麗なる俊陣Ⅱ：陽炎',''],
  [1,'流麗なる俊陣Ⅱ：流水',''],
  [1,'鉄壁の防陣Ⅰ',''],
  [1,'鉄壁の防陣Ⅱ：鉄鎧',''],
  [1,'鉄壁の防陣Ⅱ：堅体',''],
  [1,'強靭なる丈陣Ⅰ：抵体',''],
  [1,'強靭なる丈陣Ⅰ：抗心',''],
  [1,'強靭なる丈陣Ⅱ：強身',''],
  [1,'強靭なる丈陣Ⅱ：精定',''],
  [1,'強靭なる丈陣Ⅱ：安精',''],
  [1,'軍師の知略',''],
  [5,'怒濤の攻陣Ⅲ：轟炎',''],
  [5,'怒濤の攻陣Ⅲ：旋刃',''],
  [5,'怒濤の攻陣Ⅳ：爆焔',''],
  [5,'怒濤の攻陣Ⅳ：輝斬',''],
  [5,'流麗なる俊陣Ⅲ：浮身',''],
  [5,'流麗なる俊陣Ⅲ：幻惑',''],
  [5,'流麗なる俊陣Ⅳ：残影',''],
  [5,'流麗なる俊陣Ⅳ：瞬脱',''],
  [5,'鉄壁の防陣Ⅲ：鋼鎧',''],
  [5,'鉄壁の防陣Ⅲ：甲盾',''],
  [5,'鉄壁の防陣Ⅳ：反攻',''],
  [5,'鉄壁の防陣Ⅳ：無敵',''],
  [5,'強靭なる丈陣Ⅲ：剛体',''],
  [5,'強靭なる丈陣Ⅲ：整身',''],
  [5,'強靭なる丈陣Ⅲ：心清',''],
  [5,'強靭なる丈陣Ⅳ：克己',''],
  [5,'強靭なる丈陣Ⅳ：賦活',''],
  [5,'強靭なる丈陣Ⅳ：清涼',''],
  [5,'蘇る秘奥',''],
  [5,'勇壮なる軍歌',''],
  [10,'怒濤の攻陣Ⅴ：獄火',''],
  [10,'怒濤の攻陣Ⅴ：颱風',''],
  [10,'流麗なる俊陣Ⅴ：水鏡',''],
  [10,'流麗なる俊陣Ⅴ：影駆',''],
  [10,'鉄壁の防陣Ⅴ：鋼城',''],
  [10,'鉄壁の防陣Ⅴ：槍塞',''],
  [10,'強靭なる丈陣Ⅴ：激生',''],
  [10,'強靭なる丈陣Ⅴ：魔泉',''],
  [10,'大いなる挑発',''],
);

our @craft_divination = (
  [1,'幸運の星の導きを知る',''],
  [1,'幸運は手指を助ける',''],
  [1,'幸運は動きを助ける',''],
  [1,'幸運は力を助ける',''],
  [1,'幸運は知恵を助ける',''],
  [1,'幸運は勝ち戦を授ける',''],
  [1,'幸運は富をもたらす',''],
  [1,'星は剣を導く',''],
  [1,'星は盾を掲げる',''],
  [1,'星は札を翻す',''],
  [1,'星は調べを誘う',''],
  [1,'星は安らぎをもたらす',''],
  [5,'凶星の光を避ける道を知る',''],
  [5,'賢星に語らるべかりし言葉を問う',''],
  [5,'光る星は弱点を暴く',''],
  [5,'光る星は神秘を誘う',''],
  [5,'怒れる言葉の幻',''],
  [5,'崩れる壁の幻',''],
  [5,'背後から迫る闇の幻',''],
  [5,'襲いかかる敵の幻',''],
  [10,'光り輝く星は高みへと導く',''],
  [10,'黒き死の幻影',''],
  [10,'灰色なる敗北の幻影',''],
  [10,'無色なる不備の幻影',''],
);

our @craft_potential = (
  [1,'アイテム収納',''],
  [1,'生来武器強化A',''],
  [1,'属性付与',''],
  [1,'部位強化',''],
  [1,'部位耐久増強',''],
  [1,'コア耐久増強',''],
  [1,'ブレス強化','ドレイク専用'],
  [1,'魔剣ランク上昇A','ドレイク専用'],
  [1,'魔剣形状変更','ドレイク専用'],
  [1,'暗視付与','バジリスク専用'],
  [1,'邪視強化A／石化','バジリスク専用'],
  [1,'邪視強化A／貫く','バジリスク専用'],
  [1,'邪視強化A／破錠','バジリスク専用'],
  [1,'邪視強化A／賦活','バジリスク専用'],
  [1,'邪視強化A／高揚','バジリスク専用'],
  [1,'邪視強化A／消散','バジリスク専用'],
  [1,'邪視強化A／蘇る','バジリスク専用'],
  [1,'邪視強化A／全天','バジリスク専用'],
  [1,'邪視強化A／操位','バジリスク専用'],
  [1,'邪視強化A／潜魂','バジリスク専用'],
  [1,'邪視強化A／停滞','バジリスク専用'],
  [1,'邪視強化A／その他','バジリスク専用'],
  [1,'邪視拡大／達成値','バジリスク専用'],
  [1,'邪視拡大／戦闘特技','バジリスク専用'],
  [5,'渾身攻撃',''],
  [5,'生来武器強化S',''],
  [5,'部位超強化',''],
  [5,'部位耐久超増強',''],
  [5,'コア耐久超増強',''],
  [5,'練技使用',''],
  [5,'魔剣+1','ドレイク専用'],
  [5,'魔剣吸収','ドレイク専用'],
  [5,'魔剣ランク上昇S','ドレイク専用'],
  [5,'邪視拡大／数','バジリスク専用'],
  [5,'邪視強化S／石化','バジリスク専用'],
  [5,'邪視強化S／貫く','バジリスク専用'],
  [5,'邪視強化S／破錠','バジリスク専用'],
  [5,'邪視強化S／賦活','バジリスク専用'],
  [5,'邪視強化S／高揚','バジリスク専用'],
  [5,'邪視強化S／消散','バジリスク専用'],
  [5,'邪視強化S／蘇る','バジリスク専用'],
  [5,'邪視強化S／全天','バジリスク専用'],
  [5,'邪視強化S／操位','バジリスク専用'],
  [5,'邪視強化S／潜魂','バジリスク専用'],
  [5,'邪視強化S／停滞','バジリスク専用'],
  [5,'邪視強化S／その他','バジリスク専用'],
  [5,'巨大な身体','バジリスク専用'],
  [10,'生来武器強化SS',''],
  [10,'部位極強化',''],
  [10,'部位耐久極増強',''],
  [10,'コア耐久極増強',''],
  [10,'魔将の領域',''],
  [10,'マナ解除',''],
  [10,'燦光のブレス','ドレイク専用'],
  [10,'魔剣ランク上昇SS','ドレイク専用'],
  [10,'邪眼追加','バジリスク専用'],
  [10,'邪視強化SS／石化','バジリスク専用'],
  [10,'邪視強化SS／貫く','バジリスク専用'],
  [10,'邪視強化SS／破錠','バジリスク専用'],
  [10,'邪視強化SS／賦活','バジリスク専用'],
  [10,'邪視強化SS／高揚','バジリスク専用'],
  [10,'邪視強化SS／消散','バジリスク専用'],
  [10,'邪視強化SS／蘇る','バジリスク専用'],
  [10,'邪視強化SS／全天','バジリスク専用'],
  [10,'邪視強化SS／操位','バジリスク専用'],
  [10,'邪視強化SS／潜魂','バジリスク専用'],
  [10,'邪視強化SS／停滞','バジリスク専用'],
  [10,'邪視強化SS／その他','バジリスク専用'],
  [10,'魔法使用','バジリスク専用'],
);

our @craft_seal = (
  [1,'威力増強／+5',''],
  [1,'命中増強／+1',''],
  [1,'C値増強／-1',''],
  [1,'七色の武器',''],
  [1,'自動帰還',''],
  [1,'追撃の魔力',''],
  [1,'防護点増強／+1',''],
  [1,'回避増強／+1',''],
  [1,'危機回避','幸運の誘い',''],
  [1,'秘奥射程増強／+5m',''],
  [1,'秘奥ダメージ増強／+1',''],
  [1,'魔物知識増強／+2',''],
  [1,'誤射防止',''],
  [1,'生死判定増強／+3',''],
  [1,'MP自動回復／+1',''],
  [1,'HP増強／+5',''],
  [1,'能力値増強／+2',''],
  [1,'魔法ダメージ軽減／-1',''],
  [1,'浮遊落下',''],
  [1,'移動力増強',''],
  [1,'姿勢補助',''],
  [5,'威力超増強／+10',''],
  [5,'命中超増強／+1',''],
  [5,'C値超増強／-1',''],
  [5,'追撃の魔力増強／+2',''],
  [5,'武器巨大化／+10',''],
  [5,'防護点超増強／+1',''],
  [5,'魔法防御特化／-2＆+3',''],
  [5,'属性ダメージ軽減／-2',''],
  [5,'回避超増強／+1',''],
  [5,'浮遊盾',''],
  [5,'魔力増強／+1',''],
  [5,'魔法クリティカル増強／-1',''],
  [5,'浮遊魔導書',''],
  [5,'魔物解析',''],
  [5,'戦場把握',''],
  [5,'回復増強／+1',''],
  [5,'回復効果クリティカル',''],
  [5,'ブレスダメージ軽減／-2',''],
  [5,'マナ吸収',''],
  [5,'抵抗力増強／+1',''],
  [5,'守護の障壁／-5',''],
  [5,'機先の運び／+2',''],
  [5,'移動力超増強',''],
  [5,'完全姿勢補助',''],
  [5,'不動の礎',''],
  [10,'威力極増強／+15',''],
  [10,'命中極増強／+1',''],
  [10,'C値極増強／-1',''],
  [10,'吸精の武器',''],
  [10,'武器超巨大化／+10',''],
  [10,'防護点極増強／+1',''],
  [10,'属性ダメージ超軽減／-2',''],
  [10,'属性ダメージ軽減範囲拡大',''],
  [10,'回避力極増強／+1',''],
  [10,'双魔増強',''],
  [10,'魔力超増強／+1',''],
  [10,'マナ効率化',''],
  [10,'魔物知識超増強／+2',''],
  [10,'魔導即応',''],
  [10,'回復超増強／+2',''],
  [10,'生死判定超増強／+3',''],
  [10,'魔法ダメージ超軽減／-2',''],
  [10,'ブレスダメージ超軽減／-3',''],
  [10,'HP超増強／+5',''],
  [10,'抵抗力超増強／+1',''],
  [10,'能力値超増強／+1',''],
  [10,'移動力極増強',''],
  [10,'風乗りの靴',''],
);

our @craft_dignity = (
  [1,'威厳ある風格Ⅰ',''],
  [1,'麗しき歌声Ⅰ',''],
  [1,'華麗なる言の葉Ⅰ',''],
  [1,'気高き振る舞いⅠ',''],
  [1,'心震わせる美声Ⅰ',''],
  [1,'超然たるまなざしⅠ',''],
  [1,'優雅なる足運びⅠ',''],
  [1,'秘めたる博識Ⅰ',''],
  [1,'囁く気配Ⅰ',''],
  [1,'攻撃陣形',''],
  [1,'遠距離攻撃陣形',''],
  [1,'対レギオン攻撃',''],
  [1,'防御陣形',''],
  [1,'一気呵成の陣',''],
  [1,'高速移動陣形',''],
  [1,'他者追随',''],
  [1,'意思持たぬ兵隊',''],
  [1,'獣との共感',''],
  [1,'高額支給',''],
  [5,'威厳ある風格Ⅱ',''],
  [5,'麗しき歌声Ⅱ',''],
  [5,'華麗なる言の葉Ⅱ',''],
  [5,'心震わせる美声Ⅱ',''],
  [5,'超然たるまなざしⅡ',''],
  [5,'部下の情報収集',''],
  [5,'横一列攻撃陣形',''],
  [5,'波状攻撃陣形',''],
  [5,'一騎駆けの陣',''],
  [5,'魔力増大の陣',''],
  [5,'鶴翼の陣',''],
  [5,'射程延長',''],
  [5,'魚鱗の陣',''],
  [5,'野生のカン',''],
  [5,'硬い身体',''],
  [5,'対属性結界印',''],
  [10,'威厳ある風格Ⅲ',''],
  [10,'麗しき歌声Ⅲ',''],
  [10,'華麗なる言の葉Ⅲ',''],
  [10,'気高き振る舞いⅡ',''],
  [10,'心震わせる美声Ⅲ',''],
  [10,'超然たるまなざしⅢ',''],
  [10,'優雅なる足運びⅡ',''],
  [10,'秘めたる博識Ⅱ',''],
  [10,'囁く気配Ⅱ',''],
  [10,'熟練たる魚鱗の陣',''],
  [10,'魔撃の陣',''],
  [10,'一騎当千の陣',''],
  [10,'魔力暴走の陣',''],
  [10,'緊急覚醒',''],
  [10,'獣の生命力',''],
  [10,'鉄壁のファランクス',''],
  [10,'部隊分割',''],
);

our @magic_gramarye = (
  [1,"悪意の針",'アクス＝マリスティアス'],
  [1,"拒絶の障壁",'ウェルム＝リイェクタス'],
  [1,"肉体修復",'コルプス＝レストラーレ'],
  [1,"猛毒の霧",'ネブラ＝ウェネーヌムス'],
  [1,"破滅の槍",'ランケア＝ルイナス'],
  [4,"退魔活性",'アクティオ＝エクソキスムス'],
  [4,"属性付加",'アディシオ＝エレメントゥム'],
  [4,"容姿端麗",'プルケリトゥード'],
  [4,"魔力増強",'マギカ＝アウゲータス'],
  [4,"貫く光条",'ルクス＝トライキエンス'],
  [7,"大気爆発",'アトモス＝イラプティオ'],
  [7,"大跳躍",'マグナ＝サルトゥス'],
  [7,"瞬間修復",'モメント＝レストラーレ'],
  [7,"断罪の槍",'ランケア＝ダムナトリウス'],
  [7,"再生起動",'レナトゥス＝イニシアトゥス'],
  [10,"高速飛行",'ケレリタス＝ウォラートゥス'],
  [10,"完全防護",'デフェンシオス＝ペルフェクタス'],
  [10,"闇を裂く閃光",'デネブラス＝カイエンデンス＝ルミナス'],
  [10,"仮想の死",'モルス＝ウィルトゥアリス'],
  [13,"空間転移",'スパティウム＝テレポータス'],
  [13,"死の嵐",'モルス＝テンペスタス'],
  [13,"神殺の槍",'ランケア＝フェリオデウス'],
  [13,"聖魔の光来",'ルクス＝サンクトゥム＝アドヴェントゥス'],
);


1;