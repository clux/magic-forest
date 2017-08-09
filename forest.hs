module Main where

import qualified Data.Set as Set
import System.Environment

data Forest = Forest
  { goats  :: !Int
  , wolves :: !Int
  , lions  :: !Int
  } deriving (Show, Ord, Eq)

isStable :: Forest -> Bool
isStable (Forest 0 0 _) = True
isStable (Forest 0 _ 0) = True
isStable (Forest _ 0 0) = True
isStable _              = False

isValid :: Forest -> Bool
isValid (Forest g w l) = g >= 0 && w >= 0 && l >= 0

-- from haskell-ordnub repo
ordNub :: (Ord a) => [a] -> [a]
ordNub l = go Set.empty l
  where
    go _ [] = []
    go s (x:xs) = if x `Set.member` s then go s xs
                                      else x : go (Set.insert x s) xs

mutate :: [Forest] -> [Forest]
mutate xs = ordNub . filter isValid . concatMap f $ xs
  where
    f (Forest g w l) =
      [ Forest (g - 1) (w - 1) (l + 1)
      , Forest (g - 1) (w + 1) (l - 1)
      , Forest (g + 1) (w - 1) (l - 1)
      ]

solve :: Forest -> [Forest]
solve x = solve' [x]
  where
    solve' xs
      | cond xs = solve' $ mutate xs
      | otherwise = filter isStable xs
    cond [] = False
    cond xs = null . filter isStable $ xs

main :: IO ()
main = do
  [g, w, l] <- fmap (map read) $ getArgs
  let initial = Forest g w l
  print initial
  print $ solve initial
