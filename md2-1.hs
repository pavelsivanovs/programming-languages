{-
Autors: Pavels Ivanovs pi19003
-}

aa :: (Eq a) => [a] -> [(a,a)] -> [a]
aa (a:as) dict
  | found = snd el : (aa as $ removeElement el dict)
  | otherwise = aa as dict
  where 
    found = isElemInDict a dict
    el = findElement a dict
aa [] _ = []

{-
Funkcija pārbauda, vai padotais elements ir atrodams kā viens no vārdnicas indeksiem.
Ja elements neatbilst vārdnīcas pirmajam elementam, pārbaudām palikušajā vārdnīcā.
-}
isElemInDict :: (Eq a) => a -> [(a,a)] -> Bool
isElemInDict el (d:dict)
  | found = True
  | otherwise = isElemInDict el dict
  where found = el == fst d
isElemInDict _ [] = False

{-
Funkcija meklē vārdnīcā a elementam atbilstošu "tulkojumu".
Ja elements neatbilst vārdnīcas pirmajam elementam, meklējām palikušajā vārdnīcā.
-}
findElement :: (Eq a) => a ->[(a,a)] -> (a,a)
findElement a (d:dicts)
  | a == fst d = d
  | otherwise = findElement a dicts

{-
Funkcija atgriež jaunu vārdnīcu bez elementa el.
-}
removeElement :: (Eq a) => (a,a) -> [(a,a)] -> [(a,a)]
removeElement el (d:dicts)
  | snd el == snd d = removeElement el dicts
  | otherwise = d : removeElement el dicts
removeElement _ [] = []

bb :: (Eq a) => [(a, a)] -> [(a, a)] -> [(a, a)]
bb dicA dicB = removeDuplicates $ bb_main dicA dicB

{-
Funkcija atgriež ar duplikātiem divu vārdnīcu kompozīciju.
Jaunā vārdnīca tiek veidota, atrodot kompozīcijas vārdnīcu no A saraksta 1. elementa
un B vārdnīcas un tai konkatinējot vārdnīcu kompozīciju no palikušas A vārdnīcas un B vārdnīcas.
-}
bb_main :: (Eq a) => [(a, a)] -> [(a, a)] -> [(a, a)]
bb_main (dA:dicA) (dB:dicB) = bb_matchEl dA (dB:dicB) ++ bb_main dicA (dB:dicB)
bb_main [] _ = []
bb_main _ [] = []

{-
Funkcija atgriež jaunu vārdnīcu, kas ir padotu elementa un vārdnīcas kompozīcija.
Rekursīvs darbības princips.
-}
bb_matchEl :: (Eq a) => (a,a) -> [(a,a)] -> [(a,a)]
bb_matchEl dA (dB:dicB)
  | similar = (fst dA, snd dB) : bb_matchEl dA dicB
  | otherwise = bb_matchEl dA dicB
  where similar = snd dA == fst dB
bb_matchEl _ [] = []

cc :: (Eq a) => [(a,a)] -> (Int, [(a,a)])
cc a = cc_main (1,a,a)

{-
Funkcija atgriež a vārdnīcas slēgumu, rekursīvi pārbaudot, vai vārdnīcas N+1-slēgums
ir vienāds ar vārdnīcas N-slēgumu. Rekursīvs darbības princips.
-}
cc_main :: (Eq a) => (Int, [(a,a)], [(a,a)]) -> (Int, [(a,a)])
cc_main (m,a,aBase)
  | same = (m,a)
  | otherwise = cc_main (m+1, aComposed, aBase)
  where
    aComposed = removeDuplicates $ a ++ bb a aBase
    same = a == aComposed

{-
Funkcija izdzēš duplikātus no vārdnīcas rekursīvā veidā.
Pirmo vārdnīcas elementu konkatinē ar palikušo vārdnīcu, kur nav pirmā elementā un kur ir jau izņemti citi duplikāti.
-}
removeDuplicates :: (Eq a) => [a] -> [a]
removeDuplicates (d:dict) = d : (removeDuplicates $ filter (/=d) dict)
removeDuplicates [] = []


aa1 :: IO ()
aa1 = do
  let x = ["I", "eat", "apple", "and", "buy", "bread", "and", "ice cream"]
  let y = [("I", "ya"), ("eat", "yim"), ("ice cream", "morozyvo"), ("bread", "khlib"), ("and", "ta"), ("apple", "yabluko"), ("buy", "kupuyu"), ("see", "bachu")]
  print $ aa x y

aa2 :: IO ()
aa2 = do
  let x = [1,2,3,4,5,4,6,4]
  let y = [(1,10),(2,20),(3,30),(4,41),(4,42),(5,50),(6,60)]
  print $ aa x y

bb1 :: IO ()
bb1 = do
  let x = [(1,2),(2,3),(3,4),(4,5),(5,6),(7,8),(8,6)]
  let y = [(2,20),(3,30),(4,40),(5,50),(6,60),(7,70)]
  print $ bb x y

bb2 :: IO ()
bb2 = do
  let x = [("a","b"), ("a","c"), ("c","d"), ("e","f"), ("g","h")]
  let y = [("b","a"), ("b","b"), ("b","c"), ("b","d"), ("b","a"), ("b","a"), ("c","a"), ("c","d"), ("f","ff")]
  print $ bb x y

cc1 :: IO ()
cc1 = do
  let x = [(1,2),(2,3),(3,4),(4,5),(5,1)]
  let (slegums, px) = cc x
  print slegums
  print px

cc2 :: IO ()
cc2 = do
  let x = [("a","b"),("b","c"),("c","d"),("d","e"),("c","e"),("e","a")]
  let (slegums, px) = cc x
  print slegums
  print px