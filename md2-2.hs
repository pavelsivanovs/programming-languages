{-
Autors: Pavels Ivanovs pi19003
-}
-- šie valodas paplašinājumi ir nepieciešami, lai varētu
-- rakstīt tādas apakšfunkciju deklarācijas kā funkcijai mmf
{-# LANGUAGE RankNTypes #-}
{-# LANGUAGE ScopedTypeVariables #-}

data TTT aa = LeafNode aa
  | Node aa [TTT aa]
  deriving Show

mm :: forall aa. (aa -> aa) -> TTT aa -> TTT aa
mm f tree = mmf tree 
  where 
    -- vienīgais iemesls, kāpēc ir izveidota mmf funkcija,
    -- lai tajā varētu pielietot map un f būtu izmantojams no 
    -- ārēja scope un tādējādi to nevajadzētu pārnest kā argumentu
    mmf :: TTT aa -> TTT aa
    mmf (Node aa nodeList) = Node (f aa) (map mmf nodeList)
    mmf (LeafNode aa) = LeafNode $ f aa

a :: Integer -> Integer
a i = i*i

b :: Integer -> Integer
b i = rem i 5

{-
Funkcija aprēķina absolūtu attālumu no skaitļa i līdz skaitlim 100.
-}
c :: Integer -> Integer
c i = abs $ 100 - i

testTree = Node 9 [
            LeafNode 7, 
            Node 3 [
              LeafNode (-5), 
              LeafNode 13, 
              LeafNode (-27)
            ], 
            Node 20 [
              LeafNode 1, 
              Node 0 [
                LeafNode 100
              ]
            ], 
            LeafNode 19,
            Node 11111 [
              LeafNode (-79)
            ]
          ]

ff_a :: TTT Integer -> TTT Integer
ff_a tree = mm a tree

ff_b :: TTT Integer -> TTT Integer
ff_b tree = mm b tree

ff_c :: TTT Integer -> TTT Integer
ff_c tree = mm c tree 
