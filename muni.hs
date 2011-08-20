import Text.XML.Light
import Network.HTTP
import Network.Mail.Mime

recip = "4082300301@txt.att.net"
needed = 5
sid = "16619"
rt = "L"

msg = "To: " ++ recip ++ "\nThe next " ++ rt ++ " will be at stop " ++ sid ++ " in "

res <- simpleHTTP getRequest("http://webservices.nextbus.com/service/publicXMLFeed?command=predictions&a=sf-muni&stopId=" ++ sid ++ "&routeTag=" ++ rt)
    
xml <- getResponseBody res

Just doc = parseXMLDoc xml
Just min = findAttr (QName "minutes" Nothing Nothing ) (head $ findElements (QName "prediction" Nothing Nothing ) doc)

checkTime :: (Int a) => Int -> Bool
checkTime needed = 
checkTime x = False