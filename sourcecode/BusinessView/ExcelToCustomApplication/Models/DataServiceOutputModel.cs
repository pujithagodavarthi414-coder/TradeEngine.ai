using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ExcelToCustomApplication.Models
{
    public class DataServiceOutputModel
    {
        public object Data
        {
            get;
            set;
        }
        public bool? Success { get; set; }
        public List<ApiResponseMessage> ApiResponseMessages { get; set; }
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
}
