install.packages("PogromcyDanych")
library(PogromcyDanych)
auta2012

View(auta2012)
library(dplyr)
library(tidyr)

#Komentarz w ramach wst�pu: Celem pracy domowej by�o �wiczenie pakiet�w dplyr i tidyr, a nie analiza statystyczna tych danych, dlatego nad niekt�rymi z odpowiedzi 
#                           mo�na by�oby si� dalej zastanowi�, czy faktycznie stanowi� najtrafniejsz� odpowied� na zadane pytanie.
#                           Nie chcia�em jednak pracy zbytnio niepotrzebnie komplikowa�, dlatego poprzesta�em na czym� podobnym co robili�my na laboratoriach. 
#                           (Przyk�ad w komentarzu do zadania 10)

#1.Sprawd� ile jest aut z silnikiem diesla wyprodukowanych w 2007 roku?

auta2012 %>% 
  filter(Rok.produkcji == 2007,Rodzaj.paliwa == "olej napedowy (diesel)") %>% 
  summarise('Liczba dieseli w 2007 roku'=n())
  
#Odp: 11621

#2.Jakiego koloru auta maj� najmniejszy medianowy przebieg?
  
  auta2012 %>% 
    group_by(Kolor) %>% 
    summarise(Medianowy_przebieg = median(Przebieg.w.km,na.rm =TRUE)) %>% 
    arrange(Medianowy_przebieg) %>% 
    head(1) %>% 
    select(1)

#Odp: bialy-metallic
    
#3.Gdy ograniczy� si� tylko do aut wyprodukowanych w 2007, kt�ra Marka wyst�puje najcz�ciej w zbiorze danych auta2012?

auta2012 %>% 
  filter(Rok.produkcji==2007) %>% 
  group_by(Marka) %>% 
  summarise(Ilosc_marka=n()) %>% 
  top_n(1) %>% 
  select(1)

#Odp: Volkswagen

#4.Spo�r�d aut z silnikiem diesla wyprodukowanych w 2007 roku kt�ra marka jest najta�sza?

auta2012 %>% 
  filter(Rodzaj.paliwa=="olej napedowy (diesel)",Rok.produkcji==2007) %>% 
  group_by(Marka) %>% 
  summarise(Srednia_cena=mean(Cena.w.PLN,na.rm = TRUE)) %>% 
  arrange(Srednia_cena) %>%
  head(1) %>% 
  select(1)
 
#odp: Aixam

#5.Spo�r�d aut marki Toyota, kt�ry model najbardziej straci�� na cenie pomi�dzy rokiem produkcji 2007 a 2008.

toyota1<-auta2012 %>% 
  filter(Marka=="Toyota") %>% 
  group_by(Model,Rok.produkcji) %>% 
  filter(Rok.produkcji == 2007 | Rok.produkcji==2008) %>% 
  select(Cena.w.PLN,Model,Rok.produkcji) %>% 
  summarise(Srednia = mean(Cena.w.PLN, na.rm = TRUE)) 

toyota2007<-toyota1 %>% 
  filter(Rok.produkcji==2007)

toyota2008<-toyota1 %>% 
  filter(Rok.produkcji==2008)
  
toyota2007 %>% 
  inner_join(toyota2008,by='Model') %>% 
  summarise(Spadek_ceny=Srednia.y-Srednia.x) %>%  
  arrange(-Spadek_ceny) %>% 
  head(1) %>% 
  select(1)


#Odp: Land Cruiser

#6.W jakiej marce klimatyzacja jest najcz�ciej obecna?

auta2012 %>% 
  group_by(Marka) %>% 
  mutate(Klimatyzacja = grepl(pattern="Klimatyzacja",Wyposazenie.dodatkowe)) %>% 
  select(Klimatyzacja) %>% 
  summarise(Ilosc=n()) %>% 
  top_n(1)
 

#Odp: Volkswagen

#7.Gdy ograniczy� si� tylko do aut z silnikiem ponad 100 KM, kt�ra Marka wyst�puje najcz�ciej w zbiorze danych auta2012?

auta2012 %>% 
  filter(KM>100) %>% 
  group_by(Marka) %>% 
  summarise(Ilosc=n()) %>% 
  top_n(1) %>% 
  select(1)
  
#Odp: Volkswagen

#8.Gdy ograniczy� si� tylko do aut o przebiegu poni�ej 50 000 km o silniku diesla, kt�ra Marka wyst�puje najcz�ciej w zbiorze danych auta2012?

auta2012 %>% 
  filter(Przebieg.w.km<50000) %>% 
  group_by(Marka) %>% 
  summarise(Ilosc=n()) %>% 
  top_n(1) %>% 
  select(1)

#Odp:Volkswagen

#9.Spo�r�d aut marki Toyota wyprodukowanych w 2007 roku, kt�ry model jest �rednio najdro�szy?

auta2012 %>% 
  filter(Marka=="Toyota",Rok.produkcji==2007) %>% 
  group_by(Model) %>% 
  summarise(mean(Cena.w.PLN,na.rm = TRUE)) %>% 
  top_n(1) %>% 
  select(1)

#Odp: Land Cruiser


#10.Spo�r�d aut marki Toyota, kt�ry model ma najwi�ksz� r�nic� cen gdy por�wna� silniki benzynowe a diesel?

toyota2<-auta2012 %>% 
  filter(Marka=="Toyota",Rodzaj.paliwa=="benzyna"|Rodzaj.paliwa=="olej napedowy (diesel)") %>% 
  group_by(Model,Rodzaj.paliwa) %>% 
  select(Cena.w.PLN,Model,Rodzaj.paliwa) %>% 
  summarise(Srednia_cena=mean(Cena.w.PLN,na.rm=TRUE))

toyotaD<-toyota2 %>% 
  filter(Rodzaj.paliwa=='olej napedowy (diesel)')

toyotaB<-toyota2 %>% 
  filter(Rodzaj.paliwa=="benzyna")

toyotaD %>% 
  inner_join(toyotaB,by="Model") %>% 
  summarise(Roznica_cen=abs(Srednia_cena.y-Srednia_cena.x)) %>% 
  top_n(1) %>% 
  select(1)


#Odp: Camry. Najwi�ksz� r�nic� cen zinterpretowa�em jako najwi�ksz� r�nic� �redniej ceny. Nie uwa�am, �eby to by�o idealne kryterium,
#            we�my na przyk�ad pod uwag� sytuacj�, w kt�rej b�dziemy mie� rzadki model samochodu, z kt�rego sprzeda�o si� po jednej sztuce diesla i benzynowego,
#            diesel jednak by� wyprodukowany w 2016 roku a benzynowy w 2005, zatem oczywi�cie r�nica cen jest bardzo du�a, ale nie ma wiele wsp�lnego z tym,
#            czy samoch�d to diesel czy benzyna, a z jego rokiem produkcji. W�a�ciwa interpretacja statystyczna nie jest jednak g��wnym celem tej pracy domowej, 
#            dlatego pozwoli�em sobie na tego rodzaju uproszczenia skupiaj�c g��wnie na zastosowaniu R i pakiet�w dplyr i tidyr.