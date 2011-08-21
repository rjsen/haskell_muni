import Text.XML.Light
import Network.HTTP
import Network.Mail.Mime
import qualified Data.ByteString.Lazy.Char8 as B
import System.Environment

main = do
  (recip:needstr:sid:rt:extra) <- getArgs
  --let recip = "rjsen@me.com" --"4082300301@txt.att.net"
  --let needed = 15
  --let sid = "16619"
  --let rt = "L"
  let needed = read needstr :: Int

  res <- simpleHTTP $ getRequest("http://webservices.nextbus.com/service/publicXMLFeed?command=predictions&a=sf-muni&stopId=" ++ sid ++ "&routeTag=" ++ rt)
    
  xml <- getResponseBody res

  let Just min = parseXMLDoc xml >>= \x -> findAttr (QName "minutes" Nothing Nothing ) (head $ findElements (QName "prediction" Nothing Nothing ) x)
  let minutes = read min :: Int
  
  let msg = B.pack $ "To: " ++ recip ++ "\nThe next " ++ rt ++ " will be at stop " ++ sid ++ " in " ++ min ++ " minutes"

  if needed >= minutes
     then sendmail msg
     else return ()
