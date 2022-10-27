aa :: (Eq a) => [a] -> [(a,a)] -> [a]
aa (a:as) dict
  | found = snd el : (aa as $ removeElement el dict)
  | otherwise = aa as dict
  where 
    found = isElemInDict a dict
    el = findElement a dict
aa [] _ = []

isElemInDict :: (Eq a) => a -> [(a,a)] -> Bool
isElemInDict el (d:dict)
  | found = True
  | otherwise = isElemInDict el dict
  where found = el == fst d
isElemInDict _ [] = False

-- funkcija meklē vārdnīcā a elementam atbilstošu "tulkojumu"
findElement :: (Eq a) => a ->[(a,a)] -> (a,a)
findElement a (d:dicts)
  | a == fst d = d
  | otherwise = findElement a dicts

-- funkcija atgriež jaunu vārdnīcu bez elementa el
removeElement :: (Eq a) => (a,a) -> [(a,a)] -> [(a,a)]
removeElement el (d:dicts)
  | snd el == snd d = removeElement el dicts
  | otherwise = d : removeElement el dicts
removeElement _ [] = []

bb :: (Eq a) => [(a, a)] -> [(a, a)] -> [(a, a)]
bb dicA dicB = removeDuplicates $ bb_main dicA dicB

bb_main :: (Eq a) => [(a, a)] -> [(a, a)] -> [(a, a)]
bb_main (dA:dicA) (dB:dicB)
  | found = (fst dA, snd elB) : (bb_main (dA:dicA) dicB ++ bb_main dicA (dB:dicB))
  | otherwise = bb_main dicA (dB:dicB)
  where 
    found = isElemInDict (snd dA) (dB:dicB)
    elB = findElement (snd dA) (dB:dicB)
bb_main [] _ = []
bb_main _ [] = []

removeDuplicates :: (Eq a) => [a] -> [a]
removeDuplicates (d:dict) = d : (removeDuplicates $ filter (/=d) dict)
removeDuplicates [] = []

dict = [("I", "ya"), ("eat", "yim"), ("ice cream", "morozyvo"), ("bread", "khlib"), ("and", "ta"), ("apple", "yabluko"), ("buy", "kupuyu"), ("see", "bachu")]
test_input = ["I", "eat", "apple", "and", "buy", "bread", "and", "ice cream"]

bb1 :: IO ()
bb1 = do
  let x = [(1,2),(2,3),(3,4),(4,5),(5,6),(6,8)]
  let y = [(2,22),(3,33),(4,44),(5,55),(6,66),(7,77)]
  print $ bb x y

bb2 :: IO ()
bb2 = do
  let x = [("a","b"), ("a","c"), ("c","d"), ("e","f"), ("g","h")]
  let y = [("b","a"), ("b","b"), ("b","c"), ("b","d"), ("b","a"), ("b","a"), ("c","d"), ("f","ff")]
  print $ bb x y

main = do
  let example_list = ["1","2", "1", "3"]
  let example_dict = [("1","viens"), ("2","divi"), ("3","viens")]
  print $ aa example_list example_dict