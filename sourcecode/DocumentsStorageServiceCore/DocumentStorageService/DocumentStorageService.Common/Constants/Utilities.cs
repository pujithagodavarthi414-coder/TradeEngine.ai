using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Xml;
using System.Xml.Serialization;

namespace DocumentStorageService.Common.Constants
{
    public class Utilities
    {
        public static string ConvertIntoListXml<T>(List<T> listOfModel)
        {
            XmlSerializer xsSubmit = new XmlSerializer(typeof(GenericList<T>));

            var listItems = new GenericList<T> { ListItems = listOfModel };

            string returnXml;

            using (var stringWriter = new StringWriter())
            {
                using (XmlWriter writer = XmlWriter.Create(stringWriter))
                {
                    XmlWriterSettings xmlWriterSettings = new XmlWriterSettings { OmitXmlDeclaration = true };

                    xsSubmit.Serialize(writer, listItems);
                    returnXml = stringWriter.ToString();
                }
            }

            return returnXml;
        }
    }
}
