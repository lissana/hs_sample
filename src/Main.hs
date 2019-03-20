module Main where

import qualified Data.ByteString            as BS
import           System.IO
import           Hapstone.Internal.Capstone as Capstone
import EvalAst
import Ast

import Lifter
--import Simplify

main :: IO ()
main = do
  -- contents <- BS.readFile "bs/blackcipher.aes"
  print "this should be in test/"
  let input = [0xb8, 0x0a, 0x00, 0x00, 0x00, 0x83, 0xc0, 0x0a, 0xeb, 0xfb] -- jmp loop
  let modes = [Capstone.CsMode32]
  asm <- disasm_buf modes input
  case asm of
    Left _ -> print "error"
    -- Register ebx will contain 23 as it is the result of 0xa+0xd
    Right b -> print (getRegisterValues (reg_file ((iter exec 100) (uninitializedX86Context (concat (liftAsm modes b)) (0, 0)))))

