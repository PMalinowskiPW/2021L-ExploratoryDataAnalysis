##Praca domowa 1

library(dplyr)
library(tidyr)
install.packages("PogromcyDanych")
library(PogromcyDanych)
View(auta2012)

## 1. Sprawd� ile jest aut z silnikiem diesla wyprodukowanych w 2007 roku?
nrow(filter(auta2012, Rodzaj.paliwa=="olej napedowy (diesel)", Rok.produkcji==2007))
## Odp: 11621

## 2. Jakiego koloru auta maj� najmniejszy medianowy przebieg?
auta2012 %>%
  group_by(Kolor) %>%
  summarise(mediana=median(Przebieg.w.km,na.rm=TRUE)) %>%
  arrange(mediana) %>%
  head(1)
## Odp: bialy-metallic

## 3. Gdy ograniczy� si� tylko do aut wyprodukowanych w 2007, kt�ra Marka wyst�puje najcz�ciej w zbiorze danych auta2012?
auta2012 %>%
  filter(Rok.produkcji==2007) %>%
  count(Marka) %>%
  top_n(1)
## Odp: Volkswagen

## 4. Spo�r�d aut z silnikiem diesla wyprodukowanych w 2007 roku kt�ra marka jest najta�sza?
auta2012 %>%
  filter(Rok.produkcji==2007, Rodzaj.paliwa=="olej napedowy (diesel)") %>%
  group_by(Marka) %>%
  summarise(srednia=mean(Cena.w.PLN, na.rm=TRUE)) %>%
  arrange(srednia) %>%
  head(1)
## Odp: Aixam

## 5. Spo�r�d aut marki Toyota, kt�ry model najbardziej straci� na cenie pomi�dzy rokiem produkcji 2007 a 2008.
df1 <- auta2012 %>%
  filter(Marka=="Toyota", Rok.produkcji==2007) %>%
  select(Model, Cena.w.PLN) %>%
  group_by(Model) %>%
  summarise(srednia2007=mean(Cena.w.PLN,na.rm=TRUE))
df2 <- auta2012 %>%
  filter(Marka=="Toyota", Rok.produkcji==2008) %>%
  select(Model, Cena.w.PLN) %>%
  group_by(Model) %>%
  summarise(srednia2008=mean(Cena.w.PLN,na.rm=TRUE))
tabela <- inner_join(df1,df2)
tabela %>%
  mutate(roznica=srednia2007-srednia2008) %>%
  top_n(1)
## Odp: Hiace
  
## 6. W jakiej marce klimatyzacja jest najcz�ciej obecna?
auta2012 %>%
  filter(grepl("klimatyzacja",Wyposazenie.dodatkowe)) %>%
  count(Marka) %>%
  top_n(1)
## Odp: Volkswagen

## 7. Gdy ograniczy� si� tylko do aut z silnikiem ponad 100 KM, kt�ra Marka wyst�puje najcz�ciej w zbiorze danych auta2012?
auta2012 %>%
  filter(KM>100) %>%
  count(Marka) %>%
  top_n(1)
## Odp: Volkswagen

## 8. Gdy ograniczy� si� tylko do aut o przebiegu poni�ej 50 000 km o silniku diesla, kt�ra Marka wyst�puje najcz�ciej w zbiorze danych auta2012?
auta2012 %>%
  filter(Przebieg.w.km<50000, Rodzaj.paliwa=="olej napedowy (diesel)") %>%
  count(Marka) %>%
  top_n(1)
## Odp: BMW

## 9. Spo�r�d aut marki Toyota wyprodukowanych w 2007 roku, kt�ry model jest �rednio najdro�szy?
auta2012 %>%
  filter(Marka=="Toyota", Rok.produkcji==2007) %>%
  group_by(Model) %>%
  summarise(srednia=mean(Cena.w.PLN,na.rm=TRUE)) %>%
  top_n(1)
## Odp: Land Cruiser

## 10. Spo�r�d aut marki Toyota, kt�ry model ma najwi�ksz� r�nic� cen gdy por�wna� silniki benzynowe a diesel?
df1 <- auta2012 %>%
  filter(Marka=="Toyota", Rodzaj.paliwa=="olej napedowy (diesel)") %>%
  group_by(Model) %>%
  summarise(srednia.diesel=mean(Cena.w.PLN,na.rm=TRUE))
df2 <- auta2012 %>%
  filter(Marka=="Toyota", Rodzaj.paliwa=="benzyna") %>%
  group_by(Model) %>%
  summarise(srednia.benzyna=mean(Cena.w.PLN,na.rm=TRUE))
tabela <- inner_join(df1,df2)
tabela %>%
  mutate(roznica=abs(srednia.diesel-srednia.benzyna)) %>%
  top_n(1)
## Odp: Camry