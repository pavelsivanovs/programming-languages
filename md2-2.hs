{-
Autors: Pavels Ivanovs pi19003
-}

data TTT aa = EmptyNode
  | Node aa (TTT aa) (TTT aa) (TTT aa)
  deriving Show

mm :: (aa -> aa) -> TTT aa -> TTT aa
mm f EmptyNode = EmptyNode
mm f (Node aa n1 n2 n3) = (Node (f aa) (mm f n1) (mm f n2) (mm f n3))

a :: Integer -> Integer
a i = i*i

b :: Integer -> Integer
b i = rem i 5

{-
Funkcija aprēķina absolūtu attālumu no skaitļa i līdz skaitlim 100.
-}
c :: Integer -> Integer
c i = abs $ 100 - i

{-
testTree koka reprezentācija:

           (-1)
          _/ | \_
         /   |   \
       27  (-99)  100
     _/ |    \_ 
    /  /       \
1579  27        5
            __/|\__
           /   |   \
          65  75  (-75)
         / \
        1   2
            |
            3
-}
testTree :: TTT Integer
testTree = Node (-1) 
  (Node 27 
    (Node 1579 EmptyNode EmptyNode EmptyNode)
    (Node 27 EmptyNode EmptyNode EmptyNode)
    EmptyNode)
  (Node (-99)
    (Node 5 
      (Node 65 
        (Node 1 EmptyNode EmptyNode EmptyNode)
        (Node 2
          (Node 3 EmptyNode EmptyNode EmptyNode)
          EmptyNode
          EmptyNode) 
        EmptyNode)
      (Node 75 EmptyNode EmptyNode EmptyNode)
      (Node (-75) EmptyNode EmptyNode EmptyNode)) 
    EmptyNode 
    EmptyNode)
  (Node 100 EmptyNode EmptyNode EmptyNode)

ff_a :: TTT Integer -> TTT Integer
ff_a tree = mm a tree

ff_b :: TTT Integer -> TTT Integer
ff_b tree = mm b tree

ff_c :: TTT Integer -> TTT Integer
ff_c tree = mm c tree 
