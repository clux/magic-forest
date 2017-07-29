{-# LANGUAGE BangPatterns #-}
import Data.List
import System.Environment

data Forest = Forest
  { goats :: !Int
  , wolves :: !Int
  , lions :: !Int
  } deriving (Show, Ord, Eq)

is_stable :: Forest -> Bool
is_stable (Forest 0 0 _ ) = True
is_stable (Forest 0 _ 0 ) = True
is_stable (Forest _ 0 0 ) = True
is_stable _ = False

is_valid :: Forest -> Bool
is_valid (Forest g w l) = g >= 0 && w >= 0 && l >= 0

mutate :: [Forest] -> [Forest]
mutate xs = nub . filter is_valid . concatMap f $ xs
  where f (Forest g w l) = [ Forest (g-1) (w-1) (l+1)
                           , Forest (g-1) (w+1) (l-1)
                           , Forest (g+1) (w-1) (l-1)
                           ]

solve :: Forest -> [Forest]
solve x = solve' [x]
  where
  solve' xs | cond xs = solve' $ mutate xs
            | otherwise = filter is_stable xs
  cond [] = False
  cond xs = null . filter is_stable $ xs

main :: IO ()
main = do
  [g, w, l] <- fmap (map read) $ getArgs
  let initial = Forest g w l
  print initial
  print $ solve initial
