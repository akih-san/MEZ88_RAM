# MEZ86_RAM Rev1.1

MEZ86_RAM Rev1.1は[EMUZ80](https://vintagechips.wordpress.com/2022/03/05/emuz80_reference/)ボード上で動く8086/V30メザニンボードです。



（MEZ86_RAM Rev1.1メザニンボード）
![](photos/DSC_0018-1.png)<br>




EMUZ80はMicrochip社のPIC18F47Q43/83/84を使用して、Z80を制御するシングルボードコンピュータ
です。また、Z80の代わりにメザニンボードを装着することで、レガシーCPU（68008や、8086、V30、他）
を動かすことが出来ます。<br>
UART, SPI, I2C等の制御をPICで行い、レガシーCPUの外部I/Oとして機能を提供します。
SDカードはSPIを通して実装されています。<br>
PICから、レガシーCPUのメモリ空間にアクセスすることで、レガシーPCのプログラムをロードする
ことが出来るため、ROMは必要なくSRAMでプログラムを動作させることが出来ます。


# １．起動画面
MEZ86_RAM Rev1.1を起動すると、初期化終了後に、プログラムの選択待ちになります。
![](photos/opening.png)<br>

# ２．特徴
・動作CPU : Intel8086 CPU（その他互換CPU) 5MHz/8MHz/10MHz、または、NEC V30(μPD70116) 10MHz/16MHz<br>
・Microcontroller : PIC18F47Q43, PIC18F47Q84, PIC18F47Q83（注1）（注2）<br>
・1MB SRAM搭載(AS6C4008-55PCN 2個)<br>
・μSDカードI/F（SPI)<br>
・I2C I/F (RTC)リアルタイムクロック：DS1307をサポート）（注3）<br>
・UART（9600bps無手順）<br>
・コンソールキー（Ctrl-Qを2回連続入力）によるNMI割込みのサポート（注4）<br>
・INTRによる10msのインターバルタイマー割込みのサポート（注5）<br>
・動作プログラム : 後述<br><br>
（注1）<br>
　PIC18F47QXXのCLC機能を使って8086/V30のINTRを実現しています。<br>
　プログラムでの割込みベクター発生のため、CPU速度10MHzまでの<br>
　サポートになります。<br>
　12.8MHz, 16MHzのクロック指定をした場合、INTRが発生しないように<br>
　ファームウェアで調整されます。<br>
（注2）<br>
　PIC18F47QXXから1MBメモリをアクセスするために、8086/V30のALE信号に<br>
　CPLD(ATF22V10)でゲートロジックを通しています。<br>
　そのため、V30(μPD70116) 16MHz動作が安定しません。12.8MHzでの動作で<br>
　安定してると思われます。<br>
　クロックの設定は、12.8MHz, 16MHzが指定できますが、<br>
　INTRを使用する場合には10MHz以下に設定する必要があります。<br>
（注3）<br>
　I2Cの制御ドライバは、[EMU57Q-8088/V20](https://github.com/akih-san/EMU57Q-Rrv2.1_CPM_MSDOS)のファームウェアを流用しています。<br>
（注4）<br>
　NMI割込みで、常駐プログラムのモニター（Universal Monitor）が起動します。<br>
　モニターのbyeコマンドで、CPU側にリセットをかけてファームウェアの入力待ちに戻ることが出来ます。<br>
（注5）<br>
　[コンフィグ設定ファイル](https://github.com/akih-san/MEZ86_RAM/tree/main/DISKS)で割込みベクター番号の設定が可能<br>

# ３．RTC(DS1307)モジュール
DS1307を使ったTiny RTC moduleをサポートします。<br>
Tiny RTC moduleはArduinoで使用可能で、amazon, AliExpress等のから入手することができます。<br>
また、安価な互換品が出回っています。<br>
テストでは互換品を使いましたが、特に問題なく使用できました。<br>
SQピン端子は未使用です。SCL、SDA、VCC、GNDの４ピンを使用しています。<br>
<br>
日時の設定は、ファームウェア起動時のセレクトリスト0番（TOD）で指定します。<br>
もしくは、MS-DOSのdate, timeコマンドで設定することが出来ます。<br>
RTC(DS1307)モジュールが接続されていない場合、PICのtimer0の10msタイマーを用いて、<br>
日時をカウントします。その場合、電源OFFで日時が2025/06/01 00:00:00にリセットされます。<br>

(tiny_rtc_modules)<br>
![](photos/tiny_rtc_modules1.png)

# ４．μＳＤカードモジュール
SPIで制御されるμＳＤカードモジュールは、Arduinoで使用可能で、amazon, AliExpress等のから入手することができます。<br>

(μSD Card module)<br>
![](photos/μSD.png)


# ５．CPLD（22V10）
以下の外部ロジックをCPLD（22V10）を使用して1chipにまとめてあります。<br>
<br>
 ・PICからメモリアクセスを行うため、ALE信号の操作<br>
 ・SDカードアクセスの一部<br>
 ・バイト、ワードメモリアクセス関連<br>
 ・CPU HOLD時に、INTR, MIOの信号をPICでA19,A18として使用するための切替回路<br>
<br>
動作確認は、ATF22V10C-7PX, GAL22V10B-15LPで行っています。<br>
使用するために、jedファイルをCPLDに書き込む必要があります。（後述）<br>

# ６．動作プログラム
提供しているプログラムについては、他のリポジトリのプログラムをMEZ86_RAM上で動作するように移植したものです。<br>

[SBCV20_8088](https://github.com/akih-san/SBCV20_8088/tree/main)<br>
 ・Universal Monitor<br>
 ・Toyoshiki Tiny Basic<br>
 ・VTL-C<br>
 ・GAME-C Interpreter<br>
<br>
[MEZ88_RAM](https://github.com/akih-san/MEZ88_RAM)<br>
 ・CP/M-86<br>
 ・MS-DOS<br>
<br>
[8086 NASCOM BASIC](https://github.com/satoshiokue/8086_NASCOM_BASIC)<br>
 ・8086 NASCOM BASIC<br>

8086 NASCOM BASICは、[@S_Okue](https://x.com/S_Okue)さん([satoshiokue](https://github.com/satoshiokue))によって
Z80用のアセンブラから、8086用のアセンブラにコンバートされたものです。<br>
今回、MEZ86_RAM上で動くように移植しました。<br>
<br>
Universal Monitorは、単体で起動できますが、他のプログラムを起動したときには、
常駐モニターとしてロードされます。<br>
プログラム終了時や、（Ctrl+Qキーを2回連続入力で）NMI割込みを発生させると、<br>
常駐モニターに制御が移ります。モニターのbyeコマンドで、CPUにリセットをかけ<br>
ファームウェアの選択画面に戻すことができます。<br>
<br>

(例：MS-DOSを終了しファームウェアに戻る)<br>
![](photos/MSDOS終了.png)

## INTRによる割込み
提供しているプログラムは、移植のみでINTRによる割込みは使用していません。
INTRの確認は[テストプログラム](https://github.com/akih-san/MEZ86_RAM/blob/main/i86src/standalone/INTR_test/INTR%E3%81%AE%E7%A2%BA%E8%AA%8D.txt)で行っています。

# ７．PIC18F47QXX、CPLDへの書き込み
## 1. PIC18F47QXXへの書き込み
PICへの書き込みツールを用いて、Hexファイルを書き込みます。
INTRによる割込みベクター発生のタイミング調整のため、クロック別にHexファイルがあります。
使用するCPUのクロックに合わせて使用します。<br>
INTRを使用しない場合には、どのHexファイルを使用しても構いません。ファームウェア起動時に
指定クロック優先でINTRの可不可が調整されます。<br>
<br>
- PIC18F47Q43<br>
　　Q43_5MHz.hex<br>
　　Q43_8MHz.hex<br>
　　Q43_9_10MHz.hex<br>
- PIC18F47Q84
　　Q84_5MHz.hex<br>
　　Q84_8MHz.hex<br>
　　Q84_9_10MHz.hex<br>
- PIC18F47Q83<br>
　　Q83_5MHz.hex<br>
　　Q83_8MHz.hex<br>
　　Q83_9_10MHz.hex<br>
<br>
＜使用確認した書き込みツール＞<br>
<br>
- snap(マイクロチップ社の書き込みツール)<br>

  - [snap](https://www.microchip.com/en-us/development-tool/PG164100)

<br>
- PICkit3（または互換ツール）<br><br>
  PICkitminus書き込みソフトを用いて、書き込むことが出来ます。以下で入手できます。<br>

  - [PICkitminus](https://github.com/jaka-fi/PICkitminus)

## ２．CPLDへの書き込み

CPLDには、ROMライタを使用してCPLD/MEZ86_RAM.jedファイルを書込みます。
使用したのは、XGecu Programmer Model TL866Ⅱ PLUSです。<br>
少し古いですが、問題なく書き込みが出来ました。XGecu Official Siteは[こちら](https://xgecu.myshopify.com/)<br>
ソフトウェアのダウンロードは[こちら](http://www.xgecu.com/en/Download.html?refreshed=1750208080997)<br>

（今回使用したROMライタ）
   ![](photo/ROM_WRITER.JPG)<br>

# ８．μＳＤカードの作成
μSDカードはFAT32を使用しています。4G～16GBまでのＳＤカードで動作確認を行いました。DISKSフォルダ内の以下のフォルダとファイルを、FAT32でフォーマットされた
μSDカードにコピーします。<br>
<br>
＜フォルダ＞<br>
　・CPMDISKS<br>
　・DOSDISKS<br>
<br>
＜ファイル＞<br>
　・BASIC_86.BIN		（8086 NASCOM BASIC）<br>
　・GMI_S86.BIN			（GAME-86 インタプリタ）<br>
　・TT_BAS86.BIN		（豊四季タイニーベーシック）<br>
　・UMON_S86.BIN		（86版ユニバーサルモニタ）<br>
　・VTL_S86.BIN			（Very Tiny Language）<br>
　・MEZ86.CFG			（MEZ86_RAM コンフィグファイル）<br>

# ９．MEZ86_RAM詳細データ
  - [図面](https://github.com/akih-san/MEZ86_RAM/blob/main/pdf/MEZ86_RAM_R1.1%E5%9B%B3%E9%9D%A2.pdf)
  - [部品表](https://github.com/akih-san/MEZ86_RAM/blob/main/pdf/MEZ86_RAM%E9%83%A8%E5%93%81%E8%A1%A8.pdf)
  - [PICピンアサイン](https://github.com/akih-san/MEZ86_RAM/blob/main/pdf/MEZ86_RAM%20R1.1%E3%83%94%E3%83%B3%E3%82%A2%E3%82%B5%E3%82%A4%E3%83%B3.pdf)
  - [Gerberデータ](https://github.com/akih-san/MEZ86_RAM/tree/main/gerber)

## 謝意
MEZ86_RAMで動作するプログラムの多くは、元となる情報を公開されている方々のソースコードから移植しています。<br>
とても有難く使わせてもらい、感謝しています。<br>
  - [「VTL(Very Tiny Language)の作成」](https://middleriver.chagasi.com/electronics/vtl.html)
  - [超ミニ言語で遊ぼう（４）みんなで「スタ☆トレ」](https://ameblo.jp/siropyon/entry-11917965564.html)
  - [Universal Monitor](https://electrelic.com/electrelic/node/1317)
  - [豊四季タイニーベーシック](https://vintagechips.wordpress.com/2015/12/06/%E8%B1%8A%E5%9B%9B%E5%AD%A3%E3%82%BF%E3%82%A4%E3%83%8B%E3%83%BCbasic%E7%A2%BA%E5%AE%9A%E7%89%88/)
  - [「GAME」という名のプログラミング言語](https://ameblo.jp/takeoka/entry-11004344172.html)
  - [PIC24FJ64GAでGAME言語]（その５）](https://piclabo.seesaa.net/article/2015-10-01.html)
  - [ASCIIART (マンデンブロ集合) のソース](https://github.com/kyo-ta04/memo)
  - [Maze for GAME80](https://piclabo.seesaa.net/category/28042960-28.html)
    （★2019/05/03　追記の部分です）<br>

## 参考
### EMUZ80<br>
EUMZ80はZ80CPUとPIC18F47Q43のDIP40ピンIC2つで構成されるシンプルなコンピュータです。<br>
　　[電脳伝説 - EMUZ80が完成](https://vintagechips.wordpress.com/2022/03/05/emuz80_reference)
### SBCV20<br>
[SBCV20](https://vintagechips.wordpress.com/category/8088-v20/)
は[電脳伝説](https://vintagechips.wordpress.com/)さんによって作成されたSBCです。<br>
　　[SBCV20の技術資料](http://www.amy.hi-ho.ne.jp/officetetsu/storage/sbcv20_techdata.pdf)<br>
　　[SBCV20の入手先](https://store.shopping.yahoo.co.jp/orangepicoshop/pico-a-037.html)<br>
### SuperMEZ80<br>
[SuperMEZ80](https://github.com/satoshiokue/SuperMEZ80)は、EMUZ80にSRAMを追加しZ80をノーウェイトで動かすことができます。
### ＠hanyazouさんのソース<br>
https://github.com/hanyazou/SuperMEZ80/tree/mez80ram-cpm<br>
### @electrelicさんのユニバーサルモニタ<br>
https://electrelic.com/electrelic/node/1317<br>
### オレンジピコショップ<br>
オレンジピコさんでEMUZ80、その他メザニンボードの購入できます。<br>
<br>
https://store.shopping.yahoo.co.jp/orangepicoshop/pico-a-051.html<br>
https://store.shopping.yahoo.co.jp/orangepicoshop/pico-a-061.html<br>
https://store.shopping.yahoo.co.jp/orangepicoshop/pico-a-062.html<br>
https://store.shopping.yahoo.co.jp/orangepicoshop/pico-a-079.html<br>
https://store.shopping.yahoo.co.jp/orangepicoshop/pico-a-087.html<br>
