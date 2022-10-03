# mini_lisp
## 編譯執行：
1. 將finalp.l及finalp.y放到家目錄下
2. 打開終端機
3. 依序輸入：  
bison -d -o y.tab.c finalp.y  
gcc -c -g -I.. y.tab.c  
flex -o lex.yy.c finalp.l  
gcc -c -g -I.. lex.yy.c  
gcc -o finalp y.tab.o lex.yy.o -ll  
4. 最後輸入：
		./finalp < xxxx.lsp   (xxxx為測試資料檔名)
5. 觀看測試結果

## 設計簡述：
1. syntax validation：
根據助教提供的文法，撰寫至finalp.y檔內，再依讀取需要，定義finalp.l內的各個token。  
2. print：
	在PRINT_NUM的文法那行，定義輸出的動作，PRINT_BOOL處亦類似。  
3. numerical operation：
- 加法、乘法：
因為lisp文法支持連加與連乘，故需另外定義文法，使其加法和乘法的exp可以展開多次做計算。
- 減法、除法、mod：
減法與除法只需在其文法那行做一次運算即可。
- 大於、小於：
在文法那行，若符合大於、等於或小於的定義者就回傳1，反之則回傳0。
- 等於：
因為等於可以判斷多個exp，故需另外定義文法，又因為在文法展開的過程中需要存取目前相等值，故也需要另外定義一個struct，存取當前布靈值與數值。
4. logical operation：
- And、or：
因為and和or需要做多次判斷，故需另外定義文法，使其可以多次展開判斷。
- Not：
Not只需在其文法那行做一次判斷即可。
5. if expression：
		在if_exp文法那行，定義其動作。
6. variable definition：
定義兩個gobal的陣列，id_la[200][50]存取變數名字，可存200個50字元內的變數名字，num[200]可存200個變數值，另定義一個整數值len，用以標示目前存到的變數量。在def_stmt文法那行，定義存變數名與變數值的動作。為了防止重複定義的問題，在存變數名與變數值之前，做了一個while迴圈，在目前的id_la陣列中搜尋有沒有和目前想存的變數名同名的變數，有的話，就輸出「redefining is not allowed.」的error message，沒有的話，就將此變數名及變數值存入各自的陣列中，並將len值加一。
另外，欲列印變數名的變數值時，需將變數名和變數值的對應index找出，並印出該index的變數值。
