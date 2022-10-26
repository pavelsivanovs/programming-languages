-- import System.IO

-- aa :: (Eq a) => [a] -> [(a, a)] -> [a]
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
-- removeElement :: (Eq b) => b -> [b] -> [b]
removeElement el (d:dicts)
  | snd el == snd d = removeElement el dicts
  | otherwise = d : removeElement el dicts
removeElement _ [] = []

dict = [("I", "ya"), ("eat", "yim"), ("ice cream", "morozyvo"), ("bread", "khlib"), ("and", "ta"), ("apple", "yabluko"), ("buy", "kupuyu"), ("see", "bachu")]
test_input = ["I", "eat", "apple", "and", "buy", "bread", "and", "ice cream"]

main = do
  let example_list = ["1","2", "1", "3"]
  let example_dict = [("1","viens"), ("2","divi"), ("3","viens")]
  print $ aa example_list example_dict