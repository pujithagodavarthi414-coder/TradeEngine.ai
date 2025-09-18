using System;
using System.Collections.Concurrent;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Security.Cryptography;
using System.Xml;
using System.Xml.Linq;
using System.Xml.Serialization;
using Newtonsoft.Json;
namespace BTrak.Common
{
    public static class Utilities
    {
        public static object _lock = new object();
        public static ConcurrentDictionary<string, XmlSerializer> _serializers = new ConcurrentDictionary<string, XmlSerializer>();

        public static string ConvertXmlFromObject { get; set; }

        public static bool ConvertToBoolean(string value)
        {
            if (value.ToUpper().Trim() == "YES")
            {
                return true;
            }
            return false;
        }

        public static decimal ConvertToDecimal(string value)
        {
            if (value.StartsWith("£"))
            {
                string numberString = value.Substring(1, value.Length - 1);

                return Convert.ToDecimal(numberString);
            }
            return Convert.ToDecimal(value);
        }

        public static double ConvertToDouble(string value)
        {
            if (string.IsNullOrWhiteSpace(value))
            {
                return 0;
            }

            if (value.StartsWith("£"))
            {
                string numberString = value.Substring(1, value.Length - 1);

                return Convert.ToDouble(numberString);
            }
            return Convert.ToDouble(value);
        }

        public static string GetSaltedPassword(string password)
        {
            byte[] salt;
            new RNGCryptoServiceProvider().GetBytes(salt = new byte[16]);

            var pbkdf2 = new Rfc2898DeriveBytes(password, salt, 10000);
            byte[] hash = pbkdf2.GetBytes(20);
            byte[] hashBytes = new byte[36];
            Array.Copy(salt, 0, hashBytes, 0, 16);
            Array.Copy(hash, 0, hashBytes, 16, 20);
            return Convert.ToBase64String(hashBytes);
        }

        public static bool VerifyPassword(string savedPasswordHash, string passwordUserEntered)
        {
            /* Extract the bytes */
            byte[] hashBytes = Convert.FromBase64String(savedPasswordHash);
            /* Get the salt */
            byte[] salt = new byte[16];
            Array.Copy(hashBytes, 0, salt, 0, 16);
            /* Compute the hash on the password the user entered */
            var pbkdf2 = new Rfc2898DeriveBytes(passwordUserEntered, salt, 10000);
            byte[] hash = pbkdf2.GetBytes(20);
            /* Compare the results */
            for (int i = 0; i < 20; i++)
                if (hashBytes[i + 16] != hash[i])
                {
                    return false;
                }

            return true;
        }

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

        public static string ConvertIntoListXml(Guid[] listInput)
        {
            XmlSerializer xsSubmit = new XmlSerializer(typeof(ListItems));

            var listItems = new ListItems();

            foreach (Guid listItem in listInput.ToList())
            {
                listItems.ListRecords.Add(new ListItem
                {
                    ListItemId = listItem
                });
            }

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

        public static string ConvertIntoListXml(string[] listInput)
        {
            XmlSerializer xsSubmit = new XmlSerializer(typeof(MACAddressListItems));

            var mACAddressListItems = new MACAddressListItems();

            foreach (string listItem in listInput.ToList())
            {
                mACAddressListItems.ListRecords.Add(new MACAddressListItem
                {
                    MACAddress = listItem
                });
            }

            string returnXml;

            using (var stringWriter = new StringWriter())
            {
                using (XmlWriter writer = XmlWriter.Create(stringWriter))
                {
                    XmlWriterSettings xmlWriterSettings = new XmlWriterSettings { OmitXmlDeclaration = true };

                    xsSubmit.Serialize(writer, mACAddressListItems);
                    returnXml = stringWriter.ToString();
                }
            }

            return returnXml;
        }

        public static string GetXmlFromObject(object obj)
        {
            var stringWriter = new StringWriter();
            var xmlTextWriter = new XmlTextWriter(stringWriter);
            var serializer = new XmlSerializer(obj.GetType());
            serializer.Serialize(xmlTextWriter, obj);
            return stringWriter.ToString();
        }

        public static List<T> GetObjectFromXml<T>(string xmlString, string xmlRoot)
        {
            var serializer = GetSerializer<T>(xmlRoot);

            //var serializer = new XmlSerializer(typeof(List<T>), new XmlRootAttribute(xmlRoot));
            using (var stringReader = new StringReader(xmlString))
            {
                var list = (List<T>)serializer.Deserialize(stringReader);
                //GC.Collect();
                return list;
            }
        }

        public static XmlSerializer GetSerializer<T>(string rootName)
        {
            lock (_lock)
            {
                var key = $"{typeof(T)}|{rootName}";
                if (!_serializers.TryGetValue(key, out XmlSerializer serializer))
                {
                    if (!string.IsNullOrWhiteSpace(rootName))
                    {
                        serializer = new XmlSerializer(typeof(List<T>), new XmlRootAttribute(rootName));
                    }

                    _serializers.TryAdd(key, serializer);
                }

                return serializer;
            }
        }

        public static string ConvertObjectToJSON(object obj)
        {
           return JsonConvert.SerializeObject(obj);
        }
    }
}
