# MEZ88_RAM<br>
<br>
EMUZ80は、電脳伝説さんが開発し、公開したSBCです。Z80の制御に、PIC18F57Q43を使用し<br>
最小限度の部品構成でZ80を動かしています。<br>
<br>
＜電脳伝説 - EMUZ80が完成＞  <br>
https://vintagechips.wordpress.com/2022/03/05/emuz80_reference  <br>
<br>
このことがきっかけで、その後コアな愛好者によって、色々な拡張や<br>
新しいSBCが公開されています。<br>
<br>
今回、このEMUZ80のZ80の代わりに、8088/V20を動かすメザニンボードを<br>
作成しました。<br>
メザニンボード上に、8088/V20と、μSDカード用のSPI I/F、リアルタイム<br>
クロック用のI2C I/F、無手順のUART I/Fを67mm×65mmのPCBに詰め込みました。<br>
ギリギリの大きさまでPCBを詰めたので、部品をハンダ付けする際には、手順を<br>
考えないと、ハンダ付けが困難になるくらいの実装密度になっています(-_-;)<br>
<br>

MEZ88_RAMを搭載したEMUZ80<br>
![MEZ88_RAM 1](photo/P1020561.JPG)

MEZ88_RAM拡大<br>
![MEZ88_RAM 2](photo/P1020564.JPG)

# 特徴<br>
<br>
・動作CPU : Intel8088 CPU（その他互換CPU)、またはNEC V20(μPD70108) 5MHz/8MHz<br>
・512K SRAM搭載(AS6C4008-55PCN)<br>
・μSDカードI/F（SPI)<br>
・I2C I/F (RTC)リアルタイムクロック：DS1307をサポート）（注）<br>
・UART（9600bps無手順）<br>
・動作OS : CP/M-86 または MS-DOS V2.11（起動時に選択可能）<br>
<br>
（注）<br>
I2Cの制御ドライバは、EMU57Q-8088/V20のファームウェアを流用しています。<br>
その為、USB-UARTに接続するモジュール（FT200-XD)を認識します。しかし、MEZ88_RAM<br>
ではI2Cのポートを１つしか実装していないため、RTCのみをサポートしています。<br>
<br>
EMU57Q-8088/V20については、以下を参照してください。<br>
<br>
公開した時系列順です。<br>

・https://github.com/akih-san/EMU8088_57Q_CPM86<br>
・https://github.com/akih-san/EMU8088_MSDOS211<br>
・https://github.com/akih-san/EMU8088_57Q_V2_CPM86<br>
・https://github.com/akih-san/EMU57Q-Rrv2.1_CPM_MSDOS<br>


MEZ88_RAM実装イメージ<br>
![MEZ88_RAM 3](photo/094023.png)

MEZ88_RAMシルク画像<br>
![MEZ88_RAM 4](photo/093906.png)

# ファームウェア（FW）
@hanyazouさん(https://github.com/hanyazou) が作成したZ80で動作しているCP/M-80のFWを<br>
ベースに、MEZ88_RAM用のFWとして動作するように修正を加え、CP/M-86、MS-DOSを<br>
インプリメントしました。<br>
<br>
MS-DOSのデバイスドライバの本体はPICのFW側で実現しています。<br>
DISK I/OとFatFs、及びSPIについては、EMU8088_57QのFWほぼ未修整で使用しています。<br>
<br>
I2Cが使えるのは、MS-DOSのみとなっています。CPM-86では扱っていません。<br>
<br>
I2Cのサポートについては、@etoolsLab369さんのページが非常に参考になりました。<br>
感謝いたします。<br>
<br>
（18F27Q43 2台を使ってHost-Client通信）<br>
https://qiita.com/etoolsLab369/items/65befd8fe1cccd3afc33<br>
<br>
<br>
＜DS1307を使ったRTCモジュール＞
![MEZ88_RAM 5](photo/P1020512.JPG)
![MEZ88_RAM 6](photo/P1020513.JPG)

AE-DS1307：　秋月電子通商で入手できます。<br>
https://akizukidenshi.com/catalog/g/g115488/<br>
<br>
Tiny RTC modules：　amazon、その他有名webストアで入手できます。<br>
説明書も何もありませんが、amazonに図面入りのレビューがありました。<br>
<br>
<br>
# IO.SYSの開発環境
IO.SYSの開発は、マイクロソフト社マクロアセンブラ（MASM）V5.0Aを使用しています。<br>
開発には、セルフで開発できる環境か、MS-DOSエミュレーターが動作する環境が必要です。<br>
<br>
EMU8088のIO.SYSの開発には、Windows上で動くエミュレーターとして有名なmsdos playerを<br>
使用させていただきました。開発者のtakeda氏に深く感謝致します。<br>
<br>
＜MSDOS Playerの場所＞<br>
http://takeda-toshiya.my.coocan.jp/msdos/
<br>
こちらも、参考になるかと。<br>
http://iamdoingse.livedoor.blog/archives/24144518.html


# その他で使用した開発ツール
FWのソースのコンパイルは、マイクロチップ社の<br>
<br>
「MPLAB® X Integrated Development Environment (IDE)」<br>
<br>
を使っています。（MPLAB X IDE v6.20）コンパイラは、XC8を使用しています。<br>
https://www.microchip.com/en-us/tools-resources/develop/mplab-x-ide<br>
<br>
universal moniter 8088/V20は、Macro Assembler AS V1.42を使用してバイナリを<br>
作成しています。<br>
<br>
Macro Assembler 1.42 Beta [Bld 269]<br>
(i386-unknown-win32)<br>
(C) 1992,2024 Alfred Arnold<br>
<br>
http://john.ccac.rwth-aachen.de:8000/as/<br>
<br>
FatFsはR0.15を使用しています。<br>
＜FatFs - Generic FAT Filesystem Module＞<br>
http://elm-chan.org/fsw/ff/00index_e.html<br>
<br>
SDカード上のCP/Mイメージファイルの作成は、CpmtoolsGUIを利用しています。<br>
＜CpmtoolsGUI - neko Java Home Page＞<br>
http://star.gmobb.jp/koji/cgi/wiki.cgi?page=CpmtoolsGUI<br>
<br>
SDカード上のMS-DOSイメージファイルの作成は、ImDisk Virtual Disk Driverを利用しています。<br>
ここで、紹介されています。<br>
https://freesoft-100.com/review/imdisk-virtual-disk-driver.html
<br>
本家は、ここです。<br>
http://www.ltr-data.se/opencode.html/#ImDisk
<br>
＜＠hanyazouさんのソース＞<br>
https://github.com/hanyazou/SuperMEZ80/tree/mez80ram-cpm<br>
<br>
＜@electrelicさんのユニバーサルモニタ＞<br>
https://electrelic.com/electrelic/node/1317<br>
<br>
<br>
# 参考
・EMUZ80<br>
EUMZ80はZ80CPUとPIC18F47Q43のDIP40ピンIC2つで構成されるシンプルなコンピュータです。<br>
＜電脳伝説 - EMUZ80が完成＞  <br>
https://vintagechips.wordpress.com/2022/03/05/emuz80_reference  <br>
<br>
＜EMUZ80専用プリント基板 - オレンジピコショップ＞  <br>
https://store.shopping.yahoo.co.jp/orangepicoshop/pico-a-051.html<br>
<br>
・SuperMEZ80<br>
SuperMEZ80は、EMUZ80にSRAMを追加し、Z80をノーウェイトで動かすことができるメザニンボードです<br>
<br>
＜SuperMEZ80＞<br>
https://github.com/satoshiokue/SuperMEZ80<br>
<br>
