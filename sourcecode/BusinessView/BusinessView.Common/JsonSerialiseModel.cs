using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace BTrak.Common
{
    public class JsonDeserialiseModel
    {
        public Object Data { get; set; }
        public List<ApiResponseMessageModel> ApiResponseMessages { get; set; }

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

    public class ApiResponseMessageModel
    {
        public MessageTypeEnumModel MessageTypeEnum { get; set; }
        public string FieldName { get; set; }
        public string Message { get; set; }
    }

    public enum MessageTypeEnumModel
    {
        Information,
        Warning,
        Error
    }
}
