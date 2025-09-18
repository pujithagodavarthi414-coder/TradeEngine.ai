using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using PDFHTMLDesignerModels;
using PDFHTMLDesignerCommon.Texts;

namespace PDFHTMLDesignerRepo.Helpers
{
    public class SqlValidationHelper
    {
        public static void ValidateGetAllSqlExceptions(List<ValidationMessage> validationMessages, SqlException sqlException, string message)
        {
            if (validationMessages == null)
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

        public static void ValidateGetAllSqlExceptions(List<ValidationMessage> validationMessages, Exception sqlException, string message)
        {
            if (validationMessages == null)
            {
                validationMessages = new List<ValidationMessage>();
            }
            if (sqlException.HResult < 50000)
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
