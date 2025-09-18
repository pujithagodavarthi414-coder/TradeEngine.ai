using System;
using System.Collections.Generic;
using System.IdentityModel.Tokens.Jwt;
using System.Linq;
using System.Net.Http.Headers;
using PDFHTMLDesigner.Models;
using PDFHTMLDesignerModels;
using Microsoft.AspNetCore.Http;
using Newtonsoft.Json;
using Newtonsoft.Json.Serialization;
using PDFHTMLDesignerModels.ValidUserOutputmodel;

namespace PDFHTMLDesigner.Helpers
{
    public class UiHelper
    {
        public static JsonSerializerSettings JsonSerializerNullValueIncludeSettings = new JsonSerializerSettings
        {
            ContractResolver = new CamelCasePropertyNamesContractResolver(),
            NullValueHandling = NullValueHandling.Include
        };
        public static bool CheckForValidationMessages(List<ValidationMessage> validationMessages, out DataJsonResult dataJsonResult)
        {
            dataJsonResult = new DataJsonResult
            {
                Success = false
            };
            if (validationMessages.Any())
            {
                foreach (ValidationMessage validationMessage in validationMessages)
                {
                    dataJsonResult.ApiResponseMessages.Add(new ApiResponseMessage
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

        public static Guid? GetUserId(HttpContext context)
        {
            var principal = context.User;
            if (principal?.Claims != null)
            {
                return Guid.Parse(principal.Claims.FirstOrDefault(x => x.Type == "loggedin-user").Value);
            }
            return null;
        }

        public static Guid? GetCompanyId(HttpContext context)
        {
            var principal = context.User;
            if (principal?.Claims != null)
            {
                return Guid.Parse(principal.Claims.FirstOrDefault(x => x.Type == "companyId").Value);
            }
            return null;
        }
        public static ValidUserOutputmodel ValidUserOutput(HttpContext context, HttpRequest Request)
        {
            var principal = context.User;
            if (principal?.Claims != null)  
            {
                var authHeader = AuthenticationHeaderValue.Parse(Request.Headers["Authorization"]);
                var tokenHandler = new JwtSecurityTokenHandler();

                var jsonToken = tokenHandler.ReadToken(authHeader.Parameter);

                var tokenS = jsonToken as JwtSecurityToken;

                ValidUserOutputmodel validUser = new ValidUserOutputmodel();
                //validUser.CompanyId = Guid.Parse(principal.Claims.FirstOrDefault(x => x.Type == "companyId").Value);
                //validUser.Id = Guid.Parse(principal.Claims.FirstOrDefault(x => x.Type == "loggedin-user").Value);

                var jti1 = tokenS.Claims.First(claim => claim.Type == "client_id").Value;
                var jti2 = tokenS.Claims.First(claim => claim.Type == "scope").Value;

                //ValidUserOutputmodel validUser = new ValidUserOutputmodel();

                var ids = jti1.Split(" ");

                foreach (var id in ids)
                {
                    if (id == jti2)
                    {
                        validUser.CompanyId = new Guid(id);
                    }
                    else
                    {
                        validUser.Id = new Guid(id);
                    }
                }
                return validUser;
                //var user = new ValidUserOutputmodel()
                //{
                //    Id = new Guid("3E3900D7-C32E-448B-A194-EB9587A8CE5A"),
                //    CompanyId = new Guid("94DC5C64-CBDF-488D-954C-E6EAA0D48C2D")
                //};
                //return user;
            }
            return null;
        }
    }
}
