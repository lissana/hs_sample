module Main where

import System.IO
import Hapstone.Internal.Capstone as Capstone
import EvalAst
import Ast
import SymbolicEval
import BitVector
import Phasses
import Data.Maybe
import Data.SBV
import Data.Vector

import Lifter
--import Simplify


main :: IO ()
main = do
  print "this should be in test/"
  -- Ignoring the changes to the flag registers, the following is what happens

  let input = [0x50, 0xB8, 0x14, 0x00, 0x00, 0x00, 0x53, 0xBB, 0x1E, 0x00, 0x00, 0x00, 0x5B, 0x58]
      modes = [Capstone.CsMode32]
  asm <- disasm_buf modes input
  let lifted = case asm of
                  Left _ -> error "error on disasm"
                  Right b -> liftAsm modes b
      oneblock = lifted
  -- print lifted
  -- print oneblock
  
  -- Label the statements produced by lifting from assembly. The labels are necessary for
  -- the cross referencing that happens in the next stage.
  let labelled = snd $ labelStmts 0 lifted
  -- Simplify the labelled statements by doing constant propagation and folding.
  simplified <- symExec (SymbolicEval.basicX86Context modes) labelled
  -- Elimate the dead code under the assumption that the flag bits are defined-before-use
  -- in the fragment of code that follows simplified. Wrap it in a statement.
  let eliminated = Compound (-1) $ maybeToList $ snd $ eliminateDeadCode [(1408,1472)] (snd simplified)
  -- Now introduce cross references into the statements. This must be done after dead code
  -- elimination as it obscures the locations where expressions are loaded from storage.
  referenced <- insertRefs (SymbolicEval.basicX86Context modes) eliminated
  -- Now print the result of the above transformations.
  print $ snd referenced
  -- let a = (fromList [0x0123456789ABCDEF, 0xF123456789ABCDEF], 128)
  -- print $ bvshow (bvmul a a)
  -- equality <- exprEquals (BvaddExpr (BvExpr (intToBv 2 32)) (GetReg (0,32))) (BvaddExpr (GetReg (0,32)) (BvExpr (intToBv 2 32)))
  -- print equality
  --print {-(getRegisterValues (reg_file (fst-} (symExec (basicX86Context modes) (snd $ labelStmts 0 lifted)){-)))-}
