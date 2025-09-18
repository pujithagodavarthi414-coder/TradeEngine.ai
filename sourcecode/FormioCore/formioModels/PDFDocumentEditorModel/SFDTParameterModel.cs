using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using MongoDB.Bson.Serialization.Attributes;
using MongoDB.Bson;
using PDFHTMLDesignerModels.PDFDocumentEditorModel;
using System.Text.Json.Serialization;

namespace PDFHTMLDesignerModels.SFDTParameterModel
{
    public class SFDTParameter
    {
        public byte[] sfdtString { get; set; }
        public string filetype { get; set; }
        //public string filename { get; set; }
    }

   
    public class ApiResponseMessage
    {
        public MessageTypeEnum MessageTypeEnum { get; set; }
        public string FieldName { get; set; }
        public string Message { get; set; }
    }

    public enum MessageTypeEnum
    {
        Information,
        Warning,
        Error
    }

    public class JsonDeserialiseData
    {
        public Object Data { get; set; }
        public List<ApiResponseMessage> ApiResponseMessages { get; set; }

        public string Result
        {
            get;
            set;
        }

        public bool Success
        {
            get;
            set;
        }

        public string VersionNumber
        {
            get;
            set;
        }

        public bool IsLatestVersion
        {
            get;
            set;
        }
    }
}
