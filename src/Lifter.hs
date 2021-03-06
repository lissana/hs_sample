module Lifter where

import Ast
import X86Sem
import Hapstone.Capstone
import Hapstone.Internal.Capstone as Capstone
import Hapstone.Internal.X86      as X86
import Util
import Data.Word
import BitVector
import SymbolicEval
import Phasses
import Data.Maybe

-- Takes the processor mode and the executable code. Returns an ordered list of IdStmts
-- such that for each instruction, there is exactly one IdStmt with the same semantics and
-- an id equal to the address of the instruction.

lift :: [CsMode] -> [Word8] -> IO [IdStmt]

lift modes input = do
  asm <- disasmSimpleIO $ disasm modes input 0
  return $ case asm of
    Left _ -> error "Error in disassembling machine code."
    Right csInsns -> map (liftX86 modes) csInsns

-- Takes the processor mode, writable address ranges, and executable code. Validates
-- memory accesses and returns a simplified Stmt in the IR that is semantically
-- equivalent.

decompile :: [CsMode] -> [(Expr, Expr)] -> [Word8] -> IO IdStmt

decompile modes writableMemory input = do
  lifted <- lift modes input
  -- Label the statements produced by lifting from assembly. The labels are necessary for
  -- the cross referencing that happens in the next stage.
  let labelled = snd $ labelStmts 0 (Compound undefined $ lifted)
  -- Simplify the labelled statements by doing constant propagation and folding.
  simplified <- symExec (symExecContext modes) labelled
  -- The program is only able to modify addresses that can be proven to be in writableMemory
  validateWrites writableMemory (snd simplified)
  -- Eliminate the dead SetRegs under the assumption that the flag bits are defined-before-use
  -- in the fragment of code that follows simplified. Wrap it in a statement.
  let srEliminated = Compound (-1) $ maybeToList $ snd $ eliminateDeadSetRegs [(1408,1472)] (snd simplified)
  -- Eliminate the dead Stores. Wrap it in a statement.
  sEliminated <- Compound (-1) <$> maybeToList <$> snd <$> eliminateDeadStores [] srEliminated
  -- Now introduce cross references into the statements. This must be done after dead code
  -- elimination as it obscures the locations where expressions are loaded from storage.
  referenced <- insertRefs (symExecContext modes) sEliminated
  -- Now return the result of the above transformations.
  return (absToIdStmt $ snd referenced)

