module Main where

import           Data.List
import           System.Environment

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

-- removes adjacent identical elements
dedup :: [Forest] -> [Forest]
dedup = go $ Forest 0 0 0
  where
    go s (x:xs)
      | x == s = go s xs
      | otherwise = x : go x xs
    go _ _ = []

mutate :: [Forest] -> [Forest]
mutate xs = dedup . sort . filter isValid . concatMap f $ xs
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
