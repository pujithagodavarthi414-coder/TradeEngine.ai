using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Security;
using Btrak.Models;
using Btrak.Models.User;
using BTrak.Api.Models;
using BTrak.Common;
using Newtonsoft.Json;
using Newtonsoft.Json.Serialization;

namespace BTrak.Api.Helpers
{
    public static class UiHelper
    {
        public static string GetLoggedInUserToken()
        {
            var userModel = GetUserModel();
            if (userModel != null)
            {
                return userModel.Token;
            }
            return string.Empty;
        }

        public static JsonSerializerSettings JsonSerializerNullValueIncludeSettings = new JsonSerializerSettings
        {
            ContractResolver = new CamelCasePropertyNamesContractResolver(),
            NullValueHandling = NullValueHandling.Include
        };

        public static UsersModel GetUserModel()
        {
            var cookie = HttpContext.Current.Request.Cookies.Get(CookieConstants.LoginCookie);
            if (cookie != null)
            {
                var userModel = JsonConvert.DeserializeObject<UsersModel>(Encryptor.Decrypt(cookie.Value));

                return userModel;
            }
            return null;
        }

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

        public static void SetUserModel(UsersModel userModel)
        {
            var encryptCookie = Encryptor.Encrypt(JsonConvert.SerializeObject(userModel));
            var cookie = new HttpCookie(CookieConstants.LoginCookie)
            {
                Value = encryptCookie,
                Expires = DateTime.Now.AddDays(1000)
            };

            HttpContext.Current.Response.Cookies.Add(cookie);
            FormsAuthentication.SetAuthCookie(userModel.UserName, true);
        }
    }
}