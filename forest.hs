module Main where

import qualified Data.Set as S
import System.Environment

data Forest = Forest
  { goats :: !Int
  , wolves :: !Int
  , lions :: !Int
} deriving (Show, Ord, Eq)

isStable :: Forest -> Bool
isStable (Forest 0 0 _) = True
isStable (Forest 0 _ 0) = True
isStable (Forest _ 0 0) = True
isStable _ = False

isValid :: Forest -> Bool
isValid (Forest g w l) = g >= 0 && w >= 0 && l >= 0

mutate :: S.Set Forest -> S.Set Forest
mutate = S.filter isValid . S.unions . f
  where f set = [S.map lionEats set, S.map wolfEats set, S.map goatEats set]
        lionEats (Forest g w l) = Forest (g-1) (w-1) (l+1)
        wolfEats (Forest g w l) = Forest (g-1) (w+1) (l-1)
        goatEats (Forest g w l) = Forest (g+1) (w-1) (l-1)

solve :: Forest -> S.Set Forest
solve = solve' . S.singleton
  where
  solve' xs | cond xs = solve' $ mutate xs
            | otherwise = S.filter isStable xs
  cond vec | S.null vec = False
           | otherwise = S.null . S.filter isStable $ vec

main :: IO ()
main = do
  [g, w, l] <- fmap (map read) $ getArgs
  let initial = (Forest g w l)
  print initial
  print $ solve initial
