-- | Main entry point to the application.
module Main where

-- | The main entry point.
main :: IO ()
main = do
    s <- readFile "input.txt"
    putStrLn s
    putStrLn "Welcome to FP Haskell Center!"
    putStrLn "Have a good day!"
