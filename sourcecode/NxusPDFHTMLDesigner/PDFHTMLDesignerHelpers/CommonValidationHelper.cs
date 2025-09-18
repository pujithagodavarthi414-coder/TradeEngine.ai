using PDFHTMLDesignerModels;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using PDFHTMLDesignerCommon.Constants;

namespace PDFHTMLDesignerHelpers
{
    public static class CommonValidationHelper
    {
        public static List<ValidationMessage> CheckValidationForLoggedInUser(LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            return validationMessages;
        }

        public static bool ValidateLoggedInUser(LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            if (loggedInContext == null)
            {
                loggedInContext = new LoggedInContext();
            }

            if (loggedInContext.LoggedInUserId == Guid.Empty)
            {
                LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "validate LoggedInUserId", "Common Validation Helper") + "LoggedIn User Id :" + loggedInContext.LoggedInUserId);

                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyLoggedInUserId
                });
            }

            if (loggedInContext.CompanyGuid == Guid.Empty)
            {
                LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "validate CompanyId", "Common Validation Helper") + "Company Id : " + loggedInContext.CompanyGuid);

                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyCompanyId
                });
            }

            return validationMessages.Count <= 0;
        }
    }
}
