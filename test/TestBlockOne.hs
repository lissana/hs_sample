module TestBlockOne where

import Test.Tasty
import Test.Tasty.HUnit

import Lifter
import Hapstone.Internal.Capstone as Capstone
import Phasses

testBlockOne :: TestTree

testBlockOne =
  testCase "one block" $ do
    let modes = [Capstone.CsMode32]
    let input = [190, 0, 0, 0, 0, 137, 239, 129, 230, 36, 0, 0, 0, 137, 238, 33, 210, 129, 199, 102, 0, 0, 0, 186, 0, 0, 0, 0, 184, 0, 0, 0,
                0, 37, 0, 0, 0, 128, 129, 198, 0, 0, 0, 0, 187, 0, 2, 0, 0, 9, 203, 139, 54, 185, 10, 0, 0, 0, 139, 63, 1, 211, 137, 200,
                129, 234, 4, 0, 0, 0, 129, 199, 0, 0, 0, 0, 41, 200, 33, 209, 33, 208, 15, 183, 63, 129, 193, 255, 255, 255, 127, 129, 193, 1, 0, 0,
                0, 33, 193, 137, 235, 9, 208, 137, 218, 129, 226, 31, 0, 0, 0, 129, 195, 38, 0, 0, 0, 129, 193, 0, 4, 0, 0, 41, 200, 41, 218, 51,
                59, 184, 0, 0, 0, 0, 129, 241, 40, 0, 0, 0, 129, 202, 4, 0, 0, 0, 129, 239, 246, 117, 188, 112, 137, 235, 129, 194, 255, 255, 0, 0,
                129, 233, 32, 0, 0, 0, 129, 195, 38, 0, 0, 0, 185, 10, 0, 0, 0, 49, 194, 186, 0, 2, 0, 0, 49, 59, 1, 200, 129, 231, 255, 255,
                0, 0, 193, 231, 2, 137, 248, 129, 193, 31, 0, 0, 0, 186, 0, 0, 0, 0, 9, 250, 129, 242, 0, 0, 0, 128, 1, 254, 129, 241, 0, 4,
                0, 0, 129, 241, 40, 0, 0, 0, 129, 225, 4, 0, 0, 0, 139, 62, 137, 238, 129, 242, 0, 4, 0, 0, 129, 242, 1, 0, 0, 0, 129, 198,
                180, 0, 0, 0, 45, 0, 8, 0, 0, 41, 240, 9, 209, 137, 62, 33, 254, 129, 198, 0, 4, 0, 0, 186, 10, 0, 0, 0, 185, 0, 0, 0,
                0, 184, 0, 0, 0, 0, 129, 239, 255, 255, 255, 127, 137, 251, 49, 211, 137, 239, 129, 226, 40, 0, 0, 0, 129, 235, 4, 0, 0, 0, 129, 195,
                31, 0, 0, 0, 129, 199, 102, 0, 0, 0, 129, 230, 36, 0, 0, 0, 139, 63, 184, 0, 2, 0, 0, 129, 227, 36, 0, 0, 0, 129, 199, 2,
                0, 0, 0, 102, 139, 15, 49, 194, 129, 227, 4, 0, 0, 0, 137, 239, 187, 0, 4, 0, 0, 41, 250, 129, 199, 38, 0, 0, 0, 9, 195, 41,
                200, 137, 239, 129, 199, 94, 0, 0, 0, 37, 36, 0, 0, 0, 3, 15, 41, 211, 191, 10, 0, 0, 0, 41, 202, 137, 239, 129, 203, 36, 0, 0,
                0, 129, 199, 38, 0, 0, 0, 1, 211, 137, 239, 129, 199, 116, 0, 0, 0, 41, 202, 41, 218, 129, 235, 0, 8, 0, 0, 129, 7, 67, 119, 227,
                60, 137, 239, 33, 243, 129, 199, 8, 0, 0, 0, 9, 251, 102, 41, 15, 129, 199, 1, 0, 0, 0, 41, 206, 137, 238, 129, 199, 1, 0, 0, 0,
                191, 0, 0, 0, 0, 129, 198, 102, 0, 0, 0, 137, 249, 191, 0, 0, 0, 0, 139, 54, 129, 198, 4, 0, 0, 0, 129, 239, 255, 255, 255, 127,
                137, 200, 41, 192, 129, 239, 28, 0, 0, 0, 15, 183, 14, 129, 199, 0, 0, 0, 128, 49, 192, 137, 239, 190, 10, 0, 0, 0, 129, 206, 0, 4,
                0, 0, 186, 0, 2, 0, 0, 45, 1, 0, 0, 0, 129, 199, 38, 0, 0, 0, 129, 198, 32, 0, 0, 0, 43, 15, 53, 0, 8, 0, 0, 129,
                206, 0, 4, 0, 0, 13, 1, 0, 0, 0, 137, 239, 184, 0, 2, 0, 0, 37, 4, 0, 0, 0, 129, 199, 159, 0, 0, 0, 9, 240, 43, 15,
                13, 255, 255, 0, 0, 137, 238, 191, 0, 0, 0, 0, 129, 242, 255, 255, 255, 127, 129, 207, 0, 8, 0, 0, 129, 198, 38, 0, 0, 0, 186, 1,
                0, 0, 0, 41, 247, 190, 0, 2, 0, 0, 5, 4, 0, 0, 0, 33, 247, 137, 235, 5, 4, 0, 0, 0, 37, 0, 8, 0, 0, 41, 200, 33,
                222, 129, 195, 116, 0, 0, 0, 184, 0, 4, 0, 0, 129, 43, 129, 191, 177, 48, 45, 128, 0, 0, 0, 129, 239, 0, 0, 0, 128, 137, 234, 129,
                194, 111, 0, 0, 0, 33, 214, 33, 254, 138, 26, 128, 251, 197, 15, 134, 29, 0, 0, 0, 190, 10, 0, 0, 0, 9, 240, 129, 193, 192, 200, 222,
                37, 129, 207, 1, 0, 0, 0, 191, 0, 4, 0, 0, 190, 0, 0, 0, 0, 41, 216, 129, 230, 255, 255, 255, 127, 191, 1, 0, 0, 0, 137, 206,
                137, 239, 137, 246, 129, 199, 84, 0, 0, 0, 190, 1, 0, 0, 0, 137, 254, 102, 1, 15, 186, 126, 183, 246, 79, 137, 238, 137, 232, 129, 198, 38,
                0, 0, 0, 5, 116, 0, 0, 0, 9, 22, 139, 24, 129, 227, 1, 0, 0, 0, 129, 251, 0, 0, 0, 0, 15, 132, 13, 0, 0, 0, 137, 232,
                5, 116, 0, 0, 0, 129, 0, 126, 183, 246, 79, 137, 239, 129, 199, 102, 0, 0, 0, 139, 63, 129, 199, 4, 0, 0, 0, 137, 235, 129, 195, 38,
                0, 0, 0, 15, 183, 7, 137, 233, 137, 222, 129, 193, 38, 0, 0, 0, 137, 233, 129, 193, 94, 0, 0, 0, 35, 17, 57, 22, 137, 234, 129, 194,
                159, 0, 0, 0, 129, 10, 139, 3, 145, 44, 137, 232, 137, 239, 5, 8, 0, 0, 0, 15, 183, 0, 1, 232, 129, 199, 84, 0, 0, 0, 15, 183,
                63, 139, 0, 138, 0, 1, 239, 15, 182, 216, 137, 31, 129, 238, 255, 255, 255, 127, 129, 198, 28, 0, 0, 0, 33, 254, 137, 235, 1, 254, 129, 238,
                1, 0, 0, 0, 129, 195, 159, 0, 0, 0, 129, 246, 40, 0, 0, 0, 49, 254, 129, 230, 0, 0, 0, 128, 129, 230, 255, 255, 255, 127, 137, 246,
                137, 222, 1, 246, 9, 254, 129, 3, 181, 5, 73, 114, 129, 230, 40, 0, 0, 0, 137, 198, 129, 238, 64, 0, 0, 0, 129, 246, 1, 0, 0, 0,
                137, 234, 129, 238, 255, 255, 255, 127, 41, 254, 176, 88, 129, 238, 28, 0, 0, 0, 49, 222, 137, 239, 129, 194, 180, 0, 0, 0, 129, 199, 111, 0,
                0, 0, 41, 198, 190, 10, 0, 0, 0, 139, 10, 129, 230, 0, 8, 0, 0, 33, 206, 8, 7, 129, 233, 32, 39, 114, 120, 129, 206, 31, 0, 0,
                0, 191, 0, 2, 0, 0, 81, 129, 247, 0, 8, 0, 0, 191, 0, 0, 0, 0, 129, 199, 0, 8, 0, 0, 9, 255, 129, 207, 40, 0, 0, 0,
                87, 137, 231, 129, 199, 4, 0, 0, 0, 129, 239, 4, 0, 0, 0, 51, 60, 36, 49, 60, 36, 51, 60, 36, 92, 137, 20, 36, 137, 44, 36, 86,
                137, 230, 81, 185, 52, 53, 61, 63, 129, 225, 120, 110, 242, 127, 65, 129, 193, 72, 119, 116, 127, 247, 209, 129, 241, 130, 100, 91, 65, 1, 206, 89,
                129, 238, 4, 0, 0, 0, 135, 52, 36, 92, 137, 20, 36, 186, 112, 115, 26, 90, 41, 84, 36, 4, 90, 139, 52, 36, 80, 84, 88, 5, 4, 0,
                0, 0, 87, 191, 4, 0, 0, 0, 1, 248, 95, 135, 4, 36, 92, 83, 81, 185, 42, 14, 191, 110, 129, 233, 186, 154, 164, 20, 137, 203, 89, 129,
                198, 181, 191, 255, 95, 129, 238, 97, 100, 254, 118, 1, 222, 129, 198, 97, 100, 254, 118, 129, 238, 181, 191, 255, 95, 255, 52, 36, 91, 81, 137, 225,
                129, 193, 4, 0, 0, 0, 129, 193, 4, 0, 0, 0, 135, 12, 36, 92, 129, 199, 255, 255, 255, 127, 137, 207, 129, 207, 0, 8, 0, 0, 83, 137,
                227, 129, 195, 4, 0, 0, 0, 131, 235, 4, 135, 28, 36, 92, 137, 60, 36, 81, 185, 226, 13, 253, 125, 247, 217, 65, 193, 225, 7, 129, 241, 125,
                46, 190, 95, 193, 233, 5, 129, 193, 103, 177, 145, 6, 137, 207, 89, 129, 231, 212, 30, 235, 126, 129, 239, 1, 0, 0, 0, 131, 239, 255, 80, 85,
                189, 218, 132, 62, 110, 247, 221, 129, 245, 160, 36, 62, 232, 137, 232, 93, 150, 247, 214, 150, 53, 121, 68, 167, 249, 49, 199, 255, 52, 36, 88, 86,
                84, 94, 129, 198, 4, 0, 0, 0, 129, 198, 4, 0, 0, 0, 135, 52, 36, 92, 87, 49, 28, 36, 51, 28, 36, 49, 28, 36, 87, 199, 4, 36,
                90, 74, 214, 121, 137, 28, 36, 247, 20, 36, 139, 28, 36, 129, 196, 4, 0, 0, 0, 135, 28, 36, 95, 129, 239, 69, 17, 219, 136, 1, 254, 95,
                82, 87, 199, 4, 36, 141, 127, 127, 95, 129, 44, 36, 222, 154, 231, 16, 137, 44, 36, 189, 0, 0, 0, 0, 137, 234, 139, 44, 36, 129, 196, 4,
                0, 0, 0, 82, 199, 4, 36, 177, 118, 192, 75, 137, 28, 36, 187, 0, 171, 58, 127, 41, 218, 139, 28, 36, 81, 137, 60, 36, 137, 231, 85, 104,
                4, 0, 0, 0, 93, 1, 239, 93, 129, 199, 4, 0, 0, 0, 135, 60, 36, 139, 36, 36, 1, 242, 129, 194, 0, 171, 58, 127, 85, 137, 28, 36,
                82, 186, 179, 161, 46, 117, 85, 189, 0, 149, 79, 42, 129, 229, 175, 125, 243, 127, 129, 229, 115, 155, 214, 124, 129, 229, 241, 118, 222, 95, 247, 221,
                77, 129, 197, 45, 186, 57, 104, 41, 234, 93, 66, 74, 193, 234, 2, 193, 226, 2, 129, 194, 124, 8, 201, 234, 137, 211, 90, 1, 211, 129, 3, 6,
                0, 0, 0, 91, 90, 186, 178, 142, 7, 64, 137, 235, 129, 195, 116, 0, 0, 0, 129, 207, 4, 0, 0, 0, 129, 194, 0, 8, 0, 0, 184, 1,
                0, 0, 0, 137, 211, 129, 227, 0, 8, 0, 0, 129, 235, 28, 0, 0, 0, 129, 241, 31, 0, 0, 0, 129, 225, 64, 0, 0, 0, 129, 242, 64]
    l <- decompile modes (allMemory modes) input
    l @?= l

-- let modes = [Capstone.CsMode32]
-- asm <- disasm_buf modes input
-- case asm of
--   Left _ -> print "error"
--   Right b -> print (liftAsm modes b)
