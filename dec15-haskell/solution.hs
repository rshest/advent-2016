import System.Environment
import Text.Regex.Posix

parseDisk :: String -> [Int]
parseDisk str =
  map (\x -> read (head x) :: Int) (str =~ "[0-9]+" :: [[String]])

-- finds out whether the capsule would pass through the disk, if ejected at time t
willPass :: Int -> [Int] -> Bool
willPass t (idx:numPos:phase:startPos:_) =
  (t + idx - phase + startPos) `mod` numPos == 0

passAllTimes :: [[Int]] -> [Int]
passAllTimes disks = filter (\t -> all (willPass t) disks) [0..]

main = do
  args <- getArgs
  let fname = if length args > 0 then args !! 0 else "input1.txt"
  file <- readFile fname
  let disks = map parseDisk (lines file)
  putStrLn ("First time: " ++ (show $ head $ passAllTimes disks))

