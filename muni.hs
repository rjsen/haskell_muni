import Text.XML.Light
import Network.HTTP
import Network.Mail.Mime

recip = "4082300301@txt.att.net"
needed = 5

res <- simpleHTTP getRequest("http://webservices.nextbus.com/service/publicXMLFeed?command=predictions&a=sf-muni&stopId=16619&routeTag=L")
    
xml <- getResponseBody res

Just doc = parseXMLDoc xml
Just min = findAttr (QName "minutes" Nothing Nothing ) (head $ findElements (QName "prediction" Nothing Nothing ) doc)

