# MEZ88_RAM Firmware Rev1.3

MEZ88_RAM Rev1.2は[EMUZ80](https://vintagechips.wordpress.com/2022/03/05/emuz80_reference/)ボード上で動く8088/V20メザニンボードです。
Firmware Rev1.3は、MEZ86_RAM Firmware Rev1.1をMEZ88_RAMに移植したものです。


（MEZ88_RAM Rev1.2メザニンボード）
![](photos/DSC_0012.png)<br>


# １．起動画面
MEZ88_RAM Rev1.3を起動すると、初期化終了後に、プログラムの選択待ちになります。
![](photos/opening.png)<br>

# ２．特徴
・動作CPU : Intel8088 CPU（その他互換CPU) 5MHz/8MHz/10MHz、または、NEC V30(μPD70116) 8MHz/10MHz<br>
・Microcontroller : PIC18F47Q43, PIC18F47Q84, PIC18F47Q83（注1）<br>
・512KB SRAM搭載(AS6C4008-55PCN 1個)<br>
・μSDカードI/F（SPI)<br>
・I2C I/F (RTC)リアルタイムクロック：DS1307をサポート）（注2）<br>
・UART3（9600bps無手順） メインコンソール用<br>
・UART5（9600bps無手順） MS-DOS AUXデバイス用<br>
・コンソールキー（Ctrl-Qを2回連続入力）によるNMI割込みのサポート（注3）<br>
・動作プログラム : 後述<br><br>
（注1）<br>
　PIC18F47QXXから512KBメモリをアクセスするために、8088/V20のALE信号に<br>
　ゲートロジックを通しています。<br>
　16MHzまでクロックの設定が出来ますが、10MHzまでしかテスト出来ていません。<br>
（注2）<br>
　I2Cの制御ドライバは、[EMU57Q-8088/V20](https://github.com/akih-san/EMU57Q-Rrv2.1_CPM_MSDOS)のファームウェアを流用しています。<br>
（注3）<br>
　NMI割込みで、常駐プログラムのモニター（Universal Monitor）が起動します。<br>
　モニターのbyeコマンドで、CPU側にリセットをかけてファームウェアの入力待ちに戻ることが出来ます。<br>

# ３．RTC(DS1307)モジュール
DS1307を使ったAE-DS1307モジュールをサポートしています。<br>
（AE-DS1307モジュールは、現在、秋月電子通商で販売していないようです。）
他に、MEZ86_RAMでサポートしているTiny RTC moduleが使えます。
Tiny RTC moduleはArduinoで使用可能で、amazon, AliExpress等のから入手することができます。<br>
ただし、ピン配置が違うので変換アダプタを作成する必要があります。<br>

(rtc_modules)<br>
![](photos/AE-DS1307.png)

<br>
日時の設定は、ファームウェア起動時のセレクトリスト0番（TOD）で指定します。<br>
もしくは、MS-DOSのdate, timeコマンドで設定することが出来ます。<br>
RTC(DS1307)モジュールが接続されていない場合、PICのtimer0の10msタイマーを用いて、<br>
日時をカウントします。その場合、電源OFFで日時が2025/06/01 00:00:00にリセットされます。<br>


# ４．μＳＤカードモジュール
SPIで制御されるμＳＤカードモジュールは、Arduinoで使用可能で、amazon, AliExpress等のから入手することができます。<br>

(μSD Card module)<br>
![](photos/μSD.png)


# ５．動作プログラム
 ・Universal Monitor<br>
 ・8086 NASCOM BASIC<br>
 ・Toyoshiki Tiny Basic<br>
 ・VTL-C<br>
 ・GAME-C Interpreter<br>
 ・CP/M-86<br>
 ・MS-DOS<br>

Universal Monitorは、単体で起動できますが、他のプログラムを起動したときには、
常駐モニターとしてロードされます。<br>
プログラム終了時や、（Ctrl+Qキーを2回連続入力で）NMI割込みを発生させると、<br>
常駐モニターに制御が移ります。モニターのbyeコマンドで、CPUにリセットをかけ<br>
ファームウェアの選択画面に戻すことができます。<br>
<br>

(例：MS-DOSを終了しファームウェアに戻る)<br>
![](photos/MSDOS終了.png)

# ６．PIC18F47QXXへの書き込み
PICへの書き込みツールを用いて、Hexファイルを書き込みます。<br>
- PIC18F47Q43<br>
　　Q43R1.3.hex<br>
- PIC18F47Q84<br>
　　Q84R1.3.hex<br>
- PIC18F47Q83<br>
　　Q83R1.3.hex<br>
<br>
＜使用確認した書き込みツール＞<br>
<br>
- snap(マイクロチップ社の書き込みツール)<br>

  - [snap](https://www.microchip.com/en-us/development-tool/PG164100)

<br>
- PICkit3（または互換ツール）<br><br>
  PICkitminus書き込みソフトを用いて、書き込むことが出来ます。以下で入手できます。<br>

  - [PICkitminus](https://github.com/jaka-fi/PICkitminus)

# ７．μＳＤカードの作成
μSDカードはFAT32を使用しています。4G～16GBまでのＳＤカードで動作確認を行いました。DISKSフォルダ内の以下のフォルダとファイルを、FAT32でフォーマットされた
μSDカードにコピーします。<br>
<br>
＜フォルダ＞<br>
　・CPMDISKS<br>
　・DOSDISKS<br>
<br>
＜ファイル＞<br>
　・BASIC_86.BIN		（8086 NASCOM BASIC）<br>
　・GMI_S88.BIN			（GAME-86 インタプリタ）<br>
　・TT_BAS88.BIN		（豊四季タイニーベーシック）<br>
　・UMON_S88.BIN		（86版ユニバーサルモニタ）<br>
　・VTL_S88.BIN			（Very Tiny Language）<br>
　・MEZ88.CFG			（MEZ88_RAM コンフィグファイル）<br>

# ８．MEZ88_RAM詳細データ
  - [図面](pdf/MEZ88_RAM図面.pdf)
  - [部品表](https://github.com/akih-san/MEZ88_RAM/blob/Rev1.3/pdf/%E3%83%94%E3%83%B3%E3%82%A2%E3%82%B5%E3%82%A4%E3%83%B3%20%20-%20MEZ8847Q.pdf)
  - [PICピンアサイン](https://github.com/akih-san/MEZ88_RAM/blob/Rev1.3/pdf/%E3%83%94%E3%83%B3%E3%82%A2%E3%82%B5%E3%82%A4%E3%83%B3%20%20-%20MEZ8847Q.pdf)
  - [Gerberデータ](gerber)

## 謝意
MEZ88_RAMで動作するプログラムの多くは、元となる情報を公開されている方々のソースコードから移植しています。<br>
とても有難く使わせてもらい、感謝しています。<br>
  - [「VTL(Very Tiny Language)の作成」](https://middleriver.chagasi.com/electronics/vtl.html)
  - [超ミニ言語で遊ぼう（４）みんなで「スタ☆トレ」](https://ameblo.jp/siropyon/entry-11917965564.html)
  - [Universal Monitor](https://electrelic.com/electrelic/node/1317)
  - [豊四季タイニーベーシック](https://vintagechips.wordpress.com/2015/12/06/%E8%B1%8A%E5%9B%9B%E5%AD%A3%E3%82%BF%E3%82%A4%E3%83%8B%E3%83%BCbasic%E7%A2%BA%E5%AE%9A%E7%89%88/)
  - [「GAME」という名のプログラミング言語](https://ameblo.jp/takeoka/entry-11004344172.html)
  - [PIC24FJ64GAでGAME言語]（その５）](https://piclabo.seesaa.net/article/2015-10-01.html)
  - [Maze for GAME80](https://piclabo.seesaa.net/category/28042960-28.html)
    （★2019/05/03　追記の部分です）<br>

## 参考
### EMUZ80<br>
EMUZ80はMicrochip社のPIC18F47Q43/83/84を使用して、Z80を制御するシングルボードコンピュータ
です。また、Z80の代わりにメザニンボードを装着することで、レガシーCPU（68008や、8086、V30、他）
を動かすことが出来ます。<br>
　　[電脳伝説 - EMUZ80が完成](https://vintagechips.wordpress.com/2022/03/05/emuz80_reference)<br>
UART, SPI, I2C等の制御をPICで行い、レガシーCPUの外部I/Oとして機能を提供します。
SDカードはSPIを通して実装されています。<br>
PICから、レガシーCPUのメモリ空間にアクセスすることで、レガシーPCのプログラムをロードする
ことが出来るため、ROMは必要なくSRAMでプログラムを動作させることが出来ます。<br>
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
