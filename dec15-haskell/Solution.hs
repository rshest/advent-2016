import System.Environment

main = do
  args <- getArgs
  let fname = if length args > 0 then args !! 0 else "input.txt"
  file <- readFile fname
  mapM_ putStrLn (lines file)

