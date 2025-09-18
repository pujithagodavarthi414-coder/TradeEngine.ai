using System.Collections.Generic;
using System.Data.SqlClient;
using Btrak.Models;
using System;
using BTrak.Common.Texts;

namespace Btrak.Dapper.Dal.Helpers
{
    public class SqlValidationHelper
    {
        public static void ValidateGetAllSqlExceptions(List<ValidationMessage> validationMessages, SqlException sqlException, string message)
        {
            if(validationMessages == null)
            {
                validationMessages = new List<ValidationMessage>();
            }
            if (sqlException.Number < 50000)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = message

                });
            }
            else
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = GetPropValue(sqlException.Message)
                });
            }
        }

        private static string GetPropValue(string propName)
        {

            object src = new LangText();
            return src.GetType().GetProperty(propName)?.GetValue(src, null).ToString();
        }
    }
}