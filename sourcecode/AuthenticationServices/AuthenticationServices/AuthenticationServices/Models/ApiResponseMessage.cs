using AuthenticationServices.Models;

namespace AuthenticationServices.Api.Models
{
    public class ApiResponseMessage
    {
        public MessageTypeEnum MessageTypeEnum { get; set; }
        public string FieldName { get; set; }
        public string Message { get; set; }
    }
}
