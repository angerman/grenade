{-# LANGUAGE BangPatterns          #-}
{-# LANGUAGE DataKinds             #-}
{-# LANGUAGE ScopedTypeVariables   #-}
{-# LANGUAGE StandaloneDeriving    #-}
{-# LANGUAGE TypeOperators         #-}
{-# LANGUAGE TypeFamilies          #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE FlexibleInstances     #-}

module Grenade.Layers.Tanh (
    Tanh (..)
  ) where

import           GHC.TypeLits
import           Grenade.Core.Vector
import           Grenade.Core.Network
import           Grenade.Core.Shape

-- | A Tanh layer.
--   A layer which can act between any shape of the same dimension, perfoming an tanh function.s
data Tanh = Tanh
  deriving Show

instance (Monad m, KnownNat i) => Layer m Tanh ('D1 i) ('D1 i) where
  runForwards _ (S1D' y) = return $ S1D' (tanh y)
  runBackards _ _ (S1D' y) (S1D' dEdy) = return (Tanh, S1D' (tanh' y * dEdy))

instance (Monad m, KnownNat i, KnownNat j) => Layer m Tanh ('D2 i j) ('D2 i j) where
  runForwards _ (S2D' y) = return $ S2D' (tanh y)
  runBackards _ _ (S2D' y) (S2D' dEdy) = return (Tanh, S2D' (tanh' y * dEdy))

instance (Monad m, KnownNat i, KnownNat j, KnownNat k) => Layer m Tanh ('D3 i j k) ('D3 i j k) where
  runForwards _ (S3D' y) = return $ S3D' (fmap tanh y)
  runBackards _ _ (S3D' y) (S3D' dEdy) = return (Tanh, S3D' (vectorZip (\y' dEdy' -> tanh' y' * dEdy') y dEdy))

tanh' :: (Floating a) => a -> a
tanh' t = 1 - s ^ (2 :: Int)  where s = tanh t
