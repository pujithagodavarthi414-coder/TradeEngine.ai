using AuthenticationServices.Models;
using Newtonsoft.Json;
using Newtonsoft.Json.Serialization;
using System.Collections.Generic;
using System.Linq;
using AuthenticationServices.Api.Models;

namespace AuthenticationServices.Api.Helpers
{
    public class UiHelper
    {
        public static JsonSerializerSettings JsonSerializerNullValueIncludeSettings = new JsonSerializerSettings
        {
            ContractResolver = new CamelCasePropertyNamesContractResolver(),
            NullValueHandling = NullValueHandling.Include
        };

        public static bool CheckForValidationMessages(List<ValidationMessage> validationMessages, out BtrakJsonResult btrakApiResult)
        {
            btrakApiResult = new BtrakJsonResult
            {
                Success = false
            };
            if (validationMessages.Any())
            {
                foreach (ValidationMessage validationMessage in validationMessages)
                {
                    btrakApiResult.ApiResponseMessages.Add(new ApiResponseMessage
                    {
                        FieldName = validationMessage.Field,
                        Message = validationMessage.ValidationMessaage,
                        MessageTypeEnum = validationMessage.ValidationMessageType
                    });
                }
                return true;
            }
            return false;
        }
    }
}
