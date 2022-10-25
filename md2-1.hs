-- aa :: Eq a => [a] -> [(a, a)] -> [a]
aa [] _ = []
aa (a:as) dict
  | snd el /= "" = snd el : aa as (removeElement el dict)
  | otherwise = aa as dict
  where el = dictElement a dict

-- funkcija meklē vārdnīcā a elementam atbilstošu "tulkojumu"
-- dictElement :: Eq a => a ->[(a, a)] -> (a, a)
dictElement a (d:dicts)
  | a == fst d = d
  | otherwise = dictElement a dicts
dictElement _ [] = ("none", "")

-- funkcija atgriež jaunu vārdnīcu bez elementa el
-- removeElement :: Eq a => a -> [a] -> [a]
removeElement el (d:dicts)
  | el == d = dicts
  | otherwise = d : removeElement el dicts
remove _ [] = []

dict = [("I", "ya"), ("eat", "yim"), ("ice cream", "morozyvo"), ("bread", "khlib"), ("and", "ta"), ("apple", "yabluko"), ("buy", "kupuyu"), ("see", "bachu")]
test_input = ["I", "eat", "apple", "and", "buy", "bread", "and", "ice cream"]