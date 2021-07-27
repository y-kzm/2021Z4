# SecCamp2021 Z4 講義用 
- 2021_07_26~  
- Yokoo Kazuma  

---

# 事前学習 0x01
## (1) 復習
- 演習課題: Virtual Network playground 2  
  - netnsを用いて構築する
 
  ![](img/topo3.png)

>作業フォルダ: netns_pg2/

## (2) TiNET入門 
### (2.1) 課題: 基本  
- 演習課題: Virtual Network playground 1  
  - TiNETを用いて構築する(実行するだけの動作確認)

  ![](img/topo2.png)

- Usage  

~~~
tinet up -c spec.yaml | sudo sh -x
tinet conf -c spec.yaml | sudo sh -x
tinet test -c spec.yaml | sudo sh -x
tinet down -c spec.yaml | sudo sh -x
~~~

>作業フォルダ: tinet_pg1/  
>yamlファイルは以下をそのまま使用   
>https://github.com/tinynetwork/tinet/blob/master/examples/simple/topo2/spec.yaml  

### (2.2) 課題: 実践  
- 演習課題: Virtual Network playground 2  
  - TiNETを用いて構築する

 ![](img/topo3.png)

>作業フォルダ: tinet_pg2/  
>yamlファイル: tinet_pg2/spec_pg2.yaml  

---

# 事前学習 0x02


