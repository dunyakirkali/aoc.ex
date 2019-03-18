
foldr 
    (\b h -> h + 
        (fromEnum . or . map (\d -> b `mod` d == 0) $ 
        [2..(floor . sqrt . fromIntegral) b]
    )) 
    0 [108100, 108117..125100]