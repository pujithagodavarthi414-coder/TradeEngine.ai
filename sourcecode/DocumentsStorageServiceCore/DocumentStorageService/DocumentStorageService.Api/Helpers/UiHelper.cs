using DocumentStorageService.Models;
using Microsoft.AspNetCore.Http;
using Newtonsoft.Json;
using Newtonsoft.Json.Serialization;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace DocumentStorageService.Api.Helpers
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

        public static ValidUserOutputmodel ValidUserOutput(HttpContext context)
        {
            var principal = context.User;
            if (principal?.Claims != null)
            {
                ValidUserOutputmodel validUser = new ValidUserOutputmodel();
                validUser.CompanyId = Guid.Parse(principal.Claims.FirstOrDefault(x => x.Type == "companyId").Value);
                validUser.Id = Guid.Parse(principal.Claims.FirstOrDefault(x => x.Type == "loggedin-user").Value);
                return validUser;
            }
            return null;
        }
    }
}
