module EvalAst where

import Ast
import Hapstone.Internal.X86 as X86
import Util
import Data.Bits

data ExecutionContext = ExecutionContext {
  reg_file :: [Int],
  memory :: [(Int, Int)]
} deriving (Eq, Show, Read)

x86Context :: ExecutionContext
x86Context = ExecutionContext {
  reg_file = replicate reg_file_bytes 0,
  memory = []
}

-- Evaluates the given node in the given context and returns the result

eval :: ExecutionContext -> AstNode -> Int

eval cin (BvNode a _) = convert a

eval cin (BvxorNode a b) = convert (xor (eval cin a) (eval cin b))

eval cin (BvandNode a b) = convert ((eval cin a) .&. (eval cin b))

eval cin (BvorNode a b) = convert ((eval cin a) .|. (eval cin b))

eval cin (BvaddNode a b) = convert ((eval cin a) + (eval cin b))

eval cin (BvsubNode a b) = convert ((eval cin a) - (eval cin b))

eval cin (ExtractNode a b c) =
  convert ((shift (eval cin c) (convert (-b))) .&. ((2 ^ convert (a + 1 - b)) - 1))

eval cin (GetReg []) = 0

eval cin (GetReg (b:bs)) = (reg_file cin !! b) + (2 ^ word_size_bit) * (eval cin (GetReg bs))

-- Replace the given index of the given list with the given value

replace :: [a] -> Int -> a -> [a]

replace (_:xs) 0 val = val:xs

replace (x:xs) idx val = x:(replace xs (idx - 1) val)

-- Executes the given statement in the given context and returns a new context

exec :: ExecutionContext -> Stmt -> ExecutionContext

-- Executes a SetReg operation by setting each byte of the register separately

exec cin (SetReg bs a) =
  let update_reg_file regs [] _ = regs
      update_reg_file regs (c:cs) val =
        update_reg_file (replace regs c (val .&. ((2 ^ byte_size_bit) - 1))) cs (shift val (-byte_size_bit))
  in ExecutionContext {
    reg_file = update_reg_file (reg_file cin) bs (eval cin a),
    memory = memory cin
  }

-- Executes given list of statements in order in the given context and returns a new context

run :: ExecutionContext -> [Stmt] -> ExecutionContext

run cin ss = foldl exec cin ss

-- by default all undefined regs are symbolic?
symbolicEval :: ExecutionContext -> [AstNode] -> ExecutionContext
symbolicEval cin ast =
          cin
