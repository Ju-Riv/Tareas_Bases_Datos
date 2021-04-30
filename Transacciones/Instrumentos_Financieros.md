#### 1. *Ulises con cuenta en GBM compra a Julieta con cuenta en Santander 400 títulos de AMZ (Amazon) a 66048.20 MXM pagaderos con cash.*

*\# pseudocódigo*

**start transaction**  
transferir_efectivo(Ulises_GMB, BANXICO, 66048.20)

**if error then**  
&nbsp;&nbsp;&nbsp;&nbsp; **rollback**  

 **if success then**  
&nbsp;&nbsp;&nbsp;&nbsp; transferir_capitales(Julieta_Santander, Ulises_GMB, 66048.20)  

&nbsp;&nbsp;&nbsp;&nbsp; **if error then**  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; **rollback** 

&nbsp;&nbsp;&nbsp;&nbsp; **if success then**  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; transferir_efectivo(BANXICO, Julieta_Santander, 6604.20)  

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; **if error then**  

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; **rollback**  

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; **if success then**  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; **commit**

#### 2. Sebas Dulong con cuenta en Citi vende a Javier Orcazas 1200 títulos de GME (GameStop) a 3714.88 pagaderos 100 títulos de deuda gubernamental con valor de 2998.12 y el restante con cash.  

**start transaction**  
transferir_Deuda(JOrcazas, SDulong_Citi, 2998.12)  
transferir_efectivo(JOrcazas, BANXICO, 716.76)

**if error then**  
&nbsp;&nbsp;&nbsp;&nbsp; **rollback**  

**if success then**  
&nbsp;&nbsp;&nbsp;&nbsp; transferir_capitales(SDulong_Citi, JOrcazas, 3714.88)  

&nbsp;&nbsp;&nbsp;&nbsp; **if error then**  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; **rollback** 

&nbsp;&nbsp;&nbsp;&nbsp; **if success then**  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; transferir_efectivo(BANXICO, SDulong_Citi, 716.76)  

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; **if error then**  

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; **rollback**  

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; **if success then**  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; **commit**

#### 3. DJ Delgado con cuenta en Scotia vende 20000 USD a un exchange rate de 25.2 MXN y 300 títulos de deuda corporativa a un precio de 40032.71 a Frida Kaori con cuenta en Inbursa pagaderos enteramente con cash.

**start transaction**  
transferir_efectivo(FKaori, BANXICO, 544032.71)

**if error then**  
&nbsp;&nbsp;&nbsp;&nbsp; **rollback**  

**if success then**  
&nbsp;&nbsp;&nbsp;&nbsp; transferir_divisas(DJDelgado_Scotia, FKaori, 504000.00)  
&nbsp;&nbsp;&nbsp;&nbsp; transferir_capital(DJDelgado_Scotia, FKaori, 40032.71)  

&nbsp;&nbsp;&nbsp;&nbsp; **if error then**  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; **rollback** 

&nbsp;&nbsp;&nbsp;&nbsp; **if success then**  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; transferir_efectivo(BANXICO, DJDelgado, 544032.71)  

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; **if error then**  

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; **rollback**  

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; **if success then**  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; **commit**
